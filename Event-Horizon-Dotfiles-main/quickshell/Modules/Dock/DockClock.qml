import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root
    property real widgetHeight: 20
    property bool isBarVertical: false

    // Clock display options (from settings)
    property bool showFullDate: SettingsData.dockClockShowFullDate
    property bool showSeconds: SettingsData.dockClockShowSeconds
    property bool use12Hour: SettingsData.dockClockUse12Hour
    property bool showAmPm: SettingsData.dockClockShowAmPm
    property real fontSize: SettingsData.dockClockFontSize

    onUse12HourChanged: console.log("DockClock use12Hour changed to:", use12Hour)

    width: Math.max(timeText.implicitWidth, root.showFullDate ? dateText.implicitWidth : 0) + 30 * (widgetHeight / 20)
    height: widgetHeight

    Rectangle {
        anchors.fill: parent
        radius: Theme.cornerRadius * (widgetHeight / 20)
        color: {
            const baseColor = Theme.widgetBaseBackgroundColor;
            return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * Theme.widgetTransparency);
        }

        Column {
            id: clockRow
            anchors.centerIn: parent
            spacing: root.showFullDate ? -9 : 2 * (widgetHeight / 20)

            // Time display (always on top)
            StyledText {
                id: timeText
                text: {
                    const now = new Date()
                    let hours = now.getHours()
                    let minutes = now.getMinutes()
                    let seconds = now.getSeconds()

                    let timeStr = ""

                    if (root.use12Hour) {
                        // 12-hour format
                        let displayHours = hours === 0 ? 12 : hours > 12 ? hours - 12 : hours
                        timeStr = String(displayHours).padStart(2, '0') + ":" + String(minutes).padStart(2, '0')

                        if (root.showSeconds) {
                            timeStr += ":" + String(seconds).padStart(2, '0')
                        }

                        if (root.showAmPm) {
                            timeStr += " " + (hours >= 12 ? "PM" : "AM")
                        }
                    } else {
                        // 24-hour format
                        timeStr = String(hours).padStart(2, '0') + ":" + String(minutes).padStart(2, '0')

                        if (root.showSeconds) {
                            timeStr += ":" + String(seconds).padStart(2, '0')
                        }
                    }

                    return timeStr
                }
                font.pixelSize: 12 * (widgetHeight / 20) * root.fontSize
                color: Theme.surfaceText
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Date display (optional, below time)
            StyledText {
                id: dateText
                visible: root.showFullDate
                text: {
                    const now = new Date()
                    return now.toLocaleDateString(Qt.locale(), "ddd, MMM d, yyyy")
                }
                font.pixelSize: 10 * (widgetHeight / 20) * root.fontSize
                color: Theme.surfaceText
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Timer {
        interval: root.showSeconds ? 100 : 60000  // Update every 100ms for seconds, every minute otherwise
        running: true
        repeat: true
        onTriggered: {
            const now = new Date()
            let hours = now.getHours()
            let minutes = now.getMinutes()
            let seconds = now.getSeconds()

            let timeStr = ""

            if (root.use12Hour) {
                // 12-hour format
                let displayHours = hours === 0 ? 12 : hours > 12 ? hours - 12 : hours
                timeStr = String(displayHours).padStart(2, '0') + ":" + String(minutes).padStart(2, '0')

                if (root.showSeconds) {
                    timeStr += ":" + String(seconds).padStart(2, '0')
                }

                if (root.showAmPm) {
                    timeStr += " " + (hours >= 12 ? "PM" : "AM")
                }
            } else {
                // 24-hour format
                timeStr = String(hours).padStart(2, '0') + ":" + String(minutes).padStart(2, '0')

                if (root.showSeconds) {
                    timeStr += ":" + String(seconds).padStart(2, '0')
                }
            }

            timeText.text = timeStr

            if (root.showFullDate) {
                dateText.text = now.toLocaleDateString(Qt.locale(), "ddd, MMM d, yyyy")
            }
        }
    }
}
