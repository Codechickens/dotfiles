import QtQuick
import QtQuick.Effects
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

    readonly property real gpuTemperature: (DgopService.availableGpus && DgopService.availableGpus.length > 0) ? (DgopService.availableGpus[0].temperature || -1) : -1
    readonly property real gpuMemoryUsedMB: (DgopService.availableGpus && DgopService.availableGpus.length > 0) ? (DgopService.availableGpus[0].memoryUsedMB || 0) : 0
    readonly property real gpuMemoryTotalMB: (DgopService.availableGpus && DgopService.availableGpus.length > 0) ? (DgopService.availableGpus[0].memoryTotalMB || 0) : 0
    readonly property real gpuMemoryUsage: gpuMemoryTotalMB > 0 ? (gpuMemoryUsedMB / gpuMemoryTotalMB) * 100 : 0
    
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
        border.width: 1

        Row {
            anchors.fill: parent
            anchors.margins: Theme.spacingS
            spacing: Theme.spacingXS

            Column {
                width: (parent.width - 6 * Theme.spacingXS) / 7
                height: parent.height
                spacing: Theme.spacingXS

                StyledText {
                    width: parent.width
                    text: Math.round(DgopService.cpuUsage || 0) + "%"
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    color: {
                        if (DgopService.cpuUsage > 80) return Theme.error
                        if (DgopService.cpuUsage > 60) return Theme.warning
                        return Theme.primary
                    }
                }

                Rectangle {
                    width: 8
                    height: parent.height - Theme.iconSizeSmall - Theme.spacingXS * 2 - 20
                    radius: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)

                    Rectangle {
                        width: parent.width
                        height: parent.height * Math.min((DgopService.cpuUsage || 6) / 100, 1)
                        radius: parent.radius
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: {
                            if (DgopService.cpuUsage > 80) return Theme.error
                            if (DgopService.cpuUsage > 60) return Theme.warning
                            return Theme.primary
                        }

                        Behavior on height {
                            NumberAnimation {
                                duration: Theme.shortDuration
                                easing.type: Theme.standardEasing
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: Theme.iconSizeSmall

                    EHIcon {
                        name: "memory"
                        size: Theme.iconSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        color: {
                            if (DgopService.cpuUsage > 80) return Theme.error
                            if (DgopService.cpuUsage > 60) return Theme.warning
                            return Theme.primary
                        }
                    }
                }
            }

            Column {
                width: (parent.width - 6 * Theme.spacingXS) / 7
                height: parent.height
                spacing: Theme.spacingXS

                StyledText {
                    width: parent.width
                    text: {
                        const temp = DgopService.cpuTemperature || 0
                        if (temp < 0 || temp === undefined || temp === null) return "--°"
                        return Math.round(temp) + "°"
                    }
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    color: {
                        if (DgopService.cpuTemperature > 85) return Theme.error
                        if (DgopService.cpuTemperature > 69) return Theme.warning
                        return Theme.primary
                    }
                }

                Rectangle {
                    width: 8
                    height: parent.height - Theme.iconSizeSmall - Theme.spacingXS * 2 - 20
                    radius: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)

                    Rectangle {
                        width: parent.width
                        height: parent.height * Math.min(Math.max((DgopService.cpuTemperature || 40) / 100, 0), 1)
                        radius: parent.radius
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: {
                            if (DgopService.cpuTemperature > 85) return Theme.error
                            if (DgopService.cpuTemperature > 69) return Theme.warning
                            return Theme.primary
                        }

                        Behavior on height {
                            NumberAnimation {
                                duration: Theme.shortDuration
                                easing.type: Theme.standardEasing
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: Theme.iconSizeSmall

                    EHIcon {
                        name: "device_thermostat"
                        size: Theme.iconSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        color: {
                            if (DgopService.cpuTemperature > 85) return Theme.error
                            if (DgopService.cpuTemperature > 69) return Theme.warning
                            return Theme.primary
                        }
                    }
                }
            }

            Column {
                width: (parent.width - 6 * Theme.spacingXS) / 7
                height: parent.height
                spacing: Theme.spacingXS

                StyledText {
                    width: parent.width
                    text: Math.round(DgopService.memoryUsage || 0) + "%"
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    color: {
                        if (DgopService.memoryUsage > 90) return Theme.error
                        if (DgopService.memoryUsage > 75) return Theme.warning
                        return Theme.primary
                    }
                }

                Rectangle {
                    width: 8
                    height: parent.height - Theme.iconSizeSmall - Theme.spacingXS * 2 - 20
                    radius: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)

                    Rectangle {
                        width: parent.width
                        height: parent.height * Math.min((DgopService.memoryUsage || 42) / 100, 1)
                        radius: parent.radius
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: {
                            if (DgopService.memoryUsage > 90) return Theme.error
                            if (DgopService.memoryUsage > 75) return Theme.warning
                            return Theme.primary
                        }

                        Behavior on height {
                            NumberAnimation {
                                duration: Theme.shortDuration
                                easing.type: Theme.standardEasing
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: Theme.iconSizeSmall

                    EHIcon {
                        name: "developer_board"
                        size: Theme.iconSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        color: {
                            if (DgopService.memoryUsage > 90) return Theme.error
                            if (DgopService.memoryUsage > 75) return Theme.warning
                            return Theme.primary
                        }
                    }
                }
            }

            Column {
                width: (parent.width - 6 * Theme.spacingXS) / 7
                height: parent.height
                spacing: Theme.spacingXS

                StyledText {
                    width: parent.width
                    text: {
                        const temp = root.gpuTemperature
                        if (temp < 0 || temp === undefined || temp === null) return "--°"
                        return Math.round(temp) + "°"
                    }
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    color: {
                        if (root.gpuTemperature > 85) return Theme.error
                        if (root.gpuTemperature > 69) return Theme.warning
                        return Theme.primary
                    }
                }

                Rectangle {
                    width: 8
                    height: parent.height - Theme.iconSizeSmall - Theme.spacingXS * 2 - 20
                    radius: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)

                    Rectangle {
                        width: parent.width
                        height: parent.height * Math.min(Math.max((root.gpuTemperature || 40) / 100, 0), 1)
                        radius: parent.radius
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: {
                            if (root.gpuTemperature > 85) return Theme.error
                            if (root.gpuTemperature > 69) return Theme.warning
                            return Theme.primary
                        }

                        Behavior on height {
                            NumberAnimation {
                                duration: Theme.shortDuration
                                easing.type: Theme.standardEasing
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: Theme.iconSizeSmall

                    EHIcon {
                        name: "auto_awesome_mosaic"
                        size: Theme.iconSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        color: {
                            if (root.gpuTemperature > 85) return Theme.error
                            if (root.gpuTemperature > 69) return Theme.warning
                            return Theme.primary
                        }
                    }
                }
            }

            Column {
                width: (parent.width - 6 * Theme.spacingXS) / 7
                height: parent.height
                spacing: Theme.spacingXS

                StyledText {
                    width: parent.width
                    text: Math.round(root.gpuMemoryUsage || 0) + "%"
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    color: {
                        if (root.gpuMemoryUsage > 90) return Theme.error
                        if (root.gpuMemoryUsage > 75) return Theme.warning
                        return Theme.primary
                    }
                }

                Rectangle {
                    width: 8
                    height: parent.height - Theme.iconSizeSmall - Theme.spacingXS * 2 - 20
                    radius: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)

                    Rectangle {
                        width: parent.width
                        height: parent.height * Math.min((root.gpuMemoryUsage || 0) / 100, 1)
                        radius: parent.radius
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: {
                            if (root.gpuMemoryUsage > 90) return Theme.error
                            if (root.gpuMemoryUsage > 75) return Theme.warning
                            return Theme.primary
                        }

                        Behavior on height {
                            NumberAnimation {
                                duration: Theme.shortDuration
                                easing.type: Theme.standardEasing
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: Theme.iconSizeSmall

                    EHIcon {
                        name: "memory"
                        size: Theme.iconSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        color: {
                            if (root.gpuMemoryUsage > 90) return Theme.error
                            if (root.gpuMemoryUsage > 75) return Theme.warning
                            return Theme.primary
                        }
                    }
                }
            }

            Column {
                width: (parent.width - 6 * Theme.spacingXS) / 7
                height: parent.height
                spacing: Theme.spacingXS

                StyledText {
                    width: parent.width
                    text: root.formatNetworkSpeed(DgopService.networkRxRate || 0)
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    color: Theme.primary
                }

                Rectangle {
                    width: 8
                    height: parent.height - Theme.iconSizeSmall - Theme.spacingXS * 2 - 20
                    radius: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)

                    Rectangle {
                        width: parent.width
                        height: parent.height * Math.min(Math.max((DgopService.networkRxRate || 0) / (10 * 1024 * 1024), 0), 1)
                        radius: parent.radius
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: Theme.primary

                        Behavior on height {
                            NumberAnimation {
                                duration: Theme.shortDuration
                                easing.type: Theme.standardEasing
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: Theme.iconSizeSmall

                    EHIcon {
                        name: "download"
                        size: Theme.iconSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        color: Theme.primary
                    }
                }
            }

            Column {
                width: (parent.width - 6 * Theme.spacingXS) / 7
                height: parent.height
                spacing: Theme.spacingXS

                StyledText {
                    width: parent.width
                    text: root.formatNetworkSpeed(DgopService.networkTxRate || 0)
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    color: Theme.primary
                }

                Rectangle {
                    width: 8
                    height: parent.height - Theme.iconSizeSmall - Theme.spacingXS * 2 - 20
                    radius: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)

                    Rectangle {
                        width: parent.width
                        height: parent.height * Math.min(Math.max((DgopService.networkTxRate || 0) / (10 * 1024 * 1024), 0), 1)
                        radius: parent.radius
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: Theme.primary

                        Behavior on height {
                            NumberAnimation {
                                duration: Theme.shortDuration
                                easing.type: Theme.standardEasing
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: Theme.iconSizeSmall

                    EHIcon {
                        name: "upload"
                        size: Theme.iconSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        color: Theme.primary
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
}
