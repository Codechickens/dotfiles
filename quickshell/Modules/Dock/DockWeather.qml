import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
    readonly property real pillHeight: Math.max(weatherRow.implicitHeight, iconSize) + padding * 2

    width: weatherRow.implicitWidth + padding * 2
    height: widgetHeight

        Ref {
            service: WeatherService
        }

        Rectangle {
            width: parent.width
            height: widgetHeight
            anchors.centerIn: parent
            radius: Theme.cornerRadius * scaleFactor
            color: {
                const baseColor = Theme.widgetBaseBackgroundColor
                return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * Theme.widgetTransparency)
            }
            border.width: 0
            border.color: "transparent"

            Row {
                id: weatherRow
                anchors.centerIn: parent
                spacing: iconSpacing

                EHIcon {
                    name: WeatherService.getWeatherIcon(WeatherService.weather.wCode)
                    size: iconSize
                    color: Theme.primary
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    text: {
                        const temp = SettingsData.useFahrenheit ? WeatherService.weather.tempF : WeatherService.weather.temp;
                        if (temp === undefined || temp === null) {
                            return "--°" + (SettingsData.useFahrenheit ? "F" : "C");
                        }
                        return temp + "°" + (SettingsData.useFahrenheit ? "F" : "C");
                    }
                    font.pixelSize: fontSize
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }







