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

    function getOpacityValue() {
        if (cfg && cfg.hasOwnProperty("opacity")) {
            return cfg.opacity;
        }
        return SettingsData.desktopMediaPlayerOpacity;
    }

    function getFontScaleValue() {
        if (cfg && cfg.hasOwnProperty("fontScale")) {
            return cfg.fontScale;
        }
        return SettingsData.desktopMediaPlayerFontScale;
    }

    function getButtonScaleValue() {
        if (cfg && cfg.hasOwnProperty("buttonScale")) {
            return cfg.buttonScale;
        }
        return SettingsData.desktopMediaPlayerButtonScale;
    }

    function getBoldFontValue() {
        if (cfg && cfg.hasOwnProperty("boldFont")) {
            return cfg.boldFont;
        }
        return SettingsData.desktopMediaPlayerBoldFont;
    }

    function getArtScaleValue() {
        if (cfg && cfg.hasOwnProperty("artScale")) {
            return cfg.artScale;
        }
        return SettingsData.desktopMediaPlayerArtScale;
    }

    function getVisualizerIntensityValue() {
        if (cfg && cfg.hasOwnProperty("visualizerIntensity")) {
            return cfg.visualizerIntensity;
        }
        return SettingsData.desktopMediaPlayerVisualizerIntensity;
    }

    width: parent?.width ?? 400
    spacing: Theme.spacingM

    StyledText {
        text: "Media Player Widget"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    Column {
        width: parent.width
        spacing: Theme.spacingS

        StyledText {
            text: "Opacity"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceText
            font.weight: Font.Medium
        }

        EHSlider {
            width: parent.width
            height: 24
            value: Math.round(root.getOpacityValue() * 100)
            minimum: 0
            maximum: 100
            unit: "%"
            showValue: true
            wheelEnabled: false
            onSliderDragFinished: newValue => {
                if (root.instanceId) {
                    root.updateConfig("opacity", newValue / 100);
                } else {
                    SettingsData.setDesktopMediaPlayerOpacity(newValue);
                }
            }
        }
    }

    Column {
        width: parent.width
        spacing: Theme.spacingS

        StyledText {
            text: "Font Size"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceText
            font.weight: Font.Medium
        }

        EHSlider {
            width: parent.width
            height: 24
            value: Math.round(root.getFontScaleValue() * 100)
            minimum: 50
            maximum: 200
            unit: "%"
            showValue: true
            wheelEnabled: false
            onSliderDragFinished: newValue => {
                if (root.instanceId) {
                    root.updateConfig("fontScale", newValue / 100);
                } else {
                    SettingsData.setDesktopMediaPlayerFontScale(newValue);
                }
            }
        }
    }

    Column {
        width: parent.width
        spacing: Theme.spacingS

        StyledText {
            text: "Button Size"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceText
            font.weight: Font.Medium
        }

        EHSlider {
            width: parent.width
            height: 24
            value: Math.round(root.getButtonScaleValue() * 100)
            minimum: 50
            maximum: 200
            unit: "%"
            showValue: true
            wheelEnabled: false
            onSliderDragFinished: newValue => {
                if (root.instanceId) {
                    root.updateConfig("buttonScale", newValue / 100);
                } else {
                    SettingsData.setDesktopMediaPlayerButtonScale(newValue);
                }
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 48
        radius: Theme.cornerRadius
        color: Theme.surfaceContainer

        Row {
            anchors.fill: parent
            anchors.margins: Theme.spacingS
            spacing: Theme.spacingS

            StyledText {
                text: "Bold Font"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceText
                font.weight: Font.Medium
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                width: 1
                height: 1
                anchors.verticalCenter: parent.verticalCenter
            }

            EHToggle {
                id: boldFontSwitch
                anchors.verticalCenter: parent.verticalCenter
                checked: root.getBoldFontValue()
                onToggled: (checked) => {
                    if (root.instanceId) {
                        root.updateConfig("boldFont", checked);
                    } else {
                        SettingsData.setDesktopMediaPlayerBoldFont(checked);
                    }
                }
            }
        }
    }

    Column {
        width: parent.width
        spacing: Theme.spacingS

        StyledText {
            text: "Album Art & Visualizer Size"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceText
            font.weight: Font.Medium
        }

        EHSlider {
            width: parent.width
            height: 24
            value: Math.round(root.getArtScaleValue() * 100)
            minimum: 50
            maximum: 200
            unit: "%"
            showValue: true
            wheelEnabled: false
            onSliderDragFinished: newValue => {
                if (root.instanceId) {
                    root.updateConfig("artScale", newValue / 100);
                } else {
                    SettingsData.setDesktopMediaPlayerArtScale(newValue);
                }
            }
        }
    }

    Column {
        width: parent.width
        spacing: Theme.spacingS

        StyledText {
            text: "Visualizer Intensity"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceText
            font.weight: Font.Medium
        }

        EHSlider {
            width: parent.width
            height: 24
            value: Math.round((root.getVisualizerIntensityValue() - 0.5) / 1.5 * 100)
            minimum: 0
            maximum: 100
            unit: "%"
            showValue: true
            wheelEnabled: false
            onSliderDragFinished: newValue => {
                var intensity = 0.5 + (newValue / 100) * 1.5;
                if (root.instanceId) {
                    root.updateConfig("visualizerIntensity", intensity);
                } else {
                    SettingsData.setDesktopMediaPlayerVisualizerIntensity(intensity);
                }
            }
        }
    }
}
