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

    width: widgetHeight
    height: widgetHeight

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, SettingsData.dockWidgetAreaOpacity)
        radius: Theme.cornerRadius * (widgetHeight / 40)
        border.width: 0
        border.color: "transparent"

        EHIcon {
            anchors.centerIn: parent
            name: "content_paste"
            size: 14 * (widgetHeight / 40)
            color: Theme.primary
        }
    }
}







