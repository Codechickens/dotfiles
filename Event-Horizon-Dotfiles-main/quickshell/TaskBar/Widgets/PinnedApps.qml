import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.BottomPanel

Item {
    id: root

    property string section: "left"
    property var parentScreen: null
    property real widgetHeight: 30
    property var contextMenu: null
    property real iconSize: SettingsData.taskbarIconSize * SettingsData.taskbarScale
    property real iconSpacing: SettingsData.taskbarIconSpacing * SettingsData.taskbarScale

    implicitWidth: taskBarApps.implicitWidth
    implicitHeight: taskBarApps.implicitHeight
    width: implicitWidth
    height: implicitHeight

    TaskBarApps {
        id: taskBarApps
        widgetHeight: root.widgetHeight
        iconSize: root.iconSize
        iconSpacing: root.iconSpacing
        contextMenu: root.contextMenu
    }
}
