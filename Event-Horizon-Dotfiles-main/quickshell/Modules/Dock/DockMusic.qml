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

    width: musicRow.implicitWidth + 16 * (widgetHeight / 40)
    height: widgetHeight

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, 0.3)
        radius: Theme.cornerRadius * (widgetHeight / 40)
        border.width: 1
        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)

        Row {
            id: musicRow
            anchors.centerIn: parent
            spacing: 6 * (widgetHeight / 40)

            EHIcon {
                name: "music_note"
                size: 16 * (widgetHeight / 40)
                color: Theme.primary
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                id: textClip
                readonly property real maxTextWidth: 160 * (widgetHeight / 40)
                readonly property real scrollDistance: Math.max(0, titleText.implicitWidth - width)
                readonly property bool shouldScroll: SettingsData.mediaScrollEnabled && scrollDistance > 0

                width: Math.min(titleText.implicitWidth, maxTextWidth)
                height: titleText.implicitHeight
                clip: true
                anchors.verticalCenter: parent.verticalCenter

            StyledText {
                    id: titleText
                text: MprisController.currentTrack ? MprisController.currentTrack.title || "No track" : "No music"
                font.pixelSize: 12 * (widgetHeight / 40)
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
                maximumLineCount: 1
                }

                onShouldScrollChanged: {
                    if (!shouldScroll) {
                        titleText.x = 0
                    }
                }

                SequentialAnimation {
                    running: textClip.shouldScroll
                    loops: Animation.Infinite

                    PauseAnimation { duration: 700 }
                    NumberAnimation {
                        target: titleText
                        property: "x"
                        from: 0
                        to: -textClip.scrollDistance
                        duration: Math.max(1200, textClip.scrollDistance * 20)
                        easing.type: Easing.Linear
                    }
                    PauseAnimation { duration: 700 }
                    NumberAnimation {
                        target: titleText
                        property: "x"
                        from: -textClip.scrollDistance
                        to: 0
                        duration: Math.max(1200, textClip.scrollDistance * 20)
                        easing.type: Easing.Linear
                    }
                }
            }
        }
    }
}







