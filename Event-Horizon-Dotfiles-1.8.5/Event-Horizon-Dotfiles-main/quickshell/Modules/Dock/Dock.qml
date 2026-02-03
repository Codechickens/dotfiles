import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.Common
import qs.Services
import qs.Widgets
import "../../Common/MonitorUtils.js" as MonitorUtils

PanelWindow {
    id: dock

    WlrLayershell.namespace: "quickshell:dock:blur"

    WlrLayershell.layer: WlrLayershell.Top
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    property var modelData
    property var contextMenu
    property bool autoHide: SettingsData.dockAutoHide
    property real backgroundTransparency: SettingsData.dockTransparency
    readonly property bool isVertical: SettingsData.dockPosition === "left" || SettingsData.dockPosition === "right"

    property bool contextMenuOpen: (contextMenu && contextMenu.visible && contextMenu.screen === modelData)
    property bool windowIsFullscreen: {
        if (!SettingsData.dockHideOnGames || !ToplevelManager.activeToplevel) {
            return false
        }
        const activeWindow = ToplevelManager.activeToplevel
        const fullscreenApps = ["vlc", "mpv", "kodi", "steam", "lutris", "wine", "dosbox"]
        return fullscreenApps.some(app => activeWindow.appId && activeWindow.appId.toLowerCase().includes(app))
    }
    property bool reveal: (!autoHide || dockMouseArea.containsMouse || contextMenuOpen) && !windowIsFullscreen
    readonly property bool hasLeftWidgets: SettingsData.dockWidgetsEnabled && SettingsData.dockLeftWidgetsModel && SettingsData.dockLeftWidgetsModel.count > 0
    readonly property bool hasRightWidgets: SettingsData.dockWidgetsEnabled && SettingsData.dockRightWidgetsModel && SettingsData.dockRightWidgetsModel.count > 0

    Component.onCompleted: {
    }

    Connections {
        target: SettingsData
        function onDockTransparencyChanged() {
            dock.backgroundTransparency = SettingsData.dockTransparency
        }
    }

    Connections {
        target: Theme
        function onColorUpdateTriggerChanged() {
        }
    }

    screen: modelData
    visible: SettingsData.showDock
    color: "transparent"

    anchors {
        bottom: true
        left: true
        right: true
    }

    margins {
        left: 0
        right: 0
        bottom: SettingsData.dockBottomGap
    }

    readonly property var currentScreenInfo: {
        for (var i = 0; i < Quickshell.screens.length; i++) {
            if (Quickshell.screens[i].name === screen.name) {
                return Quickshell.screens[i]
            }
        }
        return Quickshell.screens.length > 0 ? Quickshell.screens[0] : {width: 1920, height: 1080}
    }

    readonly property real maxDockWidth: Math.min(currentScreenInfo.width * 0.8, 1200)
    implicitHeight: Math.min(100 * SettingsData.dockScale, maxDockWidth * 0.5)
    
    readonly property var monitorInfo: {
        if (!currentScreenInfo) return null
        return {
            width: currentScreenInfo.width || 1920,
            height: currentScreenInfo.height || 1080,
            transform: 0
        }
    }
    readonly property real effectiveBarHeight: SettingsData.dockIconSize * SettingsData.dockScale + SettingsData.dockIconSpacing * 2
    
    readonly property real calculatedExclusiveZone: {
        if (autoHide) return -1
        if (!monitorInfo || !SettingsData.dockUseDynamicZones) {
            return SettingsData.dockExclusiveZone * SettingsData.dockScale + SettingsData.dockBottomGap + (SettingsData.dockTopPadding * 2 * Math.sqrt(SettingsData.dockScale))
        }
        var optimalZone = MonitorUtils.calculateOptimalReservedZone(monitorInfo, "dock")
        return optimalZone * SettingsData.dockScale + SettingsData.dockBottomGap + (SettingsData.dockTopPadding * 2 * Math.sqrt(SettingsData.dockScale))
    }
    
    exclusiveZone: calculatedExclusiveZone

    mask: Region {
        item: dockMouseArea
    }

    MouseArea {
        id: dockMouseArea

        height: dock.reveal ? (65 * SettingsData.dockScale + (SettingsData.dockTopPadding + SettingsData.dockBottomPadding) * Math.sqrt(SettingsData.dockScale)) : SettingsData.dockCollapsedHeight
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        
        x: SettingsData.dockExpandToScreen ? 0 : leftWidgetArea.width + 8
        width: SettingsData.dockExpandToScreen ? parent.width : parent.width - leftWidgetArea.width - 8
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        propagateComposedEvents: true
        preventStealing: false
        
        onPressed: mouse.accepted = false
        onReleased: mouse.accepted = false
        onClicked: mouse.accepted = false

        Behavior on height {
            NumberAnimation {
                duration: SettingsData.dockAnimationDuration
                easing.type: Easing.OutCubic
            }
        }

        Item {
            id: dockContainer
            anchors.fill: parent

            transform: Translate {
                id: dockSlide
                y: dock.reveal ? 0 : SettingsData.dockSlideDistance

                Behavior on y {
                    NumberAnimation {
                        duration: SettingsData.dockAnimationDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Rectangle {
                id: dockBackground
                objectName: "dockBackground"
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }

                width: {
                    if (SettingsData.dockExpandToScreen) {
                        return parent.width - 16
                    } else {
                        const appsWidth = centerWidgets.implicitWidth || 0
                        const leftWidgetAreaWidth = leftWidgetArea.width || 0
                        const rightWidgetAreaWidth = rightWidgetArea.width || 0
                        const spacing = 8 + 8 + 8 + 8
                        const padding = 12
                        const totalPadding = SettingsData.dockLeftPadding * 2 * Math.sqrt(SettingsData.dockScale)
                        return appsWidth + leftWidgetAreaWidth + rightWidgetAreaWidth + spacing + padding + totalPadding
                    }
                }

                height: parent.height - 8 + (SettingsData.dockTopPadding * 2 * Math.sqrt(SettingsData.dockScale))

                anchors.topMargin: 4
                anchors.bottomMargin: 1

                color: {
                    var baseColor = Theme.surfaceContainer
                    return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, backgroundTransparency)
                }
                radius: SettingsData.dockBorderEnabled ? SettingsData.dockBorderRadius : Theme.cornerRadius
                border.width: SettingsData.dockBorderEnabled ? SettingsData.dockBorderWidth : 0
                border.color: {
                    if (!SettingsData.dockBorderEnabled) {
                        return "transparent"
                    }
                    if (SettingsData.dockDynamicBorderColors && Theme.currentTheme === Theme.dynamic) {
                        return Theme.primary
                    }
                    return Qt.rgba(SettingsData.dockBorderRed, SettingsData.dockBorderGreen, SettingsData.dockBorderBlue, SettingsData.dockBorderAlpha)
                }
                layer.enabled: true

                Rectangle {
                    anchors.fill: parent
                    color: {
                        var baseColor = Theme.surfaceTint
                        return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, SettingsData.dockBackgroundTintOpacity)
                    }
                    radius: parent.radius
                }

                Rectangle {
                    id: leftWidgetArea
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height - 8
                    width: hasLeftWidgets ? Math.max(SettingsData.dockLeftWidgetAreaMinWidth, leftWidgets.implicitWidth + 16) : 0
                    radius: 0
                    color: "transparent"
                    border.width: 0
                    border.color: "transparent"
                    z: 10
                    visible: !SettingsData.dockExpandToScreen && hasLeftWidgets
                    
                    Behavior on width {
                        NumberAnimation {
                            duration: SettingsData.dockAnimationDuration
                            easing.type: Easing.OutCubic
                        }
                    }
                    
                    Connections {
                        target: SettingsData
                        function onWidgetDataChanged() {
                            Qt.callLater(() => {
                                leftWidgets.visible = false
                                Qt.callLater(() => {
                                    leftWidgets.visible = true
                                })
                            })
                        }
                    }
                    
                    Connections {
                        target: MprisController
                        function onActivePlayerChanged() {
                            if (MprisController.activePlayer === null) {
                                Qt.callLater(() => {
                                    leftWidgets.visible = false
                                    Qt.callLater(() => {
                                        leftWidgets.visible = true
                                    })
                                })
                            }
                        }
                    }

                    DockWidgets {
                        id: leftWidgets
                        anchors.centerIn: parent
                        height: parent.height - 8
                        widgetList: SettingsData.dockLeftWidgetsModel
                        side: "left"
                        contextMenu: dock.contextMenu
                        z: 11
                        
                        Component.onCompleted: {
                        }
                    }
                }


                Rectangle {
                    id: rightWidgetArea
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height - 8
                    width: hasRightWidgets ? Math.max(SettingsData.dockRightWidgetAreaMinWidth, rightWidgets.implicitWidth + 16) : 0
                    radius: 0
                    color: "transparent"
                    border.width: 0
                    border.color: "transparent"
                    visible: !SettingsData.dockExpandToScreen && hasRightWidgets
                    
                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }
                    
                    Connections {
                        target: SettingsData
                        function onWidgetDataChanged() {
                            Qt.callLater(() => {
                                rightWidgets.visible = false
                                Qt.callLater(() => {
                                    rightWidgets.visible = true
                                })
                            })
                        }
                    }
                    
                    Connections {
                        target: MprisController
                        function onActivePlayerChanged() {
                            if (MprisController.activePlayer === null) {
                                Qt.callLater(() => {
                                    rightWidgets.visible = false
                                    Qt.callLater(() => {
                                        rightWidgets.visible = true
                                    })
                                })
                            }
                        }
                    }

                    DockWidgets {
                        id: rightWidgets
                        anchors.centerIn: parent
                        height: parent.height - 8
                        widgetList: SettingsData.dockRightWidgetsModel
                        side: "right"
                        contextMenu: dock.contextMenu
                        
                        Component.onCompleted: {
                        }
                    }
                }

                Item {
                    id: mainDockContainer
                    anchors.left: SettingsData.dockExpandToScreen ? parent.left : leftWidgetArea.right
                    anchors.leftMargin: SettingsData.dockExpandToScreen ? 8 : 12
                    anchors.right: SettingsData.dockExpandToScreen ? parent.right : rightWidgetArea.left
                    anchors.rightMargin: SettingsData.dockExpandToScreen ? 8 : 12
                    anchors.top: parent.top
                    anchors.topMargin: 4 + SettingsData.dockTopPadding * Math.sqrt(SettingsData.dockScale)
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4 + SettingsData.dockTopPadding * Math.sqrt(SettingsData.dockScale)
                    
                    clip: false
                    z: 5

                    Item {
                        anchors.fill: parent

                        Item {
                            id: centerArea
                            anchors.left: SettingsData.dockExpandToScreen ? (hasLeftWidgets ? expandedLeftWidgets.right : parent.left) : parent.left
                            anchors.right: SettingsData.dockExpandToScreen ? (hasRightWidgets ? expandedRightWidgets.left : parent.right) : parent.right
                            anchors.leftMargin: SettingsData.dockExpandToScreen ? 8 : 0
                            anchors.rightMargin: SettingsData.dockExpandToScreen ? 8 : 0
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height
                            clip: SettingsData.dockExpandToScreen
                        }

                        DockWidgets {
                            id: centerWidgets
                            anchors.horizontalCenter: centerArea.horizontalCenter
                            anchors.verticalCenter: centerArea.verticalCenter
                            height: centerArea.height - 8
                            widgetList: SettingsData.dockCenterWidgetsModel
                            side: "center"
                            contextMenu: dock.contextMenu
                            z: 1
                        }



                        DockWidgets {
                            id: expandedLeftWidgets
                            anchors.left: parent.left
                            anchors.leftMargin: 0
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - 8
                            widgetList: SettingsData.dockLeftWidgetsModel
                            side: "left"
                            allowEdgeAnchors: true
                            contextMenu: dock.contextMenu
                            visible: SettingsData.dockExpandToScreen && hasLeftWidgets
                            z: 2
                        }

                        DockWidgets {
                            id: expandedRightWidgets
                            anchors.right: parent.right
                            anchors.rightMargin: 0
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height - 8
                            widgetList: SettingsData.dockRightWidgetsModel
                            side: "right"
                            allowEdgeAnchors: true
                            contextMenu: dock.contextMenu
                            visible: SettingsData.dockExpandToScreen && SettingsData.dockWidgetsEnabled
                            z: 2
                        }

                    }
                }

            }


            
            
        }
    }
}
