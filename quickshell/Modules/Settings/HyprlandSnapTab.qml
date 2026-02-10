import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: hyprlandSnapTab

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
                height: snapContentColumn.implicitHeight + Theme.spacingL * 2 + 4
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                border.width: 1
                visible: typeof CompositorService !== "undefined" && CompositorService.isHyprland

                Column {
                    id: snapContentColumn
                    width: parent.width - Theme.spacingM * 2
                    x: Theme.spacingM
                    y: Theme.spacingM
                    spacing: Theme.spacingM

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "grid_view"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Snap"
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
                                text: "Enable Snapping"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }

                            StyledText {
                                text: "Enable snapping behavior for floating windows."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }

                        EHToggle {
                            checked: SettingsData.hyprlandSnapEnabled
                            onToggled: checked => {
                                SettingsData.setHyprlandSnapEnabled(checked)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Window Gap"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        StyledText {
                            text: "Gap used when snapping to screen edges."
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.hyprlandSnapWindowGap
                            minimum: 0
                            maximum: 200
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            onSliderDragFinished: finalValue => {
                                SettingsData.setHyprlandSnapWindowGap(finalValue)
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Monitor Gap"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        StyledText {
                            text: "Minimum gap between windows and monitor edges."
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.hyprlandSnapMonitorGap
                            minimum: 0
                            maximum: 200
                            unit: "px"
                            showValue: true
                            wheelEnabled: false
                            onSliderDragFinished: finalValue => {
                                SettingsData.setHyprlandSnapMonitorGap(finalValue)
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
                                text: "Border Overlap"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }

                            StyledText {
                                text: "When enabled, only one border's gap is kept between windows."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }

                        EHToggle {
                            checked: SettingsData.hyprlandSnapBorderOverlap
                            onToggled: checked => {
                                SettingsData.setHyprlandSnapBorderOverlap(checked)
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
                                text: "Respect Gaps"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }

                            StyledText {
                                text: "Respect `general:gaps_in` when snapping."
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }
                        }

                        EHToggle {
                            checked: SettingsData.hyprlandSnapRespectGaps
                            onToggled: checked => {
                                SettingsData.setHyprlandSnapRespectGaps(checked)
                            }
                        }
                    }
                }
            }
        }
    }
}
