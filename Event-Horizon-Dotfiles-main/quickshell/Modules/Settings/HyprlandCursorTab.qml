import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: hyprlandCursorTab

    property var parentModal: null

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
                height: cursorContentColumn.implicitHeight + Theme.spacingL * 2 + 4
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                border.width: 1
                visible: typeof CompositorService !== 'undefined' && CompositorService.isHyprland

                Column {
                    id: cursorContentColumn
                    width: parent.width - Theme.spacingM * 2
                    x: Theme.spacingM
                    y: Theme.spacingM
                    spacing: Theme.spacingM

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "mouse"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Cursor"
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingM

                        Row {
                            width: parent.width
                            spacing: Theme.spacingM

                            EHIcon {
                                name: "memory"
                                size: Theme.iconSize
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: "Hardware & Performance"
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
                                text: "No Hardware Cursors"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            StyledText {
                                text: "Disable hardware cursors. Use 0=auto, 1=off, 2=on."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            EHDropdown {
                                width: parent.width
                                text: ""
                                currentValue: String(SettingsData.hyprlandCursorNoHardwareCursors)
                                options: ["0", "1", "2"]
                                onValueChanged: value => {
                                    SettingsData.setHyprlandCursorNoHardwareCursors(parseInt(value, 10))
                                }
                            }

                            StyledText {
                                text: "Use CPU Buffer"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            StyledText {
                                text: "Force CPU-backed cursor buffers (useful on some GPUs)."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            EHDropdown {
                                width: parent.width
                                text: ""
                                currentValue: String(SettingsData.hyprlandCursorUseCpuBuffer)
                                options: ["0", "1", "2"]
                                onValueChanged: value => {
                                    SettingsData.setHyprlandCursorUseCpuBuffer(parseInt(value, 10))
                                }
                            }

                            StyledText {
                                text: "No Break FS VRR"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            StyledText {
                                text: "Avoid VRR framerate spikes on cursor movement (0 off, 1 on, 2 auto)."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            EHDropdown {
                                width: parent.width
                                text: ""
                                currentValue: String(SettingsData.hyprlandCursorNoBreakFsVrr)
                                options: ["0", "1", "2"]
                                onValueChanged: value => {
                                    SettingsData.setHyprlandCursorNoBreakFsVrr(parseInt(value, 10))
                                }
                            }

                            StyledText {
                                text: "Min Refresh Rate"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            StyledText {
                                text: "Minimum refresh rate when no_break_fs_vrr is active."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandCursorMinRefreshRate
                                minimum: 1
                                maximum: 240
                                unit: "Hz"
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandCursorMinRefreshRate(finalValue)
                                }
                            }

                            StyledText {
                                text: "Hotspot Padding"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            StyledText {
                                text: "Padding between screen edges and the cursor hotspot."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandCursorHotspotPadding
                                minimum: 0
                                maximum: 20
                                unit: "px"
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandCursorHotspotPadding(finalValue)
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
                                        text: "Enable Hyprcursor"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Use Hyprland's cursor engine when available."
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandCursorEnableHyprcursor
                                    onToggled: checked => {
                                        SettingsData.setHyprlandCursorEnableHyprcursor(checked)
                                    }
                                }
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingM

                        Row {
                            width: parent.width
                            spacing: Theme.spacingM

                            EHIcon {
                                name: "open_with"
                                size: Theme.iconSize
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: "Warping"
                                font.pixelSize: Theme.fontSizeLarge
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: Theme.spacingS

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "No Warps"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Prevent cursor warping during focus/keybind changes."
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandCursorNoWarps
                                    onToggled: checked => {
                                        SettingsData.setHyprlandCursorNoWarps(checked)
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
                                        text: "Persistent Warps"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Return cursor to its last position inside the window when refocused."
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandCursorPersistentWarps
                                    onToggled: checked => {
                                        SettingsData.setHyprlandCursorPersistentWarps(checked)
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
                                        text: "Warp Back After Non-Mouse Input"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Return cursor to prior position after keyboard/other input."
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandCursorWarpBackAfterNonMouseInput
                                    onToggled: checked => {
                                        SettingsData.setHyprlandCursorWarpBackAfterNonMouseInput(checked)
                                    }
                                }
                            }

                            StyledText {
                                text: "Warp on Workspace"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            StyledText {
                                text: "Warp cursor when changing workspaces (0 off, 1 on, 2 force)."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            EHDropdown {
                                width: parent.width
                                text: ""
                                currentValue: String(SettingsData.hyprlandCursorWarpOnChangeWorkspace)
                                options: ["0", "1", "2"]
                                onValueChanged: value => {
                                    SettingsData.setHyprlandCursorWarpOnChangeWorkspace(parseInt(value, 10))
                                }
                            }

                            StyledText {
                                text: "Warp on Special"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            StyledText {
                                text: "Warp cursor when toggling special workspace (0 off, 1 on, 2 force)."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            EHDropdown {
                                width: parent.width
                                text: ""
                                currentValue: String(SettingsData.hyprlandCursorWarpOnToggleSpecial)
                                options: ["0", "1", "2"]
                                onValueChanged: value => {
                                    SettingsData.setHyprlandCursorWarpOnToggleSpecial(parseInt(value, 10))
                                }
                            }

                            StyledText {
                                text: "Default Monitor"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            StyledText {
                                text: "Monitor name to place cursor on startup. Leave empty for default."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            EHTextField {
                                width: parent.width
                                height: 32
                                text: SettingsData.hyprlandCursorDefaultMonitor
                                placeholderText: "leave empty to auto"
                                onEditingFinished: {
                                    SettingsData.setHyprlandCursorDefaultMonitor(text)
                                }
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingM

                        Row {
                            width: parent.width
                            spacing: Theme.spacingM

                            EHIcon {
                                name: "visibility"
                                size: Theme.iconSize
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: "Visibility"
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
                                text: "Inactive Timeout"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            StyledText {
                                text: "Seconds of cursor inactivity before hiding. 0 disables hiding."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: Math.round(SettingsData.hyprlandCursorInactiveTimeout)
                                minimum: 0
                                maximum: 60
                                unit: "s"
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandCursorInactiveTimeout(finalValue)
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
                                        text: "Hide on Key Press"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Hide cursor until mouse moves after any key press."
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandCursorHideOnKeyPress
                                    onToggled: checked => {
                                        SettingsData.setHyprlandCursorHideOnKeyPress(checked)
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
                                        text: "Hide on Touch"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Hide cursor when touch input is used last."
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandCursorHideOnTouch
                                    onToggled: checked => {
                                        SettingsData.setHyprlandCursorHideOnTouch(checked)
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
                                        text: "Hide on Tablet"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Hide cursor when tablet input is used last."
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandCursorHideOnTablet
                                    onToggled: checked => {
                                        SettingsData.setHyprlandCursorHideOnTablet(checked)
                                    }
                                }
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingM

                        Row {
                            width: parent.width
                            spacing: Theme.spacingM

                            EHIcon {
                                name: "zoom_in"
                                size: Theme.iconSize
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: "Zoom"
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
                                text: "Zoom Factor"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            StyledText {
                                text: "Magnification amount around the cursor."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: Math.round(SettingsData.hyprlandCursorZoomFactor * 100)
                                minimum: 100
                                maximum: 400
                                unit: "%"
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandCursorZoomFactor(finalValue / 100)
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
                                        text: "Zoom Rigid"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Keep cursor centered when zoomed."
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandCursorZoomRigid
                                    onToggled: checked => {
                                        SettingsData.setHyprlandCursorZoomRigid(checked)
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
                                        text: "Zoom Detached Camera"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Move camera only when cursor reaches screen edge."
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandCursorZoomDetachedCamera
                                    onToggled: checked => {
                                        SettingsData.setHyprlandCursorZoomDetachedCamera(checked)
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
                                        text: "Zoom Disable AA"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Disable antialiasing while zoomed for a pixelated look."
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandCursorZoomDisableAa
                                    onToggled: checked => {
                                        SettingsData.setHyprlandCursorZoomDisableAa(checked)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
