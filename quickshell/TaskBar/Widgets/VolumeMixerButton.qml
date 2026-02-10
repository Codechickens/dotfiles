import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell.Services.Pipewire
import qs.Common
import qs.Services
import qs.Widgets

Rectangle {
    id: root

    readonly property int textWidth: 0
    readonly property int currentContentWidth: {
        return volumeRow.implicitWidth + horizontalPadding * 2;
    }
    property string section: "center"
    property var popupTarget: null
    property var parentScreen: null
    property real barHeight: 48
    property real widgetHeight: 30
    property bool isBarVertical: SettingsData.topBarPosition === "left" || SettingsData.topBarPosition === "right"
    readonly property real horizontalPadding: SettingsData.topBarNoBackground ? 0 : Math.max(Theme.spacingXS, Theme.spacingS * (widgetHeight / 30))

    signal clicked()

    width: isBarVertical ? widgetHeight : currentContentWidth
    height: isBarVertical ? currentContentWidth : widgetHeight
    radius: SettingsData.topBarNoBackground ? 0 : Theme.cornerRadius
    color: {
        if (SettingsData.topBarNoBackground) {
            return "transparent";
        }

        const baseColor = volumeArea.containsMouse ? Theme.widgetBaseHoverColor : Theme.widgetBaseBackgroundColor;
        return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * Theme.widgetTransparency);
    }

    MouseArea {
        id: volumeArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: {
            if (popupTarget && popupTarget.shouldBeVisible) {
                popupTarget.close();
            } else if (popupTarget) {
                // Get widget position in screen coordinates (like dock does)
                const rect = parent.mapToItem(null, 0, 0, width, height);
                const currentScreen = parentScreen || Screen;
                
                // Calculate taskbar thickness (similar to dock)
                var taskBarThickness = SettingsData?.taskBarHeight || 48;
                
                // Position popup above taskbar, centered on button
                const triggerX = rect.x + rect.width / 2;
                const triggerY = Screen.height - taskBarThickness;
                
                popupTarget.setTriggerPosition(triggerX, triggerY, rect.width, "taskbar", currentScreen);
                popupTarget.open();
            }
        }
    }

    Row {
        id: volumeRow
        anchors.centerIn: parent
        spacing: Theme.spacingXS

        EHIcon {
            name: AudioService.getOutputIcon()
            size: 16 * (widgetHeight / 30)

            anchors.verticalCenter: parent.verticalCenter

        }

        StyledText {
            color: AudioService.muted ? Theme.error : Theme.surfaceText
            text: Math.round(AudioService.volume * 100) + "%"
            font.pixelSize: Theme.fontSizeSmall

            font.weight: Font.Medium
            anchors.verticalCenter: parent.verticalCenter
            visible: SettingsData.mediaSize > 0

        }
    }

    Behavior on width {
        NumberAnimation {
            duration: Theme.shortDuration
            easing.type: Theme.standardEasing
        }
    }
}