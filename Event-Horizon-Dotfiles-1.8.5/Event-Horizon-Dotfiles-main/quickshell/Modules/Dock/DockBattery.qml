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
    
    readonly property real pillHeight: Math.max(batteryRow.implicitHeight, iconSize) + padding * 2

    width: batteryRow.implicitWidth + padding * 2
    height: widgetHeight

    Rectangle {
        width: parent.width
        height: root.pillHeight
        anchors.centerIn: parent
        color: {
            const baseColor = Theme.widgetBaseBackgroundColor
            return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * Theme.widgetTransparency)
        }
        radius: Theme.cornerRadius * scaleFactor
        border.width: 0
        border.color: "transparent"

        Row {
            id: batteryRow
            anchors.centerIn: parent
            spacing: iconSpacing

            EHIcon {
                name: getBatteryIcon()
                size: iconSize
                color: getBatteryColor()
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: BatteryService.chargePercent ? Math.round(BatteryService.chargePercent) + "%" : "--%"
                font.pixelSize: fontSize
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    function getBatteryIcon() {
        if (!BatteryService.chargePercent) return "battery_unknown"
        
        const percent = BatteryService.chargePercent
        if (BatteryService.charging) {
            if (percent < 25) return "battery_charging_20"
            if (percent < 50) return "battery_charging_30"
            if (percent < 75) return "battery_charging_50"
            if (percent < 90) return "battery_charging_60"
            return "battery_charging_full"
        } else {
            if (percent < 25) return "battery_alert"
            if (percent < 50) return "battery_1_bar"
            if (percent < 75) return "battery_2_bar"
            if (percent < 90) return "battery_4_bar"
            return "battery_full"
        }
    }

    function getBatteryColor() {
        if (!BatteryService.chargePercent) return Theme.surfaceText
        
        const percent = BatteryService.chargePercent
        if (BatteryService.charging) return Theme.primary
        if (percent < 20) return Theme.error
        if (percent < 50) return Theme.warning
        return Theme.surfaceText
    }
}







