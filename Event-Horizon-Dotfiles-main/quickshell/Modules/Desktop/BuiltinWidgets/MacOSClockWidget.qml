import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root

    property var instanceData: null
    property var screen: null
    property real widgetWidth: 200
    property real widgetHeight: 200

    readonly property var cfg: instanceData?.config ?? {}
    
    // Scale factor based on widget size (using average of width and height ratios)
    readonly property real baseWidth: 200
    readonly property real baseHeight: 200
    readonly property real scaleFactor: Math.min(widgetWidth / baseWidth, widgetHeight / baseHeight)
    
    // Padding values that scale with widget size
    readonly property real horizontalPadding: 20 * root.scaleFactor
    readonly property real verticalPadding: 20 * root.scaleFactor

    implicitWidth: widgetWidth
    implicitHeight: widgetHeight

    Rectangle {
        anchors.fill: parent
        radius: Math.min(width, height) / 2
        color: Qt.rgba(0, 0, 0, cfg.transparency !== undefined ? cfg.transparency * 0.4 : 0.2)
        border.color: Qt.rgba(255, 255, 255, 0.1)
        border.width: 1 * root.scaleFactor

        Item {
            anchors.fill: parent
            anchors.margins: root.verticalPadding
            anchors.leftMargin: root.horizontalPadding
            anchors.rightMargin: root.horizontalPadding

            Column {
                id: timeColumn
                anchors.centerIn: parent
                spacing: -8 * root.scaleFactor
                
                property string timeString: {
                    if (!systemClock?.date) return ""
                    return Qt.formatTime(systemClock.date, SettingsData.getEffectiveTimeFormat()).replace(/\./g, "").trim()
                }
                
                property string timeDigits: {
                    // Extract only digits and colon, excluding AM/PM
                    return timeColumn.timeString.replace(/[APM\s]/g, "")
                }
                
                property string amPmString: {
                    // Extract AM/PM if present
                    const match = timeColumn.timeString.match(/[AP]\.?M\.?/i)
                    return match ? match[0] : ""
                }
                
                property bool useWallpaperColors: cfg.wallpaperColors ?? false
                property var matugenColorNames: [
                    "primary", "secondary", "tertiary", "surface_tint",
                    "primary_container", "secondary_container", "tertiary_container",
                    "primary_fixed", "secondary_fixed", "tertiary_fixed"
                ]
                
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 4 * root.scaleFactor
                    
                    Repeater {
                        model: timeColumn.timeDigits.length
                        
                        StyledText {
                            text: timeColumn.timeDigits[index]
                            font.pixelSize: 56 * root.scaleFactor
                            font.family: "SF Pro Display, -apple-system, system-ui"
                            font.weight: Font.Bold
                            font.hintingPreference: SettingsData.fontHintingPreference
                            renderType: SettingsData.fontRenderType
                            antialiasing: SettingsData.fontAntialiasing
                            lineHeight: SettingsData.fontLineHeight
                            verticalAlignment: Text.AlignVCenter
                            color: {
                                Theme.colorUpdateTrigger
                                
                                if (timeColumn.useWallpaperColors && Theme.matugenColors && Theme.matugenColors.colors) {
                                    const colorName = timeColumn.matugenColorNames[index % timeColumn.matugenColorNames.length]
                                    const colorMode = (typeof SessionData !== "undefined" && SessionData.isLightMode) ? "light" : "dark"
                                    if (Theme.matugenColors.colors[colorName] && Theme.matugenColors.colors[colorName][colorMode]) {
                                        return Theme.matugenColors.colors[colorName][colorMode]
                                    }
                                }
                                return Qt.rgba(1, 1, 1, 0.95)
                            }
                        }
                    }
                }
                
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 2 * root.scaleFactor
                    visible: timeColumn.amPmString.length > 0
                    
                    Repeater {
                        model: timeColumn.amPmString.length
                        
                        StyledText {
                            text: timeColumn.amPmString[index]
                            font.pixelSize: 42 * root.scaleFactor
                            font.family: "SF Pro Display, -apple-system, system-ui"
                            font.weight: Font.Bold
                            font.hintingPreference: SettingsData.fontHintingPreference
                            renderType: SettingsData.fontRenderType
                            antialiasing: SettingsData.fontAntialiasing
                            lineHeight: SettingsData.fontLineHeight
                            verticalAlignment: Text.AlignVCenter
                            color: {
                                Theme.colorUpdateTrigger
                                
                                if (timeColumn.useWallpaperColors && Theme.matugenColors && Theme.matugenColors.colors) {
                                    const colorIndex = timeColumn.timeDigits.length + index
                                    const colorName = timeColumn.matugenColorNames[colorIndex % timeColumn.matugenColorNames.length]
                                    const colorMode = (typeof SessionData !== "undefined" && SessionData.isLightMode) ? "light" : "dark"
                                    if (Theme.matugenColors.colors[colorName] && Theme.matugenColors.colors[colorName][colorMode]) {
                                        return Theme.matugenColors.colors[colorName][colorMode]
                                    }
                                }
                                return Qt.rgba(1, 1, 1, 0.95)
                            }
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.SizeAllCursor
        }
    }

    SystemClock {
        id: systemClock
        precision: SystemClock.Seconds
    }
}
