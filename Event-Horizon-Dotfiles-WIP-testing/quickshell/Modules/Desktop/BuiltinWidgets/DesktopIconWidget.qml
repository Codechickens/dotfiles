import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root

    property string instanceId: ""
    property var instanceData: null
    readonly property var cfg: instanceData?.config ?? null
    readonly property bool isInstance: instanceId !== "" && cfg !== null

    // Desktop entry properties passed via instance config
    readonly property string desktopFilePath: cfg?.desktopFilePath ?? ""
    readonly property string desktopFileName: cfg?.desktopFileName ?? ""
    readonly property string desktopName: cfg?.desktopName ?? desktopFileName.replace(/\.desktop$/, "").replace(/\.ink$/, "")
    readonly property string desktopIcon: cfg?.desktopIcon ?? "application-x-desktop"
    readonly property string desktopExec: cfg?.desktopExec ?? ""
    readonly property string desktopWorkingDir: cfg?.desktopWorkingDir ?? ""
    readonly property bool desktopIsLink: cfg?.desktopIsLink ?? false
    readonly property string linkTarget: cfg?.linkTarget ?? ""

    // Size properties
    property real widgetWidth: isInstance ? (cfg?.width ?? 100) : 100
    property real widgetHeight: isInstance ? (cfg?.height ?? 100) : 100
    property real defaultWidth: 100
    property real defaultHeight: 100
    property real minWidth: 64
    property real minHeight: 64

    // Icon display size
    readonly property real iconDisplaySize: Math.min(widgetWidth, widgetHeight) * 0.7

    implicitWidth: widgetWidth
    implicitHeight: widgetHeight

    // Get the icon path from Quickshell - returns a string path
    readonly property string iconPath: Quickshell.iconPath(desktopIcon, true) || ""

    // Click handler
    function launchDesktopItem() {
        if (desktopIsLink && linkTarget) {
            // It's a symlink (.ink file) - open the target
            Quickshell.execDetached(["xdg-open", linkTarget]);
        } else if (desktopExec) {
            // It's a .desktop file - launch via SessionService or gtk-launch
            const appId = desktopFileName.replace(/\.desktop$/, "");
            
            // Try to use SessionService for proper desktop entry launching
            if (typeof SessionService !== 'undefined') {
                const entry = DesktopEntries.lookup(desktopFilePath);
                if (entry) {
                    SessionService.launchDesktopEntry(entry);
                } else {
                    // Fallback to gtk-launch
                    Quickshell.execDetached(["gtk-launch", appId]);
                }
            } else {
                // Fallback to gtk-launch
                Quickshell.execDetached(["gtk-launch", appId]);
            }
        } else {
            // No exec, just open the file
            Quickshell.execDetached(["xdg-open", desktopFilePath]);
        }
    }

    // Visual content
    Column {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 4

        // Icon
        Item {
            width: parent.width
            height: widgetHeight - 24
            anchors.horizontalCenter: parent.horizontalCenter

            // Use Image with icon path - Quickshell.iconPath returns a usable path directly
            Image {
                id: iconImage
                anchors.centerIn: parent
                width: iconDisplaySize
                height: iconDisplaySize
                source: iconPath
                smooth: true
                asynchronous: true
                fillMode: Image.PreserveAspectFit

                // Fallback to icon if image fails
                EHIcon {
                    anchors.centerIn: parent
                    name: "application-x-desktop"
                    size: iconDisplaySize * 0.8
                    color: Theme.surfaceText
                    visible: iconImage.status !== Image.Ready || !iconPath
                }
            }
        }

        // Label
        StyledText {
            width: parent.width
            text: desktopName
            font.pixelSize: 11
            color: Theme.surfaceText
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideMiddle
            maximumLineCount: 2
            wrapMode: Text.Wrap
        }
    }

    // Invisible mouse area for interactions
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                root.launchDesktopItem();
            }
        }

        onDoubleClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                root.launchDesktopItem();
            }
        }
    }
}
