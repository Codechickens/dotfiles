import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Common
import qs.Modules.ControlCenter
import qs.Modules.ControlCenter.Widgets
import qs.Modules.ControlCenter.Details
import qs.Modules.TopBar
import qs.Services
import qs.Widgets
import qs.Modules.ControlCenter.Components
import qs.Modules.ControlCenter.Models
import "./utils/state.js" as StateUtils

EHPopout {
    id: root
    objectName: "controlCenterPopout"

    backgroundColor: "transparent"
    WlrLayershell.namespace: "quickshell:dock:blur"

    // Default bar properties (will be overridden by buttons)
    barPosition: SettingsData?.topBarPosition || "bottom"
    
    // Bind to SettingsData for auto-fit width detection
    autoFitWidth: SettingsData?.topBarAutoFit || false

    property string expandedSection: ""
    property bool powerOptionsExpanded: false
    property string triggerSection: "right"
    property var triggerScreen: null
    property bool editMode: false
    property int expandedWidgetIndex: -1

    signal powerActionRequested(string action, string title, string message)
    signal lockRequested

    function setTriggerPosition(x, y, width, section, screen) {
        StateUtils.setTriggerPosition(root, x, y, width, section, screen)
    }

    function openWithSection(section) {
        StateUtils.openWithSection(root, section)
    }

    function toggleSection(section) {
        StateUtils.toggleSection(root, section)
    }

    readonly property bool isBarVertical: SettingsData.topBarPosition === "left" || SettingsData.topBarPosition === "right"
    
    readonly property real basePopupWidth: 470
    popupWidth: basePopupWidth * Theme.getControlScaleFactor() * (SettingsData.controlCenterScale || 1.0)
    popupHeight: Math.min(
        (triggerScreen?.height ?? 1080) * 0.75,  // Cap at 75% of screen height
        (contentLoader.item && contentLoader.item.implicitHeight > 0 ? contentLoader.item.implicitHeight + 16 : 600) * (SettingsData.controlCenterScale || 1.0)
    )
    
    property bool _triggerPositionSet: false
    property real _calculatedTriggerX: 0
    property real _calculatedTriggerY: 0
    
    triggerX: _calculatedTriggerX
    triggerY: _calculatedTriggerY
    triggerWidth: 80
    positioning: "center"
    shouldBeVisible: false
    visible: shouldBeVisible

    onShouldBeVisibleChanged: {
        if (shouldBeVisible) {
            Qt.callLater(() => {
                NetworkService.autoRefreshEnabled = NetworkService.wifiEnabled
                if (UserInfoService)
                    UserInfoService.getUptime()
                // Ensure volume mixer always has width 100 (full row = both left and right spots)
                const widgets = SettingsData.controlCenterWidgets || []
                let needsUpdate = false
                const updatedWidgets = widgets.map(function(w) {
                    if (w.id === "volumeMixer" && w.width !== 100) {
                        needsUpdate = true
                        const newWidget = {}
                        for (var key in w) {
                            newWidget[key] = w[key]
                        }
                        newWidget.width = 100
                        return newWidget
                    }
                    return w
                })
                if (needsUpdate) {
                    SettingsData.setControlCenterWidgets(updatedWidgets)
                }
            })
        } else {
            Qt.callLater(() => {
                NetworkService.autoRefreshEnabled = false
                // Safely stop Bluetooth discovery if it's running
                try {
                    if (BluetoothService.adapter && BluetoothService.adapter.discovering) {
                    BluetoothService.adapter.discovering = false
                    }
                } catch (e) {
                    // Discovery was already stopped or adapter changed state
                    console.debug("Bluetooth discovery stop skipped:", e.message)
                }
                editMode = false
            })
        }
    }

    WidgetModel {
        id: widgetModel
    }

    content: Component {
        Rectangle {
            id: controlContent

            implicitHeight: mainColumn.implicitHeight + Theme.spacingM * 2
            property alias bluetoothCodecSelector: bluetoothCodecSelector

            // Minimal dock-style background
            color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, Math.max(0.5, SettingsData.controlCenterTransparency || 0.85))
            radius: Theme.cornerRadius
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.15)
            border.width: 1
            antialiasing: true
            smooth: true

            Column {
                id: mainColumn
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
                    onPowerActionRequested: (action, title, message) => root.powerActionRequested(action, title, message)
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
                    visible: editMode
                    availableWidgets: {
                        const existingIds = (SettingsData.controlCenterWidgets || []).map(w => w.id)
                        return widgetModel.baseWidgetDefinitions.filter(w => !existingIds.includes(w.id))
                    }
                    onAddWidget: (widgetId) => widgetModel.addWidget(widgetId)
                    onResetToDefault: () => widgetModel.resetToDefault()
                    onClearAll: () => widgetModel.clearAll()
                }
            }

            BluetoothCodecSelector {
                id: bluetoothCodecSelector
                anchors.fill: parent
                z: 10000
            }
        }
    }

    Component {
        id: networkDetailComponent
        NetworkDetail {}
    }

    Component {
        id: bluetoothDetailComponent
        BluetoothDetail {
            id: bluetoothDetail
            onShowCodecSelector: function(device) {
                if (contentLoader.item && contentLoader.item.bluetoothCodecSelector) {
                    contentLoader.item.bluetoothCodecSelector.show(device)
                    contentLoader.item.bluetoothCodecSelector.codecSelected.connect(function(deviceAddress, codecName) {
                        bluetoothDetail.updateDeviceCodecDisplay(deviceAddress, codecName)
                    })
                }
            }
        }
    }

    Component {
        id: audioOutputDetailComponent
        AudioOutputDetail {}
    }

    Component {
        id: audioInputDetailComponent
        AudioInputDetail {}
    }

    Component {
        id: batteryDetailComponent
        BatteryDetail {}
    }
}
