pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Common

Scope {
  id: root
  property ShellScreen focusedScreen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) 
  property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
  property real spacing: 8
  property int columns: 5
  property int rows: 2
  property real contentWidth: (focusedMonitor?.width / focusedMonitor?.scale) / 1.5
  property real tileWidth: (contentWidth - spacing * (columns + 1)) / columns
  property real tileHeight: tileWidth * 9 / 16

  signal overviewClicked

  
  PanelWindow {
    id: overviewWindow
    screen: root.focusedScreen
    color: "transparent"

    implicitWidth: contentWidth
    implicitHeight: tileHeight * rows + spacing * (rows + 1)

    // mask: Region { item: Rectangle {anchors.fill: parent} }
    
    Rectangle { 
      id: overviewWindowRect
      color: Theme.surfaceContainer
      opacity: SettingsData.workspaceOverviewOpacity
      anchors.fill: parent
      radius: Theme.cornerRadius
      GridLayout {
        id: overviewLayout
        anchors.fill: parent
        anchors.margins: spacing

        columns: root.columns
        rows: root.rows
        rowSpacing: 8
        columnSpacing: 8

        Repeater {
          model: root.rows * root.columns
          WorkspaceView {
            parentWindow: overviewWindowRect
            implicitWidth: root.tileWidth 
            implicitHeight: root.tileHeight
            onAppClicked: function() {
              root.overviewClicked()
            }

            DropArea {
              anchors.fill: parent
              onDropped: function(drag) { 
                var address = drag.source.address
                Hyprland.dispatch(
                  "movetoworkspacesilent " +
                  (index + 1) +
                  ", address:" +
                  address
                )
                Hyprland.refreshWorkspaces()
                Hyprland.refreshMonitors()
                Hyprland.refreshToplevels()
              }
            }
          }
        }
      }
    }
  }
}
