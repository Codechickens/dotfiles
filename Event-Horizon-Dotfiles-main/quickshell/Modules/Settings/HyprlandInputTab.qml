import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: hyprlandInputTab

    property var parentModal: null
    property var inputDevices: []
    property string selectedInputDevice: ""
    property bool inputDevicesLoading: false

    function refreshInputDevices() {
        if (!CompositorService || !CompositorService.isHyprland) {
            return
        }
        inputDevicesLoading = true
        hyprlandDevicesProcess.running = true
    }

    function rotationLabel(value) {
        var val = parseInt(value, 10)
        if (val === 90) return "90°"
        if (val === 180) return "180°"
        if (val === 270) return "270°"
        return "0°"
    }

    Process {
        id: hyprlandDevicesProcess
        running: false
        command: ["hyprctl", "-j", "devices"]
        stdout: StdioCollector {
            onStreamFinished: {
                inputDevicesLoading = false
                try {
                    const data = JSON.parse(text)
                    const deviceList = []

                    function addDevices(devices, typeLabel) {
                        if (!devices || !Array.isArray(devices)) {
                            return
                        }
                        devices.forEach(dev => {
                            if (dev && dev.name) {
                                deviceList.push({ "name": dev.name, "type": typeLabel })
                            }
                        })
                    }

                    addDevices(data.touch, "Touch")
                    addDevices(data.tablets, "Tablet")
                    addDevices(data.tabletPads, "Tablet Pad")
                    addDevices(data.tabletTools, "Tablet Tool")
                    addDevices(data.mice, "Mouse")

                    inputDevices = deviceList
                    if (inputDevices.length > 0) {
                        var exists = inputDevices.some(dev => dev.name === selectedInputDevice)
                        if (!exists) {
                            selectedInputDevice = inputDevices[0].name
                        }
                    } else {
                        selectedInputDevice = ""
                    }
                } catch (e) {
                    inputDevices = []
                    selectedInputDevice = ""
                }
            }
        }
    }

    Component.onCompleted: {
        refreshInputDevices()
    }

    EHFlickable {
        anchors.fill: parent
        clip: true
        contentHeight: Math.max(height, mainColumn.childrenRect.height + Theme.spacingM)
        contentWidth: width

        Column {
            id: mainColumn
            width: parent.width
            spacing: Theme.spacingM

            StyledRect {
                width: parent.width
                height: inputContentColumn.implicitHeight + Theme.spacingL * 2 + 4
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                border.width: 1
                visible: typeof CompositorService !== 'undefined' && CompositorService.isHyprland

                Column {
                    id: inputContentColumn
                    width: parent.width - Theme.spacingM * 2
                    x: Theme.spacingM
                    y: Theme.spacingM
                    spacing: Theme.spacingM

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "keyboard"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Input"
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
                            text: "Keyboard Layout"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHTextField {
                            width: parent.width
                            height: 32
                            text: SettingsData.hyprlandInputKbLayout
                            placeholderText: "e.g. us,ru"
                            onEditingFinished: {
                                SettingsData.setHyprlandInputKbLayout(text)
                            }
                        }
                    }

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        Column {
                            width: parent.width / 2 - Theme.spacingM / 2
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Keyboard Variant"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHTextField {
                                width: parent.width
                                height: 32
                                text: SettingsData.hyprlandInputKbVariant
                                placeholderText: "e.g. ,phonetic"
                                onEditingFinished: {
                                    SettingsData.setHyprlandInputKbVariant(text)
                                }
                            }
                        }

                        Column {
                            width: parent.width / 2 - Theme.spacingM / 2
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Keyboard Model"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHTextField {
                                width: parent.width
                                height: 32
                                text: SettingsData.hyprlandInputKbModel
                                placeholderText: "e.g. pc105"
                                onEditingFinished: {
                                    SettingsData.setHyprlandInputKbModel(text)
                                }
                            }
                        }
                    }

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        Column {
                            width: parent.width / 2 - Theme.spacingM / 2
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Keyboard Options"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHTextField {
                                width: parent.width
                                height: 32
                                text: SettingsData.hyprlandInputKbOptions
                                placeholderText: "e.g. grp:alt_shift_toggle"
                                onEditingFinished: {
                                    SettingsData.setHyprlandInputKbOptions(text)
                                }
                            }
                        }

                        Column {
                            width: parent.width / 2 - Theme.spacingM / 2
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Keyboard Rules"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHTextField {
                                width: parent.width
                                height: 32
                                text: SettingsData.hyprlandInputKbRules
                                placeholderText: "leave blank for default"
                                onEditingFinished: {
                                    SettingsData.setHyprlandInputKbRules(text)
                                }
                            }
                        }
                    }

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        Column {
                            width: parent.width / 2 - Theme.spacingM / 2
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Repeat Rate"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandInputRepeatRate
                                minimum: 1
                                maximum: 60
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandInputRepeatRate(finalValue)
                                }
                            }
                        }

                        Column {
                            width: parent.width / 2 - Theme.spacingM / 2
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Repeat Delay (ms)"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandInputRepeatDelay
                                minimum: 100
                                maximum: 1000
                                unit: "ms"
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandInputRepeatDelay(finalValue)
                                }
                            }
                        }
                    }

                    RowLayout {
                        width: parent.width
                        spacing: Theme.spacingM

                        Column {
                            spacing: Theme.spacingXS
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter

                            StyledText {
                                text: "Numlock by Default"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }
                        }

                        EHToggle {
                            checked: SettingsData.hyprlandInputNumlockByDefault
                            onToggled: checked => {
                                SettingsData.setHyprlandInputNumlockByDefault(checked)
                            }
                        }
                    }

                    RowLayout {
                        width: parent.width
                        spacing: Theme.spacingM

                        Column {
                            spacing: Theme.spacingXS
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter

                            StyledText {
                                text: "Left Handed"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }
                        }

                        EHToggle {
                            checked: SettingsData.hyprlandInputLeftHanded
                            onToggled: checked => {
                                SettingsData.setHyprlandInputLeftHanded(checked)
                            }
                        }
                    }

                    RowLayout {
                        width: parent.width
                        spacing: Theme.spacingM

                        Column {
                            spacing: Theme.spacingXS
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter

                            StyledText {
                                text: "Natural Scroll"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }
                        }

                        EHToggle {
                            checked: SettingsData.hyprlandInputNaturalScroll
                            onToggled: checked => {
                                SettingsData.setHyprlandInputNaturalScroll(checked)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Follow Mouse"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.hyprlandInputFollowMouse
                            minimum: 0
                            maximum: 2
                            unit: ""
                            showValue: true
                            wheelEnabled: false
                            onSliderDragFinished: finalValue => {
                                SettingsData.setHyprlandInputFollowMouse(finalValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Follow Mouse Threshold"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.hyprlandInputFollowMouseThreshold
                            minimum: 0
                            maximum: 200
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            onSliderDragFinished: finalValue => {
                                SettingsData.setHyprlandInputFollowMouseThreshold(finalValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Sensitivity"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: Math.round(SettingsData.hyprlandInputSensitivity * 100)
                            minimum: -100
                            maximum: 100
                            unit: "%"
                            showValue: true
                            wheelEnabled: false
                            onSliderDragFinished: finalValue => {
                                SettingsData.setHyprlandInputSensitivity(finalValue / 100)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Accel Profile"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHDropdown {
                            width: parent.width
                            text: ""
                            currentValue: SettingsData.hyprlandInputAccelProfile
                            options: ["adaptive", "flat"]
                            onValueChanged: value => {
                                SettingsData.setHyprlandInputAccelProfile(value)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingM

                        RowLayout {
                            width: parent.width
                            spacing: Theme.spacingM

                            Column {
                                spacing: Theme.spacingXS
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter

                                StyledText {
                                    text: "Per-Device Rotation"
                                    font.pixelSize: Theme.fontSizeSmall
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                }

                                StyledText {
                                    text: "Rotate touch/tablet devices individually (Hyprland 0.52+)."
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceVariantText
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                }
                            }

                            StyledRect {
                                height: 32
                                width: refreshDevicesText.implicitWidth + Theme.spacingL * 2
                                radius: Theme.cornerRadius
                                color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1)
                                border.color: Theme.primary
                                border.width: 1
                                Layout.alignment: Qt.AlignVCenter

                                StyledText {
                                    id: refreshDevicesText
                                    anchors.centerIn: parent
                                    text: inputDevicesLoading ? "Refreshing..." : "Refresh"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.primary
                                }

                                StateLayer {
                                    stateColor: Theme.primary
                                    cornerRadius: parent.radius
                                    onClicked: {
                                        refreshInputDevices()
                                    }
                                }
                            }
                        }

                        StyledText {
                            text: inputDevicesLoading ? "Loading devices..." : (inputDevices.length === 0 ? "No input devices found." : "")
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            visible: inputDevicesLoading || inputDevices.length === 0
                            width: parent.width
                            wrapMode: Text.WordWrap
                        }

                        Column {
                            width: parent.width
                            spacing: Theme.spacingS
                            visible: inputDevices.length > 0

                            StyledText {
                                text: "Input Device"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHDropdown {
                                width: parent.width
                                text: ""
                                options: inputDevices.map(dev => dev.name)
                                currentValue: selectedInputDevice
                                onValueChanged: value => {
                                    selectedInputDevice = value
                                }
                            }

                            StyledText {
                                text: {
                                    var match = inputDevices.find(dev => dev.name === selectedInputDevice)
                                    return match ? "Type: " + match.type : ""
                                }
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                visible: selectedInputDevice !== ""
                                width: parent.width
                                wrapMode: Text.WordWrap
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: Theme.spacingS
                            visible: selectedInputDevice !== ""

                            StyledText {
                                text: "Rotation"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHDropdown {
                                width: parent.width
                                text: ""
                                options: ["0°", "90°", "180°", "270°"]
                                currentValue: rotationLabel(SettingsData.getHyprlandInputDeviceRotation(selectedInputDevice))
                                onValueChanged: value => {
                                    if (!selectedInputDevice) {
                                        return
                                    }
                                    var rotation = parseInt(value, 10)
                                    SettingsData.setHyprlandInputDeviceRotation(selectedInputDevice, rotation)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
