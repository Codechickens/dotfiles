import QtQuick
import Qt5Compat.GraphicalEffects
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root

    property bool isActive: false
    property string section: "left"
    property var popupTarget: null
    property var parentScreen: null
    property real widgetHeight: 30
    property real barHeight: 48
    property bool isBarVertical: SettingsData.topBarPosition === "left" || SettingsData.topBarPosition === "right"
    readonly property real horizontalPadding: SettingsData.topBarNoBackground ? 0 : Math.max(Theme.spacingXS, Theme.spacingS * (widgetHeight / 30))
    property bool _pendingTriggerPosition: false
    property real _pendingTriggerX: 0
    property real _pendingTriggerY: 0
    property real _pendingTriggerWidth: 0
    property string _pendingTriggerSection: "topbar"
    property var _pendingTriggerScreen: null

    signal clicked()
    property bool _pendingToggle: false

    width: isBarVertical ? widgetHeight : (Math.max(SettingsData.launcherLogoSize, 16) + horizontalPadding * 2)
    height: isBarVertical ? (Math.max(SettingsData.launcherLogoSize, 16) + horizontalPadding * 2) : widgetHeight

    function applyTriggerPosition(target) {
        if (!target || !target.setTriggerPosition) {
            return
        }
        // Set bar properties for proper positioning
        const barPos = SettingsData.topBarPosition;
        const barHeight = SettingsData.topBarHeight * (SettingsData.topbarScale || 1);
        const margin = (barPos === "bottom" && !isBarVertical) ? (SettingsData.topBarTopMargin || 0) : 0;
        const effectiveBarHeight = barHeight + margin;
        console.log(`[LauncherButton] Setting bar properties: position="${barPos}", thickness=${barHeight}, margin=${margin}, effective=${effectiveBarHeight}`);
        target.barPosition = barPos;
        target.barThickness = effectiveBarHeight;
        console.log(`[LauncherButton] Calling setTriggerPosition: (${_pendingTriggerX}, ${_pendingTriggerY}), width=${_pendingTriggerWidth}, section="${_pendingTriggerSection}"`);
        target.setTriggerPosition(_pendingTriggerX, _pendingTriggerY, _pendingTriggerWidth, _pendingTriggerSection, _pendingTriggerScreen)
        _pendingTriggerPosition = false
    }

    onPopupTargetChanged: {
        if (_pendingTriggerPosition) {
            applyTriggerPosition(popupTarget)
        }
    }

    MouseArea {
        id: launcherArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onPressed: {
            // Get button rect in screen coordinates (like SystemUpdate does)
            const rect = parent.mapToItem(null, 0, 0, width, height);
            const currentScreen = parentScreen || Screen;

            // Calculate center of button for proper positioning
            let triggerX = rect.x + rect.width / 2; // Center horizontally
            let triggerY = rect.y + rect.height / 2; // Center vertically

            if (isBarVertical) {
                if (SettingsData.topBarPosition === "right") {
                    // For right bar, position popup on the right side of the screen (like SystemUpdate)
                    const screenWidth = currentScreen.width || 2560;
                    triggerX = screenWidth - 210; // Center popup on right side of screen
                }
                // For vertical bars, Y position is already at button center
            }
            // For horizontal bars, don't adjust triggerY - let the popup positioning handle it

            // For vertical bars, triggerSection indicates screen side
            let triggerSection = isBarVertical ? SettingsData.topBarPosition : SettingsData.topBarPosition;

            // Store pending position in case popup isn't loaded yet
            _pendingTriggerX = triggerX;
            _pendingTriggerY = triggerY;
            _pendingTriggerWidth = isBarVertical ? height : width;
            _pendingTriggerSection = triggerSection;
            _pendingTriggerScreen = currentScreen;
            _pendingTriggerPosition = true;

            applyTriggerPosition(popupTarget);
            root.clicked();
        }
    }

    Rectangle {
        id: launcherContent

        anchors.fill: parent
        radius: SettingsData.topBarNoBackground ? 0 : Theme.cornerRadius
        color: {
            if (SettingsData.topBarNoBackground) {
                return "transparent";
            }

            const baseColor = launcherArea.containsMouse ? Theme.widgetBaseHoverColor : Theme.widgetBaseBackgroundColor;
            return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * Theme.widgetTransparency);
        }

        SystemLogo {
            visible: SettingsData.useOSLogo && !SettingsData.useCustomLauncherImage
            anchors.centerIn: parent
            width: SettingsData.launcherLogoSize > 0 ? SettingsData.launcherLogoSize - 3 : 0
            height: SettingsData.launcherLogoSize > 0 ? SettingsData.launcherLogoSize - 3 : 0
            colorOverride: SettingsData.osLogoColorOverride !== "" ? SettingsData.osLogoColorOverride : Qt.rgba(SettingsData.launcherLogoRed, SettingsData.launcherLogoGreen, SettingsData.launcherLogoBlue, 1.0)
            brightnessOverride: SettingsData.osLogoBrightness
            contrastOverride: SettingsData.osLogoContrast

        }

        Item {
            visible: SettingsData.useCustomLauncherImage && SettingsData.customLauncherImagePath !== ""
            anchors.centerIn: parent
            width: SettingsData.launcherLogoSize > 0 ? SettingsData.launcherLogoSize - 6 : 0
            height: SettingsData.launcherLogoSize > 0 ? SettingsData.launcherLogoSize - 6 : 0

            Image {
                id: customImage
                anchors.fill: parent
                source: SettingsData.customLauncherImagePath
                fillMode: Image.PreserveAspectFit
                smooth: true
                mipmap: true

                layer.enabled: SettingsData.launcherLogoRed !== 1.0 || SettingsData.launcherLogoGreen !== 1.0 || SettingsData.launcherLogoBlue !== 1.0
                layer.effect: ColorOverlay {
                    color: Qt.rgba(SettingsData.launcherLogoRed, SettingsData.launcherLogoGreen, SettingsData.launcherLogoBlue, 0.8)
                }
            }

        }

        EHIcon {
            visible: !SettingsData.useOSLogo && !SettingsData.useCustomLauncherImage
            anchors.centerIn: parent
            name: "apps"
            size: SettingsData.launcherLogoSize > 0 ? SettingsData.launcherLogoSize - 6 : 0
            color: Qt.rgba(SettingsData.launcherLogoRed, SettingsData.launcherLogoGreen, SettingsData.launcherLogoBlue, 1.0)

        }
    }
}
