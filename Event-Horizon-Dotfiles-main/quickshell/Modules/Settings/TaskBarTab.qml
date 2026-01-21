import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: taskBarTab

    property var baseWidgetDefinitions: [{
            "id": "launcherButton",
            "text": "App Launcher",
            "description": "Quick access to application launcher",
            "icon": "apps",
            "enabled": true
        }, {
            "id": "launchpad",
            "text": "Launchpad",
            "description": "macOS-style application grid launcher",
            "icon": "view_comfy",
            "enabled": true
        }, {
            "id": "workspaceSwitcher",
            "text": "Workspace Switcher",
            "description": "Shows current workspace and allows switching",
            "icon": "view_module",
            "enabled": true
        }, {
            "id": "focusedWindow",
            "text": "Focused Window",
            "description": "Display currently focused application title",
            "icon": "window",
            "enabled": true
        }, {
            "id": "runningApps",
            "text": "Running Apps",
            "description": "Shows all running applications with focus indication",
            "icon": "apps",
            "enabled": true
        }, {
            "id": "clock",
            "text": "Clock",
            "description": "Current time and date display",
            "icon": "schedule",
            "enabled": true
        }, {
            "id": "weather",
            "text": "Weather Widget",
            "description": "Current weather conditions and temperature",
            "icon": "wb_sunny",
            "enabled": true
        }, {
            "id": "music",
            "text": "Media Controls",
            "description": "Control currently playing media",
            "icon": "music_note",
            "enabled": true
        }, {
            "id": "clipboard",
            "text": "Clipboard Manager",
            "description": "Access clipboard history",
            "icon": "content_paste",
            "enabled": true
        }, {
            "id": "cpuUsage",
            "text": "CPU Usage",
            "description": "CPU usage indicator",
            "icon": "memory",
            "enabled": DgopService.dgopAvailable,
            "warning": !DgopService.dgopAvailable ? "Requires 'dgop' tool" : undefined
        }, {
            "id": "memUsage",
            "text": "Memory Usage",
            "description": "Memory usage indicator",
            "icon": "storage",
            "enabled": DgopService.dgopAvailable,
            "warning": !DgopService.dgopAvailable ? "Requires 'dgop' tool" : undefined
        }, {
            "id": "cpuTemp",
            "text": "CPU Temperature",
            "description": "CPU temperature display",
            "icon": "device_thermostat",
            "enabled": DgopService.dgopAvailable,
            "warning": !DgopService.dgopAvailable ? "Requires 'dgop' tool" : undefined
        }, {
            "id": "gpuTemp",
            "text": "GPU Temperature",
            "description": "GPU temperature display",
            "icon": "auto_awesome_mosaic",
            "warning": !DgopService.dgopAvailable ? "Requires 'dgop' tool" : "This widget prevents GPU power off states, which can significantly impact battery life on laptops. It is not recommended to use this on laptops with hybrid graphics.",
            "enabled": DgopService.dgopAvailable
        }, {
            "id": "systemTray",
            "text": "System Tray",
            "description": "System notification area icons",
            "icon": "notifications",
            "enabled": true
        }, {
            "id": "privacyIndicator",
            "text": "Privacy Indicator",
            "description": "Shows when microphone, camera, or screen sharing is active",
            "icon": "privacy_tip",
            "enabled": true
        }, {
            "id": "controlCenterButton",
            "text": "Control Center",
            "description": "Access to system controls and settings",
            "icon": "settings",
            "enabled": true
        }, {
            "id": "notificationButton",
            "text": "Notification Center",
            "description": "Access to notifications and do not disturb",
            "icon": "notifications",
            "enabled": true
        }, {
            "id": "battery",
            "text": "Battery",
            "description": "Battery level and power management",
            "icon": "battery_std",
            "enabled": true
        }, {
            "id": "vpn",
            "text": "VPN",
            "description": "VPN status and quick connect",
            "icon": "vpn_lock",
            "enabled": true
        }, {
            "id": "idleInhibitor",
            "text": "Idle Inhibitor",
            "description": "Prevent screen timeout",
            "icon": "motion_sensor_active",
            "enabled": true
        }, {
            "id": "spacer",
            "text": "Spacer",
            "description": "Customizable empty space",
            "icon": "more_horiz",
            "enabled": true
        }, {
            "id": "separator",
            "text": "Separator",
            "description": "Visual divider between widgets",
            "icon": "remove",
            "enabled": true
        },
        {
            "id": "network_speed_monitor",
            "text": "Network Speed Monitor",
            "description": "Network download and upload speed display",
            "icon": "network_check",
            "warning": !DgopService.dgopAvailable ? "Requires 'dgop' tool" : undefined,
            "enabled": DgopService.dgopAvailable
        }, {
            "id": "keyboard_layout_name",
            "text": "Keyboard Layout Name",
            "description": "Displays the active keyboard layout and allows switching",
            "icon": "keyboard",
        }, {
            "id": "notepadButton",
            "text": "Notepad",
            "description": "Quick access to notepad",
            "icon": "assignment",
            "enabled": true
        }, {
            "id": "colorPicker",
            "text": "Color Picker",
            "description": "Quick access to color picker",
            "icon": "palette",
            "enabled": true
        }, {
            "id": "systemUpdate",
            "text": "System Update",
            "description": "Check for system updates",
            "icon": "update",
            "enabled": SystemUpdateService.distributionSupported
        }, {
            "id": "darkDash",
            "text": "Dark Dash",
            "description": "Quick access dashboard with overview, media, and weather",
            "icon": "dashboard",
            "enabled": true
        }, {
            "id": "applications",
            "text": "Applications",
            "description": "macOS Tahoe-style application launcher with categorized apps",
            "icon": "apps",
            "enabled": true
        }, {
            "id": "volumeMixerButton",
            "text": "Volume Mixer",
            "description": "Control system and application audio levels",
            "icon": "volume_up",
            "enabled": true
        }, {
            "id": "pinnedApps",
            "text": "Pinned Apps",
            "description": "Pinned and running applications",
            "icon": "apps",
            "enabled": true
        }, {
            "id": "trash",
            "text": "Trash Bin",
            "description": "Empty trash with right-click context menu",
            "icon": "delete",
            "enabled": true
        }]
    property var defaultLeftWidgets: ["launcherButton", {"id": "workspaceSwitcher", "enabled": true}]
    property var defaultCenterWidgets: [{"id": "pinnedApps", "enabled": true}, {"id": "trash", "enabled": true}]
    property var defaultRightWidgets: ["systemTray", "weather", "clock", "notificationButton", "controlCenterButton", "systemUpdate"]

    function addWidgetToSection(widgetId, targetSection) {
        var widgetObj = {
            "id": widgetId,
            "enabled": true
        }
        if (widgetId === "spacer")
            widgetObj.size = 20
        if (widgetId === "gpuTemp") {
            widgetObj.selectedGpuIndex = 0
            widgetObj.pciId = ""
        }
        if (widgetId === "controlCenterButton") {
            widgetObj.showNetworkIcon = true
            widgetObj.showBluetoothIcon = true
            widgetObj.showAudioIcon = true
        }

        var widgets = []
        if (targetSection === "left") {
            widgets = SettingsData.taskBarLeftWidgets.slice()
            widgets.push(widgetObj)
            SettingsData.setTaskBarLeftWidgets(widgets)
        } else if (targetSection === "center") {
            widgets = SettingsData.taskBarCenterWidgets.slice()
            widgets.push(widgetObj)
            SettingsData.setTaskBarCenterWidgets(widgets)
        } else if (targetSection === "right") {
            widgets = SettingsData.taskBarRightWidgets.slice()
            widgets.push(widgetObj)
            SettingsData.setTaskBarRightWidgets(widgets)
        }
    }

    function removeWidgetFromSection(sectionId, widgetIndex) {
        var widgets = []
        if (sectionId === "left") {
            widgets = SettingsData.taskBarLeftWidgets.slice()
            if (widgetIndex >= 0 && widgetIndex < widgets.length) {
                widgets.splice(widgetIndex, 1)
            }
            SettingsData.setTaskBarLeftWidgets(widgets)
        } else if (sectionId === "center") {
            widgets = SettingsData.taskBarCenterWidgets.slice()
            if (widgetIndex >= 0 && widgetIndex < widgets.length) {
                widgets.splice(widgetIndex, 1)
            }
            SettingsData.setTaskBarCenterWidgets(widgets)
        } else if (sectionId === "right") {
            widgets = SettingsData.taskBarRightWidgets.slice()
            if (widgetIndex >= 0 && widgetIndex < widgets.length) {
                widgets.splice(widgetIndex, 1)
            }
            SettingsData.setTaskBarRightWidgets(widgets)
        }
    }

    function handleItemEnabledChanged(sectionId, itemId, enabled) {
        var widgets = []
        if (sectionId === "left")
            widgets = SettingsData.taskBarLeftWidgets.slice()
        else if (sectionId === "center")
            widgets = SettingsData.taskBarCenterWidgets.slice()
        else if (sectionId === "right")
            widgets = SettingsData.taskBarRightWidgets.slice()
        for (var i = 0; i < widgets.length; i++) {
            var widget = widgets[i]
            var widgetId = typeof widget === "string" ? widget : widget.id
            if (widgetId === itemId) {
                if (typeof widget === "string") {
                    widgets[i] = {
                        "id": widget,
                        "enabled": enabled
                    }
                } else {
                    var newWidget = {
                        "id": widget.id,
                        "enabled": enabled
                    }
                    if (widget.size !== undefined)
                        newWidget.size = widget.size
                    if (widget.selectedGpuIndex !== undefined)
                        newWidget.selectedGpuIndex = widget.selectedGpuIndex
                    else if (widget.id === "gpuTemp")
                        newWidget.selectedGpuIndex = 0
                    if (widget.pciId !== undefined)
                        newWidget.pciId = widget.pciId
                    else if (widget.id === "gpuTemp")
                        newWidget.pciId = ""
                    if (widget.id === "controlCenterButton") {
                        newWidget.showNetworkIcon = widget.showNetworkIcon !== undefined ? widget.showNetworkIcon : true
                        newWidget.showBluetoothIcon = widget.showBluetoothIcon !== undefined ? widget.showBluetoothIcon : true
                        newWidget.showAudioIcon = widget.showAudioIcon !== undefined ? widget.showAudioIcon : true
                    }
                    widgets[i] = newWidget
                }
                break
            }
        }
        if (sectionId === "left")
            SettingsData.setTaskBarLeftWidgets(widgets)
        else if (sectionId === "center")
            SettingsData.setTaskBarCenterWidgets(widgets)
        else if (sectionId === "right")
            SettingsData.setTaskBarRightWidgets(widgets)
    }

    function handleItemOrderChanged(sectionId, newOrder) {
        if (sectionId === "left")
            SettingsData.setTaskBarLeftWidgets(newOrder)
        else if (sectionId === "center")
            SettingsData.setTaskBarCenterWidgets(newOrder)
        else if (sectionId === "right")
            SettingsData.setTaskBarRightWidgets(newOrder)
    }

    function handleSpacerSizeChanged(sectionId, widgetIndex, newSize) {
        var widgets = []
        if (sectionId === "left")
            widgets = SettingsData.taskBarLeftWidgets.slice()
        else if (sectionId === "center")
            widgets = SettingsData.taskBarCenterWidgets.slice()
        else if (sectionId === "right")
            widgets = SettingsData.taskBarRightWidgets.slice()

        if (widgetIndex >= 0 && widgetIndex < widgets.length) {
            var widget = widgets[widgetIndex]
            var widgetId = typeof widget === "string" ? widget : widget.id
            if (widgetId === "spacer") {
                if (typeof widget === "string") {
                    widgets[widgetIndex] = {
                        "id": widget,
                        "enabled": true,
                        "size": newSize
                    }
                } else {
                    var newWidget = {
                        "id": widget.id,
                        "enabled": widget.enabled,
                        "size": newSize
                    }
                    if (widget.selectedGpuIndex !== undefined)
                        newWidget.selectedGpuIndex = widget.selectedGpuIndex
                    if (widget.pciId !== undefined)
                        newWidget.pciId = widget.pciId
                    if (widget.id === "controlCenterButton") {
                        newWidget.showNetworkIcon = widget.showNetworkIcon !== undefined ? widget.showNetworkIcon : true
                        newWidget.showBluetoothIcon = widget.showBluetoothIcon !== undefined ? widget.showBluetoothIcon : true
                        newWidget.showAudioIcon = widget.showAudioIcon !== undefined ? widget.showAudioIcon : true
                    }
                    widgets[widgetIndex] = newWidget
                }
            }
        }

        if (sectionId === "left")
            SettingsData.setTaskBarLeftWidgets(widgets)
        else if (sectionId === "center")
            SettingsData.setTaskBarCenterWidgets(widgets)
        else if (sectionId === "right")
            SettingsData.setTaskBarRightWidgets(widgets)
    }

    function handleGpuSelectionChanged(sectionId, widgetIndex, selectedGpuIndex) {
        var widgets = []
        if (sectionId === "left")
            widgets = SettingsData.taskBarLeftWidgets.slice()
        else if (sectionId === "center")
            widgets = SettingsData.taskBarCenterWidgets.slice()
        else if (sectionId === "right")
            widgets = SettingsData.taskBarRightWidgets.slice()

        if (widgetIndex >= 0 && widgetIndex < widgets.length) {
            var widget = widgets[widgetIndex]
            if (typeof widget === "string") {
                widgets[widgetIndex] = {
                    "id": widget,
                    "enabled": true,
                    "selectedGpuIndex": selectedGpuIndex,
                    "pciId": DgopService.availableGpus
                             && DgopService.availableGpus.length
                             > selectedGpuIndex ? DgopService.availableGpus[selectedGpuIndex].pciId : ""
                }
            } else {
                var newWidget = {
                    "id": widget.id,
                    "enabled": widget.enabled,
                    "selectedGpuIndex": selectedGpuIndex,
                    "pciId": DgopService.availableGpus
                             && DgopService.availableGpus.length
                             > selectedGpuIndex ? DgopService.availableGpus[selectedGpuIndex].pciId : ""
                }
                if (widget.size !== undefined)
                    newWidget.size = widget.size
                widgets[widgetIndex] = newWidget
            }
        }

        if (sectionId === "left")
            SettingsData.setTaskBarLeftWidgets(widgets)
        else if (sectionId === "center")
            SettingsData.setTaskBarCenterWidgets(widgets)
        else if (sectionId === "right")
            SettingsData.setTaskBarRightWidgets(widgets)
    }

    function handleControlCenterSettingChanged(sectionId, widgetIndex, settingName, value) {
        if (settingName === "showNetworkIcon") {
            SettingsData.setControlCenterShowNetworkIcon(value)
        } else if (settingName === "showBluetoothIcon") {
            SettingsData.setControlCenterShowBluetoothIcon(value)
        } else if (settingName === "showAudioIcon") {
            SettingsData.setControlCenterShowAudioIcon(value)
        } else if (settingName === "showMicIcon") {
            SettingsData.setControlCenterShowMicIcon(value)
        }
    }

    function getItemsForSection(sectionId) {
        var widgets = []
        var widgetData = []
        if (sectionId === "left")
            widgetData = SettingsData.taskBarLeftWidgets || []
        else if (sectionId === "center")
            widgetData = SettingsData.taskBarCenterWidgets || []
        else if (sectionId === "right")
            widgetData = SettingsData.taskBarRightWidgets || []
        widgetData.forEach(widget => {
                               var widgetId = typeof widget === "string" ? widget : widget.id
                               var widgetEnabled = typeof widget
                               === "string" ? true : widget.enabled
                               var widgetSize = typeof widget === "string" ? undefined : widget.size
                               var widgetSelectedGpuIndex = typeof widget
                               === "string" ? undefined : widget.selectedGpuIndex
                               var widgetPciId = typeof widget
                               === "string" ? undefined : widget.pciId
                               var widgetShowNetworkIcon = typeof widget === "string" ? undefined : widget.showNetworkIcon
                               var widgetShowBluetoothIcon = typeof widget === "string" ? undefined : widget.showBluetoothIcon
                               var widgetShowAudioIcon = typeof widget === "string" ? undefined : widget.showAudioIcon
                               var widgetDef = baseWidgetDefinitions.find(w => {
                                                                              return w.id === widgetId
                                                                          })
                               if (widgetDef) {
                                   var item = Object.assign({}, widgetDef)
                                   item.enabled = widgetEnabled
                                   if (widgetSize !== undefined)
                                   item.size = widgetSize
                                   if (widgetSelectedGpuIndex !== undefined)
                                   item.selectedGpuIndex = widgetSelectedGpuIndex
                                   if (widgetPciId !== undefined)
                                   item.pciId = widgetPciId
                                   if (widgetShowNetworkIcon !== undefined)
                                   item.showNetworkIcon = widgetShowNetworkIcon
                                   if (widgetShowBluetoothIcon !== undefined)
                                   item.showBluetoothIcon = widgetShowBluetoothIcon
                                   if (widgetShowAudioIcon !== undefined)
                                   item.showAudioIcon = widgetShowAudioIcon

                                   widgets.push(item)
                               }
                           })
        return widgets
    }

    Component.onCompleted: {
        if (!SettingsData.taskBarLeftWidgets || SettingsData.taskBarLeftWidgets.length === 0)
            SettingsData.setTaskBarLeftWidgets(defaultLeftWidgets)

        if (!SettingsData.taskBarCenterWidgets || SettingsData.taskBarCenterWidgets.length === 0)
            SettingsData.setTaskBarCenterWidgets(defaultCenterWidgets)

        if (!SettingsData.taskBarRightWidgets || SettingsData.taskBarRightWidgets.length === 0)
            SettingsData.setTaskBarRightWidgets(defaultRightWidgets)
        const sections = ["left", "center", "right"]
        sections.forEach(sectionId => {
                             var widgets = []
                             if (sectionId === "left")
                             widgets = SettingsData.taskBarLeftWidgets.slice()
                             else if (sectionId === "center")
                             widgets = SettingsData.taskBarCenterWidgets.slice()
                             else if (sectionId === "right")
                             widgets = SettingsData.taskBarRightWidgets.slice()
                             var updated = false
                             for (var i = 0; i < widgets.length; i++) {
                                 var widget = widgets[i]
                                 if (typeof widget === "object"
                                     && widget.id === "spacer"
                                     && !widget.size) {
                                     widgets[i] = Object.assign({}, widget, {
                                                                    "size": 20
                                                                })
                                     updated = true
                                 }
                             }
                             if (updated) {
                                 if (sectionId === "left")
                                 SettingsData.setTaskBarLeftWidgets(widgets)
                                 else if (sectionId === "center")
                                 SettingsData.setTaskBarCenterWidgets(widgets)
                                 else if (sectionId === "right")
                                 SettingsData.setTaskBarRightWidgets(widgets)
                             }
                         })
    }

    EHFlickable {
        anchors.fill: parent
        anchors.topMargin: Theme.spacingL
        anchors.bottomMargin: Theme.spacingS
        clip: true
        contentHeight: mainColumn.height
        contentWidth: width

        Column {
            id: mainColumn
            width: parent.width
            spacing: Theme.spacingXL

            StyledRect {
                width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                height: taskBarAppearanceSection.implicitHeight + Theme.spacingL * 2
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g,
                               Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.2)
                border.width: 1

                Column {
                    id: taskBarAppearanceSection

                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingM

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "view_agenda"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Task Bar Appearance"
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Height"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarHeight
                            minimum: 30
                            maximum: 120
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarHeight(newValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Scale"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: Math.round(SettingsData.taskbarScale * 100)
                            minimum: 50
                            maximum: 150
                            unit: "%"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskbarScale(newValue / 100)
                            }
                        }
                    }


                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Background Opacity"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: Math.round(SettingsData.taskBarTransparency * 100)
                            minimum: 0
                            maximum: 100
                            unit: "%"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarTransparency(newValue / 100)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Icon Size"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskbarIconSize
                            minimum: 20
                            maximum: 60
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskbarIconSize(newValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Icon Spacing"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskbarIconSpacing
                            minimum: 0
                            maximum: 20
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskbarIconSpacing(newValue)
                            }
                        }
                    }

                    EHToggle {
                        width: parent.width
                        text: "Auto Hide Task Bar"
                        description: "Automatically hide the taskbar when not in use"
                        checked: SettingsData.taskBarAutoHide
                        onToggled: checked => {
                            SettingsData.setTaskBarAutoHide(checked)
                        }
                    }

                    EHToggle {
                        width: parent.width
                        text: "Show Task Bar"
                        description: "Show or hide the taskbar completely"
                        checked: SettingsData.taskBarVisible
                        onToggled: checked => {
                            SettingsData.setTaskBarVisible(checked)
                        }
                    }

                    EHToggle {
                        width: parent.width
                        text: "Float Task Bar"
                        description: "Make the taskbar float above other windows"
                        checked: SettingsData.taskBarFloat
                        onToggled: checked => {
                            SettingsData.setTaskBarFloat(checked)
                        }
                    }

                    EHToggle {
                        width: parent.width
                        text: "Rounded Corners"
                        description: "Enable rounded corners for the taskbar"
                        checked: SettingsData.taskBarRoundedCorners
                        enabled: SettingsData.taskBarFloat
                        onToggled: checked => {
                            SettingsData.setTaskBarRoundedCorners(checked)
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS
                        visible: SettingsData.taskBarFloat

                        StyledText {
                            text: "Float Amount"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarBottomMargin
                            minimum: 0
                            maximum: 50
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarBottomMargin(newValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS
                        visible: SettingsData.taskBarFloat && SettingsData.taskBarRoundedCorners

                        StyledText {
                            text: "Corner Radius"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarCornerRadius
                            minimum: 0
                            maximum: 32
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarCornerRadius(newValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Exclusive Zone"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        StyledText {
                            text: "Controls how much space the taskbar reserves on screen. Set to 0 to use taskbar height automatically."
                            font.pixelSize: Theme.fontSizeSmall - 2
                            color: Theme.surfaceVariantText
                            wrapMode: Text.WordWrap
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarExclusiveZone
                            minimum: 0
                            maximum: 200
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarExclusiveZone(newValue)
                            }
                        }
                    }
                }
            }

            StyledRect {
                width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                height: taskBarPaddingSection.implicitHeight + Theme.spacingL * 2
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g,
                               Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.2)
                border.width: 1

                Column {
                    id: taskBarPaddingSection

                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingM

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "padding"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Task Bar Padding"
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Left Padding"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarLeftPadding
                            minimum: 0
                            maximum: 100
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarLeftPadding(newValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Right Padding"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarRightPadding
                            minimum: 0
                            maximum: 100
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarRightPadding(newValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Top Padding"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarTopPadding
                            minimum: 0
                            maximum: 100
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarTopPadding(newValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Bottom Padding"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarBottomPadding
                            minimum: 0
                            maximum: 100
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarBottomPadding(newValue)
                            }
                        }
                    }
                }
            }

            StyledRect {
                width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                height: widgetManagementHeader.implicitHeight + Theme.spacingL * 2
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r,
                               Theme.surfaceVariant.g,
                               Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.2)
                border.width: 1
                visible: SettingsData.taskBarVisible
                opacity: visible ? 1 : 0

                Column {
                    id: widgetManagementHeader
                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingM

                    RowLayout {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            id: widgetIcon
                            name: "widgets"
                            size: Theme.iconSize
                            color: Theme.primary
                            Layout.alignment: Qt.AlignVCenter
                        }

                        StyledText {
                            id: widgetTitle
                            text: "Widget Management"
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Item {
                            height: 1
                            Layout.fillWidth: true
                        }

                        Row {
                            spacing: Theme.spacingS
                            Layout.alignment: Qt.AlignVCenter

                            Rectangle {
                                id: defaultsButton
                                width: Theme.scaledWidth(90)
                                height: 28
                                radius: Theme.cornerRadius
                                color: defaultsArea.containsMouse ? Theme.surfacePressed : Theme.surfaceVariant
                                border.width: 1
                                border.color: defaultsArea.containsMouse ? Theme.outline : Qt.rgba(
                                                                                Theme.outline.r,
                                                                                Theme.outline.g,
                                                                                Theme.outline.b,
                                                                                0.5)

                                Row {
                                    anchors.centerIn: parent
                                    spacing: Theme.spacingXS

                                    EHIcon {
                                        name: "restore"
                                        size: 14
                                        color: Theme.surfaceText
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    StyledText {
                                        text: "Defaults"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                MouseArea {
                                    id: defaultsArea

                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        SettingsData.setTaskBarLeftWidgets(
                                                    defaultLeftWidgets)
                                        SettingsData.setTaskBarCenterWidgets(
                                                    defaultCenterWidgets)
                                        SettingsData.setTaskBarRightWidgets(
                                                    defaultRightWidgets)
                                    }
                                }

                                Behavior on color {
                                    ColorAnimation {
                                        duration: Theme.shortDuration
                                        easing.type: Theme.standardEasing
                                    }
                                }

                                Behavior on border.color {
                                    ColorAnimation {
                                        duration: Theme.shortDuration
                                        easing.type: Theme.standardEasing
                                    }
                                }
                            }

                            Rectangle {
                                id: resetButton
                                width: Theme.scaledWidth(80)
                                height: 28
                                radius: Theme.cornerRadius
                                color: resetArea.containsMouse ? Theme.surfacePressed : Theme.surfaceVariant
                                border.width: 1
                                border.color: resetArea.containsMouse ? Theme.outline : Qt.rgba(
                                                                                Theme.outline.r,
                                                                                Theme.outline.g,
                                                                                Theme.outline.b,
                                                                                0.5)

                                Row {
                                    anchors.centerIn: parent
                                    spacing: Theme.spacingXS

                                    EHIcon {
                                        name: "refresh"
                                        size: 14
                                        color: Theme.surfaceText
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    StyledText {
                                        text: "Reset"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                MouseArea {
                                    id: resetArea

                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        SettingsData.setTaskBarLeftWidgets([])
                                        SettingsData.setTaskBarCenterWidgets([])
                                        SettingsData.setTaskBarRightWidgets([])
                                    }
                                }

                                Behavior on color {
                                    ColorAnimation {
                                        duration: Theme.shortDuration
                                        easing.type: Theme.standardEasing
                                    }
                                }

                                Behavior on border.color {
                                    ColorAnimation {
                                        duration: Theme.shortDuration
                                        easing.type: Theme.standardEasing
                                    }
                                }
                            }
                        }
                    }

                    StyledText {
                        width: parent.width
                        text: "Drag widgets to reorder within sections. Use the eye icon to hide/show widgets (maintains spacing), or X to remove them completely."
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        wrapMode: Text.WordWrap
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.mediumDuration
                        easing.type: Theme.emphasizedEasing
                    }
                }
            }

            Column {
                width: parent.width
                spacing: Theme.spacingL
                visible: SettingsData.taskBarVisible
                opacity: visible ? 1 : 0

                StyledRect {
                    width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                    height: leftSection.implicitHeight + Theme.spacingL * 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: Theme.cornerRadius
                    color: Qt.rgba(Theme.surfaceVariant.r,
                                   Theme.surfaceVariant.g,
                                   Theme.surfaceVariant.b, 0.3)
                    border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                          Theme.outline.b, 0.2)
                    border.width: 1

                    WidgetsTabSection {
                        id: leftSection
                        anchors.fill: parent
                        anchors.margins: Theme.spacingL
                        title: "Left Section"
                        titleIcon: "format_align_left"
                        sectionId: "left"
                        allWidgets: taskBarTab.baseWidgetDefinitions
                        items: taskBarTab.getItemsForSection("left")
                        onItemEnabledChanged: (sectionId, itemId, enabled) => {
                                                  taskBarTab.handleItemEnabledChanged(
                                                      sectionId,
                                                      itemId, enabled)
                                              }
                        onItemOrderChanged: newOrder => {
                                                taskBarTab.handleItemOrderChanged(
                                                    "left", newOrder)
                                            }
                        onAddWidget: sectionId => {
                                         widgetSelectionPopup.allWidgets
                                         = taskBarTab.baseWidgetDefinitions
                                         widgetSelectionPopup.targetSection = sectionId
                                         widgetSelectionPopup.safeOpen()
                                     }
                        onRemoveWidget: (sectionId, widgetIndex) => {
                                            taskBarTab.removeWidgetFromSection(
                                                sectionId, widgetIndex)
                                        }
                        onSpacerSizeChanged: (sectionId, widgetIndex, newSize) => {
                                                 taskBarTab.handleSpacerSizeChanged(
                                                     sectionId, widgetIndex, newSize)
                                             }
                        onCompactModeChanged: (widgetId, value) => {
                                                  if (widgetId === "clock") {
                                                      SettingsData.setClockCompactMode(
                                                          value)
                                                  } else if (widgetId === "music") {
                                                      SettingsData.setMediaSize(
                                                          value)
                                                  } else if (widgetId === "focusedWindow") {
                                                      SettingsData.setFocusedWindowCompactMode(
                                                          value)
                                                  } else if (widgetId === "runningApps") {
                                                      SettingsData.setRunningAppsCompactMode(
                                                          value)
                                                  }
                                              }
                        onControlCenterSettingChanged: (sectionId, widgetIndex, settingName, value) => {
                                                           handleControlCenterSettingChanged(sectionId, widgetIndex, settingName, value)
                                                       }
                        onGpuSelectionChanged: (sectionId, widgetIndex, selectedIndex) => {
                                                   taskBarTab.handleGpuSelectionChanged(
                                                       sectionId, widgetIndex,
                                                       selectedIndex)
                                               }
                    }
                }

                StyledRect {
                    width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                    height: centerSection.implicitHeight + Theme.spacingL * 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: Theme.cornerRadius
                    color: Qt.rgba(Theme.surfaceVariant.r,
                                   Theme.surfaceVariant.g,
                                   Theme.surfaceVariant.b, 0.3)
                    border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                          Theme.outline.b, 0.2)
                    border.width: 1

                    WidgetsTabSection {
                        id: centerSection
                        anchors.fill: parent
                        anchors.margins: Theme.spacingL
                        title: "Center Section"
                        titleIcon: "format_align_center"
                        sectionId: "center"
                        allWidgets: taskBarTab.baseWidgetDefinitions
                        items: taskBarTab.getItemsForSection("center")
                        onItemEnabledChanged: (sectionId, itemId, enabled) => {
                                                  taskBarTab.handleItemEnabledChanged(
                                                      sectionId,
                                                      itemId, enabled)
                                              }
                        onItemOrderChanged: newOrder => {
                                                taskBarTab.handleItemOrderChanged(
                                                    "center", newOrder)
                                            }
                        onAddWidget: sectionId => {
                                         widgetSelectionPopup.allWidgets
                                         = taskBarTab.baseWidgetDefinitions
                                         widgetSelectionPopup.targetSection = sectionId
                                         widgetSelectionPopup.safeOpen()
                                     }
                        onRemoveWidget: (sectionId, widgetIndex) => {
                                            taskBarTab.removeWidgetFromSection(
                                                sectionId, widgetIndex)
                                        }
                        onSpacerSizeChanged: (sectionId, widgetIndex, newSize) => {
                                                 taskBarTab.handleSpacerSizeChanged(
                                                     sectionId, widgetIndex, newSize)
                                             }
                        onCompactModeChanged: (widgetId, value) => {
                                                  if (widgetId === "clock") {
                                                      SettingsData.setClockCompactMode(
                                                          value)
                                                  } else if (widgetId === "music") {
                                                      SettingsData.setMediaSize(
                                                          value)
                                                  } else if (widgetId === "focusedWindow") {
                                                      SettingsData.setFocusedWindowCompactMode(
                                                          value)
                                                  } else if (widgetId === "runningApps") {
                                                      SettingsData.setRunningAppsCompactMode(
                                                          value)
                                                  }
                                              }
                        onControlCenterSettingChanged: (sectionId, widgetIndex, settingName, value) => {
                                                           handleControlCenterSettingChanged(sectionId, widgetIndex, settingName, value)
                                                       }
                        onGpuSelectionChanged: (sectionId, widgetIndex, selectedIndex) => {
                                                   taskBarTab.handleGpuSelectionChanged(
                                                       sectionId, widgetIndex,
                                                       selectedIndex)
                                               }
                    }
                }

                StyledRect {
                    width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                    height: rightSection.implicitHeight + Theme.spacingL * 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: Theme.cornerRadius
                    color: Qt.rgba(Theme.surfaceVariant.r,
                                   Theme.surfaceVariant.g,
                                   Theme.surfaceVariant.b, 0.3)
                    border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                          Theme.outline.b, 0.2)
                    border.width: 1

                    WidgetsTabSection {
                        id: rightSection
                        anchors.fill: parent
                        anchors.margins: Theme.spacingL
                        title: "Right Section"
                        titleIcon: "format_align_right"
                        sectionId: "right"
                        allWidgets: taskBarTab.baseWidgetDefinitions
                        items: taskBarTab.getItemsForSection("right")
                        onItemEnabledChanged: (sectionId, itemId, enabled) => {
                                                  taskBarTab.handleItemEnabledChanged(
                                                      sectionId,
                                                      itemId, enabled)
                                              }
                        onItemOrderChanged: newOrder => {
                                                taskBarTab.handleItemOrderChanged(
                                                    "right", newOrder)
                                            }
                        onAddWidget: sectionId => {
                                         widgetSelectionPopup.allWidgets
                                         = taskBarTab.baseWidgetDefinitions
                                         widgetSelectionPopup.targetSection = sectionId
                                         widgetSelectionPopup.safeOpen()
                                     }
                        onRemoveWidget: (sectionId, widgetIndex) => {
                                            taskBarTab.removeWidgetFromSection(
                                                sectionId, widgetIndex)
                                        }
                        onSpacerSizeChanged: (sectionId, widgetIndex, newSize) => {
                                                 taskBarTab.handleSpacerSizeChanged(
                                                     sectionId, widgetIndex, newSize)
                                             }
                        onCompactModeChanged: (widgetId, value) => {
                                                  if (widgetId === "clock") {
                                                      SettingsData.setClockCompactMode(
                                                          value)
                                                  } else if (widgetId === "music") {
                                                      SettingsData.setMediaSize(
                                                          value)
                                                  } else if (widgetId === "focusedWindow") {
                                                      SettingsData.setFocusedWindowCompactMode(
                                                          value)
                                                  } else if (widgetId === "runningApps") {
                                                      SettingsData.setRunningAppsCompactMode(
                                                          value)
                                                  }
                                              }
                        onControlCenterSettingChanged: (sectionId, widgetIndex, settingName, value) => {
                                                           handleControlCenterSettingChanged(sectionId, widgetIndex, settingName, value)
                                                       }
                        onGpuSelectionChanged: (sectionId, widgetIndex, selectedIndex) => {
                                                   taskBarTab.handleGpuSelectionChanged(
                                                       sectionId, widgetIndex,
                                                       selectedIndex)
                                               }
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.mediumDuration
                        easing.type: Theme.emphasizedEasing
                    }
                }
            }

            StyledRect {
                width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                height: transparencySection.implicitHeight + Theme.spacingL * 2
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g,
                               Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.2)
                border.width: 1
                visible: SettingsData.taskBarVisible
                opacity: visible ? 1 : 0

                Column {
                    id: transparencySection

                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingM

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "opacity"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Task Bar Opacity"
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    EHSlider {
                        width: parent.width
                        height: 32
                        value: Math.round(SettingsData.taskBarTransparency * 100)
                        minimum: 0
                        maximum: 100
                        unit: "%"
                        showValue: true
                        wheelEnabled: false
                        onSliderValueChanged: newValue => {
                                                  SettingsData.setTaskBarTransparency(
                                                      newValue / 100)
                                              }
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.mediumDuration
                        easing.type: Theme.emphasizedEasing
                    }
                }
            }

            StyledRect {
                width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                height: iconSettingsSection.implicitHeight + Theme.spacingL * 2
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g,
                               Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.2)
                border.width: 1
                visible: SettingsData.taskBarVisible
                opacity: visible ? 1 : 0

                Column {
                    id: iconSettingsSection

                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingM

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "tune"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Icon Settings"
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Height"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarHeight
                            minimum: 30
                            maximum: 120
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                                      SettingsData.setTaskBarHeight(
                                                          newValue)
                                                  }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Icon Size"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskbarIconSize
                            minimum: 20
                            maximum: 60
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                                      SettingsData.setTaskbarIconSize(
                                                          newValue)
                                                  }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Icon Spacing"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskbarIconSpacing
                            minimum: 0
                            maximum: 20
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                                      SettingsData.setTaskbarIconSpacing(
                                                          newValue)
                                                  }
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.mediumDuration
                        easing.type: Theme.emphasizedEasing
                    }
                }
            }

            StyledRect {
                width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                height: exclusiveZoneSection.implicitHeight + Theme.spacingL * 2
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g,
                               Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.2)
                border.width: 1
                visible: SettingsData.taskBarVisible
                opacity: visible ? 1 : 0

                Column {
                    id: exclusiveZoneSection

                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingM

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "vertical_align_bottom"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Task Bar Exclusive Zone"
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Exclusive Zone (0 = no exclusive zone, -1 = always exclusive)"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarExclusiveZone
                            minimum: -1
                            maximum: 200
                            unit: ""
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                                      SettingsData.setTaskBarExclusiveZone(newValue)
                                                  }
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.mediumDuration
                        easing.type: Theme.emphasizedEasing
                    }
                }
            }

            StyledRect {
                width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                height: taskBarPaddingSection.implicitHeight + Theme.spacingL * 2
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g,
                               Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.2)
                border.width: 1
                visible: SettingsData.taskBarVisible
                opacity: visible ? 1 : 0

                Column {
                    id: taskBarPaddingSection2

                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingM

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "padding"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Task Bar Padding"
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Left Padding"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarLeftPadding
                            minimum: 0
                            maximum: 100
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarLeftPadding(newValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Right Padding"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarRightPadding
                            minimum: 0
                            maximum: 100
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarRightPadding(newValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Top Padding"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarTopPadding
                            minimum: 0
                            maximum: 100
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarTopPadding(newValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Bottom Padding"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.taskBarBottomPadding
                            minimum: 0
                            maximum: 100
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            thumbOutlineColor: Theme.surfaceContainer
                            onSliderValueChanged: newValue => {
                                SettingsData.setTaskBarBottomPadding(newValue)
                            }
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.mediumDuration
                        easing.type: Theme.emphasizedEasing
                    }
                }
            }
        }
    }

    WidgetSelectionPopup {
        id: widgetSelectionPopup

        anchors.centerIn: parent
        onWidgetSelected: (widgetId, targetSection) => {
                              taskBarTab.addWidgetToSection(widgetId,
                                                           targetSection)
                          }
    }
}
