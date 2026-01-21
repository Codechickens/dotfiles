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

    width: notepadRow.implicitWidth + 16 * (widgetHeight / 40)
    height: widgetHeight

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, 0.3)
        radius: Theme.cornerRadius * (widgetHeight / 40)
        border.width: 1
        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)

        Row {
            id: notepadRow
            anchors.centerIn: parent
            spacing: 6 * (widgetHeight / 40)

            EHIcon {
                name: "assignment"
                size: 16 * (widgetHeight / 40)
                color: Theme.primary
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: "Notepad"
                font.pixelSize: 12 * (widgetHeight / 40)
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}







