import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.ControlCenter.Widgets
import qs.Modules.ControlCenter.Components
import "../utils/layout.js" as LayoutUtils

Column {
    id: root

    property bool editMode: false
    property string expandedSection: ""
    property int expandedWidgetIndex: -1
    property var model: null

    signal expandClicked(var widgetData, int globalIndex, real x, real y, real width, real height)
    signal removeWidget(int index)
    signal moveWidget(int fromIndex, int toIndex)
    signal toggleWidgetSize(int index)

                spacing: Theme.spacingS

    property int expandedRowIndex: -1

    function calculateRowsAndWidgets() {
        return LayoutUtils.calculateRowsAndWidgets(root, expandedSection, expandedWidgetIndex)
    }

    // Compact dock-style widget rows
    Repeater {
        model: {
            const result = root.calculateRowsAndWidgets()
            root.expandedRowIndex = result.expandedRowIndex
            return result.rows
        }

        Column {
            width: root.width
            spacing: Theme.spacingS
            property int rowIndex: index
            property var rowWidgets: modelData
            property bool isSliderOnlyRow: {
                const widgets = rowWidgets || []
                if (widgets.length === 0) return false
                return widgets.every(w => w.id === "volumeSlider" || w.id === "brightnessSlider" || w.id === "inputVolumeSlider")
            }

            // Compact dock-style Row layout
            Row {
                width: parent.width
                spacing: Theme.spacingM

                Repeater {
                    model: rowWidgets || []

                    Item {
                        property var widgetData: modelData
                        property int globalWidgetIndex: {
                            const widgets = SettingsData.controlCenterWidgets || []
                            for (var i = 0; i < widgets.length; i++) {
                                if (widgets[i].id === modelData.id) {
                                    return i
                                }
                            }
                            return -1
                        }
                        property int widgetWidth: {
                            // Volume mixer and media always take full width (both left and right spots)
                            const id = modelData.id || ""
                            if (id === "volumeMixer" || id === "media") return 100
                            return modelData.width || 50
                        }
                        width: {
                            const baseWidth = root.width
                            const spacing = Theme.spacingM
                            let calculatedWidth
                            if (widgetWidth <= 25) {
                                calculatedWidth = (baseWidth - spacing * 3) / 4
                            } else if (widgetWidth <= 50) {
                                calculatedWidth = (baseWidth - spacing) / 2
                            } else if (widgetWidth <= 75) {
                                calculatedWidth = (baseWidth - spacing * 2) * 0.75
                            } else {
                                calculatedWidth = baseWidth
                            }
                            return calculatedWidth
                        }
                        height: {
                            const id = modelData.id || ""
                            if (id === "brightnessSlider") {
                                return 85
                            }
                            if (isSliderOnlyRow) return 16
                            if (id === "audioOutput" || id === "audioInput") return 85
                            if (id === "volumeMixer") return 140
                            if (id === "media") return 70
                            return 50
                        }

                        Loader {
                            id: widgetLoader
                            anchors.fill: parent
                            property var widgetData: parent.widgetData
                            property int widgetIndex: parent.globalWidgetIndex
                            property int globalWidgetIndex: parent.globalWidgetIndex
                            property int widgetWidth: parent.widgetWidth

                            sourceComponent: {
                                const id = modelData.id || ""
                                if (id === "wifi" || id === "bluetooth" || id === "audioOutput" || id === "audioInput" || id === "volumeMixer" || id === "hdrToggle") {
                                    return compoundPillComponent
                                } else if (id === "media") {
                                    return mediaPillComponent
                                } else if (id === "volumeSlider") {
                                    return audioSliderComponent
                                } else if (id === "brightnessSlider") {
                                    return brightnessSliderComponent
                                } else if (id === "inputVolumeSlider") {
                                    return inputAudioSliderComponent
                                } else if (id === "battery") {
                                    return widgetWidth <= 25 ? smallBatteryComponent : batteryPillComponent
                                } else if (id === "performance") {
                                    return performancePillComponent
                                } else {
                                    return widgetWidth <= 25 ? smallToggleComponent : toggleButtonComponent
                                }
                            }
                        }
                    }
                }
            }

            // Detail view for expanded widgets
            DetailHost {
                width: parent.width
                height: active ? (root.expandedSection === "volumeMixer" ? 450 : 250 + Theme.spacingS) : 0
                property bool active: root.expandedSection !== "" && rowIndex === root.expandedRowIndex
                visible: active
                expandedSection: root.expandedSection
            }
        }
    }

    Component {
        id: compoundPillComponent
        Rectangle {
            property var widgetData: parent.widgetData || {}
            property int widgetIndex: parent.widgetIndex || 0
            property var widgetDef: root.model?.getWidgetForId(widgetData.id || "")
            property bool isAudioWidget: (widgetData.id || "") === "audioOutput" || (widgetData.id || "") === "audioInput"
            property bool isVolumeMixerWidget: (widgetData.id || "") === "volumeMixer"
            width: parent.width
            height: isAudioWidget ? 85 : (isVolumeMixerWidget ? 140 : 50)
            radius: Theme.cornerRadius
            
            // Dock-style compact background
            color: {
                const alpha = Theme.getContentBackgroundAlpha() * 0.3
                return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, alpha)
            }
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
            border.width: 1

            property bool isActive: {
                switch (widgetData.id || "") {
                case "wifi": {
                    if (NetworkService.wifiToggling) return false
                    if (NetworkService.networkStatus === "ethernet") return true
                    if (NetworkService.networkStatus === "wifi") return true
                    return NetworkService.wifiEnabled
                }
                case "bluetooth": return !!(BluetoothService.available && BluetoothService.adapter && BluetoothService.adapter.enabled)
                case "audioOutput": return !!(AudioService.sink && !AudioService.sink.audio.muted)
                case "audioInput": return !!(AudioService.source && !AudioService.source.audio.muted)
                case "volumeMixer": {
                    const outputCount = (ApplicationAudioService.applicationStreams || []).length
                    const inputCount = (ApplicationAudioService.applicationInputStreams || []).length
                    return outputCount > 0 || inputCount > 0
                }
                case "hdrToggle": return HdrService.hdrEnabled
                default: return false
                }
            }

            Column {
                id: column
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: Theme.spacingXS
                anchors.leftMargin: (widgetData.id === "wifi" || widgetData.id === "bluetooth") ? Math.max(2, Theme.cornerRadius / 2) : Theme.spacingS
                anchors.rightMargin: (widgetData.id === "wifi" || widgetData.id === "bluetooth") ? Math.max(2, Theme.cornerRadius / 2) : Theme.spacingS
                spacing: Theme.spacingXS

                Row {
                    id: iconTextRow
                    spacing: (widgetData.id === "wifi" || widgetData.id === "bluetooth") ? 2 : 8
                    width: parent.width

                    Item {
                        width: Theme.iconSize
                        height: Theme.iconSize
                        anchors.verticalCenter: parent.verticalCenter
                        property bool isBluetooth: (widgetData.id || "") === "bluetooth"

                        EHIcon {
                            name: {
                                switch (widgetData.id || "") {
                                case "wifi": {
                                    if (NetworkService.wifiToggling) return "sync"
                                    if (NetworkService.networkStatus === "ethernet") return "settings_ethernet"
                                    if (NetworkService.networkStatus === "wifi") return NetworkService.wifiSignalIcon
                                    return "wifi_off"
                                }
                                case "bluetooth": {
                                    if (!BluetoothService.available) return "bluetooth_disabled"
                                    if (!BluetoothService.adapter || !BluetoothService.adapter.enabled) return "bluetooth_disabled"
                                    const primaryDevice = (() => {
                                        if (!BluetoothService.adapter || !BluetoothService.adapter.devices) return null
                                        let devices = [...BluetoothService.adapter.devices.values.filter(dev => dev && (dev.paired || dev.trusted))]
                                        for (let device of devices) {
                                            if (device && device.connected) return device
                                        }
                                        return null
                                    })()
                                    if (primaryDevice) return BluetoothService.getDeviceIcon(primaryDevice)
                                    return "bluetooth"
                                }
                                case "audioOutput": {
                                    if (!AudioService.sink) return "volume_off"
                                    let volume = AudioService.sink.audio.volume
                                    let muted = AudioService.sink.audio.muted
                                    if (muted || volume === 0.0) return "volume_off"
                                    if (volume <= 0.33) return "volume_down"
                                    if (volume <= 0.66) return "volume_up"
                                    return "volume_up"
                                }
                                case "audioInput": {
                                    if (!AudioService.source) return "mic_off"
                                    return AudioService.source.audio.muted ? "mic_off" : "mic"
                                }
                                case "volumeMixer": {
                                    const outputCount = (ApplicationAudioService.applicationStreams || []).length
                                    const inputCount = (ApplicationAudioService.applicationInputStreams || []).length
                                    if (outputCount === 0 && inputCount === 0) return "volume_up"
                                    if (outputCount > 0 && inputCount > 0) return "volume_up"
                                    if (outputCount > 0) return "volume_up"
                                    return "mic"
                                }
                                case "hdrToggle": return HdrService.hdrEnabled ? "hdr_on" : "hdr_off"
                                default: return widgetDef?.icon || "help"
                                }
                            }
                            size: Theme.iconSize
                            color: parent.parent.parent.isActive ? Theme.primary : Theme.surfaceText
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            id: bluetoothIconMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            visible: parent.isBluetooth
                            z: 20
                            onClicked: {
                                if (root.editMode) return
                                if (BluetoothService.available && BluetoothService.adapter) {
                                    BluetoothService.adapter.enabled = !BluetoothService.adapter.enabled
                                }
                            }
                        }
                    }

                    StyledText {
                        text: {
                            switch (widgetData.id || "") {
                            case "wifi": {
                                if (NetworkService.wifiToggling) return NetworkService.wifiEnabled ? "Disabling..." : "Enabling..."
                                if (NetworkService.networkStatus === "ethernet") return "Ethernet"
                                if (NetworkService.networkStatus === "wifi" && NetworkService.currentWifiSSID) {
                                    return NetworkService.currentWifiSSID.length > 12 ? NetworkService.currentWifiSSID.substring(0, 12) + "..." : NetworkService.currentWifiSSID
                                }
                                return NetworkService.wifiEnabled ? "Not connected" : "WiFi off"
                            }
                            case "bluetooth": {
                                if (!BluetoothService.available) return "Bluetooth"
                                if (!BluetoothService.adapter || !BluetoothService.adapter.enabled) return "Disabled"
                                return "Enabled"
                            }
                            case "audioOutput": {
                                return AudioService.sink?.description || "No output"
                            }
                            case "audioInput": {
                                return AudioService.source?.description || "No input"
                            }
                            case "volumeMixer": {
                                return "Volume Mixer"
                            }
                            case "hdrToggle": return HdrService.hdrEnabled ? "HDR On" : "HDR Off"
                            default: return widgetDef?.text || "Unknown"
                            }
                        }
                        font.pixelSize: 15
                        color: Theme.surfaceText
                        Component.onCompleted: {
                            if (isVolumeMixerWidget && Qt.fontFamilies().indexOf("Roboto") >= 0) {
                                font.family = "Roboto"
                            }
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        width: isAudioWidget ? parent.width - 26 - 24 - Theme.spacingS * 2 : (isVolumeMixerWidget ? parent.width - 26 - 24 - Theme.spacingS * 2 : (widgetData.id === "wifi" || widgetData.id === "bluetooth") ? parent.width - 26 - Math.max(2, Theme.cornerRadius / 2) * 2 : parent.width - 26)
                        elide: Text.ElideRight
                    }
                }

                // Audio sliders for audioOutput and audioInput
                Item {
                    visible: isAudioWidget
                    width: parent.width
                    height: 14

                    EHSlider {
                        anchors.fill: parent
                        enabled: {
                            if ((widgetData.id || "") === "audioOutput") {
                                return AudioService.sink && AudioService.sink.audio
                            } else if ((widgetData.id || "") === "audioInput") {
                                return AudioService.source && AudioService.source.audio
                            }
                            return false
                        }
                        minimum: 0
                        maximum: 100
                        value: {
                            if ((widgetData.id || "") === "audioOutput") {
                                return AudioService.sink && AudioService.sink.audio ? Math.min(100, Math.round(AudioService.sink.audio.volume * 100)) : 0
                            } else if ((widgetData.id || "") === "audioInput") {
                                return AudioService.source && AudioService.source.audio ? Math.min(100, Math.round(AudioService.source.audio.volume * 100)) : 0
                            }
                            return 0
                        }
                        showValue: false
                        thumbOutlineColor: Theme.surfaceContainer
                        trackColor: {
                            const alpha = Theme.getContentBackgroundAlpha() * 0.60
                            return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, alpha)
                        }
                        onSliderValueChanged: function(newValue) {
                            if ((widgetData.id || "") === "audioOutput") {
                                if (AudioService.sink && AudioService.sink.audio) {
                                    SessionData.suppressOSDTemporarily()
                                    AudioService.sink.audio.volume = newValue / 100.0
                                    if (newValue > 0 && AudioService.sink.audio.muted) {
                                        AudioService.sink.audio.muted = false
                                    }
                                }
                            } else if ((widgetData.id || "") === "audioInput") {
                                if (AudioService.source && AudioService.source.audio) {
                                    SessionData.suppressOSDTemporarily()
                                    AudioService.source.audio.volume = newValue / 100.0
                                    if (newValue > 0 && AudioService.source.audio.muted) {
                                        AudioService.source.audio.muted = false
                                    }
                                }
                            }
                        }
                    }
                }

                // Volume mixer applications list - show first 2 apps
                Column {
                    visible: isVolumeMixerWidget
                    width: parent.width
                    spacing: Theme.spacingXS
                    anchors.topMargin: Theme.spacingXS

                    Repeater {
                        model: {
                            const apps = (ApplicationAudioService.applicationStreams || []).slice(0, 2)
                            return apps
                        }

                        delegate: Row {
                            required property var modelData
                            
                            // Track individual node to ensure properties are bound
                            PwObjectTracker {
                                objects: modelData ? [modelData] : []
                            }
                            
                            property var nodeAudio: (modelData && modelData.audio) ? modelData.audio : null
                            property real appVolume: (nodeAudio && nodeAudio.volume !== undefined) ? nodeAudio.volume : 0.0
                            
                            width: parent.width
                            spacing: Theme.spacingXS
                            height: 30

                            Image {
                                width: 16
                                height: 16
                                source: ApplicationAudioService.getApplicationIcon(modelData)
                                sourceSize.width: 16 * 25
                                sourceSize.height: 16 * 25
                                smooth: true
                                mipmap: true
                                fillMode: Image.PreserveAspectFit
                                cache: true
                                asynchronous: true
                                anchors.verticalCenter: parent.verticalCenter

                                EHIcon {
                                    anchors.fill: parent
                                    name: "volume_up"
                                    size: 16
                                    color: nodeAudio && !nodeAudio.muted && appVolume > 0 ? Theme.primary : Theme.surfaceText
                                    visible: parent.status === Image.Error || parent.status === Image.Null || parent.source === ""
                                }
                            }

                            Item {
                                width: 120
                                height: parent.height
                                
                                StyledText {
                                    id: appNameText
                                    text: ApplicationAudioService.getApplicationName(modelData)
                                    font.pixelSize: 12
                                    font.family: Qt.fontFamilies().indexOf("Roboto") >= 0 ? "Roboto" : (typeof SettingsData !== "undefined" && SettingsData.fontFamily ? SettingsData.fontFamily : "sans-serif")
                                    color: Theme.surfaceText
                                    elide: Text.ElideRight
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                }
                            }

                            EHSlider {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 16 - Theme.spacingXS - 120 - Theme.spacingXS
                                height: 14
                                enabled: nodeAudio && modelData && modelData.ready !== false
                                minimum: 0
                                maximum: 100
                                value: Math.round(appVolume * 100)
                                showValue: false
                                thumbOutlineColor: Theme.surfaceContainer
                                trackColor: {
                                    const alpha = Theme.getContentBackgroundAlpha() * 0.60
                                    return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, alpha)
                                }
                                onSliderValueChanged: function(newValue) {
                                    if (nodeAudio && modelData && modelData.ready !== false) {
                                        try {
                                            nodeAudio.volume = newValue / 100.0
                                        } catch (e) {
                                            console.log("Failed to set volume:", e)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    StyledText {
                        text: {
                            const outputCount = (ApplicationAudioService.applicationStreams || []).length
                            const inputCount = (ApplicationAudioService.applicationInputStreams || []).length
                            const total = outputCount + inputCount
                            if (total === 0) return "No apps"
                            if (total > 2) return `+${total - 2} more`
                            return ""
                        }
                        font.pixelSize: 11
                        font.family: Qt.fontFamilies().indexOf("Roboto") >= 0 ? "Roboto" : (typeof SettingsData !== "undefined" && SettingsData.fontFamily ? SettingsData.fontFamily : "sans-serif")
                        color: Theme.surfaceVariantText
                        visible: {
                            const outputCount = (ApplicationAudioService.applicationStreams || []).length
                            const inputCount = (ApplicationAudioService.applicationInputStreams || []).length
                            return (outputCount + inputCount) > 2
                        }
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                    }
                }
            }

            // Device selection button for audio widgets and volume mixer - positioned on the right side
            Item {
                id: deviceSelectButton
                visible: isAudioWidget || isVolumeMixerWidget
                width: 24
                height: 24
                anchors.right: parent.right
                anchors.rightMargin: Theme.spacingS
                anchors.top: parent.top
                anchors.topMargin: Theme.spacingXS + 3
                z: 10

                EHIcon {
                    anchors.centerIn: parent
                    name: "settings"
                    size: 16
                    color: deviceSelectArea.containsMouse ? Theme.primary : Theme.surfaceText
                }

                MouseArea {
                    id: deviceSelectArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    z: 11
                    onClicked: {
                        if (root.editMode) return
                        // Get the Rectangle (widget) - it's the parent of column
                        const widgetRect = column.parent
                        if (widgetRect) {
                            const globalPos = widgetRect.mapToItem(null, 0, 0)
                            root.expandClicked(widgetData, widgetIndex, globalPos.x, globalPos.y, widgetRect.width, widgetRect.height)
                        } else {
                            root.expandClicked(widgetData, widgetIndex, 0, 0, 0, 0)
                        }
                    }
                }
            }

            // MouseArea for non-audio widgets - for audio widgets and volume mixer, only the settings button expands
            MouseArea {
                id: topSectionMouseArea
                anchors.left: parent.left
                anchors.leftMargin: (widgetData.id || "") === "bluetooth" ? (Math.max(2, Theme.cornerRadius / 2) + Theme.iconSize + 2) : 0
                anchors.right: parent.right
                anchors.rightMargin: (isAudioWidget || isVolumeMixerWidget) ? (24 + Theme.spacingS * 2) : 0
                anchors.top: parent.top
                height: isAudioWidget ? (Theme.spacingXS + 30 + Theme.spacingXS) : (isVolumeMixerWidget ? (Theme.spacingXS + 30 + Theme.spacingXS) : parent.height)
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.editMode) return
                    // For non-audio and non-volume-mixer widgets, clicking expands
                    if (!isAudioWidget && !isVolumeMixerWidget) {
                        const globalPos = mapToItem(null, 0, 0)
                        root.expandClicked(widgetData, widgetIndex, globalPos.x, globalPos.y, width, height)
                    }
                }
                onPressed: (mouse) => {
                    if (root.editMode) return
                    // Skip bluetooth - it's handled by the icon MouseArea
                    if ((widgetData.id || "") === "bluetooth") return
                    switch (widgetData.id || "") {
                    case "wifi": {
                        if (NetworkService.networkStatus !== "ethernet" && !NetworkService.wifiToggling) {
                            NetworkService.toggleWifiRadio()
                        }
                        break
                    }
                    case "hdrToggle": {
                        HdrService.toggleHdr()
                        break
                    }
                    }
                }
            }

            EditModeOverlay {
                anchors.fill: parent
                editMode: root.editMode
                widgetData: parent.widgetData
                widgetIndex: parent.widgetIndex
                showSizeControls: true
                isSlider: false
                onRemoveWidget: (index) => root.removeWidget(index)
                onToggleWidgetSize: (index) => root.toggleWidgetSize(index)
                onMoveWidget: (fromIndex, toIndex) => root.moveWidget(fromIndex, toIndex)
            }
        }
    }

    Component {
        id: mediaPillComponent

        MediaPill {
            width: parent.width
            height: parent.height
        }
    }

    Component {
        id: audioSliderComponent
        Item {
            property var widgetData: parent.widgetData || {}
            property int widgetIndex: parent.widgetIndex || 0
            width: parent.width
            height: 16

            AudioSliderRow {
                anchors.centerIn: parent
                width: parent.width
                height: 14
                property color sliderTrackColor: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, Theme.getContentBackgroundAlpha() * 0.60)
            }

            EditModeOverlay {
                anchors.fill: parent
                editMode: root.editMode
                widgetData: parent.widgetData
                widgetIndex: parent.widgetIndex
                showSizeControls: true
                isSlider: true
                onRemoveWidget: (index) => root.removeWidget(index)
                onToggleWidgetSize: (index) => root.toggleWidgetSize(index)
                onMoveWidget: (fromIndex, toIndex) => root.moveWidget(fromIndex, toIndex)
            }
        }
    }

    Component {
        id: brightnessSliderComponent
        Item {
            property var widgetData: parent.widgetData || {}
            property int widgetIndex: parent.widgetIndex || 0
            width: parent.width
            height: brightnessSlider.implicitHeight

            BrightnessSliderRow {
                id: brightnessSlider
                width: parent.width
            }

            EditModeOverlay {
                anchors.fill: parent
                editMode: root.editMode
                widgetData: parent.widgetData
                widgetIndex: parent.widgetIndex
                showSizeControls: true
                isSlider: true
                onRemoveWidget: (index) => root.removeWidget(index)
                onToggleWidgetSize: (index) => root.toggleWidgetSize(index)
                onMoveWidget: (fromIndex, toIndex) => root.moveWidget(fromIndex, toIndex)
            }
        }
    }

    Component {
        id: inputAudioSliderComponent
        Item {
            property var widgetData: parent.widgetData || {}
            property int widgetIndex: parent.widgetIndex || 0
            width: parent.width
            height: 16

            InputAudioSliderRow {
                anchors.centerIn: parent
                width: parent.width
                height: 14
                property color sliderTrackColor: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, Theme.getContentBackgroundAlpha() * 0.60)
            }

            EditModeOverlay {
                anchors.fill: parent
                editMode: root.editMode
                widgetData: parent.widgetData
                widgetIndex: parent.widgetIndex
                showSizeControls: true
                isSlider: true
                onRemoveWidget: (index) => root.removeWidget(index)
                onToggleWidgetSize: (index) => root.toggleWidgetSize(index)
                onMoveWidget: (fromIndex, toIndex) => root.moveWidget(fromIndex, toIndex)
            }
        }
    }

    Component {
        id: batteryPillComponent
        Rectangle {
            property var widgetData: parent.widgetData || {}
            property int widgetIndex: parent.widgetIndex || 0
            width: parent.width
            height: 50
            radius: Theme.cornerRadius
            
            color: {
                const alpha = Theme.getContentBackgroundAlpha() * 0.3
                return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, alpha)
            }
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
            border.width: 1

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Theme.spacingS
                spacing: 8

                EHIcon {
                    name: BatteryService.charging ? "battery_charging_full" : (BatteryService.chargePercent < 20 ? "battery_alert" : "battery_full")
                    size: Theme.iconSize
                    color: BatteryService.charging ? Theme.primary : (BatteryService.chargePercent < 20 ? Theme.error : Theme.surfaceText)
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    text: BatteryService.chargePercent ? Math.round(BatteryService.chargePercent) + "%" : "--%"
                    font.pixelSize: 15
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (!root.editMode) {
                        const globalPos = mapToItem(null, 0, 0)
                        root.expandClicked(widgetData, widgetIndex, globalPos.x, globalPos.y, width, height)
                    }
                }
            }

            EditModeOverlay {
                anchors.fill: parent
                editMode: root.editMode
                widgetData: parent.widgetData
                widgetIndex: parent.widgetIndex
                showSizeControls: true
                isSlider: false
                onRemoveWidget: (index) => root.removeWidget(index)
                onToggleWidgetSize: (index) => root.toggleWidgetSize(index)
                onMoveWidget: (fromIndex, toIndex) => root.moveWidget(fromIndex, toIndex)
            }
        }
    }

    Component {
        id: smallBatteryComponent
        Rectangle {
            property var widgetData: parent.widgetData || {}
            property int widgetIndex: parent.widgetIndex || 0
            width: parent.width
            height: 50
            radius: Theme.cornerRadius
            
            color: {
                const alpha = Theme.getContentBackgroundAlpha() * 0.3
                return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, alpha)
            }
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
            border.width: 1

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Theme.spacingS
                spacing: 8

                EHIcon {
                    name: BatteryService.charging ? "battery_charging_full" : (BatteryService.chargePercent < 20 ? "battery_alert" : "battery_full")
                    size: Theme.iconSize
                    color: BatteryService.charging ? Theme.primary : (BatteryService.chargePercent < 20 ? Theme.error : Theme.surfaceText)
                }

                StyledText {
                    text: BatteryService.chargePercent ? Math.round(BatteryService.chargePercent) + "%" : "--%"
                    font.pixelSize: 15
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (!root.editMode) {
                        const globalPos = mapToItem(null, 0, 0)
                        root.expandClicked(widgetData, widgetIndex, globalPos.x, globalPos.y, width, height)
                    }
                }
            }

            EditModeOverlay {
                anchors.fill: parent
                editMode: root.editMode
                widgetData: parent.widgetData
                widgetIndex: parent.widgetIndex
                showSizeControls: true
                isSlider: false
                onRemoveWidget: (index) => root.removeWidget(index)
                onToggleWidgetSize: (index) => root.toggleWidgetSize(index)
                onMoveWidget: (fromIndex, toIndex) => root.moveWidget(fromIndex, toIndex)
            }
        }
    }

    Component {
        id: toggleButtonComponent
        Rectangle {
            property var widgetData: parent.widgetData || {}
            property int widgetIndex: parent.widgetIndex || 0
            property var widgetDef: root.model?.getWidgetForId(widgetData.id || "")
            width: parent.width
            height: 50
            radius: Theme.cornerRadius
            
            color: {
                const alpha = Theme.getContentBackgroundAlpha() * 0.3
                return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, alpha)
            }
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
            border.width: 1

            property bool isActive: {
                switch (widgetData.id || "") {
                case "nightMode": return DisplayService.nightModeEnabled || false
                case "darkMode": return !SessionData.isLightMode
                case "doNotDisturb": return SessionData.doNotDisturb || false
                case "idleInhibitor": return SessionService.idleInhibited || false
                default: return false
                }
            }

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Theme.spacingS
                spacing: 8

                EHIcon {
                    name: {
                        switch (widgetData.id || "") {
                        case "nightMode": return DisplayService.nightModeEnabled ? "nightlight" : "dark_mode"
                        case "darkMode": return "contrast"
                        case "doNotDisturb": return SessionData.doNotDisturb ? "do_not_disturb_on" : "do_not_disturb_off"
                        case "idleInhibitor": return SessionService.idleInhibited ? "motion_sensor_active" : "motion_sensor_idle"
                        default: return widgetDef?.icon || "help"
                        }
                    }
                    size: Theme.iconSize
                    color: parent.parent.isActive ? Theme.primary : Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    text: {
                        switch (widgetData.id || "") {
                        case "nightMode": return "Night Mode"
                        case "darkMode": return SessionData.isLightMode ? "Light" : "Dark"
                        case "doNotDisturb": return "DND"
                        case "idleInhibitor": return SessionService.idleInhibited ? "Awake" : "Sleep"
                        default: return widgetDef?.text || "Unknown"
                        }
                    }
                    font.pixelSize: 15
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                enabled: (widgetDef?.enabled ?? true) && !root.editMode
                onClicked: {
                    switch (widgetData.id || "") {
                    case "nightMode": {
                        if (DisplayService.automationAvailable) {
                            DisplayService.toggleNightMode()
                        }
                        break
                    }
                    case "darkMode": {
                        Theme.toggleLightMode()
                        break
                    }
                    case "doNotDisturb": {
                        SessionData.setDoNotDisturb(!SessionData.doNotDisturb)
                        break
                    }
                    case "idleInhibitor": {
                        SessionService.toggleIdleInhibit()
                        break
                    }
                    }
                }
            }

            EditModeOverlay {
                anchors.fill: parent
                editMode: root.editMode
                widgetData: parent.widgetData
                widgetIndex: parent.widgetIndex
                showSizeControls: true
                isSlider: false
                onRemoveWidget: (index) => root.removeWidget(index)
                onToggleWidgetSize: (index) => root.toggleWidgetSize(index)
                onMoveWidget: (fromIndex, toIndex) => root.moveWidget(fromIndex, toIndex)
            }
        }
    }

    Component {
        id: smallToggleComponent
        Rectangle {
            property var widgetData: parent.widgetData || {}
            property int widgetIndex: parent.widgetIndex || 0
            property var widgetDef: root.model?.getWidgetForId(widgetData.id || "")
            width: parent.width
            height: 50
            radius: Theme.cornerRadius
            
            color: {
                const alpha = Theme.getContentBackgroundAlpha() * 0.3
                return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, alpha)
            }
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
            border.width: 1

            property bool isActive: {
                switch (widgetData.id || "") {
                case "nightMode": return DisplayService.nightModeEnabled || false
                case "darkMode": return !SessionData.isLightMode
                case "doNotDisturb": return SessionData.doNotDisturb || false
                case "idleInhibitor": return SessionService.idleInhibited || false
                default: return false
                }
            }

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Theme.spacingS
                spacing: 8

                EHIcon {
                    name: {
                        switch (widgetData.id || "") {
                        case "nightMode": return DisplayService.nightModeEnabled ? "nightlight" : "dark_mode"
                        case "darkMode": return "contrast"
                        case "doNotDisturb": return SessionData.doNotDisturb ? "do_not_disturb_on" : "do_not_disturb_off"
                        case "idleInhibitor": return SessionService.idleInhibited ? "motion_sensor_active" : "motion_sensor_idle"
                        default: return widgetDef?.icon || "help"
                        }
                    }
                    size: Theme.iconSize
                    color: parent.parent.isActive ? Theme.primary : Theme.surfaceText
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                enabled: (widgetDef?.enabled ?? true) && !root.editMode
                onClicked: {
                    switch (widgetData.id || "") {
                    case "nightMode": {
                        if (DisplayService.automationAvailable) {
                            DisplayService.toggleNightMode()
                        }
                        break
                    }
                    case "darkMode": {
                        Theme.toggleLightMode()
                        break
                    }
                    case "doNotDisturb": {
                        SessionData.setDoNotDisturb(!SessionData.doNotDisturb)
                        break
                    }
                    case "idleInhibitor": {
                        SessionService.toggleIdleInhibit()
                        break
                    }
                    }
                }
            }

            EditModeOverlay {
                anchors.fill: parent
                editMode: root.editMode
                widgetData: parent.widgetData
                widgetIndex: parent.widgetIndex
                showSizeControls: true
                isSlider: false
                onRemoveWidget: (index) => root.removeWidget(index)
                onToggleWidgetSize: (index) => root.toggleWidgetSize(index)
                onMoveWidget: (fromIndex, toIndex) => root.moveWidget(fromIndex, toIndex)
            }
        }
    }

    Component {
        id: performancePillComponent
        Rectangle {
            property var widgetData: parent.widgetData || {}
            property int widgetIndex: parent.widgetIndex || 0
            width: parent.width
            height: 50
            radius: Theme.cornerRadius
            
            color: {
                const alpha = Theme.getContentBackgroundAlpha() * 0.3
                return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, alpha)
            }
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
            border.width: 1

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Theme.spacingS
                spacing: 8

                EHIcon {
                    name: PerformanceService.getCurrentModeInfo().icon
                    size: Theme.iconSize
                    color: PerformanceService.getCurrentModeInfo().color
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    text: PerformanceService.isChanging ? "Changing..." : PerformanceService.getCurrentModeInfo().name
                    font.pixelSize: 15
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                enabled: !root.editMode && !PerformanceService.isChanging
                onClicked: {
                    if (root.editMode || PerformanceService.isChanging) return
                    
                    const modes = ["power-saver", "balanced", "performance"]
                    const currentIndex = modes.indexOf(PerformanceService.currentMode)
                    const nextIndex = (currentIndex + 1) % modes.length
                    PerformanceService.setMode(modes[nextIndex])
                }
            }

            EditModeOverlay {
                anchors.fill: parent
                editMode: root.editMode
                widgetData: parent.widgetData
                widgetIndex: parent.widgetIndex
                showSizeControls: true
                isSlider: false
                onRemoveWidget: (index) => root.removeWidget(index)
                onToggleWidgetSize: (index) => root.toggleWidgetSize(index)
                onMoveWidget: (fromIndex, toIndex) => root.moveWidget(fromIndex, toIndex)
            }
        }
    }
}
