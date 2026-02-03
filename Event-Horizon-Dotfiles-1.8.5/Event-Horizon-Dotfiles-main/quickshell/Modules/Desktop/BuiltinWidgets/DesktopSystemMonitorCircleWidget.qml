import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root

    property string instanceId: ""
    property var instanceData: null
    property var screen: null
    readonly property var cfg: instanceData?.config ?? null
    readonly property bool isInstance: instanceId !== "" && cfg !== null

    property real widgetWidth: 200
    property real widgetHeight: 200
    property real defaultWidth: 500
    property real defaultHeight: 200
    property real minWidth: 400
    property real minHeight: 150

    implicitWidth: widgetWidth
    implicitHeight: widgetHeight

    // Scale factor based on widget size
    readonly property real baseWidth: 500
    readonly property real baseHeight: 200
    readonly property real scaleFactor: Math.min(widgetWidth / baseWidth, widgetHeight / baseHeight)

    readonly property real gpuTemperature: (DgopService.availableGpus && DgopService.availableGpus.length > 0) ? (DgopService.availableGpus[0].temperature || -1) : -1
    readonly property real gpuMemoryUsedMB: (DgopService.availableGpus && DgopService.availableGpus.length > 0) ? (DgopService.availableGpus[0].memoryUsedMB || 0) : 0
    readonly property real gpuMemoryTotalMB: (DgopService.availableGpus && DgopService.availableGpus.length > 0) ? (DgopService.availableGpus[0].memoryTotalMB || 0) : 0
    readonly property real gpuMemoryUsage: gpuMemoryTotalMB > 0 ? (gpuMemoryUsedMB / gpuMemoryTotalMB) * 100 : 0
    
    function getShortCpuName() {
        const fullName = DgopService.cpuModel || "CPU"
        
        // Check if it's an Intel CPU
        const isIntel = /^Intel/i.test(fullName)
        
        let shortName = fullName
            // Remove vendor prefixes
            .replace(/^AMD\s+/i, "")
            .replace(/^Intel\s*\(R\)\s*/i, "")
            .replace(/^Intel\s+/i, "")
            // Remove trademark suffixes
            .replace(/\s*\(R\)/g, "")
            .replace(/\s*\(TM\)/g, "")
            // Remove trailing processor/CPU labels
            .replace(/\s+Processor$/i, "")
            .replace(/\s+CPU$/i, "")
            // Remove frequency info (e.g., "@ 3.60GHz")
            .replace(/\s+@\s+[\d.]+GHz.*$/i, "")
            .replace(/\s+@.*$/i, "")
            // Remove core count suffixes (e.g., "8-Core", "6 Core", "4-Core Processor")
            // But preserve "Core i7" type names for Intel
            .replace(/\s+\d+\s*-\s*Core.*$/i, "")
            .replace(/\s+\d+\s*Core.*$/i, "")
            // Remove graphics suffixes
            .replace(/\s+Radeon\s+Graphics.*$/i, "")
            .replace(/\s+Graphics.*$/i, "")
            .replace(/\s+with.*$/i, "")
            .trim()
        
        // For Intel CPUs, if we removed too much and it's empty or just "Core", 
        // try to extract the model name more carefully
        if (isIntel && (!shortName || shortName === "Core" || shortName.length < 3)) {
            // Try to match Intel Core series (e.g., "Core i7-9700K", "Core i5-12400")
            const coreMatch = fullName.match(/Core\s+(i[3579]|Xeon|Pentium|Celeron)[\s-]?([\w-]+)?/i)
            if (coreMatch) {
                const series = coreMatch[1]
                const model = coreMatch[2] || ""
                shortName = "Core " + series + (model ? "-" + model : "")
            } else {
                // Fallback: try to get anything after "Intel" that looks like a model
                const modelMatch = fullName.replace(/^Intel\s*\(?R\)?\s*/i, "").match(/^([A-Za-z0-9\s-]+?)(?:\s+\(|@|\s+CPU|\s+Processor|$)/)
                if (modelMatch) {
                    shortName = modelMatch[1].trim()
                }
            }
        }
        
        return shortName || fullName
    }
    
    function getShortGpuName() {
        if (!DgopService.availableGpus || DgopService.availableGpus.length === 0) {
            return "GPU"
        }
        const gpu = DgopService.availableGpus[0]
        const fullName = gpu.displayName || "GPU"
        const isRadeon = /radeon/i.test(fullName) || /amd/i.test(fullName) || gpu.vendor === "AMD"
        let shortName = fullName
        if (isRadeon) {
            shortName = fullName
                .replace(/^AMD\s+Radeon\s+/i, "")
                .replace(/^Radeon\s+/i, "")
                .replace(/^AMD\s+/i, "")
                .replace(/\s*\/\s*.*/i, "")
                .replace(/\s*\([^)]*\)/g, "")
                .replace(/\s+/g, " ")
                .trim()
            const rxMatch = shortName.match(/(?:Radeon\s+)?(?:RX\s+)?(\d{2,4}\s*\w+(?:\s*\w+)*)/i)
            if (rxMatch) {
                const modelNumber = rxMatch[1].replace(/\s+/g, "").toUpperCase()
                shortName = "RX " + modelNumber
            }
        } else {
            shortName = fullName
                .replace(/^NVIDIA\s+GeForce\s+/i, "")
                .replace(/^GeForce\s+/i, "")
                .replace(/^Intel\s+Arc\s+/i, "")
                .replace(/^Intel\s+UHD\s+/i, "")
                .replace(/^Intel\s+HD\s+/i, "")
                .replace(/^NVIDIA\s+/i, "")
                .replace(/^Intel\s+/i, "")
                .replace(/\s*\/\s*Max-Q.*$/i, "")
                .trim()
        }
        return shortName || fullName
    }
    
    function formatVRAM() {
        if (gpuMemoryTotalMB <= 0) return "--"
        const totalGB = (gpuMemoryTotalMB / 1024).toFixed(1)
        const usedGB = (gpuMemoryUsedMB / 1024).toFixed(1)
        return usedGB + "/" + totalGB + " GB"
    }
    
    function formatNetworkSpeed(bytesPerSec) {
        if (!bytesPerSec || bytesPerSec < 0) return "0 B"
        if (bytesPerSec < 1024) return Math.round(bytesPerSec) + " B"
        if (bytesPerSec < 1024 * 1024) return (bytesPerSec / 1024).toFixed(1) + " KB"
        return (bytesPerSec / (1024 * 1024)).toFixed(1) + " MB"
    }

    Component.onCompleted: {
        DgopService.addRef(["cpu", "memory", "gpu", "network", "system"])
    }
    Component.onDestruction: {
        DgopService.removeRef(["cpu", "memory", "gpu", "network", "system"])
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.cornerRadius
        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, isInstance ? (cfg?.transparency ?? 0.9) : 0.9)
        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.3)
        border.width: 1 * root.scaleFactor

        Row {
            anchors.fill: parent
            anchors.margins: Theme.spacingS * root.scaleFactor
            spacing: Theme.spacingXS * root.scaleFactor

            // CPU Usage
            Column {
                width: (parent.width - 6 * Theme.spacingXS * root.scaleFactor) / 7
                height: parent.height
                spacing: 0

                Item {
                    width: parent.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    CircularProgress {
                        id: cpuProgress
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height) * 0.95
                        height: width
                        value: (DgopService.cpuUsage || 0) / 100
                        strokeWidth: 8 * root.scaleFactor
                        readonly property real contentPadding: 4 * root.scaleFactor
                        trackColor: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                        progressColor: {
                            if (DgopService.cpuUsage > 80) return Theme.error
                            if (DgopService.cpuUsage > 60) return Theme.warning
                            return Theme.primary
                        }
                    }
                    
                    Column {
                        anchors.horizontalCenter: cpuProgress.horizontalCenter
                        anchors.verticalCenter: cpuProgress.verticalCenter
                        anchors.verticalCenterOffset: -8 * root.scaleFactor
                        width: cpuProgress.width - (cpuProgress.strokeWidth * 2) - (cpuProgress.contentPadding * 2)
                        spacing: 0
                        
                        Item {
                            width: parent.width
                            height: 1 * root.scaleFactor
                        }
                        
                        EHIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            name: "memory"
                            size: (Theme.iconSizeSmall - 4) * root.scaleFactor
                            color: {
                                if (DgopService.cpuUsage > 80) return Theme.error
                                if (DgopService.cpuUsage > 60) return Theme.warning
                                return Theme.primary
                            }
                        }
                        
                        Item {
                            width: parent.width
                            height: 8 * root.scaleFactor
                        }
                        
                        StyledText {
                            width: parent.width
                            text: root.getShortCpuName()
                            font.pixelSize: (Theme.fontSizeSmall - 4) * root.scaleFactor
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                            elide: Text.ElideMiddle
                            color: Theme.surfaceText
                        }
                    }
                }
            }

            // CPU Temperature
            Column {
                width: (parent.width - 6 * Theme.spacingXS * root.scaleFactor) / 7
                height: parent.height
                spacing: 0

                Item {
                    width: parent.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    CircularProgress {
                        id: cpuTempProgress
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height) * 0.95
                        height: width
                        value: Math.min(Math.max((DgopService.cpuTemperature || 40) / 100, 0), 1)
                        strokeWidth: 8 * root.scaleFactor
                        readonly property real contentPadding: 4 * root.scaleFactor
                        trackColor: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                        progressColor: {
                            if (DgopService.cpuTemperature > 85) return Theme.error
                            if (DgopService.cpuTemperature > 69) return Theme.warning
                            return Theme.primary
                        }
                    }
                    
                    Column {
                        anchors.centerIn: cpuTempProgress
                        width: cpuTempProgress.width - (cpuTempProgress.strokeWidth * 2) - (cpuTempProgress.contentPadding * 2)
                        spacing: 2 * root.scaleFactor
                        
                        EHIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            name: "device_thermostat"
                            size: (Theme.iconSizeSmall - 4) * root.scaleFactor
                            color: {
                                if (DgopService.cpuTemperature > 85) return Theme.error
                                if (DgopService.cpuTemperature > 69) return Theme.warning
                                return Theme.primary
                            }
                        }
                        
                        StyledText {
                            width: parent.width
                            text: {
                                const temp = DgopService.cpuTemperature || 0
                                if (temp < 0 || temp === undefined || temp === null) return "--°"
                                return Math.round(temp) + "°"
                            }
                            font.pixelSize: (Theme.fontSizeSmall - 2) * root.scaleFactor
                            font.weight: Font.Bold
                            horizontalAlignment: Text.AlignHCenter
                            color: {
                                if (DgopService.cpuTemperature > 85) return Theme.error
                                if (DgopService.cpuTemperature > 69) return Theme.warning
                                return Theme.primary
                            }
                        }
                    }
                }
            }

            // Memory Usage
            Column {
                width: (parent.width - 6 * Theme.spacingXS * root.scaleFactor) / 7
                height: parent.height
                spacing: 0

                Item {
                    width: parent.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    CircularProgress {
                        id: memoryProgress
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height) * 0.95
                        height: width
                        value: (DgopService.memoryUsage || 0) / 100
                        strokeWidth: 8 * root.scaleFactor
                        readonly property real contentPadding: 4 * root.scaleFactor
                        trackColor: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                        progressColor: {
                            if (DgopService.memoryUsage > 90) return Theme.error
                            if (DgopService.memoryUsage > 75) return Theme.warning
                            return Theme.primary
                        }
                    }
                    
                    Column {
                        anchors.horizontalCenter: memoryProgress.horizontalCenter
                        anchors.verticalCenter: memoryProgress.verticalCenter
                        anchors.verticalCenterOffset: -8 * root.scaleFactor
                        width: memoryProgress.width - (memoryProgress.strokeWidth * 2) - (memoryProgress.contentPadding * 2)
                        spacing: 2 * root.scaleFactor
                        
                        EHIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            name: "developer_board"
                            size: (Theme.iconSizeSmall - 4) * root.scaleFactor
                            color: {
                                if (DgopService.memoryUsage > 90) return Theme.error
                                if (DgopService.memoryUsage > 75) return Theme.warning
                                return Theme.primary
                            }
                        }
                        
                        StyledText {
                            width: parent.width
                            text: Math.round(DgopService.memoryUsage || 0) + "%"
                            font.pixelSize: (Theme.fontSizeSmall - 2) * root.scaleFactor
                            font.weight: Font.Bold
                            horizontalAlignment: Text.AlignHCenter
                            color: {
                                if (DgopService.memoryUsage > 90) return Theme.error
                                if (DgopService.memoryUsage > 75) return Theme.warning
                                return Theme.primary
                            }
                        }
                    }
                }
            }

            // GPU Temperature
            Column {
                width: (parent.width - 6 * Theme.spacingXS * root.scaleFactor) / 7
                height: parent.height
                spacing: 0

                Item {
                    width: parent.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    CircularProgress {
                        id: gpuTempProgress
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height) * 0.95
                        height: width
                        value: Math.min(Math.max((root.gpuTemperature || 40) / 100, 0), 1)
                        strokeWidth: 8 * root.scaleFactor
                        readonly property real contentPadding: 4 * root.scaleFactor
                        trackColor: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                        progressColor: {
                            if (root.gpuTemperature > 85) return Theme.error
                            if (root.gpuTemperature > 69) return Theme.warning
                            return Theme.primary
                        }
                    }
                    
                    Column {
                        anchors.centerIn: gpuTempProgress
                        width: gpuTempProgress.width - (gpuTempProgress.strokeWidth * 2) - (gpuTempProgress.contentPadding * 2)
                        spacing: 2 * root.scaleFactor
                        
                        EHIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            name: "auto_awesome_mosaic"
                            size: (Theme.iconSizeSmall - 4) * root.scaleFactor
                            color: {
                                if (root.gpuTemperature > 85) return Theme.error
                                if (root.gpuTemperature > 69) return Theme.warning
                                return Theme.primary
                            }
                        }
                        
                        StyledText {
                            width: parent.width
                            text: root.getShortGpuName()
                            font.pixelSize: (Theme.fontSizeSmall - 4) * root.scaleFactor
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                            elide: Text.ElideMiddle
                            color: Theme.surfaceText
                        }
                    }
                }
            }

            // VRAM Usage
            Column {
                width: (parent.width - 6 * Theme.spacingXS * root.scaleFactor) / 7
                height: parent.height
                spacing: 0

                Item {
                    width: parent.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    CircularProgress {
                        id: vramProgress
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height) * 0.95
                        height: width
                        value: (root.gpuMemoryUsage || 0) / 100
                        strokeWidth: 8 * root.scaleFactor
                        readonly property real contentPadding: 4 * root.scaleFactor
                        trackColor: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                        progressColor: {
                            if (root.gpuMemoryUsage > 90) return Theme.error
                            if (root.gpuMemoryUsage > 75) return Theme.warning
                            return Theme.primary
                        }
                    }
                    
                    Column {
                        anchors.centerIn: vramProgress
                        width: vramProgress.width - (vramProgress.strokeWidth * 2) - (vramProgress.contentPadding * 2)
                        spacing: 2 * root.scaleFactor
                        
                        EHIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            name: "memory"
                            size: (Theme.iconSizeSmall - 4) * root.scaleFactor
                            color: {
                                if (root.gpuMemoryUsage > 90) return Theme.error
                                if (root.gpuMemoryUsage > 75) return Theme.warning
                                return Theme.primary
                            }
                        }
                        
                        StyledText {
                            width: parent.width
                            text: root.formatVRAM()
                            font.pixelSize: (Theme.fontSizeSmall - 3) * root.scaleFactor
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                            color: Theme.surfaceText
                        }
                    }
                }
            }

            // Network Download
            Column {
                width: (parent.width - 6 * Theme.spacingXS * root.scaleFactor) / 7
                height: parent.height
                spacing: 0

                Item {
                    width: parent.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    CircularProgress {
                        id: downloadProgress
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height) * 0.95
                        height: width
                        value: Math.min(Math.max((DgopService.networkRxRate || 0) / (10 * 1024 * 1024), 0), 1)
                        strokeWidth: 8 * root.scaleFactor
                        readonly property real contentPadding: 4 * root.scaleFactor
                        trackColor: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                        progressColor: Theme.primary
                    }
                    
                    Column {
                        anchors.horizontalCenter: downloadProgress.horizontalCenter
                        anchors.verticalCenter: downloadProgress.verticalCenter
                        anchors.verticalCenterOffset: -8 * root.scaleFactor
                        width: downloadProgress.width - (downloadProgress.strokeWidth * 2) - (downloadProgress.contentPadding * 2)
                        spacing: 2 * root.scaleFactor
                        
                        EHIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            name: "download"
                            size: (Theme.iconSizeSmall - 4) * root.scaleFactor
                            color: Theme.primary
                        }
                        
                        StyledText {
                            width: parent.width
                            text: root.formatNetworkSpeed(DgopService.networkRxRate || 0)
                            font.pixelSize: (Theme.fontSizeSmall - 3) * root.scaleFactor
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                            color: Theme.surfaceText
                        }
                    }
                }
            }

            // Network Upload
            Column {
                width: (parent.width - 6 * Theme.spacingXS * root.scaleFactor) / 7
                height: parent.height
                spacing: 0

                Item {
                    width: parent.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter

                    CircularProgress {
                        id: uploadProgress
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height) * 0.95
                        height: width
                        value: Math.min(Math.max((DgopService.networkTxRate || 0) / (10 * 1024 * 1024), 0), 1)
                        strokeWidth: 8 * root.scaleFactor
                        readonly property real contentPadding: 4 * root.scaleFactor
                        trackColor: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                        progressColor: Theme.primary
                    }
                    
                    Column {
                        anchors.horizontalCenter: uploadProgress.horizontalCenter
                        anchors.verticalCenter: uploadProgress.verticalCenter
                        anchors.verticalCenterOffset: -8 * root.scaleFactor
                        width: uploadProgress.width - (uploadProgress.strokeWidth * 2) - (uploadProgress.contentPadding * 2)
                        spacing: 2 * root.scaleFactor
                        
                        EHIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            name: "upload"
                            size: (Theme.iconSizeSmall - 4) * root.scaleFactor
                            color: Theme.primary
                        }
                        
                        StyledText {
                            width: parent.width
                            text: root.formatNetworkSpeed(DgopService.networkTxRate || 0)
                            font.pixelSize: (Theme.fontSizeSmall - 3) * root.scaleFactor
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                            color: Theme.surfaceText
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.SizeAllCursor
        }
    }

    // Circular Progress Component
    component CircularProgress: Canvas {
        id: progressCanvas
        
        property real value: 0.0  // 0.0 to 1.0
        property real strokeWidth: 4
        property color trackColor: Qt.rgba(0.5, 0.5, 0.5, 0.3)
        property color progressColor: Theme.primary
        
        onValueChanged: requestPaint()
        onProgressColorChanged: requestPaint()
        onTrackColorChanged: requestPaint()
        
        Behavior on value {
            NumberAnimation {
                duration: Theme.shortDuration
                easing.type: Theme.standardEasing
            }
        }
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            
            var centerX = width / 2
            var centerY = height / 2
            var radius = Math.min(width, height) / 2 - strokeWidth / 2
            var startAngle = -Math.PI / 2  // Start at top
            var endAngle = startAngle + (value * 2 * Math.PI)
            
            // Draw background circle (track)
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI)
            ctx.strokeStyle = trackColor
            ctx.lineWidth = strokeWidth
            ctx.lineCap = "round"
            ctx.stroke()
            
            // Draw progress arc
            if (value > 0) {
                ctx.beginPath()
                ctx.arc(centerX, centerY, radius, startAngle, endAngle)
                ctx.strokeStyle = progressColor
                ctx.lineWidth = strokeWidth
                ctx.lineCap = "round"
                ctx.stroke()
            }
        }
    }
}
