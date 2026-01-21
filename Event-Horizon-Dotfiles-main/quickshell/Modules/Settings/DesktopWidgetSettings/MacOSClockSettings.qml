import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Column {
    id: root

    property string instanceId: ""
    property var instanceData: null

    readonly property var cfg: instanceData?.config ?? {}

    function updateConfig(key, value) {
        if (!instanceId)
            return;
        var updates = {};
        updates[key] = value;
        SettingsData.updateDesktopWidgetInstanceConfig(instanceId, updates);
    }

    width: parent?.width ?? 400
    spacing: Theme.spacingM

    Row {
        width: parent.width
        spacing: Theme.spacingM

        StyledText {
            text: "Background Opacity"
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.surfaceText
            anchors.verticalCenter: parent.verticalCenter
            width: 120
        }

        EHSlider {
            id: opacitySlider
            width: parent.width - 120 - Theme.spacingM
            height: 32
            value: Math.round((cfg.transparency ?? 0.5) * 100)
            minimum: 0
            maximum: 100
            unit: "%"
            showValue: true
            wheelEnabled: false
            
            property real pendingValue: value
            
            Timer {
                id: updateTimer
                interval: 50
                onTriggered: {
                    root.updateConfig("transparency", opacitySlider.pendingValue / 100)
                }
            }
            
            onSliderValueChanged: newValue => {
                opacitySlider.pendingValue = newValue
                updateTimer.restart()
            }
            
            onSliderDragFinished: finalValue => {
                updateTimer.stop()
                root.updateConfig("transparency", finalValue / 100)
            }
        }
    }
}
