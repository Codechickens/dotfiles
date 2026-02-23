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

    function getRotationValue() {
        if (cfg && cfg.hasOwnProperty("rotation")) {
            return cfg.rotation;
        }
        return SettingsData.desktopCavaRotation;
    }

    width: parent?.width ?? 400
    spacing: Theme.spacingM

    StyledText {
        text: "Audio Visualizer Settings"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    // Rotation Button
    Row {
        width: parent.width
        spacing: Theme.spacingM

        StyledText {
            text: "Rotation"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceText
            font.weight: Font.Medium
            anchors.verticalCenter: parent.verticalCenter
        }

        EHActionButton {
            iconName: "rotate_right"
            iconSize: Theme.iconSizeSmall
            onClicked: {
                var currentRotation = root.getRotationValue();
                var newRotation = (currentRotation + 90) % 360;
                if (root.instanceId) {
                    root.updateConfig("rotation", newRotation);
                } else {
                    SettingsData.setDesktopCavaRotation(newRotation);
                }
            }
        }

        StyledText {
            text: {
                var rotation = root.getRotationValue();
                return rotation + "°";
            }
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceVariantText
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Wallpaper Colors Toggle
    Row {
        width: parent.width
        spacing: Theme.spacingM

        StyledText {
            text: "Use Wallpaper Colors"
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.surfaceText
            anchors.verticalCenter: parent.verticalCenter
            width: 160
        }

        EHToggle {
            checked: cfg.wallpaperColors ?? false
            onToggled: checked => {
                root.updateConfig("wallpaperColors", checked)
            }
        }
    }

    // Visualizer Intensity
    Row {
        width: parent.width
        spacing: Theme.spacingM

        StyledText {
            text: "Intensity"
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.surfaceText
            anchors.verticalCenter: parent.verticalCenter
            width: 160
        }

        EHSlider {
            id: intensitySlider
            width: parent.width - 160 - Theme.spacingM
            height: 32
            value: Math.round((cfg.visualizerIntensity ?? 1.0) * 100)
            minimum: 50
            maximum: 200
            unit: "%"
            showValue: true
            wheelEnabled: false

            property real pendingValue: value

            Timer {
                id: intensityTimer
                interval: 50
                onTriggered: {
                    root.updateConfig("visualizerIntensity", intensitySlider.pendingValue / 100)
                }
            }

            onSliderValueChanged: newValue => {
                intensitySlider.pendingValue = newValue
                intensityTimer.restart()
            }

            onSliderDragFinished: finalValue => {
                intensityTimer.stop()
                root.updateConfig("visualizerIntensity", finalValue / 100)
            }
        }
    }

    // Bar Count
    Row {
        width: parent.width
        spacing: Theme.spacingM

        StyledText {
            text: "Bar Count"
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.surfaceText
            anchors.verticalCenter: parent.verticalCenter
            width: 160
        }

        EHSlider {
            id: barCountSlider
            width: parent.width - 160 - Theme.spacingM
            height: 32
            value: cfg.barCount ?? 40
            minimum: 10
            maximum: 100
            showValue: true
            wheelEnabled: false

            property real pendingValue: value

            Timer {
                id: barCountTimer
                interval: 50
                onTriggered: {
                    root.updateConfig("barCount", Math.round(barCountSlider.pendingValue))
                }
            }

            onSliderValueChanged: newValue => {
                barCountSlider.pendingValue = newValue
                barCountTimer.restart()
            }

            onSliderDragFinished: finalValue => {
                barCountTimer.stop()
                root.updateConfig("barCount", Math.round(finalValue))
            }
        }
    }

    // Show Shadow Toggle
    Row {
        width: parent.width
        spacing: Theme.spacingM

        StyledText {
            text: "Show Shadow"
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.surfaceText
            anchors.verticalCenter: parent.verticalCenter
            width: 160
        }

        EHToggle {
            checked: cfg.showShadow ?? true
            onToggled: checked => {
                root.updateConfig("showShadow", checked)
            }
        }
    }
}
