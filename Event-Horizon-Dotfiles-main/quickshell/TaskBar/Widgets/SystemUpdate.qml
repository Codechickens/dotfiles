import QtQuick
import qs.Common
import qs.Services
import qs.Widgets

Rectangle {
    id: root

    property bool isActive: false
    property string section: "right"
    property var popupTarget: null
    property var parentScreen: null
    property real widgetHeight: 30
    property real barHeight: 48
    property bool isBarVertical: SettingsData.topBarPosition === "left" || SettingsData.topBarPosition === "right"
    readonly property real horizontalPadding: SettingsData.topBarNoBackground ? 0 : Math.max(Theme.spacingXS, Theme.spacingS * (widgetHeight / 30))
    readonly property bool hasUpdates: SystemUpdateService.updateCount > 0
    readonly property bool isChecking: SystemUpdateService.isChecking

    signal clicked()

    width: isBarVertical ? widgetHeight : (updaterIcon.width + horizontalPadding * 2)
    height: isBarVertical ? (updaterIcon.width + horizontalPadding * 2) : widgetHeight
    radius: SettingsData.topBarNoBackground ? 0 : Theme.cornerRadius
    color: {
        if (SettingsData.topBarNoBackground) {
            return "transparent";
        }

        const baseColor = updaterArea.containsMouse ? Theme.widgetBaseHoverColor : Theme.widgetBaseBackgroundColor;
        return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * Theme.widgetTransparency);
    }

    Row {
        id: updaterIcon

        anchors.centerIn: parent
        spacing: Theme.spacingXS

        EHIcon {
            id: statusIcon

            anchors.verticalCenter: parent.verticalCenter
            name: {
                if (isChecking) return "refresh";
                if (SystemUpdateService.hasError) return "error";
                if (hasUpdates) return "system_update_alt";
                return "check_circle";
            }
            size: (Theme.iconSize - 6) * (widgetHeight / 30)
            color: {
                if (SystemUpdateService.hasError) return Theme.error;
                if (hasUpdates) return Theme.primary;
                return (updaterArea.containsMouse || root.isActive ? Theme.primary : Theme.surfaceText);
            }

            RotationAnimation {
                id: rotationAnimation
                target: statusIcon
                property: "rotation"
                from: 0
                to: 360
                duration: 1000
                running: isChecking
                loops: Animation.Infinite

                onRunningChanged: {
                    if (!running) {
                        statusIcon.rotation = 0
                    }
                }
            }
        }

        StyledText {
            id: countText

            anchors.verticalCenter: parent.verticalCenter
            text: SystemUpdateService.updateCount.toString()
            font.pixelSize: Theme.fontSizeSmall
            font.weight: Font.Medium
            color: Theme.surfaceText
            visible: hasUpdates && !isChecking
        }
    }

    MouseArea {
        id: updaterArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: {
            console.log(`[TaskBar SystemUpdate] CLICK DETECTED - popupTarget exists: ${!!popupTarget}`);
            if (popupTarget && popupTarget.setTriggerPosition) {
                // Get widget position in screen coordinates (like dock does)
                const rect = parent.mapToItem(null, 0, 0, width, height);
                const currentScreen = parentScreen || Screen;

                console.log(`[TaskBar SystemUpdate] Widget clicked:`);
                console.log(`  Widget screen position: (${rect.x}, ${rect.y}) size: ${rect.width}x${rect.height}`);
                console.log(`  Widget center: (${rect.x + rect.width/2}, ${rect.y + rect.height/2})`);

                // Calculate taskbar thickness (similar to dock)
                var taskBarThickness = SettingsData?.taskBarHeight || 48;

                console.log(`  TaskBar info: thickness=${taskBarThickness}, position=bottom`);
                console.log(`  Screen: ${currentScreen.width}x${currentScreen.height}`);

                // Set bar properties for proper positioning
                popupTarget.barPosition = "bottom";  // TaskBar is always at bottom
                popupTarget.barThickness = taskBarThickness;

                // Position popup above taskbar, centered on button
                const triggerX = rect.x + rect.width / 2;
                const triggerY = Screen.height - taskBarThickness;

                console.log(`  Calculated trigger position: (${triggerX}, ${triggerY})`);
                console.log(`  Distance from widget center: X=${triggerX - (rect.x + rect.width/2)}, Y=${triggerY - (rect.y + rect.height/2)}`);

                console.log(`[TaskBar SystemUpdate] About to call setTriggerPosition`);
                popupTarget.setTriggerPosition(triggerX, triggerY, rect.width, "taskbar", currentScreen);
                console.log(`[TaskBar SystemUpdate] setTriggerPosition called successfully`);
            }
            root.clicked();
        }
    }

}