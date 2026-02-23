import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Common
import qs.Widgets

Item {
    id: miniPanelTab

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
                            text: "Mini Panel Settings"
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

                    EHToggle {
                        width: parent.width
                        text: "Show Mini Panel"
                        description: "Display a compact panel at the top of the screen"
                        checked: SettingsData.showMiniPanel
                        onToggled: checked => {
                                       SettingsData.showMiniPanel = checked
                                       SettingsData.saveSettings()
                                   }
                    }

                    EHToggle {
                        width: parent.width
                        text: "Autohide"
                        description: "Automatically hide the panel when not in use"
                        checked: SettingsData.miniPanelAutohide
                        enabled: SettingsData.showMiniPanel
                        onToggled: checked => {
                                       SettingsData.miniPanelAutohide = checked
                                       SettingsData.saveSettings()
                                   }
                    }
                }
            }
        }
    }
}