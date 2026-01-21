import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import qs.Common
import qs.Widgets

Row {
    id: root

    property var availableWidgets: []

    signal addWidget(string widgetId)
    signal resetToDefault()
    signal clearAll()

    height: 48
    spacing: Theme.spacingS

    onAddWidget: addWidgetPopup.close()

    Popup {
        id: addWidgetPopup
        anchors.centerIn: parent
        width: 600
        height: 500
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: {
                const transparency = SettingsData.controlCenterTransparency || 0.90
                const surface = Theme.surfaceContainer || Qt.rgba(0.1, 0.1, 0.1, 1)
                return Qt.rgba(surface.r, surface.g, surface.b, transparency)
            }
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.15)
            border.width: 1
            radius: Theme.cornerRadius

        }

        contentItem: Item {
            anchors.fill: parent
            anchors.margins: Theme.spacingXL

            Row {
                id: headerRow
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: Theme.spacingM
                height: 40

                EHIcon {
                    name: "add_circle"
                    size: 24
                    color: Theme.primary
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    text: "Add Widget"
                    font.pixelSize: Theme.fontSizeLarge
                    font.weight: Font.Medium
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            EHListView {
                anchors.top: headerRow.bottom
                anchors.topMargin: Theme.spacingL
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                spacing: Theme.spacingM
                model: root.availableWidgets

                delegate: Rectangle {
                    width: 600 - Theme.spacingXL * 2
                    height: 64
                    radius: Theme.cornerRadius
                    color: {
                        if (widgetMouseArea.containsMouse) {
                            return Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15)
                        } else {
                            const alpha = Theme.getContentBackgroundAlpha() * 0.3
                            return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, alpha)
                        }
                    }
                    border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.15)
                    border.width: 1

                    Row {
                        anchors.fill: parent
                        anchors.margins: Theme.spacingL
                        spacing: Theme.spacingM

                        EHIcon {
                            name: modelData.icon
                            size: 24
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: modelData.text
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                            width: 600 - Theme.spacingXL * 2 - Theme.iconSize - Theme.spacingL * 2 - Theme.spacingM * 2 - Theme.iconSize
                            elide: Text.ElideRight
                        }

                        EHIcon {
                            name: "add"
                            size: 22
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: widgetMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.addWidget(modelData.id)
                        }
                    }
                }
            }
        }
    }

    // Compact dock-style buttons (reverted to original size)
    Row {
        width: parent.width
        spacing: Theme.spacingS

        Rectangle {
            width: (parent.width - Theme.spacingS * 2) / 3
            height: 48
            radius: Theme.cornerRadius
            color: addArea.containsMouse ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.2) : Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12)
            border.color: Theme.primary
            border.width: 1

            Row {
                anchors.centerIn: parent
                spacing: 8

                EHIcon {
                    name: "add"
                    size: 16
                    color: Theme.primary
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    text: "Add"
                    font.pixelSize: 13
                    color: Theme.primary
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: addArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: addWidgetPopup.open()
            }
        }

        Rectangle {
            width: (parent.width - Theme.spacingS * 2) / 3
            height: 48
            radius: Theme.cornerRadius
            color: defaultsArea.containsMouse ? Qt.rgba(Theme.warning.r, Theme.warning.g, Theme.warning.b, 0.2) : Qt.rgba(Theme.warning.r, Theme.warning.g, Theme.warning.b, 0.12)
            border.color: Theme.warning
            border.width: 1

            Row {
                anchors.centerIn: parent
                spacing: 6

                EHIcon {
                    name: "settings_backup_restore"
                    size: 14
                    color: Theme.warning
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    text: "Defaults"
                    font.pixelSize: 13
                    color: Theme.warning
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: defaultsArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.resetToDefault()
            }
        }

        Rectangle {
            width: (parent.width - Theme.spacingS * 2) / 3
            height: 48
            radius: Theme.cornerRadius
            color: resetArea.containsMouse ? Qt.rgba(Theme.error.r, Theme.error.g, Theme.error.b, 0.2) : Qt.rgba(Theme.error.r, Theme.error.g, Theme.error.b, 0.12)
            border.color: Theme.error
            border.width: 1

            Row {
                anchors.centerIn: parent
                spacing: 6

                EHIcon {
                    name: "clear_all"
                    size: 14
                    color: Theme.error
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    text: "Reset"
                    font.pixelSize: 13
                    color: Theme.error
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: resetArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.clearAll()
            }
        }
    }
}
