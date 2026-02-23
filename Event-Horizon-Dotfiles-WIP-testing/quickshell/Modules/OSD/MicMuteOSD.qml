import QtQuick
import qs.Common
import qs.Services
import qs.Widgets

EHOSD {
    id: root

    osdWidth: Theme.iconSize + Theme.spacingS * 2
    osdHeight: Theme.iconSize + Theme.spacingS * 2
    autoHideInterval: 2000
    enableMouseInteraction: false

    Connections {
        target: AudioService
        function onInputMutedChanged() {
            root.show()
        }
    }

    content: EHIcon {
        anchors.centerIn: parent
        name: {
            const source = AudioService.source
            const audio = source && source.audio
            return audio && audio.muted ? "mic_off" : "mic"
        }
        size: Theme.iconSize
        color: {
            const source = AudioService.source
            const audio = source && source.audio
            return audio && audio.muted ? Theme.error : Theme.primary
        }
    }
}
