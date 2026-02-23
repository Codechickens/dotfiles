pragma ComponentBehavior: Bound

import qs.Common
import Quickshell
import Quickshell.Hyprland
import QtQuick
import Quickshell.Wayland
import Quickshell.Widgets

ClippingRectangle {
  visible: true 
  id: root
  required property int index
  required property Item parentWindow
  property int workspaceId: index + 1
  property HyprlandWorkspace wsp: Hyprland.workspaces.values.find(s => s.id == workspaceId) || null 
  property real scaleFactor: (wsp?.monitor) ? ((wsp.monitor.width / wsp.monitor.scale) / implicitWidth) : -1
  color: "transparent"
  border {
    width: 2
    color: Theme.surfaceContainerHigh
  }
  radius: Theme.cornerRadius

  signal appClicked

  Connections {
    target: (root.wsp) ? root.wsp?.toplevels : null
    function onObjectInsertedPost() { Hyprland.refreshToplevels() }
    function onObjectRemovedPre() { Hyprland.refreshToplevels() }
    function onObjectRemovedPost() { Hyprland.refreshToplevels() }
    function onObjectInsertedPre() {Hyprland.refreshToplevels() }
  }

  Text {
    font.pixelSize: Theme.fontSizeMedium
    font.family: SettingsData.fontFamily
    color: Theme.primary
    text: root.workspaceId
    anchors.centerIn: parent
  }

  Repeater {
    model: (root.wsp) ? root.wsp.toplevels : []
    ScreencopyView {
      id: scView
      required property HyprlandToplevel modelData
      property string address: modelData.lastIpcObject.address ? modelData.lastIpcObject.address : null
      captureSource: modelData.wayland
      live: true 
      x: (modelData.lastIpcObject.at && root.wsp?.monitor) ? ((modelData.lastIpcObject.at[0] - root.wsp.monitor.x) / root.scaleFactor) : 0
      y: (modelData.lastIpcObject.at && root.wsp?.monitor) ? ((modelData.lastIpcObject.at[1] - root.wsp.monitor.y) / root.scaleFactor) : 0
      width: (modelData.lastIpcObject.size && root.wsp) ? ((modelData.lastIpcObject.size[0]) / root.scaleFactor) : 0
      height: (modelData.lastIpcObject.size && root.wsp) ? ((modelData.lastIpcObject.size[1]) / root.scaleFactor) : 0

      Component.onCompleted: Hyprland.refreshToplevels()

      DragHandler {
        id: dragHandler
        target: scView
        onActiveChanged: {
          if (!active) { 
            target.Drag.drop()
            
          }
        }
      }

      Drag.active: dragHandler.active
      Drag.source: scView
      Drag.supportedActions: Qt.MoveAction
      Drag.hotSpot.x: width / 2
      Drag.hotSpot.y: height / 2

      TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: function(eventPoint, button) {
          // Switch to the workspace first
          Hyprland.dispatch("workspace " + root.workspaceId)
          // Focus the window
          Hyprland.dispatch("focuswindow address:" + scView.address)
          // Move cursor to the window's center position on the actual monitor
          if (modelData.lastIpcObject.at && root.wsp?.monitor) {
            var windowX = modelData.lastIpcObject.at[0]
            var windowY = modelData.lastIpcObject.at[1]
            var windowWidth = modelData.lastIpcObject.size ? modelData.lastIpcObject.size[0] : 0
            var windowHeight = modelData.lastIpcObject.size ? modelData.lastIpcObject.size[1] : 0
            var cursorX = windowX + windowWidth / 2
            var cursorY = windowY + windowHeight / 2
            Hyprland.dispatch("movecursor " + Math.round(cursorX) + " " + Math.round(cursorY))
          }
          // Emit signal to close the overview
          root.appClicked()
        }
      }

      states: [
        State {
          when: dragHandler.active
          ParentChange {
            target: scView
            parent: root.parentWindow 
          }
        }
      ]
    }
  }
}
