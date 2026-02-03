import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: hyprlandRoundingTab

    property var parentModal: null

    EHFlickable {
        anchors.fill: parent
        clip: true
        contentHeight: Math.max(height, mainColumn.childrenRect.height + Theme.spacingM)
        contentWidth: width

        Column {
            id: mainColumn
            width: parent.width
            spacing: Theme.spacingM

            StyledRect {
                width: parent.width
                height: decorationContentColumn.height + Theme.spacingL * 2 + 4
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                border.width: 1
                visible: typeof CompositorService !== 'undefined' && CompositorService.isHyprland

                Column {
                    id: decorationContentColumn
                    width: parent.width - Theme.spacingM * 2
                    x: Theme.spacingM
                    y: Theme.spacingM
                    spacing: Theme.spacingM

                    // Global Blur Section
                    Column {
                        width: parent.width
                        spacing: Theme.spacingM

                        Row {
                            width: parent.width
                            spacing: Theme.spacingM

                            EHIcon {
                                name: "blur_on"
                                size: Theme.iconSize
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: "Global Blur"
                                font.pixelSize: Theme.fontSizeLarge
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Blur Size: " + SettingsData.hyprlandBlurSize
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandBlurSize
                                minimum: 0
                                maximum: 20
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandBlurSize(finalValue)
                                }
                            }

                            StyledText {
                                text: "Blur Passes: " + SettingsData.hyprlandBlurPasses
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandBlurPasses
                                minimum: 1
                                maximum: 10
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandBlurPasses(finalValue)
                                }
                            }
                        }
                    }

                    // Rounding Section
                    Column {
                        width: parent.width
                        spacing: Theme.spacingM

                        Row {
                            width: parent.width
                            spacing: Theme.spacingM

                            EHIcon {
                                name: "rounded_corner"
                                size: Theme.iconSize
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: "Window Rounding"
                                font.pixelSize: Theme.fontSizeLarge
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Corner Rounding: " + SettingsData.hyprlandDecorationRounding + "px"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandDecorationRounding
                                minimum: 0
                                maximum: 50
                                unit: "px"
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationRounding(finalValue)
                                }
                            }

                            StyledText {
                                text: "Rounding Power: " + SettingsData.hyprlandDecorationRoundingPower
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandDecorationRoundingPower
                                minimum: 1
                                maximum: 20
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationRoundingPower(finalValue)
                                }
                            }
                        }
                    }

                    // Blur Settings Section
                    Column {
                        width: parent.width
                        spacing: Theme.spacingM

                        Row {
                            width: parent.width
                            spacing: Theme.spacingM

                            EHIcon {
                                name: "blur_on"
                                size: Theme.iconSize
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: "Decoration Blur"
                                font.pixelSize: Theme.fontSizeLarge
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: Theme.spacingS

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "Enable Blur"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Apply blur effects to window decorations"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandDecorationBlurEnabled
                                    onToggled: checked => {
                                        SettingsData.setHyprlandDecorationBlurEnabled(checked)
                                    }
                                }
                            }

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM
                                visible: SettingsData.hyprlandDecorationBlurEnabled

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "X-Ray Mode"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Allow blur to show through transparent areas"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandDecorationBlurXray
                                    onToggled: checked => {
                                        SettingsData.setHyprlandDecorationBlurXray(checked)
                                    }
                                }
                            }

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM
                                visible: SettingsData.hyprlandDecorationBlurEnabled

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "Special Blur"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Apply blur to special workspaces"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandDecorationBlurSpecial
                                    onToggled: checked => {
                                        SettingsData.setHyprlandDecorationBlurSpecial(checked)
                                    }
                                }
                            }

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM
                                visible: SettingsData.hyprlandDecorationBlurEnabled

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "New Optimizations"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Use improved blur algorithms"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandDecorationBlurNewOptimizations
                                    onToggled: checked => {
                                        SettingsData.setHyprlandDecorationBlurNewOptimizations(checked)
                                    }
                                }
                            }

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM
                                visible: SettingsData.hyprlandDecorationBlurEnabled

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "Ignore Opacity"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Blur even when window is transparent"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandDecorationBlurIgnoreOpacity
                                    onToggled: checked => {
                                        SettingsData.setHyprlandDecorationBlurIgnoreOpacity(checked)
                                    }
                                }
                            }

                            StyledText {
                                text: "Blur Size: " + SettingsData.hyprlandDecorationBlurSize
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                visible: SettingsData.hyprlandDecorationBlurEnabled
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandDecorationBlurSize
                                minimum: 1
                                maximum: 20
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                visible: SettingsData.hyprlandDecorationBlurEnabled
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationBlurSize(finalValue)
                                }
                            }

                            StyledText {
                                text: "Blur Passes: " + SettingsData.hyprlandDecorationBlurPasses
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                visible: SettingsData.hyprlandDecorationBlurEnabled
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandDecorationBlurPasses
                                minimum: 1
                                maximum: 10
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                visible: SettingsData.hyprlandDecorationBlurEnabled
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationBlurPasses(finalValue)
                                }
                            }

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM
                                visible: SettingsData.hyprlandDecorationBlurEnabled

                                StyledText {
                                    text: "Enable Brightness"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceText
                                    font.weight: Font.Medium
                                    Layout.fillWidth: true
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandDecorationBlurBrightnessEnabled
                                    onToggled: checked => {
                                        SettingsData.setHyprlandDecorationBlurBrightnessEnabled(checked)
                                    }
                                }
                            }

                            StyledText {
                                text: "Brightness: " + (Math.round(SettingsData.hyprlandDecorationBlurBrightness * 100) / 100).toFixed(2)
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                visible: SettingsData.hyprlandDecorationBlurEnabled && SettingsData.hyprlandDecorationBlurBrightnessEnabled
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: Math.round(SettingsData.hyprlandDecorationBlurBrightness * 100)
                                minimum: 0
                                maximum: 200
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                visible: SettingsData.hyprlandDecorationBlurEnabled && SettingsData.hyprlandDecorationBlurBrightnessEnabled
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationBlurBrightness(finalValue / 100)
                                }
                            }

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM
                                visible: SettingsData.hyprlandDecorationBlurEnabled

                                StyledText {
                                    text: "Enable Noise"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceText
                                    font.weight: Font.Medium
                                    Layout.fillWidth: true
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandDecorationBlurNoiseEnabled
                                    onToggled: checked => {
                                        SettingsData.setHyprlandDecorationBlurNoiseEnabled(checked)
                                    }
                                }
                            }

                            StyledText {
                                text: "Noise: " + SettingsData.hyprlandDecorationBlurNoise.toFixed(3)
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                visible: SettingsData.hyprlandDecorationBlurEnabled && SettingsData.hyprlandDecorationBlurNoiseEnabled
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: Math.round(SettingsData.hyprlandDecorationBlurNoise * 1000)
                                minimum: 0
                                maximum: 100
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                visible: SettingsData.hyprlandDecorationBlurEnabled && SettingsData.hyprlandDecorationBlurNoiseEnabled
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationBlurNoise(finalValue / 1000)
                                }
                            }

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM
                                visible: SettingsData.hyprlandDecorationBlurEnabled

                                StyledText {
                                    text: "Enable Contrast"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceText
                                    font.weight: Font.Medium
                                    Layout.fillWidth: true
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandDecorationBlurContrastEnabled
                                    onToggled: checked => {
                                        SettingsData.setHyprlandDecorationBlurContrastEnabled(checked)
                                    }
                                }
                            }

                            StyledText {
                                text: "Contrast: " + SettingsData.hyprlandDecorationBlurContrast.toFixed(2)
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                visible: SettingsData.hyprlandDecorationBlurEnabled && SettingsData.hyprlandDecorationBlurContrastEnabled
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: Math.round(SettingsData.hyprlandDecorationBlurContrast * 100)
                                minimum: 0
                                maximum: 200
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                visible: SettingsData.hyprlandDecorationBlurEnabled && SettingsData.hyprlandDecorationBlurContrastEnabled
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationBlurContrast(finalValue / 100)
                                }
                            }

                            StyledText {
                                text: "Vibrancy: " + SettingsData.hyprlandDecorationBlurVibrancy.toFixed(2)
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                visible: SettingsData.hyprlandDecorationBlurEnabled
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: Math.round(SettingsData.hyprlandDecorationBlurVibrancy * 100)
                                minimum: 0
                                maximum: 100
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                visible: SettingsData.hyprlandDecorationBlurEnabled
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationBlurVibrancy(finalValue / 100)
                                }
                            }

                            StyledText {
                                text: "Vibrancy Darkness: " + SettingsData.hyprlandDecorationBlurVibrancyDarkness.toFixed(2)
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                visible: SettingsData.hyprlandDecorationBlurEnabled
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: Math.round(SettingsData.hyprlandDecorationBlurVibrancyDarkness * 100)
                                minimum: 0
                                maximum: 100
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                visible: SettingsData.hyprlandDecorationBlurEnabled
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationBlurVibrancyDarkness(finalValue / 100)
                                }
                            }

                            StyledText {
                                text: "Popups Ignore Alpha: " + SettingsData.hyprlandDecorationBlurPopupsIgnorealpha.toFixed(2)
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                visible: SettingsData.hyprlandDecorationBlurEnabled && SettingsData.hyprlandDecorationBlurPopups
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: Math.round(SettingsData.hyprlandDecorationBlurPopupsIgnorealpha * 100)
                                minimum: 0
                                maximum: 100
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                visible: SettingsData.hyprlandDecorationBlurEnabled && SettingsData.hyprlandDecorationBlurPopups
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationBlurPopupsIgnorealpha(finalValue / 100)
                                }
                            }

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM
                                visible: SettingsData.hyprlandDecorationBlurEnabled

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "Blur Input Methods"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Apply blur to input method popups"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandDecorationBlurInputMethods
                                    onToggled: checked => {
                                        SettingsData.setHyprlandDecorationBlurInputMethods(checked)
                                    }
                                }
                            }

                            StyledText {
                                text: "Input Methods Ignore Alpha: " + SettingsData.hyprlandDecorationBlurInputMethodsIgnorealpha.toFixed(2)
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                visible: SettingsData.hyprlandDecorationBlurEnabled && SettingsData.hyprlandDecorationBlurInputMethods
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: Math.round(SettingsData.hyprlandDecorationBlurInputMethodsIgnorealpha * 100)
                                minimum: 0
                                maximum: 100
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                visible: SettingsData.hyprlandDecorationBlurEnabled && SettingsData.hyprlandDecorationBlurInputMethods
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationBlurInputMethodsIgnorealpha(finalValue / 100)
                                }
                            }
                        }
                    }

                    // Shadow Settings Section
                    Column {
                        width: parent.width
                        spacing: Theme.spacingM

                        Row {
                            width: parent.width
                            spacing: Theme.spacingM

                            EHIcon {
                                name: "shadow"
                                size: Theme.iconSize
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: "Window Shadows"
                                font.pixelSize: Theme.fontSizeLarge
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: Theme.spacingS

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "Enable Shadows"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Show shadows behind windows"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandDecorationShadowEnabled
                                    onToggled: checked => {
                                        SettingsData.setHyprlandDecorationShadowEnabled(checked)
                                    }
                                }
                            }

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM
                                visible: SettingsData.hyprlandDecorationShadowEnabled

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "Ignore Window"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Do not draw shadows behind windows"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandDecorationShadowIgnoreWindow
                                    onToggled: checked => {
                                        SettingsData.setHyprlandDecorationShadowIgnoreWindow(checked)
                                    }
                                }
                            }

                            StyledText {
                                text: "Shadow Range: " + SettingsData.hyprlandDecorationShadowRange + "px"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                visible: SettingsData.hyprlandDecorationShadowEnabled
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandDecorationShadowRange
                                minimum: 1
                                maximum: 50
                                unit: "px"
                                showValue: true
                                wheelEnabled: false
                                visible: SettingsData.hyprlandDecorationShadowEnabled
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationShadowRange(finalValue)
                                }
                            }

                            Column {
                                width: parent.width
                                spacing: Theme.spacingS
                                visible: SettingsData.hyprlandDecorationShadowEnabled

                                StyledText {
                                    text: "Shadow Offset"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceText
                                    font.weight: Font.Medium
                                }

                                EHTextField {
                                    width: parent.width
                                    height: 32
                                    text: SettingsData.hyprlandDecorationShadowOffset
                                    placeholderText: "e.g. 0 2"
                                    onEditingFinished: {
                                        SettingsData.setHyprlandDecorationShadowOffset(text)
                                    }
                                }
                            }

                            StyledText {
                                text: "Render Power: " + SettingsData.hyprlandDecorationShadowRenderPower
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                visible: SettingsData.hyprlandDecorationShadowEnabled
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandDecorationShadowRenderPower
                                minimum: 1
                                maximum: 10
                                unit: ""
                                showValue: true
                                wheelEnabled: false
                                visible: SettingsData.hyprlandDecorationShadowEnabled
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationShadowRenderPower(finalValue)
                                }
                            }

                            Column {
                                width: parent.width
                                spacing: Theme.spacingS
                                visible: SettingsData.hyprlandDecorationShadowEnabled

                                StyledText {
                                    text: "Shadow Color"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceText
                                    font.weight: Font.Medium
                                }

                                EHTextField {
                                    width: parent.width
                                    height: 32
                                    text: SettingsData.hyprlandDecorationShadowColor
                                    placeholderText: "e.g. rgba(0000002A)"
                                    onEditingFinished: {
                                        SettingsData.setHyprlandDecorationShadowColor(text)
                                    }
                                }
                            }
                        }
                    }

                    // Dimming Settings Section
                    Column {
                        width: parent.width
                        spacing: Theme.spacingM

                        Row {
                            width: parent.width
                            spacing: Theme.spacingM

                            EHIcon {
                                name: "brightness_low"
                                size: Theme.iconSize
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: "Window Dimming"
                                font.pixelSize: Theme.fontSizeLarge
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: Theme.spacingS

                            RowLayout {
                                width: parent.width
                                spacing: Theme.spacingM

                                Column {
                                    spacing: Theme.spacingXS
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    StyledText {
                                        text: "Dim Inactive Windows"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                    }

                                    StyledText {
                                        text: "Reduce brightness of unfocused windows"
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }

                                EHToggle {
                                    checked: SettingsData.hyprlandDecorationDimInactive
                                    onToggled: checked => {
                                        SettingsData.setHyprlandDecorationDimInactive(checked)
                                    }
                                }
                            }

                            StyledText {
                                text: "Dim Strength: " + (SettingsData.hyprlandDecorationDimStrength * 100).toFixed(1) + "%"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                visible: SettingsData.hyprlandDecorationDimInactive
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: SettingsData.hyprlandDecorationDimStrength * 100
                                minimum: 0
                                maximum: 100
                                unit: "%"
                                showValue: true
                                wheelEnabled: false
                                visible: SettingsData.hyprlandDecorationDimInactive
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationDimStrength(finalValue / 100)
                                }
                            }

                            StyledText {
                                text: "Dim Special: " + Math.round(SettingsData.hyprlandDecorationDimSpecial * 100) + "%"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            EHSlider {
                                width: parent.width
                                height: 24
                                value: Math.round(SettingsData.hyprlandDecorationDimSpecial * 100)
                                minimum: 0
                                maximum: 100
                                unit: "%"
                                showValue: true
                                wheelEnabled: false
                                onSliderDragFinished: finalValue => {
                                    SettingsData.setHyprlandDecorationDimSpecial(finalValue / 100)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
