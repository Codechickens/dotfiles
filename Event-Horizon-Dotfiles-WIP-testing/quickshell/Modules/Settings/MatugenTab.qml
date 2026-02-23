import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Common
import qs.Modals
import qs.Widgets

Item {
    id: matugenTab

    property var parentModal: null

    EHFlickable {
        anchors.fill: parent
        clip: true
        contentHeight: mainColumn.height
        contentWidth: width

        Column {
            id: mainColumn
            width: parent.width
            spacing: Theme.spacingXL

            // Header Section
            StyledRect {
                width: parent.width
                height: headerSection.childrenRect.height + Theme.spacingL * 2
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g,
                               Theme.surfaceContainer.b, 0.6)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.12)
                border.width: 1

                Column {
                    id: headerSection
                    width: parent.width - Theme.spacingXL * 2
                    x: Theme.spacingXL
                    y: Theme.spacingXL
                    spacing: Theme.spacingM

                    Row {
                        spacing: Theme.spacingM
                        width: parent.width

                        EHIcon {
                            name: "palette"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Matugen Color Generation"
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    StyledText {
                        text: "Fine-tune how matugen extracts and generates colors from your wallpaper. These settings control the color extraction algorithm and can help preserve vibrant colors."
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }

                    // Status indicator
                    Row {
                        spacing: Theme.spacingS
                        visible: !Theme.matugenAvailable

                        EHIcon {
                            name: "warning"
                            size: Theme.fontSizeSmall
                            color: Theme.error
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "matugen not found - install matugen package for dynamic theming"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.error
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }

            // Palette Algorithm Section
            StyledRect {
                width: parent.width
                height: paletteSection.childrenRect.height + Theme.spacingL * 2
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g,
                               Theme.surfaceContainer.b, 0.6)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.12)
                border.width: 1
                enabled: Theme.matugenAvailable
                opacity: enabled ? 1 : 0.4

                Column {
                    id: paletteSection
                    width: parent.width - Theme.spacingXL * 2
                    x: Theme.spacingXL
                    y: Theme.spacingXL
                    spacing: Theme.spacingL

                    StyledText {
                        text: "Palette Algorithm"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    EHDropdown {
                        width: parent.width
                        text: "Scheme Type"
                        description: "Select the palette algorithm used for wallpaper-based colors"
                        currentValue: Theme.getMatugenScheme(SettingsData.matugenScheme).label
                        options: Theme.availableMatugenSchemes.map(scheme => scheme.label)
                        enabled: Theme.matugenAvailable
                        onValueChanged: value => {
                            for (var i = 0; i < Theme.availableMatugenSchemes.length; i++) {
                                var scheme = Theme.availableMatugenSchemes[i]
                                if (scheme.label === value) {
                                    SettingsData.setMatugenScheme(scheme.value)
                                    break
                                }
                            }
                        }
                    }

                    StyledText {
                        text: {
                            var scheme = Theme.getMatugenScheme(SettingsData.matugenScheme)
                            return scheme.description
                        }
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }

                    // Scheme recommendations
                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Recommendations for vibrant colors:"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        StyledText {
                            text: "• Vibrant - Best for keeping colors bright and saturated"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                        }

                        StyledText {
                            text: "• Fidelity - Best for preserving exact source hues"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                        }

                        StyledText {
                            text: "• Content - Best for matching the underlying image closely"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                        }
                    }
                }
            }

            // Contrast Section
            StyledRect {
                width: parent.width
                height: contrastSection.childrenRect.height + Theme.spacingL * 2
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g,
                               Theme.surfaceContainer.b, 0.6)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.12)
                border.width: 1
                enabled: Theme.matugenAvailable
                opacity: enabled ? 1 : 0.4

                Column {
                    id: contrastSection
                    width: parent.width - Theme.spacingXL * 2
                    x: Theme.spacingXL
                    y: Theme.spacingXL
                    spacing: Theme.spacingL

                    StyledText {
                        text: "Contrast"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    StyledText {
                        text: "Adjust the contrast of generated colors. Higher values increase the difference between light and dark colors."
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        Row {
                            width: parent.width
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Contrast Level"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Item { width: 1; height: 1; Layout.fillWidth: true }

                            StyledText {
                                text: {
                                    var val = SettingsData.matugenContrast
                                    if (val < -0.3) return "Low"
                                    if (val < 0.3) return "Standard"
                                    return "High"
                                }
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.matugenContrast * 100
                            minimum: -100
                            maximum: 100
                            unit: ""
                            showValue: true
                            wheelEnabled: false
                            onSliderValueChanged: newValue => {
                                SettingsData.setMatugenContrast(newValue / 100)
                            }
                        }

                        Row {
                            width: parent.width
                            spacing: Theme.spacingS

                            StyledText {
                                text: "-1 (Min)"
                                font.pixelSize: Theme.fontSizeXSmall
                                color: Theme.surfaceVariantText
                            }

                            Item { width: 1; height: 1; Layout.fillWidth: true }

                            StyledText {
                                text: "0 (Standard)"
                                font.pixelSize: Theme.fontSizeXSmall
                                color: Theme.surfaceVariantText
                            }

                            Item { width: 1; height: 1; Layout.fillWidth: true }

                            StyledText {
                                text: "+1 (Max)"
                                font.pixelSize: Theme.fontSizeXSmall
                                color: Theme.surfaceVariantText
                            }
                        }
                    }

                    // Reset button
                    Rectangle {
                        width: resetContrastText.width + Theme.spacingL * 2
                        height: 36
                        radius: Theme.cornerRadius
                        color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12)
                        border.color: Theme.primary
                        border.width: 1

                        Row {
                            anchors.centerIn: parent
                            spacing: Theme.spacingS

                            StyledText {
                                id: resetContrastText
                                text: "Reset to Default"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.primary
                                font.weight: Font.Medium
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: SettingsData.setMatugenContrast(0)
                        }
                    }
                }
            }

            // Resize Filter Section
            StyledRect {
                width: parent.width
                height: filterSection.childrenRect.height + Theme.spacingL * 2
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g,
                               Theme.surfaceContainer.b, 0.6)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.12)
                border.width: 1
                enabled: Theme.matugenAvailable
                opacity: enabled ? 1 : 0.4

                Column {
                    id: filterSection
                    width: parent.width - Theme.spacingXL * 2
                    x: Theme.spacingXL
                    y: Theme.spacingXL
                    spacing: Theme.spacingL

                    StyledText {
                        text: "Resize Filter"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    StyledText {
                        text: "The filter used when resizing the image for color extraction. Different filters can produce different source colors."
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }

                    EHDropdown {
                        width: parent.width
                        text: "Filter Type"
                        description: "Select the resize filter for color extraction"
                        currentValue: {
                            var filter = SettingsData.matugenResizeFilter
                            var filters = ["nearest", "triangle", "catmull-rom", "gaussian", "lanczos3"]
                            var labels = ["Nearest", "Triangle", "Catmull-Rom", "Gaussian", "Lanczos3"]
                            for (var i = 0; i < filters.length; i++) {
                                if (filters[i] === filter)
                                    return labels[i]
                            }
                            return "Lanczos3"
                        }
                        options: ["Nearest", "Triangle", "Catmull-Rom", "Gaussian", "Lanczos3"]
                        enabled: Theme.matugenAvailable
                        onValueChanged: value => {
                            var filters = ["nearest", "triangle", "catmull-rom", "gaussian", "lanczos3"]
                            var labels = ["Nearest", "Triangle", "Catmull-Rom", "Gaussian", "Lanczos3"]
                            for (var i = 0; i < labels.length; i++) {
                                if (labels[i] === value) {
                                    SettingsData.setMatugenResizeFilter(filters[i])
                                    break
                                }
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        StyledText {
                            text: "Filter descriptions:"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                        }

                        StyledText {
                            text: "• Nearest - Fast, pixelated, can preserve sharp color edges"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                        }

                        StyledText {
                            text: "• Triangle - Simple bilinear filtering, smooth results"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                        }

                        StyledText {
                            text: "• Catmull-Rom - Sharp interpolation, good for detailed images"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                        }

                        StyledText {
                            text: "• Gaussian - Smooth, blurrier, averages colors more"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                        }

                        StyledText {
                            text: "• Lanczos3 - High quality, default, good balance (recommended)"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                        }
                    }
                }
            }

            // Fallback Color Section
            StyledRect {
                width: parent.width
                height: fallbackSection.childrenRect.height + Theme.spacingL * 2
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g,
                               Theme.surfaceContainer.b, 0.6)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.12)
                border.width: 1
                enabled: Theme.matugenAvailable
                opacity: enabled ? 1 : 0.4

                Column {
                    id: fallbackSection
                    width: parent.width - Theme.spacingXL * 2
                    x: Theme.spacingXL
                    y: Theme.spacingXL
                    spacing: Theme.spacingL

                    StyledText {
                        text: "Fallback Color"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    StyledText {
                        text: "The color to use if matugen cannot find a good source color from the image. This ensures consistent results even with difficult images."
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHToggle {
                            checked: SettingsData.matugenFallbackColor !== ""
                            onToggled: toggled => {
                                if (toggled) {
                                    SettingsData.setMatugenFallbackColor("#ff0000")
                                } else {
                                    SettingsData.setMatugenFallbackColor("")
                                }
                            }
                        }

                        StyledText {
                            text: "Use Fallback Color"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        width: parent.width
                        spacing: Theme.spacingM
                        visible: SettingsData.matugenFallbackColor !== ""

                        Rectangle {
                            width: 40
                            height: 40
                            radius: Theme.cornerRadiusSmall
                            color: SettingsData.matugenFallbackColor
                            border.color: Theme.outline
                            border.width: 1

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: colorPicker.show()
                            }
                        }

                        StyledText {
                            text: SettingsData.matugenFallbackColor || "No color set"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        // Pick Color button
                        Rectangle {
                            width: pickColorText.width + Theme.spacingL * 2
                            height: 36
                            radius: Theme.cornerRadius
                            color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12)
                            border.color: Theme.primary
                            border.width: 1

                            StyledText {
                                id: pickColorText
                                text: "Pick Color"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.primary
                                font.weight: Font.Medium
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: colorPicker.show()
                            }
                        }

                        // Clear button
                        Rectangle {
                            width: clearText.width + Theme.spacingL * 2
                            height: 36
                            radius: Theme.cornerRadius
                            color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.5)
                            border.color: Theme.outline
                            border.width: 1

                            StyledText {
                                id: clearText
                                text: "Clear"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: SettingsData.setMatugenFallbackColor("")
                            }
                        }
                    }

                    ColorPickerModal {
                        id: colorPicker
                        onColorSelected: color => {
                            SettingsData.setMatugenFallbackColor(color)
                        }
                    }
                }
            }

            // Saturation Boost Section
            StyledRect {
                width: parent.width
                height: saturationSection.childrenRect.height + Theme.spacingL * 2
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g,
                               Theme.surfaceContainer.b, 0.6)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.12)
                border.width: 1
                enabled: Theme.matugenAvailable
                opacity: enabled ? 1 : 0.4

                Column {
                    id: saturationSection
                    width: parent.width - Theme.spacingXL * 2
                    x: Theme.spacingXL
                    y: Theme.spacingXL
                    spacing: Theme.spacingL

                    StyledText {
                        text: "Saturation Boost"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    StyledText {
                        text: "Boost the saturation of generated colors. This can help make muted colors more vibrant. Applied after color extraction."
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        Row {
                            width: parent.width
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Saturation Multiplier"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Item { width: 1; height: 1; Layout.fillWidth: true }

                            StyledText {
                                text: (SettingsData.matugenSaturationBoost * 100).toFixed(0) + "%"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.matugenSaturationBoost * 100
                            minimum: 50
                            maximum: 200
                            unit: "%"
                            showValue: false
                            wheelEnabled: false
                            onSliderValueChanged: newValue => {
                                SettingsData.setMatugenSaturationBoost(newValue / 100)
                                Theme.reapplyColorAdjustments()
                            }
                        }

                        Row {
                            width: parent.width
                            spacing: Theme.spacingS

                            StyledText {
                                text: "50% (Muted)"
                                font.pixelSize: Theme.fontSizeXSmall
                                color: Theme.surfaceVariantText
                            }

                            Item { width: 1; height: 1; Layout.fillWidth: true }

                            StyledText {
                                text: "100% (Normal)"
                                font.pixelSize: Theme.fontSizeXSmall
                                color: Theme.surfaceVariantText
                            }

                            Item { width: 1; height: 1; Layout.fillWidth: true }

                            StyledText {
                                text: "200% (Vibrant)"
                                font.pixelSize: Theme.fontSizeXSmall
                                color: Theme.surfaceVariantText
                            }
                        }
                    }

                    Row {
                        spacing: Theme.spacingS

                        // Reset button
                        Rectangle {
                            width: resetSatText.width + Theme.spacingL * 2
                            height: 36
                            radius: Theme.cornerRadius
                            color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.5)
                            border.color: Theme.outline
                            border.width: 1

                            StyledText {
                                id: resetSatText
                                text: "Reset to Default"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    SettingsData.setMatugenSaturationBoost(1.0)
                                    Theme.reapplyColorAdjustments()
                                }
                            }
                        }

                        // Boost button
                        Rectangle {
                            width: boostText.width + Theme.spacingL * 2
                            height: 36
                            radius: Theme.cornerRadius
                            color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12)
                            border.color: Theme.primary
                            border.width: 1

                            StyledText {
                                id: boostText
                                text: "Boost to 150%"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.primary
                                font.weight: Font.Medium
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    SettingsData.setMatugenSaturationBoost(1.5)
                                    Theme.reapplyColorAdjustments()
                                }
                            }
                        }
                    }
                }
            }

            // Lightness Adjustment Section
            StyledRect {
                width: parent.width
                height: lightnessSection.childrenRect.height + Theme.spacingL * 2
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g,
                               Theme.surfaceContainer.b, 0.6)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.12)
                border.width: 1
                enabled: Theme.matugenAvailable
                opacity: enabled ? 1 : 0.4

                Column {
                    id: lightnessSection
                    width: parent.width - Theme.spacingXL * 2
                    x: Theme.spacingXL
                    y: Theme.spacingXL
                    spacing: Theme.spacingL

                    StyledText {
                        text: "Lightness Adjustment"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    StyledText {
                        text: "Adjust the lightness of generated colors. Positive values make colors lighter, negative values make them darker."
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }

                    Column {
                        width: parent.width
                        spacing: Theme.spacingS

                        Row {
                            width: parent.width
                            spacing: Theme.spacingS

                            StyledText {
                                text: "Lightness Offset"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Item { width: 1; height: 1; Layout.fillWidth: true }

                            StyledText {
                                text: SettingsData.matugenLightnessOffset > 0 ? "+" + SettingsData.matugenLightnessOffset.toFixed(2) : SettingsData.matugenLightnessOffset.toFixed(2)
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        EHSlider {
                            width: parent.width
                            height: 24
                            value: SettingsData.matugenLightnessOffset * 100
                            minimum: -50
                            maximum: 50
                            unit: ""
                            showValue: false
                            wheelEnabled: false
                            onSliderValueChanged: newValue => {
                                SettingsData.setMatugenLightnessOffset(newValue / 100)
                                Theme.reapplyColorAdjustments()
                            }
                        }

                        Row {
                            width: parent.width
                            spacing: Theme.spacingS

                            StyledText {
                                text: "-0.5 (Darker)"
                                font.pixelSize: Theme.fontSizeXSmall
                                color: Theme.surfaceVariantText
                            }

                            Item { width: 1; height: 1; Layout.fillWidth: true }

                            StyledText {
                                text: "0 (Normal)"
                                font.pixelSize: Theme.fontSizeXSmall
                                color: Theme.surfaceVariantText
                            }

                            Item { width: 1; height: 1; Layout.fillWidth: true }

                            StyledText {
                                text: "+0.5 (Lighter)"
                                font.pixelSize: Theme.fontSizeXSmall
                                color: Theme.surfaceVariantText
                            }
                        }
                    }

                    // Reset button
                    Rectangle {
                        width: resetLightnessText.width + Theme.spacingL * 2
                        height: 36
                        radius: Theme.cornerRadius
                        color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.5)
                        border.color: Theme.outline
                        border.width: 1

                        StyledText {
                            id: resetLightnessText
                            text: "Reset to Default"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            font.weight: Font.Medium
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                SettingsData.setMatugenLightnessOffset(0)
                                Theme.reapplyColorAdjustments()
                            }
                        }
                    }
                }
            }

            // Actions Section
            StyledRect {
                width: parent.width
                height: actionsSection.childrenRect.height + Theme.spacingL * 2
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g,
                               Theme.surfaceContainer.b, 0.6)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.12)
                border.width: 1
                enabled: Theme.matugenAvailable
                opacity: enabled ? 1 : 0.4

                Column {
                    id: actionsSection
                    width: parent.width - Theme.spacingXL * 2
                    x: Theme.spacingXL
                    y: Theme.spacingXL
                    spacing: Theme.spacingL

                    StyledText {
                        text: "Actions"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    Row {
                        spacing: Theme.spacingM

                        // Regenerate button
                        Rectangle {
                            width: regenerateText.width + Theme.spacingL * 2
                            height: 40
                            radius: Theme.cornerRadius
                            color: Theme.primary

                            Row {
                                anchors.centerIn: parent
                                spacing: Theme.spacingS

                                EHIcon {
                                    name: "refresh"
                                    size: 16
                                    color: Theme.onPrimary
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                StyledText {
                                    id: regenerateText
                                    text: "Regenerate Colors"
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.onPrimary
                                    font.weight: Font.Medium
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (typeof Theme !== 'undefined') {
                                        Theme.extractColors()
                                    }
                                }
                            }
                        }

                        // GTK button
                        Rectangle {
                            width: gtkText.width + Theme.spacingL * 2
                            height: 40
                            radius: Theme.cornerRadius
                            color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12)
                            border.color: Theme.primary
                            border.width: 1

                            Row {
                                anchors.centerIn: parent
                                spacing: Theme.spacingS

                                EHIcon {
                                    name: "folder"
                                    size: 16
                                    color: Theme.primary
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                StyledText {
                                    id: gtkText
                                    text: "Apply GTK Theme"
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.primary
                                    font.weight: Font.Medium
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (typeof Theme !== 'undefined') {
                                        Theme.applyGtkColors()
                                    }
                                }
                            }
                        }

                        // Qt button
                        Rectangle {
                            width: qtText.width + Theme.spacingL * 2
                            height: 40
                            radius: Theme.cornerRadius
                            color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12)
                            border.color: Theme.primary
                            border.width: 1

                            Row {
                                anchors.centerIn: parent
                                spacing: Theme.spacingS

                                EHIcon {
                                    name: "settings"
                                    size: 16
                                    color: Theme.primary
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                StyledText {
                                    id: qtText
                                    text: "Apply Qt Theme"
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.primary
                                    font.weight: Font.Medium
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (typeof Theme !== 'undefined') {
                                        Theme.applyQtColors()
                                    }
                                }
                            }
                        }
                    }

                    StyledText {
                        text: "Click 'Regenerate Colors' to apply your changes and extract new colors from the current wallpaper."
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }
                }
            }

            // Preview Section
            StyledRect {
                width: parent.width
                height: previewSection.childrenRect.height + Theme.spacingL * 2
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g,
                               Theme.surfaceContainer.b, 0.6)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.12)
                border.width: 1
                visible: Theme.matugenAvailable && Theme.matugenColors && Object.keys(Theme.matugenColors).length > 0

                Column {
                    id: previewSection
                    width: parent.width - Theme.spacingXL * 2
                    x: Theme.spacingXL
                    y: Theme.spacingXL
                    spacing: Theme.spacingL

                    StyledText {
                        text: "Current Color Preview"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    Flow {
                        width: parent.width
                        spacing: Theme.spacingS

                        Repeater {
                            model: ["primary", "secondary", "tertiary", "error", "surface", "surfaceContainer"]

                            Column {
                                spacing: Theme.spacingXS

                                Rectangle {
                                    width: 60
                                    height: 40
                                    radius: Theme.cornerRadiusSmall
                                    color: {
                                        if (!Theme.matugenColors || !Theme.matugenColors.colors)
                                            return Theme.surfaceVariant
                                        var colorName = modelData
                                        var colorMode = (typeof SessionData !== "undefined" && SessionData.isLightMode) ? "light" : "dark"
                                        if (Theme.matugenColors.colors[colorName] && Theme.matugenColors.colors[colorName][colorMode]) {
                                            return Theme.matugenColors.colors[colorName][colorMode]
                                        }
                                        return Theme.surfaceVariant
                                    }
                                    border.color: Theme.outline
                                    border.width: 1
                                }

                                StyledText {
                                    text: modelData
                                    font.pixelSize: Theme.fontSizeXSmall
                                    color: Theme.surfaceVariantText
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }
            }

            // Spacer at bottom
            Item {
                width: parent.width
                height: Theme.spacingL
            }
        }
    }
}
