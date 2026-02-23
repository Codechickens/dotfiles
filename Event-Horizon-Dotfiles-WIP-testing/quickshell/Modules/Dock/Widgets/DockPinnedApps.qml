import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Dock

Item {
    id: root

    property string section: "left"
    property var parentScreen: null
    property real widgetHeight: 30
    property var contextMenu: null
    property real iconSize: SettingsData.taskbarIconSize * SettingsData.taskbarScale
    property real iconSpacing: SettingsData.taskbarIconSpacing * SettingsData.taskbarScale
    property bool pillEnabled: SettingsData.dockPinnedAppsPillEnabled

    implicitWidth: pillEnabled ? pillBackground.implicitWidth : dockApps.implicitWidth
    implicitHeight: pillEnabled ? pillBackground.implicitHeight : dockApps.implicitHeight
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

        implicitWidth: dockApps.implicitWidth + 16
        implicitHeight: dockApps.implicitHeight

        DockApps {
            id: dockApps
            anchors.centerIn: parent
            widgetHeight: root.widgetHeight
            iconSize: root.iconSize
            iconSpacing: root.iconSpacing
            contextMenu: root.contextMenu
        }
    }

    DockApps {
        id: dockAppsNoPill
        anchors.fill: parent
        visible: !root.pillEnabled
        widgetHeight: root.widgetHeight
        iconSize: root.iconSize
        iconSpacing: root.iconSpacing
        contextMenu: root.contextMenu
    }
}
