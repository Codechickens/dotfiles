import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import qs.Common
import qs.Widgets

PanelWindow {
    id: root

    WlrLayershell.namespace: "quickshell:dock:blur"

    property string text: ""
    property var anchorItem: null
    property real dockVisibleHeight: 40
    property bool showTooltip: false

    function showForButton(button, text, dockHeight) {
        if (showTooltip && anchorItem === button) {
            return
        }

        anchorItem = button
        root.text = text || ""
        dockVisibleHeight = dockHeight || 40

        const dockWindow = button.Window.window
        if (dockWindow) {
            for (var i = 0; i < Quickshell.screens.length; i++) {
                const s = Quickshell.screens[i]
                if (dockWindow.x >= s.x && dockWindow.x < s.x + s.width) {
                    root.screen = s
                    break
                }
            }
        }

        showTooltip = true
    }

    function hide() {
        showTooltip = false
    }

    screen: Quickshell.screens[0]

    visible: showTooltip && text !== ""
    WlrLayershell.layer: WlrLayershell.Overlay
    WlrLayershell.exclusiveZone: -1
    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    property point anchorPos: Qt.point(screen.width / 2, screen.height - 100)

    onAnchorItemChanged: updatePosition()
    onVisibleChanged: {
        if (visible) {
            updatePosition()
        }
    }

    function updatePosition() {
        if (!anchorItem) {
            anchorPos = Qt.point(screen.width / 2, screen.height - 100)
            return
        }

        const dockWindow = anchorItem.Window.window
        if (!dockWindow) {
            anchorPos = Qt.point(screen.width / 2, screen.height - 100)
            return
        }

        const buttonPosInDock = anchorItem.mapToItem(dockWindow.contentItem, 0, 0)
        let actualDockHeight = root.dockVisibleHeight

        function findDockBackground(item) {
            if (item.objectName === "dockBackground") {
                return item
            }
            for (var i = 0; i < item.children.length; i++) {
                const found = findDockBackground(item.children[i])
                if (found) {
                    return found
                }
            }
            return null
        }

        const dockBackground = findDockBackground(dockWindow.contentItem)
        if (dockBackground) {
            actualDockHeight = dockBackground.height
        }

        const dockBottomMargin = 16
        const buttonScreenY = root.screen.height - actualDockHeight - dockBottomMargin - 20

        const dockContentWidth = dockWindow.width
        const screenWidth = root.screen.width
        const dockLeftMargin = Math.round((screenWidth - dockContentWidth) / 2)
        const buttonScreenX = dockLeftMargin + buttonPosInDock.x + anchorItem.width / 2

        anchorPos = Qt.point(buttonScreenX, buttonScreenY)
    }

    Rectangle {
        id: tooltipContainer

        width: Math.min(300, Math.max(120, tooltipText.implicitWidth + Theme.spacingM * 2))
        height: Math.max(32, tooltipText.implicitHeight + Theme.spacingS * 2)

        x: {
            const left = 10
            const right = root.width - width - 10
            const want = root.anchorPos.x - width / 2
            return Math.max(left, Math.min(right, want))
        }
        y: Math.max(10, root.anchorPos.y - height + 30)

        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, Theme.popupTransparency)
        radius: Theme.cornerRadius
        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
        border.width: 1
        opacity: showTooltip ? 1 : 0
        scale: showTooltip ? 1 : 0.85

        StyledText {
            id: tooltipText
            anchors.centerIn: parent
            text: root.text
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceText
            wrapMode: Text.NoWrap
            maximumLineCount: 1
            elide: Text.ElideRight
            width: Math.min(implicitWidth, 300 - Theme.spacingM * 2)
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.mediumDuration
                easing.type: Theme.emphasizedEasing
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: Theme.mediumDuration
                easing.type: Theme.emphasizedEasing
            }
        }
    }
}