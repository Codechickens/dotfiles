import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: hyprlandGroupbarTab

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
                height: groupbarContentColumn.implicitHeight + Theme.spacingL * 2 + 4
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                border.width: 1
                visible: typeof CompositorService !== "undefined" && CompositorService.isHyprland

                Column {
                    id: groupbarContentColumn
                    width: parent.width - Theme.spacingM * 2
                    x: Theme.spacingM
                    y: Theme.spacingM
                    spacing: Theme.spacingM

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "view_carousel"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Groupbar"
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
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
                                text: "Enabled"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }

                            StyledText {
                                text: "Toggle groupbar rendering."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }

                        EHToggle {
                            checked: SettingsData.hyprlandGroupbarEnabled
                            onToggled: checked => {
                                SettingsData.setHyprlandGroupbarEnabled(checked)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Active Color"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHTextField {
                            width: parent.width
                            height: 32
                            text: SettingsData.hyprlandGroupbarColActive
                            placeholderText: "rgba(...) gradient"
                            onEditingFinished: {
                                SettingsData.setHyprlandGroupbarColActive(text)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Inactive Color"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHTextField {
                            width: parent.width
                            height: 32
                            text: SettingsData.hyprlandGroupbarColInactive
                            placeholderText: "rgba(...)"
                            onEditingFinished: {
                                SettingsData.setHyprlandGroupbarColInactive(text)
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
                                text: "Height"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandGroupbarHeight
                                minimum: 10
                                maximum: 100
                                unit: "px"
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandGroupbarHeight(finalValue)
                                }
                            }
                        }

                        Column {
                            width: parent.width / 2 - Theme.spacingM / 2
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Priority"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandGroupbarPriority
                                minimum: 0
                                maximum: 10
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandGroupbarPriority(finalValue)
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
                                text: "Render Titles"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }
                        }

                        EHToggle {
                            checked: SettingsData.hyprlandGroupbarRenderTitles
                            onToggled: checked => {
                                SettingsData.setHyprlandGroupbarRenderTitles(checked)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Font Family"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHTextField {
                            width: parent.width
                            height: 32
                            text: SettingsData.hyprlandGroupbarFontFamily
                            placeholderText: "Inter Variable, Inter, Roboto, ..."
                            onEditingFinished: {
                                SettingsData.setHyprlandGroupbarFontFamily(text)
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
                                text: "Font Size"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandGroupbarFontSize
                                minimum: 6
                                maximum: 36
                                unit: "px"
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandGroupbarFontSize(finalValue)
                                }
                            }
                        }

                        Column {
                            width: parent.width / 2 - Theme.spacingM / 2
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Rounding"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandGroupbarRounding
                                minimum: 0
                                maximum: 30
                                unit: "px"
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandGroupbarRounding(finalValue)
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
                                text: "Gradients"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }
                        }

                        EHToggle {
                            checked: SettingsData.hyprlandGroupbarGradients
                            onToggled: checked => {
                                SettingsData.setHyprlandGroupbarGradients(checked)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Text Color"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        EHTextField {
                            width: parent.width
                            height: 32
                            text: SettingsData.hyprlandGroupbarTextColor
                            placeholderText: "rgba(...)"
                            onEditingFinished: {
                                SettingsData.setHyprlandGroupbarTextColor(text)
                            }
                        }
                    }
                }
            }
        }
    }
}
