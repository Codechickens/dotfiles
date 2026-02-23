import QtQuick
import Quickshell
import qs.Common
import qs.Widgets

Rectangle {
    id: root

    

    property real widgetHeight: 40
    property var parentScreen: null
    property real padding: 1
    property real iconSize: 64
    property real iconSpacing: 4
    property real scaleFactor: 1
    property bool isHovered: mouseArea.containsMouse

    readonly property real horizontalPadding: Math.max(Theme.spacingXS, Theme.spacingS * (widgetHeight / 30))

    width: launchpadIcon.width
    height: launchpadIcon.height
    radius: 0
    color: "transparent"

    onIsHoveredChanged: {
        if (isHovered) {
            exitAnimation.stop()
            if (!bounceAnimation.running)
                bounceAnimation.restart()
        } else {
            bounceAnimation.stop()
            exitAnimation.restart()
        }
    }

    SequentialAnimation {
        id: bounceAnimation

        running: false

        NumberAnimation {
            target: iconTransform
            property: "y"
            to: -8
            duration: Anims.durShort
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Anims.emphasizedAccel
        }

        NumberAnimation {
            target: iconTransform
            property: "y"
            to: -6
            duration: Anims.durShort
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Anims.emphasizedDecel
        }
    }

    NumberAnimation {
        id: exitAnimation

        running: false
        target: iconTransform
        property: "y"
        to: 0
        duration: Anims.durShort
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Anims.emphasizedDecel
    }

    function getLaunchpadLoader() {
        let current = root
        while (current) {
            if (current.launchpadLoader) {
                return current.launchpadLoader
            }
            current = current.parent
        }

        if (typeof launchpadLoader !== "undefined") {
            return launchpadLoader
        }

        return null
    }

    function openLaunchpad() {
        const loader = getLaunchpadLoader()
        if (!loader) {
            return
        }

        loader.active = true
        if (loader.item) {
            loader.item.targetScreen = parentScreen || (root.Window && root.Window.window ? root.Window.window.screen : Screen)
            if (loader.item.show) {
                loader.item.show()
            }
        }
    }

    Item {
        id: iconContainer
        anchors.centerIn: parent
        width: launchpadIcon.width
        height: launchpadIcon.height
        transform: Translate {
            id: iconTransform
            y: 0
        }
    }

    Image {
        id: launchpadIcon
        anchors.centerIn: iconContainer
        source: Qt.resolvedUrl("../../../assets/Dark_Launchpad.svg")
        width: 48 * (widgetHeight / 40)
        height: 48 * (widgetHeight / 40)
        smooth: true
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onClicked: root.openLaunchpad()
    }
}

