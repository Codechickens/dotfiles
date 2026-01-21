import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: hyprlandGeneralTab

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
                height: generalContentColumn.implicitHeight + Theme.spacingL * 2 + 4
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                border.width: 1
                visible: typeof CompositorService !== "undefined" && CompositorService.isHyprland

                Column {
                    id: generalContentColumn
                    width: parent.width - Theme.spacingM * 2
                    x: Theme.spacingM
                    y: Theme.spacingM
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
                            text: "General"
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
                            text: "Inner Gaps"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        StyledText {
                            text: "Gap between windows."
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.hyprlandGeneralGapsIn
                            minimum: 0
                            maximum: 50
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            onSliderDragFinished: finalValue => {
                                SettingsData.setHyprlandGeneralGapsIn(finalValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Outer Gaps"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        StyledText {
                            text: "Gap between windows and monitor edges."
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.hyprlandGeneralGapsOut
                            minimum: 0
                            maximum: 100
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            onSliderDragFinished: finalValue => {
                                SettingsData.setHyprlandGeneralGapsOut(finalValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Workspace Gaps"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        StyledText {
                            text: "Gap between workspaces."
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.hyprlandGeneralGapsWorkspaces
                            minimum: 0
                            maximum: 100
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            onSliderDragFinished: finalValue => {
                                SettingsData.setHyprlandGeneralGapsWorkspaces(finalValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Border Size"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        StyledText {
                            text: "Window border thickness."
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.hyprlandGeneralBorderSize
                            minimum: 0
                            maximum: 20
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            onSliderDragFinished: finalValue => {
                                SettingsData.setHyprlandGeneralBorderSize(finalValue)
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
                                text: "Resize on Border"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }

                            StyledText {
                                text: "Allow resizing by dragging borders and gaps."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }

                        EHToggle {
                            checked: SettingsData.hyprlandGeneralResizeOnBorder
                            onToggled: checked => {
                                SettingsData.setHyprlandGeneralResizeOnBorder(checked)
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
                                text: "No Focus Fallback"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }

                            StyledText {
                                text: "Do not focus another window if none is found."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }

                        EHToggle {
                            checked: SettingsData.hyprlandGeneralNoFocusFallback
                            onToggled: checked => {
                                SettingsData.setHyprlandGeneralNoFocusFallback(checked)
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
                                text: "Allow Tearing"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }

                            StyledText {
                                text: "Allow the immediate window rule to tear."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }

                        EHToggle {
                            checked: SettingsData.hyprlandGeneralAllowTearing
                            onToggled: checked => {
                                SettingsData.setHyprlandGeneralAllowTearing(checked)
                            }
                        }
                    }
                }
            }
        }
    }
}
