import QtQuick
import Quickshell
import qs.Common
import qs.Widgets

Item {
    id: root

    property real widgetHeight: 40
    property var parentScreen: null
    property bool pillEnabled: SettingsData.dockLaunchpadPillEnabled

    readonly property real horizontalPadding: Math.max(Theme.spacingXS, Theme.spacingS * (widgetHeight / 30))

    implicitWidth: pillEnabled ? pillBackground.implicitWidth : launchpadIcon.width
    implicitHeight: pillEnabled ? pillBackground.implicitHeight : launchpadIcon.height
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        id: pillBackground
        anchors.fill: parent
        visible: root.pillEnabled
        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, SettingsData.dockWidgetAreaOpacity)
        radius: Theme.cornerRadius
        border.width: 0
        border.color: "transparent"
        clip: true

        implicitWidth: launchpadIcon.width + 16
        implicitHeight: root.widgetHeight

        Image {
            id: launchpadIconPill
            anchors.centerIn: parent
            source: Qt.resolvedUrl("../../assets/Dark_Launchpad.svg")
            width: 48 * (widgetHeight / 40)
            height: 48 * (widgetHeight / 40)
            smooth: true
            fillMode: Image.PreserveAspectFit
            mipmap: true
        }

        MouseArea {
            id: launchpadAreaPill
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton
            onClicked: root.openLaunchpad()
        }
    }

    Image {
        id: launchpadIcon
        visible: !root.pillEnabled
        anchors.centerIn: parent
        source: Qt.resolvedUrl("../../assets/Dark_Launchpad.svg")
        width: 48 * (widgetHeight / 40)
        height: 48 * (widgetHeight / 40)
        smooth: true
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }

    MouseArea {
        id: launchpadArea
        visible: !root.pillEnabled
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onClicked: root.openLaunchpad()
    }

    function getLaunchpadLoader() {
        let current = root
        while (current) {
            if (current.launchpadLoader) {
                return current.launchpadLoader
            }
            current = current.parent
        }

        if (typeof launchpadLoader !== "undefined") {
            return launchpadLoader
        }

        return null
    }

    function openLaunchpad() {
        const loader = getLaunchpadLoader()
        if (!loader) {
            return
        }

        loader.active = true
        if (loader.item) {
            loader.item.targetScreen = parentScreen || (root.Window && root.Window.window ? root.Window.window.screen : Screen)
            if (loader.item.show) {
                loader.item.show()
            }
        }
    }
}
