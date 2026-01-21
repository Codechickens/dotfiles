import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Rectangle {
    id: root

    property int widgetHeight: 28
    property int barHeight: 32
    property string section: "right"
    property var popupTarget: null
    property var parentScreen: null
    property bool isBarVertical: SettingsData.topBarPosition === "left" || SettingsData.topBarPosition === "right"
    readonly property real horizontalPadding: SettingsData.topBarNoBackground ? 0 : Math.max(Theme.spacingXS, Theme.spacingS * (widgetHeight / 30))

    signal toggleVpnPopup()

    width: isBarVertical ? widgetHeight : (Theme.iconSize + horizontalPadding * 2)
    height: isBarVertical ? (Theme.iconSize + horizontalPadding * 2) : widgetHeight
    radius: SettingsData.topBarNoBackground ? 0 : Theme.cornerRadius
    color: {
        if (SettingsData.topBarNoBackground) {
            return "transparent";
        }

        const baseColor = clickArea.containsMouse ? Theme.widgetBaseHoverColor : Theme.widgetBaseBackgroundColor;
        return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, baseColor.a * Theme.widgetTransparency);
    }

    EHIcon {
        id: icon

        name: VpnService.isBusy ? "sync" : (VpnService.connected ? "vpn_lock" : "vpn_key_off")
        size: Theme.iconSize - 6
        color: VpnService.connected ? Theme.primary : Theme.surfaceText
        anchors.centerIn: parent

        RotationAnimation on rotation {
            running: VpnService.isBusy
            loops: Animation.Infinite
            from: 0
            to: 360
            duration: 900
        }

    }

    MouseArea {
        id: clickArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: {
            if (popupTarget && popupTarget.setTriggerPosition) {
                const globalPos = mapToGlobal(0, 0);
                const currentScreen = parentScreen || Screen;
                const screenX = currentScreen.x || 0;
                const screenY = currentScreen.y || 0;
                const relativeX = globalPos.x - screenX;
                const relativeY = globalPos.y - screenY;
                
                let triggerX, triggerY;
                if (isBarVertical) {
                    if (SettingsData.topBarPosition === "left") {
                        triggerX = relativeX + width + Theme.spacingXS;
                        triggerY = relativeY;
                    } else {
                        triggerX = relativeX - Theme.spacingXS;
                        triggerY = relativeY;
                    }
                } else {
                    triggerX = relativeX;
                    if (SettingsData.topBarPosition === "top") {
                        triggerY = relativeY + height + Theme.spacingXS;
                    } else {
                        triggerY = relativeY - Theme.spacingXS;
                    }
                }
                
                popupTarget.setTriggerPosition(triggerX, triggerY, isBarVertical ? height : width, section, currentScreen);
            }
            root.toggleVpnPopup();
        }
    }


}
