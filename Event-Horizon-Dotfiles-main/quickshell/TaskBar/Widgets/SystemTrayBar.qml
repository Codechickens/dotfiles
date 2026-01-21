import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Common
import qs.Widgets

Item {
    id: root

    /**
     * Utility component for creating menu close timers with proper cleanup
     * Ensures timers are properly destroyed to prevent resource leaks
     */
    Component {
        id: menuCloseTimerComponent
        Timer {
            property var menuRoot: null
            interval: 80
            repeat: false
            running: true
            onTriggered: {
                if (menuRoot && typeof menuRoot.close === 'function') {
                    menuRoot.close()
                }
                destroy()
            }
            Component.onDestruction: {
                if (running) {
                    stop()
                }
            }
        }
    }

    property bool isVertical: axis?.isVertical ?? false
    property bool isBarVertical: SettingsData.topBarPosition === "left" || SettingsData.topBarPosition === "right"
    property var axis: null
    property var parentWindow: null
    property var parentScreen: null
    property real widgetHeight: 30
    property real widgetThickness: 30
    property real barThickness: 32
    property bool isAtBottom: false
    readonly property real horizontalPadding: SettingsData.topBarNoBackground ? 2 : Theme.spacingS
    readonly property var hiddenTrayIds: {
        const envValue = Quickshell.env("DMS_HIDE_TRAYIDS") || ""
        return envValue ? envValue.split(",").map(id => id.trim().toLowerCase()) : []
    }
    readonly property var blacklistedTrayIds: {
        const envValue = Quickshell.env("DMS_BLACKLIST_TRAYIDS") || ""
        return envValue ? envValue.split(",").map(id => id.trim().toLowerCase()) : []
    }
    readonly property var visibleTrayItems: {
        let items = SystemTray.items.values || []

        // Filter out hidden items (DMS_HIDE_TRAYIDS)
        if (hiddenTrayIds.length) {
            items = items.filter(item => {
                const itemId = item?.id || ""
                return !hiddenTrayIds.includes(itemId.toLowerCase())
            })
        }

        // Filter out blacklisted items (DMS_BLACKLIST_TRAYIDS)
        if (blacklistedTrayIds.length) {
            items = items.filter(item => {
                const itemId = item?.id || ""
                return !blacklistedTrayIds.includes(itemId.toLowerCase())
            })
        }

        return items
    }
    readonly property int calculatedSize: visibleTrayItems.length > 0 ? visibleTrayItems.length * 24 : 0

    // Reactive status tracking for performance
    readonly property var statusSignature: {
        if (!SystemTray.items || !SystemTray.items.values) {
            return ""
        }
        var sig = ""
        var items = SystemTray.items.values
        for (var i = 0; i < items.length; i++) {
            var item = items[i]
            if (item) {
                var s = item.status
                sig += (item.id || i) + ":" + (s !== undefined ? s : -1)
            }
        }
        return sig
    }
    readonly property real visualWidth: (isVertical || isBarVertical) ? widgetThickness : calculatedSize
    readonly property real visualHeight: (isVertical || isBarVertical) ? calculatedSize : widgetThickness

    implicitWidth: (isVertical || isBarVertical) ? barThickness : visualWidth
    implicitHeight: (isVertical || isBarVertical) ? visualHeight : (isAtBottom ? barThickness : widgetHeight)
    width: implicitWidth
    height: implicitHeight
    visible: visibleTrayItems.length > 0

    Rectangle {
        id: visualBackground
        width: root.visualWidth
        height: root.visualHeight
        anchors.centerIn: parent
    radius: SettingsData.topBarNoBackground ? 0 : Theme.cornerRadius
    color: {
            if (visibleTrayItems.length === 0) {
            return "transparent";
        }
        if (SettingsData.topBarNoBackground) {
            return "transparent";
        }
        const baseColor = Theme.widgetBaseBackgroundColor;
        return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * Theme.widgetTransparency);
    }
    }

    Loader {
        id: layoutLoader
        anchors.centerIn: parent
        sourceComponent: (root.isVertical || root.isBarVertical) ? columnComp : rowComp
    }

    Loader {
        id: trayContextMenuLoader
        source: "./TrayContextMenu.qml"
        asynchronous: false

        onLoaded: {
        }

        onStatusChanged: {
            if (status === Loader.Error) {
                console.error("[SystemTrayBar] Failed to load TrayContextMenu:", source, errorString())
            }
        }
    }

    Component {
        id: rowComp
        Row {
        spacing: 0
        Repeater {
                model: root.visibleTrayItems
            delegate: Item {
                    id: delegateRoot
                property var trayItem: modelData
                property string iconSource: {
                    if (!trayItem) {
                        return "";
                    }
                    
                    let icon = trayItem.icon;
                    if (typeof icon === 'string' || icon instanceof String) {
                        if (icon === "") {
                            return "";
                        }
                        if (icon.includes("?path=")) {
                            const split = icon.split("?path=");
                            if (split.length !== 2) {
                                return icon;
                            }
                            const name = split[0];
                            const path = split[1];
                            let fileName = name.substring(name.lastIndexOf("/") + 1);
                            if (fileName.startsWith("dropboxstatus")) {
                                fileName = `hicolor/16x16/status/${fileName}`;
                            }
                            return `file://${path}/${fileName}`;
                        }
                        if (icon.startsWith("/") && !icon.startsWith("file://")) {
                            return `file://${icon}`;
                        }
                        return icon;
                    }
                    return "";
                }

                width: 24
                    height: root.isAtBottom ? root.barThickness : root.widgetHeight

                Rectangle {
                        id: visualContent
                        width: 24
                        height: 24
                        anchors.centerIn: parent
                    radius: Theme.cornerRadius
                    color: trayItemArea.containsMouse ? Theme.primaryHover : "transparent"

                        Item {
                            anchors.centerIn: parent
                            width: Math.min(16, root.widgetHeight - 8)
                            height: Math.min(16, root.widgetHeight - 8)
                            layer.enabled: SettingsData.systemIconTinting

                            IconImage {
                                anchors.centerIn: parent
                                width: Math.min(16, root.widgetHeight - 8)
                                height: Math.min(16, root.widgetHeight - 8)
                                source: delegateRoot.iconSource
                                asynchronous: true
                                smooth: true
                                mipmap: true
                            }
                            
                            layer.effect: MultiEffect {
                                colorization: SettingsData.systemIconTinting ? SettingsData.iconTintIntensity : 0
                                colorizationColor: Theme.primary
                            }
                        }
                    }

                    MouseArea {
                        id: trayItemArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: (mouse) => {
                            if (!delegateRoot.trayItem) {
                                return;
                            }
                            if (mouse.button === Qt.LeftButton && !delegateRoot.trayItem.onlyMenu) {
                                delegateRoot.trayItem.activate();
                                return;
                            }
                            if (mouse.button === Qt.RightButton) {
                                const hasMenu = delegateRoot.trayItem.menu || delegateRoot.trayItem.hasMenu
                                if (delegateRoot.trayItem && hasMenu) {
                                    root.showForTrayItem(delegateRoot.trayItem, visualContent, parentScreen, root.isAtBottom, root.isVertical, root.axis);
                                } else {
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: columnComp
        Column {
            spacing: 0
            Repeater {
                model: root.visibleTrayItems
                delegate: Item {
                    id: delegateRoot
                    property var trayItem: modelData
                    property string iconSource: {
                        if (!trayItem) {
                            return "";
                        }
                        
                        let icon = trayItem.icon;
                        if (typeof icon === 'string' || icon instanceof String) {
                            if (icon === "") {
                                return "";
                            }
                            if (icon.includes("?path=")) {
                                const split = icon.split("?path=");
                                if (split.length !== 2) {
                                    return icon;
                                }
                                const name = split[0];
                                const path = split[1];
                                let fileName = name.substring(name.lastIndexOf("/") + 1);
                                if (fileName.startsWith("dropboxstatus")) {
                                    fileName = `hicolor/16x16/status/${fileName}`;
                                }
                                return `file://${path}/${fileName}`;
                            }
                            if (icon.startsWith("/") && !icon.startsWith("file://")) {
                                return `file://${icon}`;
                            }
                            return icon;
                        }
                        return "";
                    }

                    width: root.isAtBottom ? root.barThickness : root.widgetHeight
                    height: 24

                    Rectangle {
                        id: visualContent
                        width: 24
                        height: 24
                        anchors.centerIn: parent
                        radius: Theme.cornerRadius
                        color: trayItemArea.containsMouse ? Theme.primaryHover : "transparent"

                        Item {
                            anchors.centerIn: parent
                            width: Math.min(16, root.widgetHeight - 8)
                            height: Math.min(16, root.widgetHeight - 8)
                            layer.enabled: SettingsData.systemIconTinting

                            IconImage {
                                anchors.centerIn: parent
                                width: Math.min(16, root.widgetHeight - 8)
                                height: Math.min(16, root.widgetHeight - 8)
                                source: delegateRoot.iconSource
                                asynchronous: true
                                smooth: true
                                mipmap: true
                            }
                            
                            layer.effect: MultiEffect {
                                colorization: SettingsData.systemIconTinting ? SettingsData.iconTintIntensity : 0
                                colorizationColor: Theme.primary
                            }
                        }
                    }

                MouseArea {
                    id: trayItemArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: (mouse) => {
                            if (!delegateRoot.trayItem) {
                            return;
                        }
                            if (mouse.button === Qt.LeftButton && !delegateRoot.trayItem.onlyMenu) {
                                delegateRoot.trayItem.activate();
                            return;
                        }
                            if (mouse.button === Qt.RightButton) {
                                const hasMenu = delegateRoot.trayItem.menu || delegateRoot.trayItem.hasMenu
                                if (delegateRoot.trayItem && hasMenu) {
                                    root.showForTrayItem(delegateRoot.trayItem, visualContent, parentScreen, root.isAtBottom, root.isVertical, root.axis);
                                } else {
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    function showForTrayItem(item, anchor, screen, atBottom, vertical, axisObj) {
        const barPosition = atBottom ? "bottom" : "top"
        const barThickness = root.barThickness
        const menuComponent = trayContextMenuLoader.item
        if (menuComponent && menuComponent.openForItem) {
            menuComponent.openForItem(item, anchor, screen, barPosition, vertical, barThickness)
        } else {
            console.error("[SystemTrayBar] TrayContextMenu not available or missing openForItem function")
        }
    }
}
