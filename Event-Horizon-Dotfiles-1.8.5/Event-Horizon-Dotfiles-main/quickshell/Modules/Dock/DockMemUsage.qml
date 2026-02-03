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

    width: memRow.implicitWidth + padding * 2
    height: widgetHeight

    Rectangle {
        anchors.fill: parent
        color: {
            const baseColor = Theme.widgetBaseBackgroundColor
            return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * Theme.widgetTransparency)
        }
        radius: Theme.cornerRadius * scaleFactor
        border.width: 0
        border.color: "transparent"

        Row {
            id: memRow
            anchors.centerIn: parent
            spacing: iconSpacing

            EHIcon {
                name: "storage"
                size: iconSize
                color: Theme.primary
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: DgopService.memUsage ? `${DgopService.memUsage}%` : "N/A"
                font.pixelSize: fontSize
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}







