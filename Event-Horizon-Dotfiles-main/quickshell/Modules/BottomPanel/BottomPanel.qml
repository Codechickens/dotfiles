import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.Notifications
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Common
import qs.Services
import qs.Widgets
import qs.TaskBar.Widgets
import qs.Modules.BottomPanel
import qs.Modules.Dock

PanelWindow {
    id: root

    WlrLayershell.namespace: "quickshell:bar:blur"
    WlrLayershell.layer: WlrLayershell.Top
    WlrLayershell.exclusiveZone: {
        if (!SettingsData.taskBarVisible) {
            return 0
        }
        if (SettingsData.taskBarAutoHide && !taskBarCore.reveal) {
            return 8
        }
        return SettingsData.taskBarExclusiveZone > 0 ? SettingsData.taskBarExclusiveZone * SettingsData.taskbarScale : implicitHeight
    }
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    property var modelData
    property var notepadVariants: null
    property real panelHeight: SettingsData.taskBarHeight * SettingsData.taskbarScale
    property real backgroundTransparency: SettingsData.taskBarTransparency
    readonly property real widgetHeight: Math.max(20, panelHeight * 0.85)
    readonly property string screenName: modelData.name
    readonly property int notificationCount: NotificationService.notifications.length

    signal colorPickerRequested()

    function getNotepadInstanceForScreen() {
        if (!notepadVariants || !notepadVariants.instances) return null

        for (var i = 0; i < notepadVariants.instances.length; i++) {
            var slideout = notepadVariants.instances[i]
            if (slideout.modelData && slideout.modelData.name === root.screen?.name) {
                return slideout
            }
        }
        return null
    }

    screen: modelData
    color: "transparent"
    visible: SettingsData.taskBarVisible

    property var contextMenu: dockContextMenuLoader.item
    
    Connections {
        target: dockContextMenuLoader
        function onItemChanged() {
            // Force update of contextMenu when loader item changes
            if (dockContextMenuLoader.item) {
                // The property binding should handle this, but this ensures it updates
            }
        }
    }

    // Edge-to-edge positioning (or floating)
    anchors {
        bottom: true
        left: true
        right: true
    }

    margins {
        left: SettingsData.taskBarFloat ? SettingsData.taskBarBottomMargin : 0
        right: SettingsData.taskBarFloat ? SettingsData.taskBarBottomMargin : 0
        bottom: SettingsData.taskBarFloat ? SettingsData.taskBarBottomMargin : 0
        top: 0
    }

    implicitHeight: panelHeight

    Item {
        id: taskBarCore
        anchors.fill: parent
        property bool autoHide: SettingsData.taskBarAutoHide
        property bool revealSticky: false
        property bool intentToShow: false

        Timer {
            id: hideTimer
            interval: 500
            repeat: false
            onTriggered: {
                // Only hide if mouse is still away and we don't have intent to show
                if (!taskBarMouseArea.containsMouse && !taskBarCore.intentToShow) {
                    taskBarCore.revealSticky = false
                }
            }
        }

        Timer {
            id: graceTimer
            interval: 1500
            repeat: false
            onTriggered: {
                if (!taskBarMouseArea.containsMouse && !taskBarCore.hasActivePopout) {
                    taskBarCore.revealSticky = false
                }
            }
        }

        Timer {
            id: showIntentTimer
            interval: 200  // Mouse must be present for 200ms to establish intent
            repeat: false
            onTriggered: {
                taskBarCore.intentToShow = true
            }
        }

        property bool reveal: {
            if (!SettingsData.taskBarVisible) {
                return false
            }
            return !autoHide || taskBarMouseArea.containsMouse || revealSticky
        }


        readonly property bool hasActivePopout: {
            const loaders = [{
                                 "loader": appDrawerLoader,
                                 "prop": "shouldBeVisible"
                             }, {
                                 "loader": darkDashLoader,
                                 "prop": "shouldBeVisible"
                             }, {
                                 "loader": processListPopoutLoader,
                                 "prop": "shouldBeVisible"
                             }, {
                                 "loader": notificationCenterLoader,
                                 "prop": "shouldBeVisible"
                             }, {
                                 "loader": batteryPopoutLoader,
                                 "prop": "shouldBeVisible"
                             }, {
                                 "loader": vpnPopoutLoader,
                                 "prop": "shouldBeVisible"
                             }, {
                                 "loader": controlCenterLoader,
                                 "prop": "shouldBeVisible"
                             }, {
                                 "loader": clipboardHistoryModalPopup,
                                 "prop": "visible"
                             }, {
                                 "loader": volumeMixerPopoutLoader,
                                 "prop": "shouldBeVisible"
                             }]
            return loaders.some(item => {
                if (item.loader) {
                    return item.loader?.item?.[item.prop]
                }
                return false
            })
        }

        Connections {
            target: taskBarMouseArea
            function onContainsMouseChanged() {
                if (taskBarMouseArea.containsMouse) {
                    // Mouse entered - show immediately and cancel all timers
                    taskBarCore.revealSticky = true
                    hideTimer.stop()
                    graceTimer.stop()
                } else {
                    // Mouse left - start grace period before hiding
                    if (taskBarCore.autoHide && !graceTimer.running) {
                        graceTimer.restart()
                    }
                }
            }
        }

        MouseArea {
            id: taskBarMouseArea
            anchors.fill: parent
            hoverEnabled: taskBarCore.autoHide
            acceptedButtons: Qt.NoButton
            enabled: taskBarCore.autoHide
        }
    }

    Item {
        id: panelContainer
        anchors.fill: parent
        readonly property string barPosition: "bottom"
        readonly property bool barIsVertical: false
        
        transform: Translate {
            id: panelSlide
            y: Math.round(taskBarCore.reveal ? 0 : panelHeight)
            
            Behavior on y {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }

        Rectangle {
            id: panelBackground
            anchors.fill: parent
            color: {
                var baseColor = Theme.surfaceContainer
                return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, backgroundTransparency)
            }
            radius: SettingsData.taskBarRoundedCorners ? SettingsData.taskBarCornerRadius : 0
        }

        // Content container
        Item {
            id: panelContent
            anchors.fill: parent
        anchors.leftMargin: SettingsData.taskBarLeftPadding + 2
        anchors.rightMargin: SettingsData.taskBarRightPadding + 2
        anchors.topMargin: SettingsData.taskBarTopPadding
        anchors.bottomMargin: SettingsData.taskBarBottomPadding
        clip: true

        function getWidgetEnabled(enabled) {
            return enabled !== false
        }

        readonly property var widgetVisibility: ({
                                                     "cpuUsage": DgopService.dgopAvailable,
                                                     "memUsage": DgopService.dgopAvailable,
                                                     "cpuTemp": DgopService.dgopAvailable,
                                                     "gpuTemp": DgopService.dgopAvailable,
                                                     "network_speed_monitor": DgopService.dgopAvailable
                                                 })

        function getWidgetVisible(widgetId) {
            return widgetVisibility[widgetId] ?? true
        }

        readonly property var componentMap: ({
                                                 "launcherButton": launcherButtonComponent,
                                                 "launchpad": launchpadComponent,
                                                 "workspaceSwitcher": workspaceSwitcherComponent,
                                                 "focusedWindow": focusedWindowComponent,
                                                 "runningApps": runningAppsComponent,
                                                 "clock": clockComponent,
                                                 "music": mediaComponent,
                                                 "weather": weatherComponent,
                                                 "darkDash": darkDashComponent,
                                                 "applications": applicationsComponent,
                                                 "systemTray": systemTrayComponent,
                                                 "privacyIndicator": privacyIndicatorComponent,
                                                 "clipboard": clipboardComponent,
                                                 "trash": trashComponent,
                                                 "cpuUsage": cpuUsageComponent,
                                                 "memUsage": memUsageComponent,
                                                 "cpuTemp": cpuTempComponent,
                                                 "gpuTemp": gpuTempComponent,
                                                 "notificationButton": notificationButtonComponent,
                                                 "battery": batteryComponent,
                                                 "controlCenterButton": controlCenterButtonComponent,
                                                 "idleInhibitor": idleInhibitorComponent,
                                                 "spacer": spacerComponent,
                                                 "separator": separatorComponent,
                                                 "network_speed_monitor": networkComponent,
                                                 "keyboard_layout_name": keyboardLayoutNameComponent,
                                                 "vpn": vpnComponent,
                                                 "notepadButton": notepadButtonComponent,
                                                 "colorPicker": colorPickerComponent,
                                                 "systemUpdate": systemUpdateComponent,
                                                 "volumeMixerButton": volumeMixerButtonComponent,
                                                 "pinnedApps": pinnedAppsComponent
                                             })

        function getWidgetComponent(widgetId) {
            return componentMap[widgetId] || null
        }

        Item {
            id: contentRow
            anchors.fill: parent

            // Left section
            Row {
                id: leftSection
                height: parent.height
                spacing: Theme.spacingXS
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                Repeater {
                    model: SettingsData.taskBarLeftWidgetsModel

                    Connections {
                        target: SettingsData.taskBarLeftWidgetsModel
                        function onCountChanged() {
                            // Toggling visibility forces the Repeater to re-evaluate its model
                            leftSection.visible = false
                            Qt.callLater(() => { leftSection.visible = true })
                        }
                    }

                    Loader {
                        property string widgetId: model.widgetId
                        property var widgetData: model
                        property int spacerSize: model.size || 20

                        property bool isBarVertical: panelContainer.barIsVertical

                        anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                        active: leftSection.visible && panelContent.getWidgetVisible(model.widgetId) && (model.widgetId !== "music" || MprisController.activePlayer !== null)
                        sourceComponent: panelContent.getWidgetComponent(model.widgetId)
                        opacity: panelContent.getWidgetEnabled(model.enabled) ? 1 : 0
                        asynchronous: false
                    }
                }
            }

            // Center section
            Item {
                id: centerSection
                width: centerRow.width
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter

                Row {
                    id: centerRow
                    height: parent.height
                    spacing: Theme.spacingXS
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    Repeater {
                        model: SettingsData.taskBarCenterWidgetsModel

                        Connections {
                            target: SettingsData.taskBarCenterWidgetsModel
                            function onCountChanged() {
                                centerRow.visible = false
                                Qt.callLater(() => { centerRow.visible = true })
                            }
                        }

                        Loader {
                            property string widgetId: model.widgetId
                            property var widgetData: model
                            property int spacerSize: model.size || 20

                            property bool isBarVertical: panelContainer.barIsVertical

                            anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                            active: centerSection.visible && panelContent.getWidgetVisible(model.widgetId) && (model.widgetId !== "music" || MprisController.activePlayer !== null)
                            sourceComponent: panelContent.getWidgetComponent(model.widgetId)
                            opacity: panelContent.getWidgetEnabled(model.enabled) ? 1 : 0
                            asynchronous: false
                        }
                    }
                }
            }

            // Right section
            Row {
                id: rightSection
                height: parent.height
                spacing: Theme.spacingXS
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                Repeater {
                    model: SettingsData.taskBarRightWidgetsModel

                    Connections {
                        target: SettingsData.taskBarRightWidgetsModel
                        function onCountChanged() {
                            rightSection.visible = false
                            Qt.callLater(() => { rightSection.visible = true })
                        }
                    }

                    Loader {
                        property string widgetId: model.widgetId
                        property var widgetData: model
                        property int spacerSize: model.size || 20

                        property bool isBarVertical: panelContainer.barIsVertical

                        anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                        active: rightSection.visible && panelContent.getWidgetVisible(model.widgetId) && (model.widgetId !== "music" || MprisController.activePlayer !== null)
                        sourceComponent: panelContent.getWidgetComponent(model.widgetId)
                        opacity: panelContent.getWidgetEnabled(model.enabled) ? 1 : 0
                        asynchronous: false
                    }
                }
            }
        }

        // Widget Components
        Component {
            id: launcherButtonComponent
            LauncherButton {
                isActive: false
                widgetHeight: root.widgetHeight
                barHeight: root.panelHeight
                section: "left"
                popupTarget: appDrawerLoader.item
                parentScreen: root.screen
                onClicked: {
                    appDrawerLoader.active = true
                    appDrawerLoader.item?.toggle()
                }
            }
        }

        Component {
            id: launchpadComponent
            Launchpad {
                widgetHeight: root.widgetHeight
                parentScreen: root.screen
            }
        }

        Component {
            id: workspaceSwitcherComponent
            WorkspaceSwitcher {
                screenName: root.screenName
                widgetHeight: root.widgetHeight
                isBarVertical: false
            }
        }

        Component {
            id: focusedWindowComponent
            FocusedApp {
                availableWidth: 456
                widgetHeight: root.widgetHeight
            }
        }

        Component {
            id: runningAppsComponent
            RunningApps {
                widgetHeight: root.widgetHeight
                section: "left"
                parentScreen: root.screen
                topBar: panelContent
                contextMenu: root.contextMenu
            }
        }

        Component {
            id: clockComponent
            Clock {
                compactMode: false
                barHeight: root.panelHeight
                widgetHeight: root.widgetHeight
                section: "center"
                parentScreen: root.screen
                isBarVertical: false
            }
        }

        Component {
            id: mediaComponent
            Media {
                compactMode: false
                barHeight: root.panelHeight
                widgetHeight: root.widgetHeight
                section: "center"
                parentScreen: root.screen
                isBarVertical: false
            }
        }

        Component {
            id: weatherComponent
            Weather {
                barHeight: root.panelHeight
                widgetHeight: root.widgetHeight
                section: "center"
                parentScreen: root.screen
                isBarVertical: false
            }
        }

        Component {
            id: darkDashComponent
            DarkDash {
                barHeight: root.panelHeight
                widgetHeight: root.widgetHeight
                section: "center"
                parentScreen: root.screen
                isBarVertical: false
            }
        }

        Component {
            id: applicationsComponent
            Applications {
                barHeight: root.panelHeight
                widgetHeight: root.widgetHeight
                section: "center"
                parentScreen: root.screen
                isBarVertical: false
            }
        }

        Component {
            id: systemTrayComponent
            SystemTrayBar {
                parentWindow: root
                parentScreen: root.screen
                widgetHeight: root.widgetHeight
                isAtBottom: true
                isVertical: false
                isBarVertical: false
                axis: null
                visible: true
            }
        }

        Component {
            id: privacyIndicatorComponent
            PrivacyIndicator {
                widgetHeight: root.widgetHeight
                section: "right"
                parentScreen: root.screen
                isBarVertical: false
            }
        }

        Component {
            id: cpuUsageComponent
            CpuMonitor {
                barHeight: root.panelHeight
                widgetHeight: root.widgetHeight
                section: "right"
                popupTarget: {
                    processListPopoutLoader.active = true
                    return processListPopoutLoader.item
                }
                parentScreen: root.screen
                toggleProcessList: () => {
                                       processListPopoutLoader.active = true
                                       return processListPopoutLoader.item?.toggle()
                                   }
                isBarVertical: false
            }
        }

        Component {
            id: memUsageComponent
            RamMonitor {
                barHeight: root.panelHeight
                widgetHeight: root.widgetHeight
                section: "right"
                popupTarget: {
                    processListPopoutLoader.active = true
                    return processListPopoutLoader.item
                }
                parentScreen: root.screen
                toggleProcessList: () => {
                                       processListPopoutLoader.active = true
                                       return processListPopoutLoader.item?.toggle()
                                   }
                isBarVertical: false
            }
        }

        Component {
            id: cpuTempComponent
            CpuTemperature {
                barHeight: root.panelHeight
                widgetHeight: root.widgetHeight
                section: "right"
                popupTarget: {
                    processListPopoutLoader.active = true
                    return processListPopoutLoader.item
                }
                parentScreen: root.screen
                toggleProcessList: () => {
                                       processListPopoutLoader.active = true
                                       return processListPopoutLoader.item?.toggle()
                                   }
                isBarVertical: false
            }
        }

        Component {
            id: gpuTempComponent
            GpuTemperature {
                barHeight: root.panelHeight
                widgetHeight: root.widgetHeight
                section: "right"
                popupTarget: {
                    processListPopoutLoader.active = true
                    return processListPopoutLoader.item
                }
                parentScreen: root.screen
                widgetData: parent.widgetData
                toggleProcessList: () => {
                                       processListPopoutLoader.active = true
                                       return processListPopoutLoader.item?.toggle()
                                   }
                isBarVertical: false
            }
        }

        Component {
            id: networkComponent
            NetworkMonitor {
                isBarVertical: false
            }
        }

        Component {
            id: notificationButtonComponent
            NotificationCenterButton {
                hasUnread: root.notificationCount > 0
                isActive: notificationCenterLoader.item ? notificationCenterLoader.item.shouldBeVisible : false
                widgetHeight: root.widgetHeight
                barHeight: root.panelHeight
                section: "right"
                popupTarget: {
                    notificationCenterLoader.active = true
                    return notificationCenterLoader.item
                }
                parentScreen: root.screen
                onClicked: {
                    notificationCenterLoader.active = true
                    notificationCenterLoader.item?.toggle()
                }
                isBarVertical: false
            }
        }

        Component {
            id: batteryComponent
            Battery {
                batteryPopupVisible: batteryPopoutLoader.item ? batteryPopoutLoader.item.shouldBeVisible : false
                widgetHeight: root.widgetHeight
                barHeight: root.panelHeight
                section: "right"
                popupTarget: {
                    batteryPopoutLoader.active = true
                    return batteryPopoutLoader.item
                }
                parentScreen: root.screen
                onToggleBatteryPopup: {
                    batteryPopoutLoader.active = true
                    batteryPopoutLoader.item?.toggle()
                }
                isBarVertical: false
            }
        }

        Component {
            id: vpnComponent
            Vpn {
                widgetHeight: root.widgetHeight
                barHeight: root.panelHeight
                section: "right"
                popupTarget: {
                    vpnPopoutLoader.active = true
                    return vpnPopoutLoader.item
                }
                parentScreen: root.screen
                onToggleVpnPopup: {
                    vpnPopoutLoader.active = true
                    vpnPopoutLoader.item?.toggle()
                }
                isBarVertical: false
            }
        }

        Component {
            id: controlCenterButtonComponent
            ControlCenterButton {
                isActive: controlCenterLoader.item ? controlCenterLoader.item.shouldBeVisible : false
                widgetHeight: root.widgetHeight
                barHeight: root.panelHeight
                section: "right"
                popupTarget: {
                    controlCenterLoader.active = true
                    return controlCenterLoader.item
                }
                parentScreen: root.screen
                widgetData: parent.widgetData
                onClicked: {
                    controlCenterLoader.active = true
                    if (!controlCenterLoader.item) {
                        return
                    }
                    controlCenterLoader.item.triggerScreen = root.screen
                    controlCenterLoader.item.toggle()
                    if (controlCenterLoader.item.shouldBeVisible && NetworkService.wifiEnabled) {
                        NetworkService.scanWifi()
                    }
                }
                isBarVertical: false
            }
        }

        Component {
            id: idleInhibitorComponent
            IdleInhibitor {
                widgetHeight: root.widgetHeight
                section: "right"
                parentScreen: root.screen
                isBarVertical: false
            }
        }

        Component {
            id: spacerComponent
            Item {
                width: parent.spacerSize || 20
                height: root.widgetHeight
            }
        }

        Component {
            id: separatorComponent
            Rectangle {
                width: 1
                height: root.widgetHeight * 0.67
                color: Theme.outline
                opacity: 0.3
            }
        }

        Component {
            id: keyboardLayoutNameComponent
            KeyboardLayoutName {
                isBarVertical: false
            }
        }

        Component {
            id: notepadButtonComponent
            NotepadButton {
                property var notepadInstance: root.getNotepadInstanceForScreen()
                isActive: notepadInstance?.isVisible ?? false
                widgetHeight: root.widgetHeight
                barHeight: root.panelHeight
                section: "right"
                popupTarget: notepadInstance
                parentScreen: root.screen
                onClicked: {
                    if (notepadInstance) {
                        notepadInstance.toggle()
                    }
                }
                isBarVertical: false
            }
        }

        Component {
            id: colorPickerComponent
            ColorPicker {
                widgetHeight: root.widgetHeight
                barHeight: root.panelHeight
                section: "right"
                parentScreen: root.screen
                onColorPickerRequested: {
                    root.colorPickerRequested()
                }
                isBarVertical: false
            }
        }

        Component {
            id: systemUpdateComponent
            SystemUpdate {
                isActive: false // TODO: connect to popup visibility if needed
                widgetHeight: root.widgetHeight
                barHeight: root.panelHeight
                section: "right"
                parentScreen: root.screen
                isBarVertical: false
            }
        }

        Component {
            id: volumeMixerButtonComponent
            VolumeMixerButton {
                widgetHeight: root.widgetHeight
                barHeight: root.panelHeight
                section: "right"
                popupTarget: {
                    volumeMixerPopoutLoader.active = true
                    return volumeMixerPopoutLoader.item
                }
                parentScreen: root.screen
                isBarVertical: false
            }
        }

        Component {
            id: pinnedAppsComponent
            PinnedApps {
                widgetHeight: root.widgetHeight
                section: "left"
                parentScreen: root.screen
                contextMenu: root.contextMenu
            }
        }

        Component {
            id: clipboardComponent
            Rectangle {
                readonly property real horizontalPadding: Math.max(Theme.spacingXS, Theme.spacingS * (root.widgetHeight / 30))
                width: clipboardIcon.width + horizontalPadding * 2
                height: root.widgetHeight
                radius: Theme.cornerRadius
                color: {
                    const baseColor = clipboardArea.containsMouse ? Theme.widgetBaseHoverColor : Theme.widgetBaseBackgroundColor
                    return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * 0.85)
                }

                EHIcon {
                    id: clipboardIcon
                    anchors.centerIn: parent
                    name: "content_paste"
                    size: Theme.iconSize - 10
                    color: Theme.surfaceText
                }

                MouseArea {
                    id: clipboardArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        clipboardHistoryModalPopup.toggle()
                    }
                }
            }
        }

        Component {
            id: trashComponent
            TrashBin {
                widgetHeight: root.widgetHeight
                section: "right"
                parentScreen: root.screen
            }
        }
        }
    }

    // Context menu for pinned apps
    Loader {
        id: dockContextMenuLoader
        active: true
        asynchronous: false
        sourceComponent: Component {
            TaskBarContextMenu {
                id: taskBarContextMenu
                screen: root.screen
            }
        }
    }
}
