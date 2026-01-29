import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root

    property real widgetHeight: 40
    property bool isBarVertical: false

    width: privacyRow.implicitWidth + 16 * (widgetHeight / 40)
    height: widgetHeight

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, SettingsData.dockWidgetAreaOpacity)
        radius: Theme.cornerRadius * (widgetHeight / 40)
        border.width: 0
        border.color: "transparent"

        Row {
            id: privacyRow
            anchors.centerIn: parent
            spacing: 6 * (widgetHeight / 40)

            EHIcon {
                name: "privacy_tip"
                size: 16 * (widgetHeight / 40)
                color: Theme.primary
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: "Privacy"
                font.pixelSize: 12 * (widgetHeight / 40)
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}







