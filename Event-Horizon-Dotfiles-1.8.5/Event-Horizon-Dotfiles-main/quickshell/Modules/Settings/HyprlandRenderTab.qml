import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: hyprlandRenderTab

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
                height: renderContentColumn.implicitHeight + Theme.spacingL * 2 + 4
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                border.width: 1
                visible: typeof CompositorService !== 'undefined' && CompositorService.isHyprland

                Column {
                    id: renderContentColumn
                    width: parent.width - Theme.spacingM * 2
                    x: Theme.spacingM
                    y: Theme.spacingM
                    spacing: Theme.spacingM

                    Column {
                        width: parent.width
                        spacing: Theme.spacingM

                        Row {
                            width: parent.width
                            spacing: Theme.spacingM

                            EHIcon {
                                name: "settings"
                                size: Theme.iconSize
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: "Render Settings"
                                font.pixelSize: Theme.fontSizeLarge
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: Theme.spacingS

                            // Render Scheduling
                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "New Render Scheduling"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Use improved render scheduling algorithm"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandRenderNewScheduling
                                    onToggled: checked => {
                                        SettingsData.setHyprlandRenderNewScheduling(checked)
                                    }
                                }
                            }

                            // Color Management Enabled
                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "Color Management"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Enable color management features"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandRenderCmEnabled
                                    onToggled: checked => {
                                        SettingsData.setHyprlandRenderCmEnabled(checked)
                                    }
                                }
                            }

                            // Auto HDR
                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM
                                visible: SettingsData.hyprlandRenderCmEnabled

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "Auto HDR"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Automatically enable HDR when available"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandRenderCmAutoHdr
                                    onToggled: checked => {
                                        SettingsData.setHyprlandRenderCmAutoHdr(checked)
                                    }
                                }
                            }

                            // Send Content Type
                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM
                                visible: SettingsData.hyprlandRenderCmEnabled

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "Send Content Type"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Send content type information to display"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandRenderSendContentType
                                    onToggled: checked => {
                                        SettingsData.setHyprlandRenderSendContentType(checked)
                                    }
                                }
                            }

                            // CM FS Passthrough
                            Column {
                                width: parent.width
                                spacing: Theme.spacingXS
                                visible: SettingsData.hyprlandRenderCmEnabled

                                StyledText {
                                    text: "FS Passthrough: " + SettingsData.hyprlandRenderCmFsPassthrough
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceText
                                    font.weight: Font.Medium
                                }

                                StyledText {
                                    text: "Fullscreen color management passthrough mode"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceVariantText
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                }

                                EHSlider {
                                    width: parent.width
                                    height: 24
                                    value: SettingsData.hyprlandRenderCmFsPassthrough
                                    minimum: 0
                                    maximum: 1
                                    unit: ""
                                    showValue: true
                                    wheelEnabled: false
                                    onSliderDragFinished: finalValue => {
                                        SettingsData.setHyprlandRenderCmFsPassthrough(finalValue)
                                    }
                                }
                            }

                            // Direct Scanout
                            Column {
                                width: parent.width
                                spacing: Theme.spacingXS

                                StyledText {
                                    text: "Direct Scanout: " + SettingsData.hyprlandRenderDirectScanout
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceText
                                    font.weight: Font.Medium
                                }

                                StyledText {
                                    text: "Control direct scanout behavior (0=disabled, 1=enabled, 2=auto)"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceVariantText
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                }

                                EHSlider {
                                    width: parent.width
                                    height: 24
                                    value: SettingsData.hyprlandRenderDirectScanout
                                    minimum: 0
                                    maximum: 2
                                    unit: ""
                                    showValue: true
                                    wheelEnabled: false
                                    onSliderDragFinished: finalValue => {
                                        SettingsData.setHyprlandRenderDirectScanout(finalValue)
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
                                        text: "Expand Undersized Textures"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Expand textures smaller than the output size."
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandRenderExpandUndersizedTextures
                                    onToggled: checked => {
                                        SettingsData.setHyprlandRenderExpandUndersizedTextures(checked)
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
