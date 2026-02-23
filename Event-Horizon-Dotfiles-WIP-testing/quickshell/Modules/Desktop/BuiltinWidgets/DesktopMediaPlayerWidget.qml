import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes
import Quickshell.Services.Mpris
import qs.Common
import qs.Services
import qs.Widgets

Item {
    id: root

    property string instanceId: ""
    property var instanceData: null
    readonly property var cfg: instanceData?.config ?? null
    readonly property bool isInstance: instanceId !== "" && cfg !== null

    property real widgetWidth: isInstance ? (cfg?.width ?? 360) : 360
    property real widgetHeight: isInstance ? (cfg?.height ?? 200) : 200
    property real defaultWidth: 360
    property real defaultHeight: 200
    property real minWidth: 280
    property real minHeight: 160

    readonly property real widgetOpacity: isInstance ? (cfg?.opacity ?? 0.8) : (SettingsData.desktopMediaPlayerOpacity ?? 0.8)

    // Font and button scale from settings
    readonly property real fontScale: isInstance ? (cfg?.fontScale ?? 1.0) : (SettingsData.desktopMediaPlayerFontScale ?? 1.0)
    readonly property real buttonScale: isInstance ? (cfg?.buttonScale ?? 1.0) : (SettingsData.desktopMediaPlayerButtonScale ?? 1.0)
    readonly property bool boldFont: isInstance ? (cfg?.boldFont ?? false) : (SettingsData.desktopMediaPlayerBoldFont ?? false)
    readonly property real artScale: isInstance ? (cfg?.artScale ?? 1.0) : (SettingsData.desktopMediaPlayerArtScale ?? 1.0)
    readonly property real visualizerIntensity: isInstance ? (cfg?.visualizerIntensity ?? 1.0) : (SettingsData.desktopMediaPlayerVisualizerIntensity ?? 1.0)

    // Scale factor based on widget size
    readonly property real scaleFactor: Math.min(widgetWidth / 360, widgetHeight / 200)

    // Vertical mode when height > width
    readonly property bool verticalMode: widgetHeight > widgetWidth

    // State-based layout switching
    states: State {
        name: "vertical"
        when: verticalMode
        PropertyChanges { target: verticalLayout; visible: true }
        PropertyChanges { target: horizontalLayout; visible: false }
    }
    State {
        name: "horizontal"
        when: !verticalMode
        PropertyChanges { target: verticalLayout; visible: false }
        PropertyChanges { target: horizontalLayout; visible: true }
    }

    readonly property MprisPlayer activePlayer: MprisController.activePlayer
    readonly property bool playerAvailable: activePlayer !== null
    property bool compactMode: false
    property bool showVisualizer: true
    property bool showControls: true

    implicitWidth: widgetWidth
    implicitHeight: widgetHeight

    // Cava audio visualization reference
    Loader {
        active: activePlayer?.playbackState === MprisPlaybackState.Playing
        sourceComponent: Component {
            Ref {
                service: CavaService
            }
        }
    }

    Timer {
        running: !CavaService.cavaAvailable && activePlayer?.playbackState === MprisPlaybackState.Playing
        interval: 256
        repeat: true
        onTriggered: {
            CavaService.values = [Math.random() * 40 + 10, Math.random() * 60 + 20, Math.random() * 50 + 15, Math.random() * 35 + 20, Math.random() * 45 + 15, Math.random() * 55 + 25]
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        radius: Theme.cornerRadius
        color: Qt.rgba(Theme.surfaceContainer.r, Theme.surfaceContainer.g, Theme.surfaceContainer.b, widgetOpacity)
        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, SettingsData.desktopWidgetBorderOpacity || 0.3)
        border.width: SettingsData.desktopWidgetBorderThickness || 1

        // Vertical mode: Column layout (mobile-style)
        Column {
            id: verticalLayout
            anchors.fill: parent
            anchors.margins: 16 * scaleFactor
            spacing: 12 * scaleFactor
            visible: verticalMode

            // Album art centered at top
            Item {
                width: parent.width
                height: width
                anchors.horizontalCenter: parent.horizontalCenter

                // Circular visualizer
                Shape {
                    id: circularVisualizerV
                    width: parent.width * 1.15 * artScale
                    height: parent.height * 1.15 * artScale
                    anchors.centerIn: parent
                    visible: showVisualizer && activePlayer?.playbackState === MprisPlaybackState.Playing
                    z: 0
                    asynchronous: false
                    antialiasing: true
                    preferredRendererType: Shape.CurveRenderer

                    layer.enabled: true
                    layer.smooth: true
                    layer.samples: 4

                    readonly property real centerX: width / 2
                    readonly property real centerY: height / 2
                    readonly property real baseRadius: Math.min(width, height) * 0.42
                    readonly property int segments: 24

                    property var audioLevels: {
                        if (!CavaService.cavaAvailable || CavaService.values.length === 0) {
                            return [0.5, 0.3, 0.7, 0.4, 0.6, 0.5]
                        }
                        return CavaService.values
                    }

                    property var smoothedLevels: [0.5, 0.3, 0.7, 0.4, 0.6, 0.5]
                    property var cubics: []

                    onAudioLevelsChanged: updatePath()

                    FrameAnimation {
                        running: circularVisualizerV.visible
                        onTriggered: circularVisualizerV.updatePath()
                    }

                    Component {
                        id: cubicSegmentV
                        PathCubic {}
                    }

                    Component.onCompleted: {
                        shapePathV.pathElements.push(Qt.createQmlObject(
                            'import QtQuick; import QtQuick.Shapes; PathMove {}', shapePathV
                        ))

                        for (let i = 0; i < segments; i++) {
                            const seg = cubicSegmentV.createObject(shapePathV)
                            shapePathV.pathElements.push(seg)
                            cubics.push(seg)
                        }

                        updatePath()
                    }

                    function expSmooth(prev, next, alpha) {
                        return prev + alpha * (next - prev)
                    }

                    function updatePath() {
                        if (cubics.length === 0) return

                        for (let i = 0; i < Math.min(smoothedLevels.length, audioLevels.length); i++) {
                            smoothedLevels[i] = expSmooth(smoothedLevels[i], audioLevels[i], 0.4)
                        }

                        const points = []
                        for (let i = 0; i < segments; i++) {
                            const angle = (i / segments) * 2 * Math.PI - Math.PI / 2
                            const audioIndex = i % Math.min(smoothedLevels.length, 6)

                            const rawLevel = smoothedLevels[audioIndex] || 0
                            const scaledLevel = Math.sqrt(Math.min(Math.max(rawLevel, 0), 100) / 100) * 100
                            const normalizedLevel = scaledLevel / 100
                            const audioLevel = Math.max(0.1, normalizedLevel) * 0.35 * root.visualizerIntensity

                            const radius = baseRadius * (1.0 + audioLevel)
                            const x = centerX + Math.cos(angle) * radius
                            const y = centerY + Math.sin(angle) * radius
                            points.push({x: x, y: y})
                        }

                        const startMove = shapePathV.pathElements[0]
                        startMove.x = points[0].x
                        startMove.y = points[0].y

                        const tension = 0.5
                        for (let i = 0; i < segments; i++) {
                            const p0 = points[(i - 1 + segments) % segments]
                            const p1 = points[i]
                            const p2 = points[(i + 1) % segments]
                            const p3 = points[(i + 2) % segments]

                            const c1x = p1.x + (p2.x - p0.x) * tension / 3
                            const c1y = p1.y + (p2.y - p0.y) * tension / 3
                            const c2x = p2.x - (p3.x - p1.x) * tension / 3
                            const c2y = p2.y - (p3.y - p1.y) * tension / 3

                            const seg = cubics[i]
                            seg.control1X = c1x
                            seg.control1Y = c1y
                            seg.control2X = c2x
                            seg.control2Y = c2y
                            seg.x = p2.x
                            seg.y = p2.y
                        }
                    }

                    ShapePath {
                        id: shapePathV
                        fillColor: Theme.primary
                        strokeColor: "transparent"
                        strokeWidth: 0
                        joinStyle: ShapePath.RoundJoin
                        fillRule: ShapePath.WindingFill
                    }
                }

                // Album art container
                Rectangle {
                    id: coverArtContainerV
                    width: parent.width * artScale
                    height: parent.height * artScale
                    anchors.centerIn: parent
                    radius: width / 2
                    z: 1
                    color: Theme.surfaceContainerHigh

                    Image {
                        id: coverArtV
                        anchors.fill: parent
                        source: activePlayer?.metadata["mpris:artUrl"] || ""
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        asynchronous: true
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: coverArtV.width > 0 ? coverArtV.width : 1
                                height: coverArtV.height > 0 ? coverArtV.height : 1
                                radius: width / 2
                            }
                        }
                    }

                    EHIcon {
                        anchors.centerIn: parent
                        name: "music_note"
                        size: parent.width * 0.35
                        color: Theme.surfaceTextMedium
                        visible: coverArtV.status !== Image.Ready
                    }
                }
            }

            // Text info column
            Column {
                width: parent.width
                spacing: 4 * scaleFactor

                StyledText {
                    id: trackTitleV
                    property string displayTitle: {
                        if (!activePlayer || !activePlayer.trackTitle) {
                            return "No Media Playing";
                        }
                        return activePlayer.trackTitle || "Unknown Track";
                    }
                    text: displayTitle
                    font.pixelSize: 16 * scaleFactor * fontScale
                    font.weight: root.boldFont ? Font.Bold : Font.Medium
                    color: Theme.surfaceText
                    wrapMode: Text.Wrap
                    elide: Text.ElideNone
                    maximumLineCount: 3
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }

                StyledText {
                    id: trackArtistV
                    property string displayArtist: {
                        if (!activePlayer) {
                            return "";
                        }
                        return activePlayer.trackArtist || activePlayer.identity || "";
                    }
                    text: displayArtist
                    font.pixelSize: 14 * scaleFactor * fontScale
                    color: Theme.surfaceTextMedium
                    wrapMode: Text.Wrap
                    elide: Text.ElideNone
                    maximumLineCount: 2
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // Progress bar
            Item {
                width: parent.width
                height: 8 * scaleFactor
                visible: activePlayer && activePlayer.canSeek

                Rectangle {
                    id: progressBarBgV
                    width: parent.width
                    height: 4 * scaleFactor
                    radius: 2 * scaleFactor
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.surfaceContainerHigh
                }

                Rectangle {
                    id: progressBarFillV
                    width: {
                        if (!activePlayer || !activePlayer.length) return 0;
                        return (activePlayer.position / activePlayer.length) * progressBarBgV.width;
                    }
                    height: 4 * scaleFactor
                    radius: 2 * scaleFactor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: progressBarBgV.left
                    color: Theme.primary
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: activePlayer && activePlayer.canSeek
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (activePlayer && activePlayer.canSeek && activePlayer.length) {
                            const newPosition = (mouse.x / width) * activePlayer.length;
                            activePlayer.seek(newPosition);
                        }
                    }
                }
            }

            // Compact playback controls
            Row {
                spacing: 16 * scaleFactor * buttonScale
                visible: showControls
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: 40 * scaleFactor * buttonScale
                    height: 40 * scaleFactor * buttonScale
                    radius: 20 * scaleFactor * buttonScale
                    color: prevAreaV.containsMouse ? Theme.primaryHover : Theme.primaryHover
                    visible: playerAvailable
                    opacity: (activePlayer && activePlayer.canGoPrevious) ? 1 : 0.4

                    EHIcon {
                        anchors.centerIn: parent
                        name: "skip_previous"
                        size: 20 * scaleFactor * buttonScale
                        color: Theme.surfaceText
                    }

                    MouseArea {
                        id: prevAreaV
                        anchors.fill: parent
                        enabled: playerAvailable && activePlayer && activePlayer.canGoPrevious
                        hoverEnabled: enabled
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if (activePlayer) {
                                activePlayer.previous();
                            }
                        }
                    }
                }

                Rectangle {
                    width: 52 * scaleFactor * buttonScale
                    height: 52 * scaleFactor * buttonScale
                    radius: 26 * scaleFactor * buttonScale
                    z: 1
                    color: activePlayer && activePlayer.playbackState === MprisPlaybackState.Playing ? Theme.primary : Theme.primaryHover
                    visible: playerAvailable
                    opacity: activePlayer ? 1 : 0.4

                    EHIcon {
                        anchors.centerIn: parent
                        name: activePlayer && activePlayer.playbackState === MprisPlaybackState.Playing ? "pause" : "play_arrow"
                        size: 28 * scaleFactor * buttonScale
                        color: activePlayer && activePlayer.playbackState === MprisPlaybackState.Playing ? Theme.background : Theme.primary
                    }

                    MouseArea {
                        id: playPauseAreaV
                        z: 2
                        anchors.fill: parent
                        enabled: playerAvailable && activePlayer && activePlayer.canTogglePlaying
                        hoverEnabled: enabled
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if (activePlayer) {
                                activePlayer.playPause();
                            }
                        }
                    }
                }

                Rectangle {
                    width: 40 * scaleFactor * buttonScale
                    height: 40 * scaleFactor * buttonScale
                    radius: 20 * scaleFactor * buttonScale
                    color: nextAreaV.containsMouse ? Theme.primaryHover : Theme.primaryHover
                    visible: playerAvailable
                    opacity: (activePlayer && activePlayer.canGoNext) ? 1 : 0.4

                    EHIcon {
                        anchors.centerIn: parent
                        name: "skip_next"
                        size: 20 * scaleFactor * buttonScale
                        color: Theme.surfaceText
                    }

                    MouseArea {
                        id: nextAreaV
                        anchors.fill: parent
                        enabled: playerAvailable && activePlayer && activePlayer.canGoNext
                        hoverEnabled: enabled
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if (activePlayer) {
                                activePlayer.next();
                            }
                        }
                    }
                }
            }

            // Visualizer intensity slider
            Row {
                spacing: 8 * scaleFactor
                visible: showVisualizer
                anchors.horizontalCenter: parent.horizontalCenter
                height: 20 * scaleFactor

                EHIcon {
                    name: "graphic_eq"
                    size: 14 * scaleFactor
                    color: Theme.surfaceTextLight
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: 100 * scaleFactor
                    height: 4 * scaleFactor
                    radius: 2 * scaleFactor
                    color: Theme.surfaceContainerHigh
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        width: (visualizerIntensity - 0.5) / 1.5 * parent.width
                        height: parent.height
                        radius: parent.radius
                        color: Theme.primary
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (isInstance) {
                                var newIntensity = 0.5 + (mouse.x / width) * 1.5;
                                newIntensity = Math.max(0.5, Math.min(2.0, newIntensity));
                                SettingsData.updateDesktopWidgetInstanceConfig(instanceId, {"visualizerIntensity": newIntensity});
                            } else {
                                var newIntensity = 0.5 + (mouse.x / width) * 1.5;
                                newIntensity = Math.max(0.5, Math.min(2.0, newIntensity));
                                SettingsData.setDesktopMediaPlayerVisualizerIntensity(newIntensity);
                            }
                        }
                        onPositionChanged: {
                            if (mouse.buttons & Qt.LeftButton) {
                                if (isInstance) {
                                    var newIntensity = 0.5 + (mouse.x / width) * 1.5;
                                    newIntensity = Math.max(0.5, Math.min(2.0, newIntensity));
                                    SettingsData.updateDesktopWidgetInstanceConfig(instanceId, {"visualizerIntensity": newIntensity});
                                } else {
                                    var newIntensity = 0.5 + (mouse.x / width) * 1.5;
                                    newIntensity = Math.max(0.5, Math.min(2.0, newIntensity));
                                    SettingsData.setDesktopMediaPlayerVisualizerIntensity(newIntensity);
                                }
                            }
                        }
                    }
                }

                EHIcon {
                    name: "bolt"
                    size: 14 * scaleFactor
                    color: Theme.surfaceTextLight
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Horizontal mode: Row layout (desktop-style)
        Row {
            id: horizontalLayout
            anchors.fill: parent
            anchors.margins: 16 * scaleFactor
            spacing: 16 * scaleFactor
            visible: !verticalMode

            // Left side - Album art with visualizer
            Item {
                id: albumArtSection
                width: height
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                // Circular visualizer - smaller, around album art
                Shape {
                    id: circularVisualizer
                    width: parent.width * 1.15 * artScale
                    height: parent.height * 1.15 * artScale
                    anchors.centerIn: parent
                    visible: showVisualizer && activePlayer?.playbackState === MprisPlaybackState.Playing
                    z: 0
                    asynchronous: false
                    antialiasing: true
                    preferredRendererType: Shape.CurveRenderer

                    layer.enabled: true
                    layer.smooth: true
                    layer.samples: 4

                    readonly property real centerX: width / 2
                    readonly property real centerY: height / 2
                    readonly property real baseRadius: Math.min(width, height) * 0.42
                    readonly property int segments: 24

                    property var audioLevels: {
                        if (!CavaService.cavaAvailable || CavaService.values.length === 0) {
                            return [0.5, 0.3, 0.7, 0.4, 0.6, 0.5]
                        }
                        return CavaService.values
                    }

                    property var smoothedLevels: [0.5, 0.3, 0.7, 0.4, 0.6, 0.5]
                    property var cubics: []

                    onAudioLevelsChanged: updatePath()

                    FrameAnimation {
                        running: circularVisualizer.visible
                        onTriggered: circularVisualizer.updatePath()
                    }

                    Component {
                        id: cubicSegment
                        PathCubic {}
                    }

                    Component.onCompleted: {
                        shapePath.pathElements.push(Qt.createQmlObject(
                            'import QtQuick; import QtQuick.Shapes; PathMove {}', shapePath
                        ))

                        for (let i = 0; i < segments; i++) {
                            const seg = cubicSegment.createObject(shapePath)
                            shapePath.pathElements.push(seg)
                            cubics.push(seg)
                        }

                        updatePath()
                    }

                    function expSmooth(prev, next, alpha) {
                        return prev + alpha * (next - prev)
                    }

                    function updatePath() {
                        if (cubics.length === 0) return

                        for (let i = 0; i < Math.min(smoothedLevels.length, audioLevels.length); i++) {
                            smoothedLevels[i] = expSmooth(smoothedLevels[i], audioLevels[i], 0.4)
                        }

                        const points = []
                        for (let i = 0; i < segments; i++) {
                            const angle = (i / segments) * 2 * Math.PI - Math.PI / 2
                            const audioIndex = i % Math.min(smoothedLevels.length, 6)

                            const rawLevel = smoothedLevels[audioIndex] || 0
                            const scaledLevel = Math.sqrt(Math.min(Math.max(rawLevel, 0), 100) / 100) * 100
                            const normalizedLevel = scaledLevel / 100
                            const audioLevel = Math.max(0.1, normalizedLevel) * 0.35 * root.visualizerIntensity

                            const radius = baseRadius * (1.0 + audioLevel)
                            const x = centerX + Math.cos(angle) * radius
                            const y = centerY + Math.sin(angle) * radius
                            points.push({x: x, y: y})
                        }

                        const startMove = shapePath.pathElements[0]
                        startMove.x = points[0].x
                        startMove.y = points[0].y

                        const tension = 0.5
                        for (let i = 0; i < segments; i++) {
                            const p0 = points[(i - 1 + segments) % segments]
                            const p1 = points[i]
                            const p2 = points[(i + 1) % segments]
                            const p3 = points[(i + 2) % segments]

                            const c1x = p1.x + (p2.x - p0.x) * tension / 3
                            const c1y = p1.y + (p2.y - p0.y) * tension / 3
                            const c2x = p2.x - (p3.x - p1.x) * tension / 3
                            const c2y = p2.y - (p3.y - p1.y) * tension / 3

                            const seg = cubics[i]
                            seg.control1X = c1x
                            seg.control1Y = c1y
                            seg.control2X = c2x
                            seg.control2Y = c2y
                            seg.x = p2.x
                            seg.y = p2.y
                        }
                    }

                    ShapePath {
                        id: shapePath
                        fillColor: Theme.primary
                        strokeColor: "transparent"
                        strokeWidth: 0
                        joinStyle: ShapePath.RoundJoin
                        fillRule: ShapePath.WindingFill
                    }
                }

                // Album art container
                Rectangle {
                    id: coverArtContainer
                    width: parent.width * artScale
                    height: parent.height * artScale
                    anchors.centerIn: parent
                    radius: width / 2
                    z: 1
                    color: Theme.surfaceContainerHigh

                    Image {
                        id: coverArt
                        anchors.fill: parent
                        source: activePlayer?.metadata["mpris:artUrl"] || ""
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        asynchronous: true
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: coverArt.width > 0 ? coverArt.width : 1
                                height: coverArt.height > 0 ? coverArt.height : 1
                                radius: width / 2
                            }
                        }
                    }

                    // Placeholder icon
                    EHIcon {
                        anchors.centerIn: parent
                        name: "music_note"
                        size: parent.width * 0.35
                        color: Theme.surfaceTextMedium
                        visible: coverArt.status !== Image.Ready
                    }
                }
            }

            // Right side - Track info and controls
            Item {
                id: infoColumn
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - albumArtSection.width - horizontalLayout.spacing
                height: albumArtSection.height

                // Centered content in the info area
                Column {
                    id: infoContent
                    anchors.centerIn: parent
                    width: parent.width
                    spacing: 4 * scaleFactor

                    // Track title
                    StyledText {
                        id: trackTitle
                        property string displayTitle: {
                            if (!activePlayer || !activePlayer.trackTitle) {
                                return "No Media Playing";
                            }
                            return activePlayer.trackTitle || "Unknown Track";
                        }
                        text: displayTitle
                        font.pixelSize: 15 * scaleFactor * fontScale
                        font.weight: root.boldFont ? Font.Bold : Font.Medium
                        color: Theme.surfaceText
                        wrapMode: Text.Wrap
                        elide: Text.ElideNone
                        maximumLineCount: 3
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }

                    // Artist
                    StyledText {
                        id: trackArtist
                        property string displayArtist: {
                            if (!activePlayer) {
                                return "";
                            }
                            return activePlayer.trackArtist || activePlayer.identity || "";
                        }
                        text: displayArtist
                        font.pixelSize: 13 * scaleFactor * fontScale
                        color: Theme.surfaceTextMedium
                        wrapMode: Text.Wrap
                        elide: Text.ElideNone
                        maximumLineCount: 2
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }

                    // Spacer
                    Item {
                        width: 1
                        height: 6 * scaleFactor
                    }

                    // Progress bar (if available)
                    Item {
                        width: parent.width
                        height: 6 * scaleFactor
                        visible: activePlayer && activePlayer.canSeek

                        Rectangle {
                            id: progressBarBg
                            width: parent.width
                            height: 4 * scaleFactor
                            radius: 2 * scaleFactor
                            anchors.verticalCenter: parent.verticalCenter
                            color: Theme.surfaceContainerHigh
                        }

                        Rectangle {
                            id: progressBarFill
                            width: {
                                if (!activePlayer || !activePlayer.length) return 0;
                                return (activePlayer.position / activePlayer.length) * progressBarBg.width;
                            }
                            height: 4 * scaleFactor
                            radius: 2 * scaleFactor
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: progressBarBg.left
                            color: Theme.primary
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: activePlayer && activePlayer.canSeek
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (activePlayer && activePlayer.canSeek && activePlayer.length) {
                                    const newPosition = (mouse.x / width) * activePlayer.length;
                                    activePlayer.seek(newPosition);
                                }
                            }
                        }
                    }

                    // Playback controls
                    Row {
                        spacing: 12 * scaleFactor * buttonScale
                        visible: showControls
                        anchors.horizontalCenter: parent.horizontalCenter

                        // Previous button
                        Rectangle {
                            width: 36 * scaleFactor * buttonScale
                            height: 36 * scaleFactor * buttonScale
                            radius: 18 * scaleFactor * buttonScale
                            color: prevArea.containsMouse ? Theme.primaryHover : Theme.primaryHover
                            visible: playerAvailable
                            opacity: (activePlayer && activePlayer.canGoPrevious) ? 1 : 0.4

                            EHIcon {
                                anchors.centerIn: parent
                                name: "skip_previous"
                                size: 18 * scaleFactor * buttonScale
                                color: Theme.surfaceText
                            }

                            MouseArea {
                                id: prevArea
                                anchors.fill: parent
                                enabled: playerAvailable && activePlayer && activePlayer.canGoPrevious
                                hoverEnabled: enabled
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: {
                                    if (activePlayer) {
                                        activePlayer.previous();
                                    }
                                }
                            }
                        }

                        // Play/Pause button
                        Rectangle {
                            id: playPauseButton
                            width: 44 * scaleFactor * buttonScale
                            height: 44 * scaleFactor * buttonScale
                            radius: 22 * scaleFactor * buttonScale
                            z: 1
                            color: activePlayer && activePlayer.playbackState === MprisPlaybackState.Playing ? Theme.primary : Theme.primaryHover
                            visible: playerAvailable
                            opacity: activePlayer ? 1 : 0.4

                            EHIcon {
                                anchors.centerIn: parent
                                name: activePlayer && activePlayer.playbackState === MprisPlaybackState.Playing ? "pause" : "play_arrow"
                                size: 24 * scaleFactor * buttonScale
                                color: activePlayer && activePlayer.playbackState === MprisPlaybackState.Playing ? Theme.background : Theme.primary
                            }

                            MouseArea {
                                id: playPauseArea
                                z: 2
                                anchors.fill: parent
                                enabled: playerAvailable && activePlayer && activePlayer.canTogglePlaying
                                hoverEnabled: enabled
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: {
                                    if (activePlayer) {
                                        activePlayer.playPause();
                                    }
                                }
                            }
                        }

                        // Next button
                        Rectangle {
                            width: 36 * scaleFactor * buttonScale
                            height: 36 * scaleFactor * buttonScale
                            radius: 18 * scaleFactor * buttonScale
                            color: nextArea.containsMouse ? Theme.primaryHover : Theme.primaryHover
                            visible: playerAvailable
                            opacity: (activePlayer && activePlayer.canGoNext) ? 1 : 0.4

                            EHIcon {
                                anchors.centerIn: parent
                                name: "skip_next"
                                size: 18 * scaleFactor * buttonScale
                                color: Theme.surfaceText
                            }

                            MouseArea {
                                id: nextArea
                                anchors.fill: parent
                                enabled: playerAvailable && activePlayer && activePlayer.canGoNext
                                hoverEnabled: enabled
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: {
                                    if (activePlayer) {
                                        activePlayer.next();
                                    }
                                }
                            }
                        }
                    }

                    // Visualizer intensity slider
                    Row {
                        spacing: 8 * scaleFactor
                        visible: showVisualizer
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 20 * scaleFactor

                        EHIcon {
                            name: "graphic_eq"
                            size: 14 * scaleFactor
                            color: Theme.surfaceTextLight
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Rectangle {
                            width: 80 * scaleFactor
                            height: 4 * scaleFactor
                            radius: 2 * scaleFactor
                            color: Theme.surfaceContainerHigh
                            anchors.verticalCenter: parent.verticalCenter

                            Rectangle {
                                width: (visualizerIntensity - 0.5) / 1.5 * parent.width
                                height: parent.height
                                radius: parent.radius
                                color: Theme.primary
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (isInstance) {
                                        var newIntensity = 0.5 + (mouse.x / width) * 1.5;
                                        newIntensity = Math.max(0.5, Math.min(2.0, newIntensity));
                                        SettingsData.updateDesktopWidgetInstanceConfig(instanceId, {"visualizerIntensity": newIntensity});
                                    } else {
                                        var newIntensity = 0.5 + (mouse.x / width) * 1.5;
                                        newIntensity = Math.max(0.5, Math.min(2.0, newIntensity));
                                        SettingsData.setDesktopMediaPlayerVisualizerIntensity(newIntensity);
                                    }
                                }
                                onPositionChanged: {
                                    if (mouse.buttons & Qt.LeftButton) {
                                        if (isInstance) {
                                            var newIntensity = 0.5 + (mouse.x / width) * 1.5;
                                            newIntensity = Math.max(0.5, Math.min(2.0, newIntensity));
                                            SettingsData.updateDesktopWidgetInstanceConfig(instanceId, {"visualizerIntensity": newIntensity});
                                        } else {
                                            var newIntensity = 0.5 + (mouse.x / width) * 1.5;
                                            newIntensity = Math.max(0.5, Math.min(2.0, newIntensity));
                                            SettingsData.setDesktopMediaPlayerVisualizerIntensity(newIntensity);
                                        }
                                    }
                                }
                            }
                        }

                        EHIcon {
                            name: "bolt"
                            size: 14 * scaleFactor
                            color: Theme.surfaceTextLight
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // Spacer to push controls to bottom when no progress bar
                    Item {
                        width: 1
                        height: 1
                        visible: !activePlayer || !activePlayer.canSeek
                    }
                }
            }
        }
    }
}
