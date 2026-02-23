import QtQuick
import Qt5Compat.GraphicalEffects
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root

    property bool expanded: false

    signal powerActionRequested(string action, string title, string message)

    implicitHeight: expanded ? 56 : 0
    height: implicitHeight
    clip: true

    Behavior on height {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    // Compact dock-style background
    Rectangle {
        width: parent.width
        height: 56
        radius: Theme.cornerRadius
        color: {
            const alpha = Theme.getContentBackgroundAlpha() * 0.3
            return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, alpha)
        }
        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
        border.width: 1
        opacity: root.expanded ? 1 : 0
        clip: true

        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }

        // Compact dock-style row layout
        Row {
            anchors.centerIn: parent
            spacing: Theme.spacingXS
            visible: root.expanded

            PowerButton {
                width: SessionService.hibernateSupported ? 80 : 90
                height: 40
                iconName: "logout"
                text: "Logout"
                onPressed: root.powerActionRequested("logout", "Logout", "Are you sure you want to logout?")
            }

            PowerButton {
                width: SessionService.hibernateSupported ? 80 : 90
                height: 40
                iconName: "restart_alt"
                text: "Restart"
                onPressed: root.powerActionRequested("reboot", "Restart", "Are you sure you want to restart?")
            }

            PowerButton {
                width: 100
                height: 40
                iconName: "bedtime"
                text: "Suspend"
                onPressed: root.powerActionRequested("suspend", "Suspend", "Are you sure you want to suspend?")
            }

            PowerButton {
                width: 100
                height: 40
                iconName: "ac_unit"
                text: "Hibernate"
                visible: SessionService.hibernateSupported
                onPressed: root.powerActionRequested("hibernate", "Hibernate", "Are you sure you want to hibernate?")
            }

            PowerButton {
                width: 100
                height: 40
                iconName: "power_settings_new"
                text: "Shutdown"
                onPressed: root.powerActionRequested("poweroff", "Shutdown", "Are you sure you want to shutdown?")
            }
        }
    }
}
