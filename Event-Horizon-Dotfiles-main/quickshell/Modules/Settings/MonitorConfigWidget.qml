import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Common
import qs.Widgets

StyledRect {
    id: monitorWidget

    property var monitorData: null
    property var monitorCapabilities: ({})
    property var initialCapabilities: ({})  // Store original capabilities for robust detection
    signal settingChanged(string setting, var value)

    onMonitorCapabilitiesChanged: {
        // Store initial capabilities for robust detection
        if (Object.keys(initialCapabilities).length === 0 && monitorCapabilities &&
            Object.keys(monitorCapabilities).length > 0) {
            initialCapabilities = JSON.parse(JSON.stringify(monitorCapabilities))
        }
    }







    readonly property bool supportsHDR: {
        // Check if Hyprland already detected HDR
        if (monitorCapabilities && monitorCapabilities.hdr === true) {
            return true
        }

        // Check if HDR is configured in monitor settings
        if (monitorData) {
            var cm = (monitorData.cm || "").toLowerCase()
            if (cm === "hdr" || cm === "hdredid") {
                return true
            }
            if (monitorData.supports_hdr === true || monitorData.supports_hdr === "1" || monitorData.supports_hdr === 1) {
                return true
            }
        }

        // Dynamic HDR detection based on monitor capabilities only
        if (monitorCapabilities) {
            // Check for HDR-related mode names or capabilities
            if (monitorCapabilities.availableModes) {
                for (var k = 0; k < monitorCapabilities.availableModes.length; k++) {
                    var mode = monitorCapabilities.availableModes[k].toLowerCase()
                    if (mode.includes("hdr") || mode.includes("bt2020") || mode.includes("dci") ||
                        mode.includes("p3") || mode.includes("rec2020") || mode.includes("adobe") ||
                        mode.includes("wide") || mode.includes("10bit") || mode.includes("10-bit")) {
                        return true
                    }
                }
            }

            // Check for high dynamic range luminance capabilities
            // HDR monitors typically have high peak brightness (>300 nits)
            if (monitorCapabilities.max_luminance > 300 || monitorCapabilities.sdrMaxLuminance > 400) {
                return true
            }

            // Check for HDR-specific color management presets from Hyprland
            var colorPreset = (monitorCapabilities.colorManagementPreset || "").toLowerCase()
            if (colorPreset.includes("hdr") || colorPreset.includes("bt2020") ||
                colorPreset.includes("dci") || colorPreset.includes("p3")) {
                return true
            }

            // Check description/model for known HDR indicators
            var desc = (monitorCapabilities.description || "").toLowerCase()
            var model = (monitorCapabilities.model || "").toLowerCase()
            if (desc.includes("hdr") || model.includes("hdr") ||
                desc.includes("oled") || model.includes("oled") ||
                desc.includes("qled") || model.includes("qled")) {
                return true
            }

            // Conservative HDR detection for known premium monitor patterns
            // Only for specific monitor types that reliably support HDR
            var desc = (monitorCapabilities.description || "").toLowerCase()
            var model = (monitorCapabilities.model || "").toLowerCase()

            // Known HDR-capable monitor models (verified through research)
            var verifiedHDRModels = [
                "h27s17", "mag 272q", "optix", "xg", "pg", "cg",
                "s3222qs", "u3223qe", "u2723qe", "27gl850", "32ul950",
                "49wl95c", "27uk650", "32uk950", "c32hg70", "c27hg70",
                "c32g7x", "c27g7x", "c32g9x", "c27g9x", "aorus", "fi27q", "fi32u"
            ]

            for (var m = 0; m < verifiedHDRModels.length; m++) {
                if (desc.includes(verifiedHDRModels[m]) || model.includes(verifiedHDRModels[m])) {
                    return true
                }
            }
        }

        return false
    }
    readonly property bool supportsVRR: monitorCapabilities && monitorCapabilities.vrr !== undefined && monitorCapabilities.vrr !== null
    readonly property bool supports10Bit: {
        // Simplified, reliable 10-bit detection using definitive indicators only

        // Use current capabilities, but fall back to initial capabilities if current is incomplete
        var caps = monitorCapabilities
        if (!caps || Object.keys(caps).length === 0) {
            caps = initialCapabilities
        }
        if (!caps || Object.keys(caps).length === 0) return false

        // 1. Most reliable: Monitor is currently using 10-bit format
        var format = (caps.currentFormat || "").toLowerCase()
        if (format.includes("2101010") || format.includes("101010") || format.includes("30")) {
            return true
        }

        // 2. Explicit 10-bit indicators in available modes
        if (caps.availableModes) {
            for (var i = 0; i < caps.availableModes.length; i++) {
                var mode = caps.availableModes[i].toLowerCase()
                if (mode.includes("10bit") || mode.includes("10-bit") || mode.includes("deep")) {
                    return true
                }
            }
        }

        // 3. Monitor explicitly reports 10-bit capability in description
        var desc = (caps.description || "").toLowerCase()
        var model = (caps.model || "").toLowerCase()
        if (desc.includes("10-bit") || desc.includes("10bit") || desc.includes("deep color") ||
            model.includes("10-bit") || model.includes("10bit")) {
            return true
        }

        // 4. Known 10-bit capable monitors (verified models)
        var desc = (caps.description || "").toLowerCase()
        var model = (caps.model || "").toLowerCase()

        var verified10BitModels = [
            "h27s17", "mag 272q", "mag272q", "optix", "xg", "pg", "cg",
            "s3222qs", "s3221qs", "u3223qe", "u2723qe", "s2722dgm",
            "27gl850", "32ul950", "49wl95c", "27uk650", "32uk950",
            "c32hg70", "c27hg70", "c32g7x", "c27g7x", "c32g9x", "c27g9x",
            "aorus", "fi27q", "fi32u", "sw270c", "sw321c"
        ]

        for (var m = 0; m < verified10BitModels.length; m++) {
            if (desc.includes(verified10BitModels[m]) || model.includes(verified10BitModels[m])) {
                return true
            }
        }

        // 5. Conservative heuristic: Ultra-high-end monitors on DisplayPort
        var outputName = (caps.name || "").toLowerCase()
        var refresh = caps.refresh || 0
        var width = caps.width || 0

        var isDisplayPort = outputName.startsWith("dp-")
        var hasUltraHighRefresh = refresh > 240  // Extremely high refresh
        var hasExtremeRes = width >= 5120       // 5K+ resolution

        // Only enable for truly exceptional displays
        return isDisplayPort && (hasUltraHighRefresh || hasExtremeRes)
    }
    readonly property bool supportsWideColor: {
        // Use current capabilities, but fall back to initial capabilities if current is incomplete
        var caps = monitorCapabilities
        if (!caps || Object.keys(caps).length === 0) {
            caps = initialCapabilities
        }
        if (!caps || Object.keys(caps).length === 0) return false

        // Check if monitor has wide color gamut modes
        if (caps.availableModes) {
            for (var i = 0; i < caps.availableModes.length; i++) {
                var mode = caps.availableModes[i].toLowerCase()
                if (mode.includes("bt2020") || mode.includes("dci") || mode.includes("p3") ||
                    mode.includes("rec2020") || mode.includes("adobe") || mode.includes("wide") ||
                    mode.includes("color") || mode.includes("gamut")) {
                    return true
                }
            }
        }

        // Check for wide color indicators in description or model
        var desc = (caps.description || "").toLowerCase()
        var model = (caps.model || "").toLowerCase()
        if (desc.includes("wide") || desc.includes("gamut") || desc.includes("color") ||
            model.includes("wide") || model.includes("gamut") || model.includes("color")) {
            return true
        }

        // Monitors with 10-bit color depth often support wide color
        if (caps.currentFormat === "XBGR2101010") {
            return true
        }

        // High-end displays (high refresh + high resolution) often have wide color
        if (caps.refresh > 120 && caps.width >= 2560) {
            return true
        }

        // Check for HDR indicators (HDR monitors typically have wide color support)
        var hasHDRIndicators = false
        if (caps.availableModes) {
            for (var j = 0; j < caps.availableModes.length; j++) {
                if (caps.availableModes[j].toLowerCase().includes("hdr")) {
                    hasHDRIndicators = true
                    break
                }
            }
        }
        var colorPreset = (caps.colorManagementPreset || "").toLowerCase()
        hasHDRIndicators = hasHDRIndicators || colorPreset.includes("hdr") ||
                          desc.includes("hdr") || model.includes("hdr") ||
                          (caps.max_luminance || 0) > 300

        if (hasHDRIndicators) {
            return true
        }

        return false
    }

    height: contentColumn.implicitHeight + Theme.spacingM * 2
    radius: Theme.cornerRadius
    color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.20)
    border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.12)
    border.width: 1

    Column {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: Theme.spacingM
        spacing: Theme.spacingXS

        RowLayout {
            width: parent.width
            spacing: Theme.spacingM

            EHIcon {
                name: "monitor"
                size: Theme.iconSize - 2
                color: Theme.primary
                Layout.alignment: Qt.AlignVCenter
            }

            Column {
                Layout.fillWidth: true
                spacing: Theme.spacingXS
                Layout.alignment: Qt.AlignVCenter

                StyledText {
                    text: monitorData ? monitorData.name : "Unknown Monitor"
                    font.pixelSize: Theme.fontSizeLarge
                    font.weight: Font.Medium
                    color: Theme.surfaceText
                }

                StyledText {
                    text: {
                        if (!monitorData) return ""
                        var text = monitorData.resolution || "No resolution set"
                        if (monitorData.refreshRate) {
                            text += " @ " + monitorData.refreshRate + " Hz"
                        }
                        if (monitorData.disabled) {
                            text += " (Disabled)"
                        }
                        return text
                    }
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceVariantText
                }
            }
        }

        GridLayout {
            width: parent.width
            columns: 2
            columnSpacing: Theme.spacingM
            rowSpacing: Theme.spacingXS

            StyledText {
                text: "Disabled"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.fillWidth: true
            }

            EHToggle {
                Layout.fillWidth: true
                text: "Disabled"
                description: "Disable this monitor"
                checked: monitorData ? monitorData.disabled : false
                onToggled: (checked) => {
                    if (monitorData) {
                        monitorData.disabled = checked
                        settingChanged("disabled", checked ? "true" : "false")
                    }
                }
            }

            StyledText {
                text: "Resolution"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.fillWidth: true
            }

            EHDropdown {
                id: resolutionDropdown
                Layout.fillWidth: true
                text: "Resolution"
                options: {
                    if (!monitorCapabilities || !monitorCapabilities.resolutions || monitorCapabilities.resolutions.length === 0) {

                        if (monitorData && monitorData.resolution) {
                            return [monitorData.resolution]
                        }
                        return ["No resolutions available"]
                    }
                    return monitorCapabilities.resolutions
                }
                currentValue: monitorData ? (monitorData.resolution || "") : ""
                onValueChanged: (value) => {
                    if (monitorData && value && value !== "No resolutions available") {
                        monitorData.resolution = value
                        settingChanged("resolution", value)

                        if (refreshRateButtonGroup) {
                            refreshRateButtonGroup.selectedResolution = value
                            refreshRateButtonGroup.forceUpdate = !refreshRateButtonGroup.forceUpdate
                        }
                    }
                }
            }

            StyledText {
                text: "Refresh Rate"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            EHButtonGroup {
                id: refreshRateButtonGroup
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                buttonHeight: 42
                minButtonWidth: 65
                buttonPadding: Theme.spacingS
                textSize: Theme.fontSizeSmall
                checkIconSize: Theme.iconSizeSmall + 2

                property string selectedResolution: monitorData ? (monitorData.resolution || "") : ""
                property bool forceUpdate: false

                function updateOptionsForResolution(resolution) {
                    selectedResolution = resolution
                    forceUpdate = !forceUpdate
                }

                model: {
                    var _ = forceUpdate

                    if (!monitorCapabilities) {
                        if (monitorData && monitorData.refreshRate) {
                            return [monitorData.refreshRate.toString() + " Hz"]
                        }
                        return ["N/A"]
                    }

                    var currentRes = selectedResolution || (monitorData ? monitorData.resolution : "")

                    if (monitorCapabilities.resolutionRefreshMap && currentRes && monitorCapabilities.resolutionRefreshMap[currentRes]) {
                        var rates = monitorCapabilities.resolutionRefreshMap[currentRes]
                        return rates.map(function(rate) {
                            return rate.toString() + " Hz"
                        })
                    }

                    if (monitorCapabilities.refreshRates && monitorCapabilities.refreshRates.length > 0) {
                        return monitorCapabilities.refreshRates.map(function(rate) {
                            return rate.toString() + " Hz"
                        })
                    }

                    if (monitorData && monitorData.refreshRate) {
                        return [monitorData.refreshRate.toString() + " Hz"]
                    }
                    return ["N/A"]
                }

                currentIndex: {
                    if (!monitorData || !monitorData.refreshRate) return -1
                    var rate = parseFloat(monitorData.refreshRate)
                    var currentRes = selectedResolution || (monitorData ? monitorData.resolution : "")

                    if (monitorCapabilities && monitorCapabilities.resolutionRefreshMap && currentRes && monitorCapabilities.resolutionRefreshMap[currentRes]) {
                        var rates = monitorCapabilities.resolutionRefreshMap[currentRes]
                        var exactMatch = rates.findIndex(function(r) {
                            return Math.abs(r - rate) < 0.01
                        })
                        if (exactMatch >= 0) return exactMatch

                        var closestIndex = 0
                        var closest = rates[0]
                        var minDiff = Math.abs(closest - rate)
                        for (var i = 1; i < rates.length; i++) {
                            var diff = Math.abs(rates[i] - rate)
                            if (diff < minDiff) {
                                minDiff = diff
                                closest = rates[i]
                                closestIndex = i
                            }
                        }
                        return closestIndex
                    }

                    if (monitorCapabilities && monitorCapabilities.refreshRates && monitorCapabilities.refreshRates.length > 0) {
                        var exactMatch = monitorCapabilities.refreshRates.findIndex(function(r) {
                            return Math.abs(r - rate) < 0.01
                        })
                        if (exactMatch >= 0) return exactMatch

                        var closestIndex = 0
                        var closest = monitorCapabilities.refreshRates[0]
                        var minDiff = Math.abs(closest - rate)
                        for (var i = 1; i < monitorCapabilities.refreshRates.length; i++) {
                            var diff = Math.abs(monitorCapabilities.refreshRates[i] - rate)
                            if (diff < minDiff) {
                                minDiff = diff
                                closest = monitorCapabilities.refreshRates[i]
                                closestIndex = i
                            }
                        }
                        return closestIndex
                    }
                    return -1
                }

                onSelectionChanged: (index, selected) => {
                    if (!monitorData || !selected || index < 0) return
                    var rateText = model[index]
                    if (rateText && rateText !== "N/A") {
                        var rate = parseFloat(rateText.replace(" Hz", ""))
                        monitorData.refreshRate = rate.toString()
                        settingChanged("refreshRate", rate.toString())
                    }
                }
            }

            StyledText {
                text: "Scale"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.fillWidth: true
            }

            Row {
                Layout.fillWidth: true
                spacing: Theme.spacingS

                EHSlider {
                    id: scaleSlider
                    width: parent.width - scaleValueText.width - parent.spacing
                    minimum: 10
                    maximum: 20
                    value: {
                        if (!monitorData) return 10
                        var scale = parseFloat(monitorData.scale) || 1.0
                        scale = Math.max(1.0, Math.min(2.0, scale))
                        return Math.round(scale * 10)
                    }
                    onSliderDragFinished: (finalValue) => {
                        if (monitorData) {
                            var scale = (finalValue / 10.0).toFixed(1)
                            monitorData.scale = scale
                            settingChanged("scale", scale)
                        }
                    }
                }

                StyledText {
                    id: scaleValueText
                    text: {
                        if (!monitorData) return "1.0x"
                        var scale = parseFloat(monitorData.scale) || 1.0
                        scale = Math.max(1.0, Math.min(2.0, scale))
                        return scale.toFixed(1) + "x"
                    }
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            StyledText {
                text: "Transform"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.fillWidth: true
            }

            EHDropdown {
                Layout.fillWidth: true
                text: "Transform"
                options: ["Normal (0°)", "90°", "180°", "270°", "Flipped", "Flipped + 90°", "Flipped + 180°", "Flipped + 270°"]
                currentValue: {
                    if (!monitorData) return "Normal (0°)"
                    var transform = parseInt(monitorData.transform) || 0
                    var options = ["Normal (0°)", "90°", "180°", "270°", "Flipped", "Flipped + 90°", "Flipped + 180°", "Flipped + 270°"]
                    return options[transform] || "Normal (0°)"
                }
                onValueChanged: (value) => {
                    if (monitorData) {
                        var options = ["Normal (0°)", "90°", "180°", "270°", "Flipped", "Flipped + 90°", "Flipped + 180°", "Flipped + 270°"]
                        var index = options.indexOf(value)
                        if (index >= 0) {
                            monitorData.transform = index.toString()
                            settingChanged("transform", index.toString())
                        }
                    }
                }
            }

            StyledText {
                text: "Bit Depth"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            EHButtonGroup {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                buttonHeight: 42
                minButtonWidth: 80
                buttonPadding: Theme.spacingS
                textSize: Theme.fontSizeSmall
                checkIconSize: Theme.iconSizeSmall + 2
                model: supports10Bit ? ["8-bit", "10-bit"] : ["8-bit"]
                currentIndex: {
                    if (!monitorData || !monitorData.bitdepth || monitorData.bitdepth === "") return 0
                    return (monitorData.bitdepth === "10" && supports10Bit) ? 1 : 0
                }
                onSelectionChanged: (index, selected) => {
                    if (!monitorData || !selected) return
                    var bitdepth = (index === 1 && supports10Bit) ? "10" : ""
                    monitorData.bitdepth = bitdepth
                    settingChanged("bitdepth", bitdepth)
                }
            }
        }

        StyledText {
            text: "Color Settings"
            font.pixelSize: Theme.fontSizeMedium
            font.weight: Font.Medium
            color: Theme.primary
            visible: !monitorData || !monitorData.disabled
            width: parent.width
        }

        Column {
            width: parent.width
            spacing: Theme.spacingXS
            visible: !monitorData || !monitorData.disabled

            StyledText {
                text: "Color Management"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            EHDropdown {
                width: parent.width
                text: "Color Management"
                options: {
                    var baseOptions = ["Auto", "sRGB"]

                    // Only add wide color options if monitor supports them
                    if (supportsWideColor) {
                        baseOptions.push("DCI P3", "Display P3", "Adobe RGB", "Wide (BT2020)")
                    }

                    baseOptions.push("EDID")

                    // Only add HDR options if monitor supports HDR
                    if (supportsHDR) {
                        baseOptions.push("HDR", "HDR EDID")
                    }

                    return baseOptions
                }
                currentValue: {
                    if (!monitorData) return "Auto"
                    var cm = monitorData.cm || ""
                    var map = {
                        "auto": "Auto",
                        "srgb": "sRGB",
                        "dcip3": "DCI P3",
                        "dp3": "Display P3",
                        "adobe": "Adobe RGB",
                        "wide": "Wide (BT2020)",
                        "edid": "EDID",
                        "hdr": "HDR",
                        "hdredid": "HDR EDID"
                    }
                    var value = map[cm.toLowerCase()] || "Auto"

                    // Reset to Auto if current setting is not supported
                    if (!supportsHDR && (value === "HDR" || value === "HDR EDID")) {
                        return "Auto"
                    }
                    if (!supportsWideColor && (value === "DCI P3" || value === "Display P3" || value === "Adobe RGB" || value === "Wide (BT2020)")) {
                        return "Auto"
                    }

                    return value
                }
                onValueChanged: (value) => {
                    if (monitorData) {
                        var map = {
                            "Auto": "auto",
                            "sRGB": "srgb",
                            "DCI P3": "dcip3",
                            "Display P3": "dp3",
                            "Adobe RGB": "adobe",
                            "Wide (BT2020)": "wide",
                            "EDID": "edid",
                            "HDR": "hdr",
                            "HDR EDID": "hdredid"
                        }
                        monitorData.cm = map[value] || "auto"
                        settingChanged("cm", monitorData.cm)
                    }
                }
            }
        }

        StyledText {
            text: "HDR Settings"
            font.pixelSize: Theme.fontSizeMedium
            font.weight: Font.Medium
            color: Theme.primary
            visible: (!monitorData || !monitorData.disabled) && supportsHDR
            width: parent.width
        }

        GridLayout {
            width: parent.width
            columns: 2
            columnSpacing: Theme.spacingM
            rowSpacing: Theme.spacingXS
            visible: (!monitorData || !monitorData.disabled) && supportsHDR

            StyledText {
                text: "SDR Brightness"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.fillWidth: true
            }

            Row {
                Layout.fillWidth: true
                spacing: Theme.spacingS

                EHSlider {
                    id: sdrBrightnessSlider
                    width: parent.width - sdrBrightnessValueText.width - parent.spacing
                    minimum: 10
                    maximum: 200
                    value: {
                        if (!monitorData) return 100
                        var brightness = parseFloat(monitorData.sdrbrightness) || 1.0
                        return Math.round(brightness * 100)
                    }
                    onSliderDragFinished: (finalValue) => {
                        if (monitorData) {
                            var brightness = (finalValue / 100.0).toFixed(2)
                            monitorData.sdrbrightness = brightness
                            settingChanged("sdrbrightness", brightness)
                        }
                    }
                }

                StyledText {
                    id: sdrBrightnessValueText
                    text: {
                        if (!monitorData) return "1.00"
                        var brightness = parseFloat(monitorData.sdrbrightness) || 1.0
                        return brightness.toFixed(2)
                    }
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            StyledText {
                text: "SDR Saturation"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.fillWidth: true
            }

            Row {
                Layout.fillWidth: true
                spacing: Theme.spacingS

                EHSlider {
                    id: sdrSaturationSlider
                    width: parent.width - sdrSaturationValueText.width - parent.spacing
                    minimum: 0
                    maximum: 200
                    value: {
                        if (!monitorData) return 100
                        var saturation = parseFloat(monitorData.sdrsaturation) || 1.0
                        return Math.round(saturation * 100)
                    }
                    onSliderDragFinished: (finalValue) => {
                        if (monitorData) {
                            var saturation = (finalValue / 100.0).toFixed(2)
                            monitorData.sdrsaturation = saturation
                            settingChanged("sdrsaturation", saturation)
                        }
                    }
                }

                StyledText {
                    id: sdrSaturationValueText
                    text: {
                        if (!monitorData) return "1.00"
                        var saturation = parseFloat(monitorData.sdrsaturation) || 1.0
                        return saturation.toFixed(2)
                    }
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            StyledText {
                text: "SDR EOTF"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            EHButtonGroup {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                buttonHeight: 42
                minButtonWidth: 75
                buttonPadding: Theme.spacingS
                textSize: Theme.fontSizeSmall
                checkIconSize: Theme.iconSizeSmall + 2
                model: ["Follow", "sRGB", "Gamma 2.2"]
                currentIndex: {
                    if (!monitorData) return 0
                    var eotf = parseInt(monitorData.sdr_eotf) || 0
                    return Math.max(0, Math.min(2, eotf))
                }
                onSelectionChanged: (index, selected) => {
                    if (!monitorData || !selected) return
                    monitorData.sdr_eotf = index.toString()
                    settingChanged("sdr_eotf", index.toString())
                }
            }

            StyledText {
                text: "Wide Color Gamut"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            EHButtonGroup {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                buttonHeight: 42
                minButtonWidth: 80
                buttonPadding: Theme.spacingS
                textSize: Theme.fontSizeSmall
                checkIconSize: Theme.iconSizeSmall + 2
                model: ["Auto", "Force On", "Force Off"]
                currentIndex: {
                    if (!monitorData) return 0
                    var value = monitorData.supports_wide_color
                    if (value === 0 || value === "0") return 0
                    if (value === 1 || value === "1" || value === true) return 1
                    if (value === -1 || value === "-1") return 2
                    return 0
                }
                onSelectionChanged: (index, selected) => {
                    if (!monitorData || !selected) return
                    var value = "0"
                    if (index === 1) value = "1"
                    else if (index === 2) value = "-1"

                    monitorData.supports_wide_color = parseInt(value)
                    settingChanged("supports_wide_color", value)
                }
            }

            StyledText {
                text: "HDR Support"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            EHButtonGroup {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                buttonHeight: 42
                minButtonWidth: 80
                buttonPadding: Theme.spacingS
                textSize: Theme.fontSizeSmall
                checkIconSize: Theme.iconSizeSmall + 2
                model: ["Auto", "Force On", "Force Off"]
                currentIndex: {
                    if (!monitorData) return 0
                    var value = monitorData.supports_hdr
                    if (value === 0 || value === "0") return 0
                    if (value === 1 || value === "1" || value === true) return 1
                    if (value === -1 || value === "-1") return 2
                    return 0
                }
                onSelectionChanged: (index, selected) => {
                    if (!monitorData || !selected) return
                    var value = "0"
                    if (index === 1) value = "1"
                    else if (index === 2) value = "-1"

                    monitorData.supports_hdr = parseInt(value)
                    settingChanged("supports_hdr", value)
                }
            }
        }


        Column {
            width: parent.width
            spacing: Theme.spacingS
            visible: (!monitorData || !monitorData.disabled) && supportsHDR

            StyledText {
                text: "SDR Min Luminance"
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            Row {
                width: parent.width
                spacing: Theme.spacingM

                EHSlider {
                    id: sdrMinLuminanceSlider
                    width: parent.width - sdrMinLuminanceValueText.width - parent.spacing
                    minimum: 0
                    maximum: 10
                    value: {
                        if (!monitorData) return 0
                        return Math.round((monitorData.sdr_min_luminance || 0.0) * 1000)
                    }
                    onSliderDragFinished: (finalValue) => {
                        if (monitorData) {
                            var value = (finalValue / 1000.0).toFixed(3)
                            monitorData.sdr_min_luminance = parseFloat(value)
                            settingChanged("sdr_min_luminance", value)
                        }
                    }
                }

                StyledText {
                    id: sdrMinLuminanceValueText
                    text: {
                        if (!monitorData) return "0.000"
                        return (monitorData.sdr_min_luminance || 0.0).toFixed(3)
                    }
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            StyledText {
                text: "Set to 0.005 for true black matching HDR black"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Theme.outline
            opacity: 0.12
            visible: !monitorData || !monitorData.disabled
        }


        Column {
            width: parent.width
            spacing: Theme.spacingS
            visible: (!monitorData || !monitorData.disabled) && supportsHDR

            StyledText {
                text: "SDR Max Luminance"
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            Row {
                width: parent.width
                spacing: Theme.spacingM

                EHSlider {
                    id: sdrMaxLuminanceSlider
                    width: parent.width - sdrMaxLuminanceValueText.width - parent.spacing
                    minimum: 80
                    maximum: 400
                    value: monitorData ? (monitorData.sdr_max_luminance || 200) : 200
                    onSliderDragFinished: (finalValue) => {
                        if (monitorData) {
                            monitorData.sdr_max_luminance = finalValue
                            settingChanged("sdr_max_luminance", finalValue.toString())
                        }
                    }
                }

                StyledText {
                    id: sdrMaxLuminanceValueText
                    text: (monitorData ? (monitorData.sdr_max_luminance || 200) : 200) + " nits"
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            StyledText {
                text: "Typical range: 200-250 nits (default: 200)"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }
        }


        Column {
            width: parent.width
            spacing: Theme.spacingS
            visible: (!monitorData || !monitorData.disabled) && supportsHDR

            StyledText {
                text: "Monitor Min Luminance"
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            Row {
                width: parent.width
                spacing: Theme.spacingM

                EHSlider {
                    id: minLuminanceSlider
                    width: parent.width - minLuminanceValueText.width - parent.spacing
                    minimum: 0
                    maximum: 10
                    value: {
                        if (!monitorData) return 0
                        return Math.round((monitorData.min_luminance || 0.0) * 1000)
                    }
                    onSliderDragFinished: (finalValue) => {
                        if (monitorData) {
                            var value = (finalValue / 1000.0).toFixed(3)
                            monitorData.min_luminance = parseFloat(value)
                            settingChanged("min_luminance", value)
                        }
                    }
                }

                StyledText {
                    id: minLuminanceValueText
                    text: {
                        if (!monitorData) return "0.000"
                        return (monitorData.min_luminance || 0.0).toFixed(3)
                    }
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }


        Column {
            width: parent.width
            spacing: Theme.spacingS
            visible: (!monitorData || !monitorData.disabled) && supportsHDR

            StyledText {
                text: "Monitor Max Luminance"
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            Row {
                width: parent.width
                spacing: Theme.spacingM

                EHSlider {
                    id: maxLuminanceSlider
                    width: parent.width - maxLuminanceValueText.width - parent.spacing
                    minimum: 0
                    maximum: 2000
                    value: monitorData ? (monitorData.max_luminance || 0) : 0
                    onSliderDragFinished: (finalValue) => {
                        if (monitorData) {
                            monitorData.max_luminance = finalValue
                            settingChanged("max_luminance", finalValue.toString())
                        }
                    }
                }

                StyledText {
                    id: maxLuminanceValueText
                    text: (monitorData ? (monitorData.max_luminance || 0) : 0) + " nits"
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Theme.outline
            opacity: 0.12
            visible: !monitorData || !monitorData.disabled
        }


        Column {
            width: parent.width
            spacing: Theme.spacingS
            visible: (!monitorData || !monitorData.disabled) && supportsHDR

            StyledText {
                text: "Monitor Max Avg Luminance"
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            Row {
                width: parent.width
                spacing: Theme.spacingM

                EHSlider {
                    id: maxAvgLuminanceSlider
                    width: parent.width - maxAvgLuminanceValueText.width - parent.spacing
                    minimum: 0
                    maximum: 2000
                    value: monitorData ? (monitorData.max_avg_luminance || 0) : 0
                    onSliderDragFinished: (finalValue) => {
                        if (monitorData) {
                            monitorData.max_avg_luminance = finalValue
                            settingChanged("max_avg_luminance", finalValue.toString())
                        }
                    }
                }

                StyledText {
                    id: maxAvgLuminanceValueText
                    text: (monitorData ? (monitorData.max_avg_luminance || 0) : 0) + " nits"
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            StyledText {
                text: "Maximum luminance on average for a typical frame"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }
        }
    }
}
