import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Wayland
import qs.Common
import "./DynamicPositioning.js" as Positioning

PanelWindow {
    id: root

    // Namespace for blur
    WlrLayershell.namespace: "quickshell:dock:blur"

    // Content component
    property alias content: contentLoader.sourceComponent
    property alias contentLoader: contentLoader
    
    // Popup dimensions (base sizes before scaling)
    property real basePopupWidth: 720
    property real basePopupHeight: 540
    
    // Calculated dimensions after scaling
    property real popupWidth: basePopupWidth
    property real popupHeight: basePopupHeight
    
    // Trigger/widget information
    property real triggerX: 0
    property real triggerY: 0
    property real triggerWidth: 80
    property real triggerHeight: 48
    property string triggerSection: ""  // "left", "center", "right" or "top", "middle", "bottom"
    property var triggerScreen: null
    
    // Bar configuration
    property string barPosition: "bottom"  // "top", "bottom", "left", "right"
    property real barThickness: 48
    property real barSpacing: 4
    property real bottomGap: 0
    property bool autoFitWidth: false  // For bars that auto-fit to content
    
    // Popup behavior
    property real popupGap: 8  // Distance from bar to popup
    property bool shouldBeVisible: false
    property real userScale: 1.0  // User-defined scale multiplier
    property bool enableAdaptiveScaling: true  // Whether to scale based on screen size
    
    // Visual properties
    property color backgroundColor: Qt.rgba(Theme.surface.r, Theme.surface.g, Theme.surface.b, 0.95)
    property real borderWidth: 1
    property color borderColor: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
    property int animationDuration: Theme.mediumDuration || 200
    
    // Background click handling
    property bool disableBackgroundClick: false
    
    // Calculated position (output of positioning system)
    property point calculatedPosition: Qt.point(0, 0)
    property real calculatedScale: 1.0
    property var lastPositionResult: null
    
    // Signals
    signal opened
    signal popoutClosed
    signal backgroundClicked
    
    /**
     * Set trigger position from a widget
     * This is called when a widget wants to show the popup
     */
    function setTriggerPosition(x, y, width, height, section, screen) {
        console.log(`[EHPopout] ${objectName} setTriggerPosition called:`)
        console.log(`  Position: (${x}, ${y}), Size: ${width}x${height}`)
        console.log(`  Section: ${section}, Screen: ${screen ? screen.name : 'null'}`)
        
        triggerX = x
        triggerY = y
        triggerWidth = width
        triggerHeight = height || barThickness
        triggerSection = section || ""
        triggerScreen = screen
        
        if (shouldBeVisible) {
            updatePosition()
        }
    }
    
    /**
     * Update popup position based on current trigger and bar configuration
     */
    function updatePosition() {
        console.log(`[EHPopout] ${objectName} updatePosition called`)
        
        // Use triggerScreen if available, otherwise use root.screen
        const screen = triggerScreen || root.screen
        
        if (!screen) {
            console.warn(`[EHPopout] ${objectName} No screen available`)
            return
        }
        
        // Calculate position using the positioning system
        const result = Positioning.calculatePopupPosition({
            // Screen and bar
            screen: screen,
            barPosition: barPosition,
            barThickness: barThickness,
            barSpacing: barSpacing,
            bottomGap: bottomGap,
            
            // Trigger
            triggerX: triggerX,
            triggerY: triggerY,
            triggerWidth: triggerWidth,
            triggerHeight: triggerHeight,
            
            // Popup - use calculated popupWidth/Height if already set by subclass
            popupWidth: popupWidth || basePopupWidth,
            popupHeight: popupHeight || basePopupHeight,
            
            // Spacing and scaling
            popupGap: popupGap,
            userScale: enableAdaptiveScaling ? userScale : 1.0
        })
        
        // Store result
        lastPositionResult = result
        
        // Update calculated values
        calculatedPosition = Qt.point(result.x, result.y)
        calculatedScale = result.scale
        popupWidth = result.width
        popupHeight = result.height
        
        // Update section if it was calculated
        if (result.widgetSection) {
            triggerSection = result.widgetSection
        }
        
        console.log(`[EHPopout] ${objectName} Position updated to (${result.x.toFixed(1)}, ${result.y.toFixed(1)})`)
        console.log(`  Scaled dimensions: ${result.width.toFixed(1)}x${result.height.toFixed(1)}`)
        console.log(`  Scale factor: ${result.scale.toFixed(2)}`)
    }
    
    /**
     * Open the popup
     */
    function open() {
        closeTimer.stop()
        shouldBeVisible = true
        visible = true
        updatePosition()
        opened()
    }
    
    /**
     * Close the popup
     */
    function close() {
        shouldBeVisible = false
        closeTimer.restart()
    }
    
    /**
     * Toggle the popup
     */
    function toggle() {
        if (shouldBeVisible) {
            close()
        } else {
            open()
        }
    }
    
    // Update position when relevant properties change
    onTriggerXChanged: if (shouldBeVisible) Qt.callLater(updatePosition)
    onTriggerYChanged: if (shouldBeVisible) Qt.callLater(updatePosition)
    onTriggerScreenChanged: if (shouldBeVisible) Qt.callLater(updatePosition)
    onBarPositionChanged: if (shouldBeVisible) Qt.callLater(updatePosition)
    onBarThicknessChanged: if (shouldBeVisible) Qt.callLater(updatePosition)
    onBasePopupWidthChanged: if (shouldBeVisible) Qt.callLater(updatePosition)
    onBasePopupHeightChanged: if (shouldBeVisible) Qt.callLater(updatePosition)
    onUserScaleChanged: if (shouldBeVisible) Qt.callLater(updatePosition)
    
    onShouldBeVisibleChanged: {
        console.log(`[EHPopout] ${objectName} shouldBeVisible changed to: ${shouldBeVisible}`)
        if (shouldBeVisible) {
            updatePosition()
        }
    }
    
    // Close timer for smooth animations
    Timer {
        id: closeTimer
        interval: animationDuration + 50
        onTriggered: {
            if (!shouldBeVisible) {
                visible = false
                popoutClosed()
            }
        }
    }
    
    // Window properties
    color: "transparent"
    WlrLayershell.layer: WlrLayershell.Top
    WlrLayershell.exclusiveZone: shouldBeVisible ? -1 : 0
    WlrLayershell.keyboardFocus: shouldBeVisible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    
    anchors {
        top: true
        left: true
    }
    
    margins {
        left: calculatedPosition.x
        top: calculatedPosition.y
    }
    
    implicitWidth: popupWidth
    implicitHeight: popupHeight
    visible: shouldBeVisible
    
    // Background click detection
    MouseArea {
        anchors.fill: parent
        enabled: shouldBeVisible && visible && !root.disableBackgroundClick
        z: shouldBeVisible ? -1 : -2
        propagateComposedEvents: true
        
        onClicked: mouse => {
            if (!shouldBeVisible || root.disableBackgroundClick) {
                mouse.accepted = false
                return
            }
            
            // Check if click is outside content
            var localPos = mapToItem(contentContainer, mouse.x, mouse.y)
            if (localPos.x < 0 || localPos.x > contentContainer.width || 
                localPos.y < 0 || localPos.y > contentContainer.height) {
                backgroundClicked()
                close()
                mouse.accepted = true
            } else {
                mouse.accepted = false
            }
        }
    }
    
    // Content container with animations
    Item {
        id: contentContainer
        anchors.fill: parent
        z: 10
        
        opacity: shouldBeVisible ? 1 : 0
        scale: shouldBeVisible ? 1 : 0.9
        
        Behavior on opacity {
            NumberAnimation {
                duration: animationDuration
                easing.type: Easing.OutCubic
            }
        }
        
        Behavior on scale {
            NumberAnimation {
                duration: animationDuration
                easing.type: Easing.OutCubic
            }
        }
        
        // Background
        Rectangle {
            id: backgroundRect
            anchors.fill: parent
            color: root.backgroundColor
            radius: Theme.cornerRadius || 8
            border.color: root.borderColor
            border.width: root.borderWidth
            antialiasing: true
        }
        
        // Content loader
        Loader {
            id: contentLoader
            anchors.fill: parent
            active: root.visible
            asynchronous: false
        }
        
        // Keyboard focus handling
        Item {
            anchors.fill: parent
            focus: true
            
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    close()
                    event.accepted = true
                }
            }
            
            Component.onCompleted: forceActiveFocus()
            onVisibleChanged: if (visible) forceActiveFocus()
        }
    }
}