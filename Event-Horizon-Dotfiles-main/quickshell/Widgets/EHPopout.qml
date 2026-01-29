import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Wayland
import qs.Common

PanelWindow {
    id: root

    WlrLayershell.namespace: (root.objectName === "darkDashPopout" || root.objectName === "applicationsPopout") ? "quickshell:dock:blur" : "quickshell:popout"

    property alias content: contentLoader.sourceComponent
    property alias contentLoader: contentLoader
    property real popupWidth: 400
    property real popupHeight: 300
    property real triggerX: 0
    property real triggerY: 0
    property real triggerWidth: 0
    property string triggerSection: ""
    property var triggerScreen: null
    property string positioning: "center" // "center", "trigger", "manual"

    onTriggerXChanged: if (shouldBeVisible) updatePosition()
    onTriggerYChanged: if (shouldBeVisible) updatePosition()
    onTriggerScreenChanged: if (shouldBeVisible) updatePosition()
    onBarPositionChanged: if (shouldBeVisible) updatePosition()
    onBarThicknessChanged: if (shouldBeVisible) updatePosition()
    property string barPosition: "top" // "top", "bottom", "left", "right"
    property real barThickness: 32
    property real popupDistance: Theme.popupDistance !== undefined ? Theme.popupDistance : 8
    property bool shouldBeVisible: false
    property color backgroundColor: Qt.rgba(Theme.surface.r, Theme.surface.g, Theme.surface.b, 0.95)

    onShouldBeVisibleChanged: {
        console.log(`[EHPopout] ${objectName} shouldBeVisible changed to: ${shouldBeVisible}`);
        if (shouldBeVisible) {
            console.log(`[EHPopout] ${objectName} opening, updating position`);
            updatePosition();
        } else {
            console.log(`[EHPopout] ${objectName} closing`);
        }
    }
    property real borderWidth: root.objectName === "darkDashPopout" ? SettingsData.darkDashBorderThickness : 1
    property color borderColor: root.objectName === "darkDashPopout" && SettingsData.darkDashBorderThickness > 0 ? Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, SettingsData.darkDashBorderOpacity) : (root.objectName === "darkDashPopout" ? "transparent" : Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2))
    property int animationDuration: Theme.mediumDuration
    property real contentWidth: 0
    property real contentHeight: 0
    property point calculatedPosition: Qt.point(0, 0)
    property bool disableBackgroundClick: false

    readonly property bool isBarVertical: typeof SettingsData !== "undefined" && (SettingsData.topBarPosition === "left" || SettingsData.topBarPosition === "right")
    readonly property bool isBarAtBottom: typeof SettingsData !== "undefined" && SettingsData.topBarPosition === "bottom"

    function updatePosition() {
        // ===== SCREEN DETECTION =====
        // Get screen info from popup trigger or fallback to first available screen
        let screen = root.triggerScreen;
        if (!screen && typeof Quickshell !== "undefined" && Quickshell.screens && Quickshell.screens.length > 0) {
            screen = Quickshell.screens[0]; // Fallback to primary screen if no trigger screen
        }

        // ===== SCREEN DIMENSIONS & SCALING =====
        const screenX = screen ? (screen.x || 0) : 0;           // Screen X offset from desktop origin
        const screenY = screen ? (screen.y || 0) : 0;           // Screen Y offset from desktop origin
        const screenWidth = screen ? (screen.width || 1920) : 1920;    // Screen width in pixels
        const screenHeight = screen ? (screen.height || 1080) : 1080;  // Screen height in pixels
        const scale = screen ? (screen.devicePixelRatio || 1) : 1;     // High-DPI scaling factor

        // Calculate responsive scaling factors based on screen resolution
        const baseWidth = 2560;  // Reference resolution (QHD)
        const baseHeight = 1440;
        const widthScale = screenWidth / baseWidth;    // Scale factor for horizontal positioning
        const heightScale = screenHeight / baseHeight; // Scale factor for vertical positioning

        if (!screen) {
            console.log(`[EHPopout] ${root.objectName}: No screen available, using defaults`);
        }

        // ===== BAR THICKNESS SCALING =====
        const scaledBarThickness = root.barThickness * scale;  // Scale bar thickness for high-DPI displays

        // ===== TRIGGER COORDINATE HANDLING =====
        // Use trigger coordinates from button press, or default to screen center
        let triggerX = root.triggerX;
        let triggerY = root.triggerY;
        if (triggerX === 0 && triggerY === 0) {
            // No trigger coordinates set (popup opened automatically), default to screen center
            triggerX = screenX + screenWidth / 2;
            triggerY = screenY + screenHeight / 2;
            console.log(`  Using default trigger coordinates: (${triggerX}, ${triggerY}) - screen center`);
        }

        // ===== DEBUG LOGGING =====
        console.log(`[EHPopout] ${root.objectName} POSITION UPDATE:`);
        console.log(`  Screen: ${screenWidth}x${screenHeight} @ (${screenX}, ${screenY}), scale: ${scale}, source: ${screen ? 'triggerScreen' : 'fallback'}`);
        console.log(`  Bar: position="${root.barPosition}", thickness=${root.barThickness}, scaledThickness=${scaledBarThickness}`);
        console.log(`  Trigger: (${triggerX}, ${triggerY}), width=${root.triggerWidth}, section="${root.triggerSection}"`);
        console.log(`  Popup: ${root.popupWidth}x${root.popupHeight}, distance=${root.popupDistance}`);

        // ===== TARGET POSITION CALCULATION =====
        let targetX, targetY;  // Final popup position coordinates

        // ===== UNIFIED BAR-RELATIVE POSITIONING =====
        // Same positioning logic as topbar-at-bottom, scaled for different bar positions
        if (root.barPosition === "top") {
            // TOP BAR: Separate positioning for each popup type

            if (root.objectName === "appDrawerPopout") {
                // AppDrawer: Position less far right, more centered
                targetX = Math.max(15, screenWidth - root.popupWidth - 2010);  // 200px from right edge (less far right)
                targetY = Math.min(screenHeight - root.popupHeight - 15, screenY + scaledBarThickness + root.popupDistance);
                console.log(`  Top bar AppDrawer: targetX=${targetX} (200px from right), targetY=${targetY} (below bar)`);
            }
            else if (root.objectName === "systemUpdatePopout") {
                // Updater: Keep original right-side positioning
                targetX = Math.max(15, screenWidth - root.popupWidth - 10);  // 50px from right edge
                targetY = Math.min(screenHeight - root.popupHeight - 15, screenY + scaledBarThickness + root.popupDistance);
                console.log(`  Top bar Updater: targetX=${targetX} (50px from right), targetY=${targetY} (below bar)`);
            }
            else if (root.objectName === "controlCenterPopout") {
                // Control Center: Position further below the bar
                targetX = Math.max(15, Math.min(screenWidth - root.popupWidth - 15, triggerX - root.popupWidth / 2));  // Center on trigger
                targetY = Math.min(screenHeight - root.popupHeight - 15, screenY + scaledBarThickness + root.popupDistance + 10);
                console.log(`  Top bar ControlCenter: targetX=${targetX}, targetY=${targetY} (extra below bar)`);
            }
            else {
                // Other popups: Standard positioning below bar
                targetX = Math.max(15, Math.min(screenWidth - root.popupWidth - 15, triggerX - root.popupWidth / 2));  // Center on trigger
                targetY = Math.min(screenHeight - root.popupHeight - 15, screenY + scaledBarThickness + root.popupDistance);
                console.log(`  Top bar (${root.objectName}): targetX=${targetX}, targetY=${targetY} (below bar towards center)`);
            }
        }
        else if (root.barPosition === "bottom") {
            // BOTTOM BAR: Separate positioning logic for each popup type

            const barTop = screenHeight - scaledBarThickness;

            // ===== APP DRAWER =====
            if (root.objectName === "appDrawerPopout") {
                // AppDrawer: Center on trigger horizontally, position above bar
                targetX = Math.max(15, Math.min(screenWidth - root.popupWidth - 15, triggerX - root.popupWidth / 2));  // Center on trigger
                targetY = Math.max(15, barTop - root.popupHeight - 15);  // 15px above bar
                console.log(`  AppDrawer: Trigger-centered X, 15px above bar`);
            }

            // ===== UPDATER =====
            else if (root.objectName === "systemUpdatePopout") {
                // Updater: Same as AppDrawer - center on trigger, close to bar
                targetX = Math.max(15, Math.min(screenWidth - root.popupWidth - 15, triggerX - root.popupWidth / 2));  // Center on trigger
                targetY = Math.max(15, barTop - root.popupHeight - 15);  // 15px above bar
                console.log(`  Updater: Same as AppDrawer - trigger-centered X, 15px above bar`);
            }

            // ===== CONTROL CENTER POPUP =====
            else if (root.objectName === "controlCenterPopout") {
                // Dedicated dock/center positioning - Control Center should be positioned directly above the dock/center
                if (root.triggerSection === "dock" || root.triggerSection === "center") {
                    // DOCK/CENTER: Position Control Center directly above the dock/center with minimal spacing
                    targetX = Math.max(15, Math.min(screenWidth - root.popupWidth - 15, triggerX - root.popupWidth / 2));  // Center on trigger
                    targetY = Math.max(15, barTop - root.popupHeight);  // 5px above dock (minimal spacing)
                    console.log(`  ControlCenter (${root.triggerSection}): Trigger-centered, 5px above bar`);
                } else {
                    // TASKBAR: Custom spacing above taskbar
                    targetX = Math.max(15, Math.min(screenWidth - root.popupWidth - 15, triggerX - root.popupWidth / 2));  // Center on trigger
                    targetY = Math.max(15, barTop - root.popupHeight + 45);  // Farther above bar
                    console.log(`  ControlCenter (taskbar): Trigger-centered, custom spacing above bar`);
                }
            }

            // ===== OTHER POPUPS =====
            else {
                targetX = Math.max(15, Math.min(screenWidth - root.popupWidth - 15, triggerX - root.popupWidth / 2));
                targetY = Math.max(15, barTop - root.popupHeight - 20);  // 20px above bar
                console.log(`  Other bottom popup: Trigger-centered X, 20px above bar`);
            }

            // ===== DEBUGGING =====
            const popupBottom = targetY + root.popupHeight;
            const distanceFromBar = barTop - popupBottom;

            console.log(`    Final: targetX=${targetX}, targetY=${targetY}`);
            console.log(`    Bar top: ${barTop}, Popup bottom: ${popupBottom}, Distance: ${distanceFromBar}px (${distanceFromBar >= 0 ? 'above bar' : 'overlapping bar'})`);
        }
        else if (root.barPosition === "left") {
            // LEFT BAR: Different positioning for different popups
            targetY = Math.max(15, Math.min(screenHeight - root.popupHeight - 15, triggerY - root.popupHeight / 2));  // Center vertically on trigger

            if (root.objectName === "appDrawerPopout" || root.objectName === "systemUpdatePopout") {
                // AppDrawer/Updater: Closer to the bar
                targetX = Math.max(15, screenX + scaledBarThickness + 10);  // Minimal distance from bar
                console.log(`  Left bar ${root.objectName}: targetX=${targetX} (close to bar), targetY=${targetY}`);
            } else if (root.objectName === "controlCenterPopout") {
                // ControlCenter: Standard distance from bar
                targetX = Math.max(15, screenX + scaledBarThickness + root.popupDistance + 15);  // Standard distance
                console.log(`  Left bar ControlCenter: targetX=${targetX} (standard distance from bar), targetY=${targetY}`);
            } else {
                // Other popups: Standard distance
                targetX = Math.max(15, screenX + scaledBarThickness + root.popupDistance + 15);
                console.log(`  Left bar ${root.objectName}: targetX=${targetX} (standard distance), targetY=${targetY}`);
            }
        }
        else if (root.barPosition === "right") {
            // RIGHT BAR: Separate positioning for different popup types
            targetY = Math.max(15, Math.min(screenHeight - root.popupHeight - 15, triggerY - root.popupHeight / 2));  // Center vertically on trigger

            // ===== APP DRAWER =====
            if (root.objectName === "appDrawerPopout") {
                // AppDrawer: Farther from the bar (810px to the left) - this is perfect
                targetX = Math.max(15, screenX + screenWidth - scaledBarThickness - 810);
                console.log(`  Right bar AppDrawer: targetX=${targetX} (810px from bar), targetY=${targetY}`);
            }

            // ===== UPDATER =====
            else if (root.objectName === "systemUpdatePopout") {
                // Updater: Less far from the bar (400px to the left) - not too far left
                targetX = Math.max(15, screenX + screenWidth - scaledBarThickness - 410);
                console.log(`  Right bar Updater: targetX=${targetX} (400px from bar), targetY=${targetY}`);
            }

            // ===== CONTROL CENTER (separate logic) =====
            else if (root.objectName === "controlCenterPopout") {
                // ControlCenter: Standard distance from bar
                targetX = Math.max(15, screenX + screenWidth - scaledBarThickness - root.popupDistance - root.popupWidth - 15);
                console.log(`  Right bar ControlCenter: targetX=${targetX} (standard distance from bar), targetY=${targetY}`);
            }

            // ===== OTHER POPUPS =====
            else {
                // Other popups: Standard distance
                targetX = Math.max(15, screenX + screenWidth - scaledBarThickness - root.popupDistance - root.popupWidth - 15);
                console.log(`  Right bar ${root.objectName}: targetX=${targetX} (standard distance), targetY=${targetY}`);
            }
        }
        else {
            // FALLBACK: Unknown bar position, center popup on screen
            targetX = screenX + screenWidth / 2;   // Horizontal center
            targetY = screenY + screenHeight / 2;  // Vertical center
            console.log(`  Fallback: targetX=${targetX} (screen center), targetY=${targetY} (screen center)`);
        }

        // ===== FINAL POSITION LOGGING =====
        console.log(`  Final position: (${targetX}, ${targetY})`);  // Popup top-left corner coordinates
        console.log(`  Popup bounds: (${targetX}, ${targetY}) to (${targetX + root.popupWidth}, ${targetY + root.popupHeight})`);  // Full popup rectangle

        // ===== UPDATE QML PROPERTIES =====
        calculatedPosition = Qt.point(targetX, targetY);  // Set the calculated position for QML binding system
    }

    signal opened
    signal popoutClosed
    signal backgroundClicked

    function open() {
        closeTimer.stop()
        shouldBeVisible = true
        visible = true
        opened()
    }

    function close() {
        shouldBeVisible = false
        closeTimer.restart()
    }

    function toggle() {
        if (shouldBeVisible)
            close()
        else
            open()
    }

    Timer {
        id: closeTimer
        interval: animationDuration + 50
        onTriggered: {
            if (!shouldBeVisible) {
                visible = false
                popoutClosed()
            } else {
            }
        }
    }

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

    width: popupWidth
    height: popupHeight

    visible: shouldBeVisible

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
                       var localPos = mapToItem(contentContainer, mouse.x, mouse.y)
                       if (localPos.x < 0 || localPos.x > contentContainer.width || localPos.y < 0 || localPos.y > contentContainer.height) {
                           backgroundClicked()
                           close()
                           mouse.accepted = true
                       } else {
                           mouse.accepted = false
                       }
                   }
    }

    Item {
        id: contentContainer
        z: 10

        readonly property real screenWidth: root.screen ? root.screen.width : 1920
        readonly property real screenHeight: root.screen ? root.screen.height : 1080
        readonly property real barExclusiveSize: typeof SettingsData !== "undefined" && SettingsData.topBarVisible && !SettingsData.topBarFloat ? ((SettingsData.topBarHeight * SettingsData.topbarScale) + SettingsData.topBarSpacing + (SettingsData.topBarGothCornersEnabled ? Theme.cornerRadius : 0)) : 0

        anchors.fill: parent
        opacity: shouldBeVisible ? 1 : 0
        scale: shouldBeVisible ? 1 : 0.9

        Behavior on opacity {
            NumberAnimation {
                duration: animationDuration
                easing.type: Theme.emphasizedEasing
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: animationDuration
                easing.type: Theme.emphasizedEasing
            }
        }

        Rectangle {
            id: backgroundRect
            anchors.fill: parent
            color: root.backgroundColor
            radius: Theme.cornerRadius
            border.color: root.borderColor
            border.width: root.borderWidth

        }

        Loader {
            id: contentLoader
            anchors.fill: parent
            active: root.visible
            asynchronous: false
        }

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
            onVisibleChanged: if (visible)
                                  forceActiveFocus()
        }
    }
}
