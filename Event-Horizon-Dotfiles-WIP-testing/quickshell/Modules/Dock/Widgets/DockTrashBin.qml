import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Dock

Item {
    id: root

    property string section: "right"
    property var popupTarget: null
    property var parentScreen: null
    property real widgetHeight: 30
    property bool pillEnabled: SettingsData.dockTrashPillEnabled
    property bool isHovered: pillEnabled ? mouseArea.containsMouse : mouseAreaNoPill.containsMouse

    // Trash state tracking
    property bool isTrashEmpty: true
    property bool trashCheckRunning: false

    implicitWidth: pillEnabled ? pillBackground.implicitWidth : trashIcon.width
    implicitHeight: pillEnabled ? pillBackground.implicitHeight : trashIcon.height
    width: implicitWidth
    height: implicitHeight

    onIsHoveredChanged: {
        if (isHovered) {
            exitAnimation.stop()
            if (!bounceAnimation.running)
                bounceAnimation.restart()
        } else {
            bounceAnimation.stop()
            exitAnimation.restart()
        }
    }

    SequentialAnimation {
        id: bounceAnimation

        running: false

        NumberAnimation {
            target: iconTransform
            property: "y"
            to: -6
            duration: Anims.durShort
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Anims.emphasizedAccel
        }

        NumberAnimation {
            target: iconTransform
            property: "y"
            to: -4
            duration: Anims.durShort
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Anims.emphasizedDecel
        }
    }

    NumberAnimation {
        id: exitAnimation

        running: false
        target: iconTransform
        property: "y"
        to: 0
        duration: Anims.durShort
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Anims.emphasizedDecel
    }

    Rectangle {
        id: pillBackground
        anchors.fill: parent
        visible: root.pillEnabled
        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, SettingsData.dockWidgetAreaOpacity)
        radius: Theme.cornerRadius
        border.width: 0
        border.color: "transparent"
        clip: true

        implicitWidth: trashIcon.width + 16
        implicitHeight: root.widgetHeight

        Item {
            id: pillIconContainer
            anchors.centerIn: parent
            width: trashIcon.width
            height: trashIcon.height
            transform: Translate {
                id: iconTransform
                y: 0
            }
        }

        Image {
            id: trashIcon
            anchors.centerIn: pillIconContainer
            width: SettingsData.dockIconSize * SettingsData.dockScale
            height: SettingsData.dockIconSize * SettingsData.dockScale
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            antialiasing: true

            // Use custom macOS-style trash icons based on trash state
            source: isTrashEmpty ? Qt.resolvedUrl("../../../assets/MacOS-Trash-Empty.png")
                               : Qt.resolvedUrl("../../../assets/MacOS-Trash-Full.png")

            // Update icon when trash state changes
            Connections {
                target: trashChecker
                function onTrashStateChanged() {
                    trashIcon.source = isTrashEmpty ? Qt.resolvedUrl("../../../assets/MacOS-Trash-Empty.png")
                                                  : Qt.resolvedUrl("../../../assets/MacOS-Trash-Full.png")
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    // Left-click: Open trash in default file browser
                    trashOpenProcess.running = true;
                } else if (mouse.button === Qt.RightButton) {
                    // Right-click: Show context menu
                    if (trashContextMenuLoader.item) {
                        trashContextMenuLoader.item.showForButton(root, null, root.parent ? root.parent.height : 40, null)
                    }
                }
            }
        }
    }

    // Non-pill version
    Item {
        id: noPillIconContainer
        visible: !root.pillEnabled
        anchors.centerIn: parent
        width: trashIconNoPill.width
        height: trashIconNoPill.height
        transform: Translate {
            y: 0
        }
    }

    Image {
        id: trashIconNoPill
        visible: !root.pillEnabled
        anchors.centerIn: noPillIconContainer
        width: SettingsData.dockIconSize * SettingsData.dockScale
        height: SettingsData.dockIconSize * SettingsData.dockScale
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
        antialiasing: true

        source: isTrashEmpty ? Qt.resolvedUrl("../../../assets/MacOS-Trash-Empty.png")
                           : Qt.resolvedUrl("../../../assets/MacOS-Trash-Full.png")

        Connections {
            target: trashChecker
            function onTrashStateChanged() {
                trashIconNoPill.source = isTrashEmpty ? Qt.resolvedUrl("../../../assets/MacOS-Trash-Empty.png")
                                                    : Qt.resolvedUrl("../../../assets/MacOS-Trash-Full.png")
            }
        }
    }

    MouseArea {
        id: mouseAreaNoPill
        visible: !root.pillEnabled
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                trashOpenProcess.running = true;
            } else if (mouse.button === Qt.RightButton) {
                if (trashContextMenuLoader.item) {
                    trashContextMenuLoader.item.showForButton(root, null, root.parent ? root.parent.height : 40, null)
                }
            }
        }
    }

    // Context menu loader
    Loader {
        id: trashContextMenuLoader
        active: true
        asynchronous: false
        sourceComponent: DockTrashContextMenu {
            screen: root.parentScreen || Quickshell.screens[0]
            onTrashEmptied: {
                // Immediately recheck trash state after emptying
                trashCheckRunning = true;
                trashCheckProcess.running = true;
            }
        }
    }

    // Trash state checker
    Item {
        id: trashChecker

        signal trashStateChanged()

        Process {
            id: trashCheckProcess
            running: false
            command: ["sh", "-c", "ls ~/.local/share/Trash/files/ | grep -v '^\\.$' | grep -v '^\\.\\.$' | wc -l"]

            onExited: exitCode => {
                if (exitCode === 0 && stdout) {
                    const count = parseInt(stdout.trim());
                    const hasItems = count > 0;
                    if (root.isTrashEmpty !== !hasItems) {
                        root.isTrashEmpty = !hasItems;
                        trashChecker.trashStateChanged();
                    }
                }
                trashCheckRunning = false;
            }
        }

        // Process to open trash in file browser
        Process {
            id: trashOpenProcess
            running: false
            command: ["sh", "-c", "xdg-open ~/.local/share/Trash/files"]
        }

        Timer {
            id: trashCheckTimer
            interval: 5000  // Check every 5 seconds
            running: false  // Disabled automatic checking
            repeat: true
            onTriggered: {
                if (!trashCheckRunning) {
                    trashCheckRunning = true;
                    trashCheckProcess.running = true;
                }
            }
        }
    }

    Component.onCompleted: {
        // Initial check
        trashCheckRunning = true;
        trashCheckProcess.running = true;
    }
}
