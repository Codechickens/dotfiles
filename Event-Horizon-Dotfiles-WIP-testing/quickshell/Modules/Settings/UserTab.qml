import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import qs.Common
import qs.Widgets
import qs.Services

Item {
    id: userTab

    property var parentModal: null

    EHFlickable {
        anchors.fill: parent
        clip: true
        contentHeight: mainColumn.height + Theme.spacingXL * 2
        contentWidth: width

        Column {
            id: mainColumn
            width: parent.width
            spacing: Theme.spacingL
            topPadding: Theme.spacingL
            bottomPadding: Theme.spacingL

            // User Profile Section
            StyledRect {
                width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                height: userProfileRow.implicitHeight + Theme.spacingXL * 2
                anchors.horizontalCenter: parent.horizontalCenter
                
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
                radius: Theme.cornerRadius
                border.width: 1
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)

                RowLayout {
                    id: userProfileRow
                    anchors.fill: parent
                    anchors.margins: Theme.spacingXL
                    spacing: Theme.spacingL

                    // User Avatar
                    Rectangle {
                        Layout.preferredWidth: 110
                        Layout.preferredHeight: 110
                        Layout.alignment: Qt.AlignVCenter
                        radius: 55
                        color: Theme.surfaceContainerHigh
                        clip: true

                        EHIcon {
                            anchors.centerIn: parent
                            name: "person"
                            size: 64
                            color: Theme.primary
                            visible: !userImage.visible
                        }
                        
                        Image {
                            id: userImage
                            anchors.fill: parent
                            source: {
                                if (PortalService.profileImage === "") return ""
                                if (PortalService.profileImage.startsWith("/")) return "file://" + PortalService.profileImage
                                return PortalService.profileImage
                            }
                            visible: PortalService.profileImage !== "" && status === Image.Ready
                            fillMode: Image.PreserveAspectCrop
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: Rectangle {
                                    width: userImage.width
                                    height: userImage.height
                                    radius: userImage.width / 2
                                    visible: false
                                }
                            }
                        }
                    }

                    // User Details
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 4

                        StyledText {
                            text: "Welcome back,"
                            font.pixelSize: Theme.fontSizeLarge
                            color: Theme.surfaceVariantText
                            font.weight: Font.Medium
                        }

                        StyledText {
                            text: UserInfoService.fullName || UserInfoService.username || "User"
                            font.pixelSize: 48
                            font.weight: Font.ExtraBold
                            color: Theme.primary
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            lineHeight: 1.1
                        }

                        Rectangle {
                            Layout.topMargin: 4
                            height: 32
                            width: hostnameRow.implicitWidth + Theme.spacingL
                            radius: 16
                            color: Theme.surfaceContainerHigh
                            
                            RowLayout {
                                id: hostnameRow
                                anchors.centerIn: parent
                                spacing: 2
                                
                                StyledText {
                                    text: "@"
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.primary
                                    font.weight: Font.Bold
                                }

                                StyledText {
                                    text: (HardwareService.hostname || "localhost")
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceText
                                    font.family: "Monospace"
                                    font.weight: Font.Medium
                                }
                            }
                        }
                    }
                }
            }

            // Distro & System Info Section
            StyledRect {
                width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                height: Math.max(250, systemRow.implicitHeight + Theme.spacingXL * 2)
                anchors.horizontalCenter: parent.horizontalCenter

                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
                radius: Theme.cornerRadius
                border.width: 1
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)

                RowLayout {
                    id: systemRow
                    anchors.fill: parent
                    anchors.margins: Theme.spacingXL
                    spacing: Theme.spacingXL

                    // Distro Logo Area
                    ColumnLayout {
                        Layout.preferredWidth: parent.width * 0.3
                        Layout.alignment: Qt.AlignTop
                        spacing: Theme.spacingM

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredHeight: 180
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            
                            Image {
                                anchors.fill: parent
                                source: "../../assets/Event-Horizon-logo.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                            }
                        }
                    }

                    // Vertical Separator
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        color: Theme.outlineVariant
                    }

                    // System Specs Grid
                    GridLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 2
                        columnSpacing: Theme.spacingXL
                        rowSpacing: Theme.spacingL

                        // Helper for Info Items
                        component InfoItem : ColumnLayout {
                            property string label
                            property string value
                            property string icon
                            property int span: 1

                            Layout.columnSpan: span
                            Layout.fillWidth: true
                            spacing: Theme.spacingXS

                            RowLayout {
                                spacing: Theme.spacingS
                                EHIcon {
                                    name: icon
                                    size: 16
                                    color: Theme.primary
                                }
                                StyledText {
                                    text: label
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceVariantText
                                    font.weight: Font.Medium
                                }
                            }

                            StyledText {
                                Layout.leftMargin: 24 // Indent under label text (icon width + spacing)
                                text: value
                                font.pixelSize: Theme.fontSizeMedium
                                color: Theme.surfaceText
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }

                        InfoItem {
                            label: "Kernel"
                            value: HardwareService.kernelVersion || "Unknown"
                            icon: "memory"
                        }

                        InfoItem {
                            label: "Uptime"
                            value: UserInfoService.uptime || "Unknown"
                            icon: "schedule"
                        }

                        InfoItem {
                            label: "Memory"
                            value: HardwareService.usedMemory + " / " + HardwareService.totalMemory
                            icon: "memory"
                        }

                        InfoItem {
                            label: "Disk"
                            value: HardwareService.diskUsed + " / " + HardwareService.diskTotal
                            icon: "storage"
                        }
                        
                        InfoItem {
                            label: "CPU"
                            value: HardwareService.cpuModel || "Unknown"
                            icon: "developer_board"
                            span: 2
                        }

                        InfoItem {
                            label: "GPU"
                            value: HardwareService.gpuModel || "Unknown"
                            icon: "videocam"
                            span: 2
                        }
                    }
                }
            }
            // Detailed Hardware Information
            StyledRect {
                width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                height: hardwareSection.implicitHeight + Theme.spacingL * 2
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                border.width: 1

                Column {
                    id: hardwareSection
                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingXL

                    RowLayout {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "memory"
                            size: Theme.iconSize
                            color: Theme.primary
                            Layout.alignment: Qt.AlignVCenter
                        }

                        StyledText {
                            text: "Hardware Information"
                            font.pixelSize: Theme.fontSizeLarge
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Item {
                            Layout.fillWidth: true
                        }
                    }

                    // Processor Section
                    StyledRect {
                        width: parent.width
                        height: processorSection.implicitHeight + Theme.spacingM * 2
                        radius: Theme.cornerRadius
                        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, 0.5)
                        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.1)
                        border.width: 1

                        Column {
                            id: processorSection
                            anchors.fill: parent
                            anchors.margins: Theme.spacingM
                            spacing: Theme.spacingM

                            Row {
                                width: parent.width
                                spacing: Theme.spacingM

                                EHIcon {
                                    name: "memory"
                                    size: Theme.iconSize - 4
                                    color: Theme.primary
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                StyledText {
                                    text: "Processor"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Grid {
                                width: parent.width
                                columns: 2
                                columnSpacing: Theme.spacingL
                                rowSpacing: Theme.spacingM

                                StyledText {
                                    text: "Model:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                }

                                Column {
                                    spacing: 2
                                    width: parent.width - parent.children[0].width - Theme.spacingL

                                    StyledText {
                                        text: HardwareService.cpuModel || "Loading..."
                                        font.pixelSize: Theme.fontSizeMedium
                                        color: Theme.surfaceVariantText
                                        width: parent.width
                                        elide: Text.ElideRight
                                    }
                                }

                                StyledText {
                                    text: "Cores:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    visible: HardwareService.cpuCores > 0
                                }

                                StyledText {
                                    text: HardwareService.cpuCores > 0 ? HardwareService.cpuCores + " cores" : ""
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                    visible: HardwareService.cpuCores > 0
                                }

                                StyledText {
                                    text: "Threads:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    visible: HardwareService.cpuThreads > 0
                                }

                                StyledText {
                                    text: HardwareService.cpuThreads > 0 ? HardwareService.cpuThreads + " threads" : ""
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                    visible: HardwareService.cpuThreads > 0
                                }

                                StyledText {
                                    text: "Frequency:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    visible: HardwareService.cpuFrequency && HardwareService.cpuFrequency.length > 0
                                }

                                StyledText {
                                    text: HardwareService.cpuFrequency || ""
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                    visible: HardwareService.cpuFrequency && HardwareService.cpuFrequency.length > 0
                                }

                                StyledText {
                                    text: "Architecture:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    visible: HardwareService.cpuArchitecture && HardwareService.cpuArchitecture.length > 0
                                }

                                StyledText {
                                    text: HardwareService.cpuArchitecture || ""
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                    visible: HardwareService.cpuArchitecture && HardwareService.cpuArchitecture.length > 0
                                }
                            }
                        }
                    }

                    // Memory Section
                    StyledRect {
                        width: parent.width
                        height: memorySection.implicitHeight + Theme.spacingM * 2
                        radius: Theme.cornerRadius
                        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, 0.5)
                        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.1)
                        border.width: 1

                        Column {
                            id: memorySection
                            anchors.fill: parent
                            anchors.margins: Theme.spacingM
                            spacing: Theme.spacingM

                            Row {
                                width: parent.width
                                spacing: Theme.spacingM

                                EHIcon {
                                    name: "memory"
                                    size: Theme.iconSize - 4
                                    color: Theme.primary
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                StyledText {
                                    text: "Memory"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Grid {
                                width: parent.width
                                columns: 2
                                columnSpacing: Theme.spacingL
                                rowSpacing: Theme.spacingM

                                StyledText {
                                    text: "Total:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                }

                                StyledText {
                                    text: HardwareService.totalMemory || "Loading..."
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                }

                                StyledText {
                                    text: "Used:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    visible: HardwareService.usedMemory && HardwareService.usedMemory.length > 0
                                }

                                StyledText {
                                    text: HardwareService.usedMemory || ""
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                    visible: HardwareService.usedMemory && HardwareService.usedMemory.length > 0
                                }

                                StyledText {
                                    text: "Available:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    visible: HardwareService.availableMemory && HardwareService.availableMemory.length > 0
                                }

                                StyledText {
                                    text: HardwareService.availableMemory || ""
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                    visible: HardwareService.availableMemory && HardwareService.availableMemory.length > 0
                                }
                            }
                        }
                    }

                    // Graphics Section
                    StyledRect {
                        width: parent.width
                        height: graphicsSection.implicitHeight + Theme.spacingM * 2
                        radius: Theme.cornerRadius
                        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, 0.5)
                        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.1)
                        border.width: 1

                        Column {
                            id: graphicsSection
                            anchors.fill: parent
                            anchors.margins: Theme.spacingM
                            spacing: Theme.spacingM

                            Row {
                                width: parent.width
                                spacing: Theme.spacingM

                                EHIcon {
                                    name: "videocam"
                                    size: Theme.iconSize - 4
                                    color: Theme.primary
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                StyledText {
                                    text: "Graphics"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Grid {
                                width: parent.width
                                columns: 2
                                columnSpacing: Theme.spacingL
                                rowSpacing: Theme.spacingM

                                StyledText {
                                    text: "Model:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                }

                                Column {
                                    spacing: 2
                                    width: parent.width - parent.children[0].width - Theme.spacingL

                                    StyledText {
                                        text: HardwareService.gpuModel || "Loading..."
                                        font.pixelSize: Theme.fontSizeMedium
                                        color: Theme.surfaceVariantText
                                        width: parent.width
                                        elide: Text.ElideRight
                                    }
                                }

                                StyledText {
                                    text: "Driver:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    visible: HardwareService.gpuDriver && HardwareService.gpuDriver.length > 0
                                }

                                StyledText {
                                    text: HardwareService.gpuDriver || ""
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                    visible: HardwareService.gpuDriver && HardwareService.gpuDriver.length > 0
                                }
                            }
                        }
                    }

                    // Storage Section
                    StyledRect {
                        width: parent.width
                        height: storageSection.implicitHeight + Theme.spacingM * 2
                        radius: Theme.cornerRadius
                        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, 0.5)
                        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.1)
                        border.width: 1

                        Column {
                            id: storageSection
                            anchors.fill: parent
                            anchors.margins: Theme.spacingM
                            spacing: Theme.spacingM

                            Row {
                                width: parent.width
                                spacing: Theme.spacingM

                                EHIcon {
                                    name: "storage"
                                    size: Theme.iconSize - 4
                                    color: Theme.primary
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                StyledText {
                                    text: "Storage"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Grid {
                                width: parent.width
                                columns: 2
                                columnSpacing: Theme.spacingL
                                rowSpacing: Theme.spacingM

                                StyledText {
                                    text: "Total:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                }

                                StyledText {
                                    text: HardwareService.diskTotal || "Loading..."
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                }

                                StyledText {
                                    text: "Used:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    visible: HardwareService.diskUsed && HardwareService.diskUsed.length > 0
                                }

                                StyledText {
                                    text: HardwareService.diskUsed || ""
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                    visible: HardwareService.diskUsed && HardwareService.diskUsed.length > 0
                                }

                                StyledText {
                                    text: "Available:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    visible: HardwareService.diskAvailable && HardwareService.diskAvailable.length > 0
                                }

                                StyledText {
                                    text: HardwareService.diskAvailable || ""
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                    visible: HardwareService.diskAvailable && HardwareService.diskAvailable.length > 0
                                }

                                StyledText {
                                    text: "Usage:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    visible: HardwareService.diskUsagePercent && HardwareService.diskUsagePercent.length > 0
                                }

                                StyledText {
                                    text: HardwareService.diskUsagePercent || ""
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                    visible: HardwareService.diskUsagePercent && HardwareService.diskUsagePercent.length > 0
                                }
                            }
                        }
                    }

                    // System Section
                    StyledRect {
                        width: parent.width
                        height: systemSection.implicitHeight + Theme.spacingM * 2
                        radius: Theme.cornerRadius
                        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, 0.5)
                        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.1)
                        border.width: 1

                        Column {
                            id: systemSection
                            anchors.fill: parent
                            anchors.margins: Theme.spacingM
                            spacing: Theme.spacingM

                            Row {
                                width: parent.width
                                spacing: Theme.spacingM

                                EHIcon {
                                    name: "computer"
                                    size: Theme.iconSize - 4
                                    color: Theme.primary
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                StyledText {
                                    text: "System"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Grid {
                                width: parent.width
                                columns: 2
                                columnSpacing: Theme.spacingL
                                rowSpacing: Theme.spacingM

                                StyledText {
                                    text: "OS:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                }

                                StyledText {
                                    text: HardwareService.osName || "Loading..."
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                }

                                StyledText {
                                    text: "Kernel:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    visible: HardwareService.kernelVersion && HardwareService.kernelVersion.length > 0
                                }

                                StyledText {
                                    text: HardwareService.kernelVersion || ""
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                    visible: HardwareService.kernelVersion && HardwareService.kernelVersion.length > 0
                                }

                                StyledText {
                                    text: "Hostname:"
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    visible: HardwareService.hostname && HardwareService.hostname.length > 0
                                }

                                StyledText {
                                    text: HardwareService.hostname || ""
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceVariantText
                                    visible: HardwareService.hostname && HardwareService.hostname.length > 0
                                }
                            }
                        }
                    }
                }
            }
            
            // Actions Row (Optional buttons)
            RowLayout {
                width: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.spacingM
                
                Item { Layout.fillWidth: true } // Spacer

                Rectangle {
                    Layout.preferredHeight: 36
                    Layout.preferredWidth: refreshRow.implicitWidth + Theme.spacingL
                    color: refreshMouseArea.containsMouse ? Theme.surfaceVariantAlpha : Theme.surfaceHover
                    radius: Theme.cornerRadius

                    RowLayout {
                        id: refreshRow
                        anchors.centerIn: parent
                        spacing: Theme.spacingS

                        EHIcon {
                            name: "refresh"
                            size: 16
                            color: Theme.primary
                        }

                        StyledText {
                            text: "Refresh Info"
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.primary
                            font.weight: Font.Medium
                        }
                    }

                    MouseArea {
                        id: refreshMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            UserInfoService.refreshUserInfo()
                            HardwareService.refreshAll()
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.shortDuration
                            easing.type: Theme.standardEasing
                        }
                    }
                }
            }
        }
    }
}