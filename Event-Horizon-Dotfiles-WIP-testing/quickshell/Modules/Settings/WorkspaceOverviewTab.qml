import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import qs.Common
import qs.Widgets
import qs.Modules.Settings
import qs.Services

Item {
    id: workspaceOverviewTab

    EHFlickable {
        anchors.fill: parent
        anchors.topMargin: Theme.spacingL
        clip: true
        contentHeight: mainColumn.height
        contentWidth: width

        Column {
            id: mainColumn
            width: parent.width
            spacing: Theme.spacingXL

            StyledRect {
                width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                height: settingsColumn.implicitHeight + Theme.spacingL * 2
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g,
                               Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.2)
                border.width: 1

                Column {
                    id: settingsColumn
                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingM

                    RowLayout {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "space_dashboard"
                            size: Theme.iconSize
                            color: Theme.primary
                            Layout.alignment: Qt.AlignVCenter
                        }

                        StyledText {
                            text: "Workspace Overview Settings"
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Bold
                            color: Theme.surfaceText
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.outline
                        opacity: 0.2
                    }

                    // Opacity Slider for main background only
                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        RowLayout {
                            width: parent.width
                            StyledText {
                                text: "Background Opacity"
                                font.pixelSize: Theme.fontSizeMedium
                                color: Theme.surfaceText
                            }
                            Item { Layout.fillWidth: true }
                            StyledText {
                                text: Math.round(SettingsData.workspaceOverviewOpacity * 100) + "%"
                                font.pixelSize: Theme.fontSizeMedium
                                color: Theme.primary
                            }
                        }

                        Slider {
                            id: opacitySlider
                            width: parent.width
                            from: 0.1
                            to: 1.0
                            value: SettingsData.workspaceOverviewOpacity
                            stepSize: 0.05
                            onMoved: {
                                SettingsData.setWorkspaceOverviewOpacity(value)
                            }
                        }
                    }
                }
            }
        }
    }
}
