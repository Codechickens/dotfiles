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

    function formatNetworkSpeed(bytesPerSec) {
        if (bytesPerSec < 1024) {
            return bytesPerSec.toFixed(0) + " B/s";
        } else if (bytesPerSec < 1024 * 1024) {
            return (bytesPerSec / 1024).toFixed(1) + " KB/s";
        } else if (bytesPerSec < 1024 * 1024 * 1024) {
            return (bytesPerSec / (1024 * 1024)).toFixed(1) + " MB/s";
        } else {
            return (bytesPerSec / (1024 * 1024 * 1024)).toFixed(1) + " GB/s";
        }
    }

    width: networkContent.implicitWidth + 16 * (widgetHeight / 40)
    height: widgetHeight

    Component.onCompleted: {
        DgopService.addRef(["network"]);
    }
    Component.onDestruction: {
        DgopService.removeRef(["network"]);
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, SettingsData.dockWidgetAreaOpacity)
        radius: Theme.cornerRadius * (widgetHeight / 40)
        border.width: 0
        border.color: "transparent"

        Row {
            id: networkContent
            anchors.centerIn: parent
            spacing: 3 * (widgetHeight / 30)

            EHIcon {
                name: "network_check"
                size: (Theme.iconSize - 8) * (widgetHeight / 30)
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                StyledText {
                    text: "↓"
                    font.pixelSize: Theme.fontSizeSmall * (widgetHeight / 30)
                    color: Theme.info
                }

                StyledText {
                    text: DgopService.networkRxRate > 0 ? formatNetworkSpeed(DgopService.networkRxRate) : "0 B/s"
                    font.pixelSize: Theme.fontSizeSmall * (widgetHeight / 30)
                    font.weight: Font.Medium
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideNone
                    wrapMode: Text.NoWrap

                    StyledTextMetrics {
                        id: rxBaseline
                        font.pixelSize: Theme.fontSizeSmall * (widgetHeight / 30)
                        font.weight: Font.Medium
                        text: "88.8 MB/s"
                    }

                    width: Math.max(rxBaseline.width, paintedWidth)

                    Behavior on width {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.OutCubic
                        }
                    }
                }

            }

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                StyledText {
                    text: "↑"
                    font.pixelSize: Theme.fontSizeSmall * (widgetHeight / 30)
                    color: Theme.error
                }

                StyledText {
                    text: DgopService.networkTxRate > 0 ? formatNetworkSpeed(DgopService.networkTxRate) : "0 B/s"
                    font.pixelSize: Theme.fontSizeSmall * (widgetHeight / 30)
                    font.weight: Font.Medium
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideNone
                    wrapMode: Text.NoWrap

                    StyledTextMetrics {
                        id: txBaseline
                        font.pixelSize: Theme.fontSizeSmall * (widgetHeight / 30)
                        font.weight: Font.Medium
                        text: "88.8 MB/s"
                    }

                    width: Math.max(txBaseline.width, paintedWidth)

                    Behavior on width {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.OutCubic
                        }
                    }
                }

            }
        }
    }
}







