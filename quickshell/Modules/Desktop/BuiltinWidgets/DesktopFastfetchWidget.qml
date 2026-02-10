import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root

    property string instanceId: ""
    property var instanceData: null
    readonly property var cfg: instanceData?.config ?? null
    readonly property bool isInstance: instanceId !== "" && cfg !== null

    property real widgetWidth: defaultWidth
    property real widgetHeight: defaultHeight
    property real defaultWidth: 750
    property real defaultHeight: 550
    property real minWidth: 500
    property real minHeight: 400
    property real fontSize: isInstance ? (cfg.fontSize ?? 12) : (SettingsData.desktopWidgetFontSize || 12)
    property real spacing: isInstance ? (cfg.spacing ?? 4) : 4
    property real padding: isInstance ? (cfg.padding ?? 16) : 16

    function shouldShow(key) {
        if (!isInstance || !cfg) return true
        if (cfg.hasOwnProperty(key)) {
            return cfg[key] !== false
        }
        return true
    }

    function getConfigValue(key, defaultValue) {
        if (!isInstance || !cfg) return defaultValue
        if (cfg.hasOwnProperty(key)) {
            return cfg[key]
        }
        return defaultValue
    }

    width: widgetWidth
    height: widgetHeight

    Component.onCompleted: {
        if (typeof FastfetchService !== "undefined") {
            FastfetchService.refreshAll()
        }
        if (typeof HardwareService !== "undefined") {
            HardwareService.refreshAll()
        }
        if (typeof DgopService !== "undefined") {
            DgopService.addRef(["cpu", "memory", "gpu"])
        }
    }
    
    Component.onDestruction: {
        if (typeof DgopService !== "undefined") {
            DgopService.removeRef(["cpu", "memory", "gpu"])
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.cornerRadius
        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, 0.9)
        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.3)
        border.width: 1

        Flickable {
            id: flickable
            anchors.fill: parent
            anchors.margins: root.padding
            contentWidth: width
            contentHeight: contentColumn.implicitHeight
            clip: true

            Column {
                id: contentColumn
                width: parent.width
                spacing: root.padding

                // Header with logo and user info
                Row {
                    width: parent.width
                    spacing: root.padding
                    height: Math.max(userInfoColumn.height, logoContainer.height)

                    // OS Logo
                    Item {
                        id: logoContainer
                        width: 80
                        height: 80

                        SystemLogo {
                            id: osLogo
                            anchors.fill: parent
                            visible: {
                                const useCustom = root.getConfigValue("useCustomLogo", false)
                                const customPath = root.getConfigValue("customLogoPath", "")
                                return !useCustom || customPath === ""
                            }
                        }

                        Item {
                            visible: {
                                const useCustom = root.getConfigValue("useCustomLogo", false)
                                const customPath = root.getConfigValue("customLogoPath", "")
                                return useCustom && customPath !== ""
                            }
                            anchors.fill: parent

                            Image {
                                id: customLogo
                                anchors.fill: parent
                                source: root.getConfigValue("customLogoPath", "") ? "file://" + root.getConfigValue("customLogoPath", "") : ""
                                fillMode: Image.PreserveAspectFit
                                smooth: false
                                mipmap: true
                            }
                        }
                    }

                    // User info
                    Column {
                        id: userInfoColumn
                        width: parent.width - logoContainer.width - parent.spacing
                        spacing: 2

                        StyledText {
                            text: typeof UserInfoService !== "undefined" ? (UserInfoService.username || "user") : "user"
                            font.pixelSize: root.fontSize + 6
                            font.weight: Font.Bold
                            color: Theme.primary
                        }

                        StyledText {
                            text: "@" + (typeof FastfetchService !== "undefined" ? FastfetchService.hostname : (typeof HardwareService !== "undefined" ? HardwareService.hostname : "hostname"))
                            font.pixelSize: root.fontSize + 2
                            color: Theme.surfaceTextMedium
                            font.weight: Font.Medium
                        }

                        StyledText {
                            text: typeof FastfetchService !== "undefined" ? FastfetchService.uptime : (typeof UserInfoService !== "undefined" ? UserInfoService.shortUptime : "Unknown")
                            font.pixelSize: root.fontSize
                            color: Theme.surfaceTextMedium
                            visible: root.shouldShow("showUptime")
                        }
                    }
                }

                // System Information Card
                InfoCard {
                    title: "System"
                    width: parent.width

                    Column {
                        width: parent.width
                        spacing: root.spacing

                        InfoRow {
                            visible: root.shouldShow("showOs")
                            label: "OS"
                            value: typeof FastfetchService !== "undefined" ? FastfetchService.osName : (typeof HardwareService !== "undefined" ? HardwareService.osName : "Unknown")
                        }

                        InfoRow {
                            visible: root.shouldShow("showHost")
                            label: "Host"
                            value: typeof FastfetchService !== "undefined" ? FastfetchService.hostname : (typeof HardwareService !== "undefined" ? HardwareService.hostname : "Unknown")
                        }

                        InfoRow {
                            visible: root.shouldShow("showKernel")
                            label: "Kernel"
                            value: typeof FastfetchService !== "undefined" ? FastfetchService.kernelVersion : (typeof HardwareService !== "undefined" ? HardwareService.kernelVersion : "Unknown")
                        }

                        InfoRow {
                            visible: root.shouldShow("showRes")
                            label: "Resolution"
                            value: typeof FastfetchService !== "undefined" ? FastfetchService.resolution : "Unknown"
                        }

                        InfoRow {
                            visible: root.shouldShow("showUptime")
                            label: "Uptime"
                            value: typeof FastfetchService !== "undefined" ? FastfetchService.uptime : (typeof UserInfoService !== "undefined" ? UserInfoService.shortUptime : "Unknown")
                        }
                    }
                }

                // Hardware Information Card
                InfoCard {
                    title: "Hardware"
                    width: parent.width

                    Column {
                        width: parent.width
                        spacing: root.spacing

                        InfoRow {
                            visible: root.shouldShow("showCpu")
                            label: "CPU"
                            value: typeof FastfetchService !== "undefined" && FastfetchService.cpu ? FastfetchService.cpu : (typeof HardwareService !== "undefined" ? HardwareService.cpuModel : (typeof DgopService !== "undefined" ? DgopService.cpuModel : "Unknown"))
                        }

                        InfoRow {
                            visible: root.shouldShow("showGpu")
                            label: "GPU"
                            value: {
                                if (typeof HardwareService !== "undefined" && HardwareService.gpuModel) {
                                    return HardwareService.gpuModel
                                } else if (typeof DgopService !== "undefined" && DgopService.availableGpus && DgopService.availableGpus.length > 0) {
                                    return DgopService.availableGpus[0].name || "Unknown"
                                }
                                return "Unknown"
                            }
                        }

                        InfoRow {
                            visible: root.shouldShow("showMemory")
                            label: "Memory"
                            value: {
                                if (typeof DgopService !== "undefined" && DgopService.totalMemoryMB > 0) {
                                    const used = (DgopService.usedMemoryMB / DgopService.totalMemoryMB * 100).toFixed(1)
                                    return `${(DgopService.usedMemoryMB / 1024).toFixed(1)}GiB / ${(DgopService.totalMemoryMB / 1024).toFixed(1)}GiB (${used}%)`
                                } else if (typeof HardwareService !== "undefined") {
                                    return HardwareService.usedMemory + " / " + HardwareService.totalMemory
                                }
                                return "Unknown"
                            }
                        }

                        InfoRow {
                            visible: root.shouldShow("showDisk")
                            label: "Disk"
                            value: typeof HardwareService !== "undefined" ? (HardwareService.diskUsed + " / " + HardwareService.diskTotal + " (" + HardwareService.diskUsagePercent + ")") : "Unknown"
                        }
                    }
                }

                // Software Information Card
                InfoCard {
                    title: "Software"
                    width: parent.width

                    Column {
                        width: parent.width
                        spacing: root.spacing

                        InfoRow {
                            visible: root.shouldShow("showPackages")
                            label: "Packages"
                            value: typeof FastfetchService !== "undefined" ? (FastfetchService.packages + (FastfetchService.packageManager ? " (" + FastfetchService.packageManager + ")" : "")) : "Unknown"
                        }

                        InfoRow {
                            visible: root.shouldShow("showShell")
                            label: "Shell"
                            value: typeof FastfetchService !== "undefined" ? (FastfetchService.shell + (FastfetchService.shellVersion ? " " + FastfetchService.shellVersion : "")) : (Quickshell.env("SHELL") ? Quickshell.env("SHELL").split("/").pop() : "Unknown")
                        }

                        InfoRow {
                            visible: root.shouldShow("showDe")
                            label: "DE"
                            value: typeof FastfetchService !== "undefined" ? FastfetchService.desktopEnvironment : "Unknown"
                        }

                        InfoRow {
                            visible: root.shouldShow("showWm")
                            label: "WM"
                            value: typeof FastfetchService !== "undefined" ? FastfetchService.windowManager : "Unknown"
                        }

                        InfoRow {
                            visible: root.shouldShow("showTheme")
                            label: "Theme"
                            value: typeof FastfetchService !== "undefined" ? FastfetchService.theme : "Unknown"
                        }

                        InfoRow {
                            visible: root.shouldShow("showIcons")
                            label: "Icons"
                            value: typeof FastfetchService !== "undefined" ? FastfetchService.icons : "Unknown"
                        }

                        InfoRow {
                            visible: root.shouldShow("showFonts")
                            label: "Fonts"
                            value: typeof FastfetchService !== "undefined" ? FastfetchService.fonts : "Unknown"
                        }
                    }
                }

                // Network Information Card
                InfoCard {
                    title: "Network"
                    width: parent.width

                    Column {
                        width: parent.width
                        spacing: root.spacing

                        InfoRow {
                            visible: root.shouldShow("showLocalIp")
                            label: "Local IP"
                            value: typeof FastfetchService !== "undefined" ? FastfetchService.localIp : "Unknown"
                        }
                    }
                }
            }
        }
    }

    component InfoCard: Column {
        property string title: ""
        property alias content: contentContainer.children

        width: parent.width
        spacing: root.spacing

        // Card title
        StyledText {
            text: parent.title
            font.pixelSize: root.fontSize + 2
            font.weight: Font.Bold
            color: Theme.primary
            opacity: 0.8
        }

        // Card content
        Column {
            id: contentContainer
            width: parent.width
            spacing: root.spacing
        }

        // Card separator
        Rectangle {
            width: parent.width
            height: 1
            color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
        }
    }

    component InfoRow: Row {
        property string label: ""
        property string value: ""

        width: parent.width
        spacing: root.spacing * 2

        StyledText {
            text: parent.label + ":"
            font.pixelSize: root.fontSize
            color: Theme.surfaceTextMedium
            font.weight: Font.Medium
            width: 80
        }

        StyledText {
            text: parent.value
            font.pixelSize: root.fontSize
            color: Theme.surfaceText
            width: parent.width - 80 - parent.spacing
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            maximumLineCount: 2
        }
    }
}
