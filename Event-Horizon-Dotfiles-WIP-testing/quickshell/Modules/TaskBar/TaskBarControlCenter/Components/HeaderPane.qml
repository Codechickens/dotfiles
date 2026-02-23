import QtQuick
import Qt5Compat.GraphicalEffects
import qs.Common
import qs.Services
import qs.Widgets

Rectangle {
    id: root

    property bool powerOptionsExpanded: false
    property bool editMode: false

    signal powerActionRequested(string action, string title, string message)
    signal lockRequested()
    signal editModeToggled()

    implicitHeight: 60
    radius: Theme.cornerRadius
    
    // Compact dock-style background
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
        anchors.rightMargin: Theme.spacingS
        spacing: Theme.spacingS

        EHCircularImage {
            id: avatarContainer
            width: 44
            height: 44
            imageSource: {
                if (PortalService.profileImage === "")
                    return ""

                if (PortalService.profileImage.startsWith("/"))
                    return "file://" + PortalService.profileImage

                return PortalService.profileImage
            }
            fallbackIcon: "settings"
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1

            StyledText {
                text: UserInfoService.fullName || UserInfoService.username || "User"
                font.pixelSize: 14
                color: Theme.surfaceText
            }

            StyledText {
                text: (UserInfoService.uptime || "Unknown")
                font.pixelSize: 12
                color: Theme.surfaceVariantText
            }
        }
    }

    // Compact dock-style action buttons
    Row {
        id: actionButtonsRow
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: Theme.spacingXS
        spacing: Theme.spacingXS

        Rectangle {
            width: 36
            height: 36
            radius: 8
            color: lockArea.containsMouse ? Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.4) : "transparent"
            border.width: 0

            EHIcon {
                anchors.centerIn: parent
                name: "lock"
                size: 18
                color: Theme.surfaceText
            }

            MouseArea {
                id: lockArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.lockRequested()
            }
        }

        Rectangle {
            width: 36
            height: 36
            radius: 8
            color: powerArea.containsMouse ? Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.4) : (root.powerOptionsExpanded ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.2) : "transparent")
            border.width: 0

            EHIcon {
                anchors.centerIn: parent
                name: root.powerOptionsExpanded ? "expand_less" : "power_settings_new"
                size: 18
                color: root.powerOptionsExpanded ? Theme.primary : Theme.surfaceText
            }

            MouseArea {
                id: powerArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.powerOptionsExpanded = !root.powerOptionsExpanded
            }
        }

        Rectangle {
            width: 36
            height: 36
            radius: 8
            color: settingsArea.containsMouse ? Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.4) : "transparent"
            border.width: 0

            EHIcon {
                anchors.centerIn: parent
                name: "settings"
                size: 18
                color: Theme.surfaceText
            }

            MouseArea {
                id: settingsArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: settingsModal.show()
            }
        }

        Rectangle {
            width: 36
            height: 36
            radius: 8
            color: editArea.containsMouse ? Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.4) : (root.editMode ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.2) : "transparent")
            border.width: 0

            EHIcon {
                anchors.centerIn: parent
                name: root.editMode ? "done" : "edit"
                size: 18
                color: root.editMode ? Theme.primary : Theme.surfaceText
            }

            MouseArea {
                id: editArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.editModeToggled()
            }
        }
    }
}
