import QtQuick
import qs.Common
import qs.Services
import qs.Widgets

EHOSD {
    id: root

    property string deviceName: ""
    property bool showingDeviceName: false
    property var lastSource: null

    osdWidth: Math.min(260, Screen.width - Theme.spacingM * 2)
    osdHeight: showingDeviceName ? 40 + Theme.spacingS * 2 + 20 : 40 + Theme.spacingS * 2
    autoHideInterval: 3000
    enableMouseInteraction: true

    Connections {
        target: AudioService

        function onInputMutedChanged() {
            root.updateDeviceName()
            root.show()
        }

        function onSourceChanged() {
            if (AudioService.source && AudioService.source !== root.lastSource) {
                root.lastSource = AudioService.source
                root.updateDeviceName()
                root.show()
            }
        }
    }

    // Watch for input volume changes
    Connections {
        target: AudioService.source && AudioService.source.audio ? AudioService.source.audio : null

        function onVolumeChanged() {
            root.updateDeviceName()
            root.show()
        }
    }

    // Also watch the source property directly using a binding
    property var currentSource: AudioService.source
    property real currentInputVolume: AudioService.inputVolume

    onCurrentInputVolumeChanged: {
        updateDeviceName()
        show()
    }

    onCurrentSourceChanged: {
        if (currentSource && currentSource !== lastSource) {
            lastSource = currentSource
            updateDeviceName()
            show()
        }
    }

    function updateDeviceName() {
        if (AudioService.source) {
            deviceName = AudioService.displayName(AudioService.source)
            showingDeviceName = deviceName !== ""
        } else {
            deviceName = ""
            showingDeviceName = false
        }
    }

    onOsdHidden: {
        // Reset device name state when OSD hides
        showingDeviceName = false
        deviceName = ""
    }

    Component.onCompleted: {
        lastSource = AudioService.source
        updateDeviceName()
    }

    content: Item {
        anchors.fill: parent

        StyledText {
            id: deviceNameText
            visible: root.showingDeviceName && root.deviceName !== ""
            text: root.deviceName
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Theme.spacingXS
            anchors.leftMargin: Theme.spacingS
            anchors.rightMargin: Theme.spacingS
            height: visible ? 20 : 0
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceVariantText
            elide: Text.ElideMiddle
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            property int gap: Theme.spacingS

            anchors.centerIn: parent
            anchors.verticalCenterOffset: root.showingDeviceName ? 10 : 0
            width: parent.width - Theme.spacingS * 2
            height: 40

            Rectangle {
                width: Theme.iconSize
                height: Theme.iconSize
                radius: Theme.iconSize / 2
                color: "transparent"
                x: parent.gap
                anchors.verticalCenter: parent.verticalCenter

                EHIcon {
                    anchors.centerIn: parent
                    name: AudioService.source && AudioService.source.audio && AudioService.source.audio.muted ? "mic_off" : "mic"
                    size: Theme.iconSize
                    color: muteButton.containsMouse ? Theme.primary : (AudioService.source && AudioService.source.audio && AudioService.source.audio.muted ? Theme.error : Theme.surfaceText)
                }

                MouseArea {
                    id: muteButton

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        AudioService.toggleMicMute()
                    }
                    onContainsMouseChanged: {
                        setChildHovered(containsMouse || volumeSlider.containsMouse)
                    }
                }
            }

            EHSlider {
                id: volumeSlider

                readonly property real actualVolumePercent: AudioService.source && AudioService.source.audio ? Math.round(AudioService.source.audio.volume * 100) : 0
                readonly property real displayPercent: actualVolumePercent

                width: parent.width - Theme.iconSize - parent.gap * 3
                height: 40
                x: parent.gap * 2 + Theme.iconSize
                anchors.verticalCenter: parent.verticalCenter
                minimum: 0
                maximum: 100
                enabled: AudioService.source && AudioService.source.audio
                showValue: true
                unit: "%"
                thumbOutlineColor: Theme.surfaceContainer
                valueOverride: displayPercent

                Component.onCompleted: {
                    if (AudioService.source && AudioService.source.audio) {
                        value = Math.min(100, Math.round(AudioService.source.audio.volume * 100))
                    }
                }

                onSliderValueChanged: newValue => {
                                          if (AudioService.source && AudioService.source.audio) {
                                              SessionData.suppressOSDTemporarily()
                                              AudioService.source.audio.volume = newValue / 100
                                              resetHideTimer()
                                          }
                                      }

                onContainsMouseChanged: {
                    setChildHovered(containsMouse || muteButton.containsMouse)
                }

                Binding {
                    target: volumeSlider
                    property: "value"
                    value: AudioService.source && AudioService.source.audio ? Math.min(100, Math.round(AudioService.source.audio.volume * 100)) : 0
                    when: !volumeSlider.isDragging
                }

                Connections {
                    target: AudioService.source && AudioService.source.audio ? AudioService.source.audio : null

                    function onVolumeChanged() {
                        if (volumeSlider && !volumeSlider.isDragging) {
                            volumeSlider.value = Math.min(100, Math.round(AudioService.source.audio.volume * 100))
                        }
                    }
                }
            }
        }
    }

    onOsdShown: {
        updateDeviceName()
        if (AudioService.source && AudioService.source.audio && contentLoader.item) {
            // Find the slider in the content (it's the second child Item's second child)
            const contentItem = contentLoader.item
            if (contentItem && contentItem.children.length > 1) {
                const sliderContainer = contentItem.children[1]
                if (sliderContainer && sliderContainer.children.length > 1) {
                    const slider = sliderContainer.children[1]
                    if (slider && slider.value !== undefined) {
                        slider.value = Math.min(100, Math.round(AudioService.source.audio.volume * 100))
                    }
                }
            }
        }
    }
}
