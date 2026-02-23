import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Dock.DockControlCenter.Components
import qs.Modules.Dock.DockControlCenter.Models

/**
 * ControlCenterPopout - A control center popout using TopBarTrayContextMenu positioning approach
 *
 * This component provides control center functionality with positioning logic
 * adapted from TopBarTrayContextMenu for consistent behavior across the dock.
 */
Item {
    id: root

    // Control Center specific properties
    property string expandedSection: ""
    property bool powerOptionsExpanded: false
    property bool editMode: false
    property int expandedWidgetIndex: -1

    // Positioning properties (adapted from TopBarTrayContextMenu)
    property string barPosition: "bottom"  // "top", "bottom", "left", "right"
    property real barThickness: 48
    property real popupDistance: 8

    // State
    property bool showMenu: false
    property var parentScreen: null

    signal powerActionRequested(string action, string title, string message)
    signal lockRequested

    function toggle() {
        if (showMenu) {
            close()
        } else {
            open()
        }
    }

    function open() {
        showMenu = true
    }

    function close() {
        showMenu = false
    }

    function showContextMenu(x, y, screen) {
        // Could implement a context menu for quick settings
    }

    WidgetModel {
        id: widgetModel
    }

    PanelWindow {
        id: menuWindow
        visible: root.showMenu
        WlrLayershell.namespace: "quickshell:dock:blur"
        WlrLayershell.layer: WlrLayershell.Top
        WlrLayershell.exclusiveZone: -1
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        color: "transparent"
        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        property point anchorPos: Qt.point(screen.width / 2, screen.height / 2)

        onVisibleChanged: {
            if (visible) {
                updatePosition()
            }
        }

        function updatePosition() {
            if (!root.parentScreen) {
                anchorPos = Qt.point(screen.width / 2, screen.height / 2)
                return
            }

            const screenX = screen.x || 0
            const screenY = screen.y || 0
            const scale = screen.devicePixelRatio || 1
            const scaledBarThickness = root.barThickness * scale

            let targetX, targetY

            if (root.barPosition === "top") {
                targetX = screenX + screen.width / 2
                targetY = screenY + scaledBarThickness + root.popupDistance + 15
            } else if (root.barPosition === "bottom") {
                targetX = screenX + screen.width / 2
                targetY = screenY + screen.height - scaledBarThickness - root.popupDistance - 15
            } else if (root.barPosition === "left") {
                targetX = screenX + scaledBarThickness + root.popupDistance + 15
                targetY = screenY + screen.height / 2
            } else if (root.barPosition === "right") {
                targetX = screenX + screen.width - scaledBarThickness - root.popupDistance - 15
                targetY = screenY + screen.height / 2
            } else {
                targetX = screenX + screen.width / 2
                targetY = screenY + screen.height / 2
            }

            anchorPos = Qt.point(targetX, targetY)
        }

        Rectangle {
            id: menuContainer
            width: Math.min(700, Math.max(500, menuColumn.implicitWidth + Theme.spacingM * 2))
            height: Math.max(100, menuColumn.implicitHeight + Theme.spacingM * 2)

            onWidthChanged: menuWindow.updatePosition()
            onHeightChanged: menuWindow.updatePosition()

            x: {
                const left = 10
                const right = menuWindow.screen.width - width - 10
                const want = menuWindow.anchorPos.x - width / 2
                return Math.max(left, Math.min(right, want))
            }

            y: {
                if (root.barPosition === "top") {
                    return Math.max(10, menuWindow.anchorPos.y)
                } else if (root.barPosition === "bottom") {
                    return Math.min(menuWindow.screen.height - height - 10, menuWindow.anchorPos.y - height)
                }
                const top = 10
                const bottom = menuWindow.screen.height - height - 10
                const want = menuWindow.anchorPos.y - height / 2
                return Math.max(top, Math.min(bottom, want))
            }

            color: Qt.rgba(
                Theme.surfaceContainer.r,
                Theme.surfaceContainer.g,
                Theme.surfaceContainer.b,
                Math.max(0.5, SettingsData.controlCenterTransparency || 0.85)
            )
            radius: Theme.cornerRadius
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.15)
            border.width: 1
            antialiasing: true
            smooth: true
            opacity: root.showMenu ? 1 : 0
            scale: root.showMenu ? 1 : 0.9

            Column {
                id: menuColumn
                width: parent.width - Theme.spacingM * 2
                x: Theme.spacingM
                y: Theme.spacingM
                spacing: Theme.spacingM

                HeaderPane {
                    id: headerPane
                    width: parent.width
                    powerOptionsExpanded: root.powerOptionsExpanded
                    editMode: root.editMode
                    onPowerOptionsExpandedChanged: root.powerOptionsExpanded = powerOptionsExpanded
                    onEditModeToggled: root.editMode = !root.editMode
                    onPowerActionRequested: (action, title, message) => {
                        root.powerActionRequested(action, title, message)
                    }
                    onLockRequested: {
                        root.close()
                        root.lockRequested()
                    }
                }

                PowerOptionsPane {
                    id: powerOptionsPane
                    width: parent.width
                    expanded: root.powerOptionsExpanded
                    onPowerActionRequested: (action, title, message) => {
                        root.powerOptionsExpanded = false
                        root.close()
                        root.powerActionRequested(action, title, message)
                    }
                }

                WidgetGrid {
                    id: widgetGrid
                    width: parent.width
                    editMode: root.editMode
                    expandedSection: root.expandedSection
                    expandedWidgetIndex: root.expandedWidgetIndex
                    model: widgetModel
                    onExpandClicked: (widgetData, globalIndex, x, y, width, height) => {
                        root.expandedWidgetIndex = globalIndex
                        root.toggleSection(widgetData.id)
                    }
                    onRemoveWidget: (index) => widgetModel.removeWidget(index)
                    onMoveWidget: (fromIndex, toIndex) => widgetModel.moveWidget(fromIndex, toIndex)
                    onToggleWidgetSize: (index) => widgetModel.toggleWidgetSize(index)
                }

                EditControls {
                    width: parent.width
                    visible: root.editMode
                    availableWidgets: {
                        const existingIds = (SettingsData.controlCenterWidgets || []).map(w => w.id)
                        return widgetModel.baseWidgetDefinitions.filter(w => !existingIds.includes(w.id))
                    }
                    onAddWidget: (widgetId) => widgetModel.addWidget(widgetId)
                    onResetToDefault: () => widgetModel.resetToDefault()
                    onClearAll: () => widgetModel.clearAll()
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: Theme.mediumDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: Theme.mediumDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: root.close()
        }
    }

    function toggleSection(section) {
        if (root.expandedSection === section) {
            root.expandedSection = ""
            root.expandedWidgetIndex = -1
        } else {
            root.expandedSection = section
        }
    }
}
