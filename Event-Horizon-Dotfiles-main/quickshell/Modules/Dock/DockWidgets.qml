import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Services.Notifications
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.Common
import qs.Modules
import qs.Modules.TopBar
import qs.Modules.Dock
import qs.TaskBar.Widgets
import qs.Services
import qs.Widgets

Row {
    id: root

    property var widgetList: []
    property var contextMenu: null
    property string side: "left" // "left", "right", "farLeft", or "farRight"
    property bool allowEdgeAnchors: false
    property bool _pendingAppDrawerPosition: false
    property real _pendingTriggerX: 0
    property real _pendingTriggerY: 0
    property real _pendingTriggerWidth: 0
    property string _pendingTriggerSection: "dock"
    property var _pendingTriggerScreen: null
    property var _pendingAppDrawerLoader: null

    spacing: Theme.spacingS
    clip: false // Ensure widgets aren't clipped
    anchors.centerIn: !root.allowEdgeAnchors ? parent : undefined
    anchors.verticalCenter: root.allowEdgeAnchors ? parent.verticalCenter : undefined

    readonly property real widgetHeight: height
    
    readonly property bool isFarSide: side === "farLeft" || side === "farRight"
    readonly property real farSideOpacity: 0.8
    readonly property real farSideScale: 0.9
    
    function calculateWidgetPosition(position, triggerWidth, triggerHeight) {
        const screen = root.screen || Screen
        const screenWidth = screen.width
        const screenHeight = screen.height
        
        // Use dock exclusive zone for thickness (matches dock volumemixer pattern)
        // Exclusive zone includes: dockExclusiveZone + dockBottomGap + (dockTopPadding * 2)
        var dockThickness = (SettingsData?.dockExclusiveZone || 0) * (SettingsData?.dockScale || 1) + (SettingsData?.dockBottomGap || 0) + ((SettingsData?.dockTopPadding || 0) * 2 * Math.sqrt(SettingsData?.dockScale || 1))
        // Fallback to dockHeight if exclusive zone not set
        if (dockThickness === 0) {
            dockThickness = ((SettingsData?.dockHeight || 80) + (SettingsData?.dockBottomGap || 0) + ((SettingsData?.dockTopPadding || 0) * 2 * Math.sqrt(SettingsData?.dockScale || 1))) * (SettingsData?.dockScale || 1)
        }
        const availableHeight = screenHeight - dockThickness - 20 // Extra margin
        
        const isExpandMode = SettingsData.dockExpandToScreen
        
        switch (position) {
            case "top-left":
                return { x: 20, y: 20, section: "left" }
            case "top-right":
                return { x: screenWidth - triggerWidth, y: 20, section: "right" }
            case "bottom-left":
                if (isExpandMode) {
                    return { x: 8, y: availableHeight - triggerHeight, section: "left" }
                } else {
                    return { x: 20, y: availableHeight - triggerHeight, section: "left" }
                }
            case "bottom-right":
                if (isExpandMode) {
                    return { x: screenWidth - triggerWidth - 8, y: availableHeight - triggerHeight, section: "right" }
                } else {
                    return { x: screenWidth - triggerWidth, y: availableHeight - triggerHeight, section: "right" }
                }
            case "center":
                if (isExpandMode) {
                    return { x: 8, y: (availableHeight - triggerHeight) / 2, section: "left" }
                } else {
                    return { x: (screenWidth - triggerWidth) / 2, y: (availableHeight - triggerHeight) / 2, section: "center" }
                }
            default:
                if (isExpandMode) {
                    return { x: screenWidth - triggerWidth - 8, y: availableHeight - triggerHeight, section: "right" }
                } else {
                    return { x: screenWidth - triggerWidth, y: availableHeight - triggerHeight, section: "right" }
                }
        }
    }

    function applyPendingAppDrawerPosition() {
        if (!_pendingAppDrawerPosition || !_pendingAppDrawerLoader || !_pendingAppDrawerLoader.item) {
            return
        }
        if (_pendingAppDrawerLoader.item.setTriggerPosition) {
            _pendingAppDrawerLoader.item.setTriggerPosition(_pendingTriggerX, _pendingTriggerY, _pendingTriggerWidth, _pendingTriggerSection, _pendingTriggerScreen)
        }
        _pendingAppDrawerLoader.item.show()
        _pendingAppDrawerPosition = false
    }

    Connections {
        target: _pendingAppDrawerLoader
        function onItemChanged() {
            root.applyPendingAppDrawerPosition()
        }
    }

    Component { id: clockComponent; DockClock { widgetHeight: root.widgetHeight } }
    Component {
        id: weatherComponent
        DockWeather {
            widgetHeight: root.widgetHeight
            isBarVertical: false
        }
    }
    Component { id: batteryComponent; DockBattery { widgetHeight: root.widgetHeight } }
    Component {
        id: musicComponent
        DockMusic {
            widgetHeight: root.widgetHeight
            isBarVertical: false
        }
    }
    Component { 
        id: launcherButtonComponent
        Rectangle {
            readonly property real horizontalPadding: Math.max(Theme.spacingXS, Theme.spacingS * (root.widgetHeight / 30))
            width: Math.max(40, launcherIcon.width + horizontalPadding * 2) // Ensure minimum width
            height: root.widgetHeight
            radius: Theme.cornerRadius
            z: 1000 // Ensure the entire button is on top
            color: {
                const baseColor = launcherArea.containsMouse ? Theme.widgetBaseHoverColor : Theme.widgetBaseBackgroundColor
                return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * Theme.widgetTransparency)
            }
            
            Component.onCompleted: {
            }
            
            

            SystemLogo {
                visible: SettingsData.useOSLogo && !SettingsData.useCustomLauncherImage
                anchors.centerIn: parent
                width: SettingsData.launcherLogoSize > 0 ? (SettingsData.launcherLogoSize - 3) * (root.widgetHeight / 40) : (root.widgetHeight - 6)
                height: SettingsData.launcherLogoSize > 0 ? (SettingsData.launcherLogoSize - 3) * (root.widgetHeight / 40) : (root.widgetHeight - 6)
                colorOverride: SettingsData.osLogoColorOverride !== "" ? SettingsData.osLogoColorOverride : Qt.rgba(SettingsData.launcherLogoRed, SettingsData.launcherLogoGreen, SettingsData.launcherLogoBlue, 1.0)
                brightnessOverride: SettingsData.osLogoBrightness
                contrastOverride: SettingsData.osLogoContrast

            }

            Item {
                visible: SettingsData.useCustomLauncherImage && SettingsData.customLauncherImagePath !== ""
                anchors.centerIn: parent
                width: SettingsData.launcherLogoSize > 0 ? (SettingsData.launcherLogoSize - 6) * (root.widgetHeight / 40) : (root.widgetHeight - 8)
                height: SettingsData.launcherLogoSize > 0 ? (SettingsData.launcherLogoSize - 6) * (root.widgetHeight / 40) : (root.widgetHeight - 8)

                Image {
                    id: customImage
                    anchors.fill: parent
                    source: SettingsData.customLauncherImagePath
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true

                    layer.enabled: SettingsData.launcherLogoRed !== 1.0 || SettingsData.launcherLogoGreen !== 1.0 || SettingsData.launcherLogoBlue !== 1.0
                    layer.effect: ColorOverlay {
                        color: Qt.rgba(SettingsData.launcherLogoRed, SettingsData.launcherLogoGreen, SettingsData.launcherLogoBlue, 0.8)
                    }
                }
            }

            EHIcon {
                id: launcherIcon
                visible: !SettingsData.useOSLogo && !SettingsData.useCustomLauncherImage
                anchors.centerIn: parent
                name: "apps"
                size: SettingsData.launcherLogoSize > 0 ? (SettingsData.launcherLogoSize - 6) * (root.widgetHeight / 40) : Math.min(Theme.iconSize, root.widgetHeight - 8)
                color: Qt.rgba(SettingsData.launcherLogoRed, SettingsData.launcherLogoGreen, SettingsData.launcherLogoBlue, 1.0)
            }

            MouseArea {
                id: launcherArea
                anchors.fill: parent
                anchors.margins: 0 // Ensure no margins
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                z: 2000 // Very high z-index to ensure it's on top
                propagateComposedEvents: false // Prevent event propagation
                enabled: true // Explicitly enable the mouse area
                
                preventStealing: true
                
                Rectangle {
                    anchors.fill: parent
                    color: launcherArea.containsMouse ? "rgba(255, 0, 0, 0.3)" : "rgba(255, 0, 0, 0.1)"
                    border.color: "red"
                    border.width: 2
                    radius: parent.parent.radius
                    z: 1000 // Ensure it's on top
                    visible: false // Hide debug visual
                }
                
                Component.onCompleted: {
                }
                
                onEntered: {
                }
                
                onExited: {
                }
                
                onPressed: (mouse) => {
                    mouse.accepted = true
                }
                
                onReleased: {
                }
                
                onClicked: {
                    try {
                        // Compute trigger position up front so we can apply it even if the loader isn't ready yet.
                        const rect = parent.mapToItem(null, 0, 0, width, height)

                        // Calculate dock thickness (same as other dock widgets)
                        var dockThickness = (SettingsData?.dockExclusiveZone || 0) * (SettingsData?.dockScale || 1) + (SettingsData?.dockBottomGap || 0) + ((SettingsData?.dockTopPadding || 0) * 2 * Math.sqrt(SettingsData?.dockScale || 1))
                        if (dockThickness === 0) {
                            dockThickness = ((SettingsData?.dockHeight || 48) + (SettingsData?.dockBottomGap || 0) + ((SettingsData?.dockTopPadding || 0) * 2)) * (SettingsData?.dockScale || 1)
                        }

                        // Position popup above dock, centered on button
                        const popupWidth = 400
                        const popupHeight = 600
                        // For dock positioning, triggerX should be the left edge of the button
                        // The EHPopout centering logic will handle centering the popup on the button
                        const triggerX = rect.x
                        const triggerY = Screen.height - dockThickness - popupHeight - 20

                        function queueAppDrawer(loader) {
                            if (!loader) {
                                return
                            }
                            loader.active = true
                            _pendingAppDrawerLoader = loader
                            _pendingTriggerX = triggerX
                            _pendingTriggerY = triggerY
                            _pendingTriggerWidth = rect.width
                            _pendingTriggerSection = "dock"
                            _pendingTriggerScreen = Screen
                            _pendingAppDrawerPosition = true
                            root.applyPendingAppDrawerPosition()
                        }

                        let current = root
                        while (current) {
                        if (current.appDrawerLoader) {
                            queueAppDrawer(current.appDrawerLoader)
                            return
                        }
                            current = current.parent
                        }

                        if (typeof appDrawerLoader !== 'undefined') {
                            queueAppDrawer(appDrawerLoader)
                        }
                    } catch (e) {
                    }
                }
                
                onPressAndHold: {
                }
            }
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
                return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * Theme.widgetTransparency)
            }

            EHIcon {
                id: clipboardIcon
                anchors.centerIn: parent
                name: "content_paste"
                size: Theme.iconSize
                color: Theme.surfaceText
            }

            MouseArea {
                id: clipboardArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                }
            }
        }
    }
    Component { id: cpuUsageComponent; DockCpuUsage { widgetHeight: root.widgetHeight } }
    Component {
        id: memUsageComponent
        DockMemUsage {
            widgetHeight: root.widgetHeight
            isBarVertical: false
        }
    }
    Component {
        id: cpuTempComponent
        DockCpuTemp {
            widgetHeight: root.widgetHeight
            isBarVertical: false
        }
    }
    Component { id: gpuTempComponent; DockGpuTemp { widgetHeight: root.widgetHeight } }
    Component {
        id: systemTrayComponent
        SystemTrayBar {
            parentScreen: root.screen
            parentWindow: root.Window.window
            isAtBottom: true
            isVertical: false
            axis: null
            widgetHeight: root.widgetHeight
            isBarVertical: false
        }
    }
    Component { id: privacyIndicatorComponent; DockPrivacyIndicator { widgetHeight: root.widgetHeight } }
    Component { 
        id: controlCenterButtonComponent
        ControlCenterButton {
            section: "left"
            isBarVertical: false
            popupTarget: {
                let current = root
                while (current) {
                    if (current.controlCenterLoader) {
                        current.controlCenterLoader.active = true
                        return current.controlCenterLoader.item
                    }
                    current = current.parent
                }
                return null
            }
            parentScreen: root.screen
            onClicked: {
                let current = root
                while (current) {
                    if (current.controlCenterLoader) {
                        current.controlCenterLoader.active = true
                        if (current.controlCenterLoader.item) {
                            // Get button position and calculate popup position above dock
                            const rect = parent.mapToItem(null, 0, 0, width, height)

                            // Calculate dock thickness (same as DockVolumeMixer and DockApplications)
                            var dockThickness = ((SettingsData?.dockExclusiveZone || 0) + (SettingsData?.dockBottomGap || 0) + ((SettingsData?.dockTopPadding || 0) * 2)) * (SettingsData?.dockScale || 1)
                            if (dockThickness === 0) {
                                dockThickness = ((SettingsData?.dockHeight || 48) + (SettingsData?.dockBottomGap || 0) + ((SettingsData?.dockTopPadding || 0) * 2)) * (SettingsData?.dockScale || 1)
                            }

                            // Position popup above dock, centered on button
                            // triggerY should be the top of the dock area - EHPopout will position above it
                            const triggerX = rect.x + rect.width / 2
                            const triggerY = Screen.height - dockThickness

                            current.controlCenterLoader.item.setTriggerPosition(triggerX, triggerY, rect.width, "center", Screen)
                            current.controlCenterLoader.item.toggle()
                        }
                        return
                    }
                    current = current.parent
                }

                if (typeof controlCenterLoader !== 'undefined') {
                    controlCenterLoader.active = true
                    if (controlCenterLoader.item) {
                        // Get button position and calculate popup position above dock
                        const rect = parent.mapToItem(null, 0, 0, width, height)

                        // Calculate dock thickness (same as DockVolumeMixer and DockApplications)
                        var dockThickness = ((SettingsData?.dockExclusiveZone || 0) + (SettingsData?.dockBottomGap || 0) + ((SettingsData?.dockTopPadding || 0) * 2)) * (SettingsData?.dockScale || 1)
                        if (dockThickness === 0) {
                            dockThickness = ((SettingsData?.dockHeight || 48) + (SettingsData?.dockBottomGap || 0) + ((SettingsData?.dockTopPadding || 0) * 2)) * (SettingsData?.dockScale || 1)
                        }

                        // Position popup above dock, centered on button
                        // triggerY should be the top of the dock area - EHPopout will position above it
                        const triggerX = rect.x + rect.width / 2
                        const triggerY = Screen.height - dockThickness

                        controlCenterLoader.item.setTriggerPosition(triggerX, triggerY, rect.width, "center", Screen)
                        controlCenterLoader.item.toggle()
                    }
                }
            }
        }
    }
    Component {
        id: workspaceSwitcherComponent
        WorkspaceSwitcher {
            widgetHeight: root.widgetHeight
            isBarVertical: false
        }
    }
    Component {
        id: trashComponent
        TrashBin {
            widgetHeight: root.widgetHeight
            parentScreen: root.screen
        }
    }
    Component {
        id: pinnedAppsComponent
        PinnedApps {
            widgetHeight: root.widgetHeight
            parentScreen: root.screen
            contextMenu: root.contextMenu
            iconSize: SettingsData.dockPinnedAppsIconSize * SettingsData.dockScale
            iconSpacing: SettingsData.dockPinnedAppsIconSpacing * SettingsData.dockScale
        }
    }
    Component { id: notificationButtonComponent; DockNotificationButton { widgetHeight: root.widgetHeight } }
    Component { id: vpnComponent; DockVpn { widgetHeight: root.widgetHeight } }
    Component { id: idleInhibitorComponent; DockIdleInhibitor { widgetHeight: root.widgetHeight } }
    Component { 
        id: spacerComponent
        Item {
            width: (widgetData && widgetData.size) ? widgetData.size : 20
            height: root.widgetHeight
        }
    }
    Component { 
        id: separatorComponent
        Rectangle {
            width: 2
            height: root.widgetHeight - 8
            color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.3)
            radius: 1
        }
    }
    Component { id: networkSpeedMonitorComponent; DockNetworkSpeedMonitor { widgetHeight: root.widgetHeight } }
    Component { id: keyboardLayoutNameComponent; DockKeyboardLayoutName { widgetHeight: root.widgetHeight } }
    Component { id: notepadButtonComponent; DockNotepadButton { widgetHeight: root.widgetHeight } }
    Component {
        id: volumeMixerButtonComponent
        DockVolumeMixer {
            widgetHeight: root.widgetHeight
        }
    }
    Component { id: colorPickerComponent; ColorPicker { } }
    Component { id: systemUpdateComponent; SystemUpdate { } }
    Component {
        id: darkDashComponent
        DockDarkDash {
            parentScreen: root.screen
        }
    }
    Component {
        id: applicationsComponent
        DockApplications {
            parentScreen: root.screen
            widgetHeight: root.widgetHeight
            function calculateWidgetPosition(position, triggerWidth, triggerHeight) {
                return root.calculateWidgetPosition(position, triggerWidth, triggerHeight)
            }
        }
    }
    Component {
        id: launchpadComponent
        DockLaunchpad {
            parentScreen: root.screen
            widgetHeight: root.widgetHeight
        }
    }
    Component {
        id: settingsButtonComponent
        Rectangle {
            property real widgetHeight: root.widgetHeight
            readonly property real horizontalPadding: Math.max(Theme.spacingXS, Theme.spacingS * (root.widgetHeight / 30))
            width: 40
            height: root.widgetHeight
            radius: Theme.cornerRadius
            color: settingsArea.containsMouse ? Theme.widgetBaseHoverColor : "transparent"
            
            MouseArea {
                id: settingsArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    settingsModal.show()
                }
            }

            EHIcon {
                anchors.centerIn: parent
                name: "settings"
                size: Math.min(Theme.iconSize, root.widgetHeight - 8)
                color: Theme.surfaceText
            }
        }
    }

    readonly property var componentMap: ({
                                             "clock": clockComponent,
                                             "weather": weatherComponent,
                                             "battery": batteryComponent,
                                             "music": musicComponent,
                                             "launcherButton": launcherButtonComponent,
                                             "darkDash": darkDashComponent,
                                             "applications": applicationsComponent,
                                             "launchpad": launchpadComponent,
                                             "clipboard": clipboardComponent,
                                             "cpuUsage": cpuUsageComponent,
                                             "memUsage": memUsageComponent,
                                             "cpuTemp": cpuTempComponent,
                                             "gpuTemp": gpuTempComponent,
                                             "systemTray": systemTrayComponent,
                                             "privacyIndicator": privacyIndicatorComponent,
                                             "controlCenterButton": controlCenterButtonComponent,
                                             "workspaceSwitcher": workspaceSwitcherComponent,
                                             "trash": trashComponent,
                                             "pinnedApps": pinnedAppsComponent,
                                             "notificationButton": notificationButtonComponent,
                                             "vpn": vpnComponent,
                                             "idleInhibitor": idleInhibitorComponent,
                                             "spacer": spacerComponent,
                                             "separator": separatorComponent,
                                             "network_speed_monitor": networkSpeedMonitorComponent,
                                             "keyboard_layout_name": keyboardLayoutNameComponent,
                                             "notepadButton": notepadButtonComponent,
                                             "volumeMixerButton": volumeMixerButtonComponent,
                                             "colorPicker": colorPickerComponent,
                                             "systemUpdate": systemUpdateComponent,
                                             "settingsButton": settingsButtonComponent
                                         })

    function getWidgetComponent(widgetId) {
        return componentMap[widgetId] || null
    }
    
    function getWidgetVisible(widgetId) {
        return true
    }
    
    function getWidgetEnabled(enabled) {
        if (!SettingsData.dockWidgetsEnabled) {
            return false
        }
        return enabled !== false
    }

    

    Repeater {
        model: root.widgetList
        
        Connections {
            target: root
            function onWidgetListChanged() {
                // Force re-evaluation of the Repeater when widgetList changes
                root.visible = false
                Qt.callLater(() => { root.visible = true })
            }
        }

        Component.onCompleted: {
        }

        Loader {
            property string widgetId: model.widgetId
            property var widgetData: model
            property int spacerSize: model.size || 20

            anchors.verticalCenter: parent ? parent.verticalCenter : undefined
            
            active: root.getWidgetVisible(widgetId) && (widgetId !== "music" || MprisController.activePlayer !== null)
            sourceComponent: root.getWidgetComponent(widgetId)
            
            Component.onCompleted: {
            }
            opacity: {
                const enabled = root.getWidgetEnabled(model.enabled)
                const farSideOpacity = root.isFarSide ? root.farSideOpacity : 1.0
                return enabled ? farSideOpacity : 0
            }
            scale: root.isFarSide ? root.farSideScale : 1.0
            asynchronous: false
            
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
            
            Behavior on scale {
                NumberAnimation { duration: 200 }
            }

            onLoaded: {
                if (!item) {
                    return
                }
                if (widgetId === "spacer") {
                    item.spacerSize = Qt.binding(() => model.size || 20)
                }
                
                if (root.isFarSide && item) {
                    item.opacity = root.farSideOpacity
                    item.scale = root.farSideScale
                }
                
                // Ensure volume mixer widget width is respected
                if (widgetId === "volumeMixerButton" && item.width) {
                    width = Qt.binding(() => item.width)
                }
            }
            
            onActiveChanged: {
                if (active) {
                    Qt.callLater(() => {
                        if (item) {
                            item.visible = true
                        }
                    })
                }
            }
        }
    }
}
