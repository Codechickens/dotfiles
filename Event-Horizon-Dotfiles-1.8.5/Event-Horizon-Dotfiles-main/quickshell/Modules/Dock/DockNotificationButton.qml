import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root

    // Unified scaling properties from DockWidgets
    property real widgetHeight: 40
    property real scaleFactor: 1.0
    property real iconSize: 20
    property real fontSize: 13
    property real iconSpacing: 6
    property real padding: 8
    
    property bool isBarVertical: false

    width: notificationRow.implicitWidth + padding * 2
    height: widgetHeight

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, SettingsData.dockWidgetAreaOpacity)
        radius: Theme.cornerRadius * scaleFactor
        border.width: 0
        border.color: "transparent"

        Row {
            id: notificationRow
            anchors.centerIn: parent
            spacing: iconSpacing

            EHIcon {
                name: "notifications"
                size: iconSize
                color: Theme.primary
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: "Notifications"
                font.pixelSize: fontSize
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}







