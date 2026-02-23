import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Services.Pipewire
import qs.Common
import qs.Services
import qs.Widgets

Rectangle {
    implicitHeight: 400
    radius: Theme.cornerRadius
    color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, Theme.getContentBackgroundAlpha() * SettingsData.controlCenterWidgetBackgroundOpacity)
    border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.08)
    border.width: 1

    Row {
        id: headerRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: Theme.spacingM * 0.6
        anchors.rightMargin: Theme.spacingM * 0.6
        anchors.topMargin: Theme.spacingS * 0.6
        height: 20

        StyledText {
            id: headerText
            text: "Volume Mixer"
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.surfaceText
            font.weight: Font.Medium
            anchors.verticalCenter: parent.verticalCenter
            renderType: Text.QtRendering
            antialiasing: true
            smooth: true
            layer.enabled: false
        }
    }

    EHFlickable {
        id: audioContent
        anchors.top: headerRow.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.spacingM * 0.6
        anchors.topMargin: Theme.spacingM * 0.6
        contentHeight: audioColumn.height
        clip: true

        Column {
            id: audioColumn
            width: parent.width
            spacing: Theme.spacingS

            Repeater {
                model: ApplicationAudioService.applicationStreams || []

                delegate: Rectangle {
                    required property var modelData
                    required property int index

                    property var nodeAudio: (modelData && modelData.audio) ? modelData.audio : null
                    property real appVolume: (nodeAudio && nodeAudio.volume !== undefined) ? nodeAudio.volume : 0.0
                    property bool appMuted: (nodeAudio && nodeAudio.muted !== undefined) ? nodeAudio.muted : false

                    width: parent.width
                    height: 80
                    radius: Theme.cornerRadius
                    color: index % 2 === 0 ? Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3) : Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.2)
                    border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.12)
                    border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: Theme.spacingM
                        spacing: Theme.spacingS

                        Row {
                            id: appContent
                            width: parent.width
                            spacing: Theme.spacingM

                            Image {
                                width: 20
                                height: 20
                                source: ApplicationAudioService.getApplicationIcon(modelData)
                                sourceSize.width: 20 * 25
                                sourceSize.height: 20 * 25
                                smooth: true
                                mipmap: true
                                fillMode: Image.PreserveAspectFit
                                cache: true
                                asynchronous: true
                                anchors.top: parent.top

                                EHIcon {
                                    anchors.fill: parent
                                    name: "volume_up"
                                    size: 20
                                    color: nodeAudio && !appMuted && appVolume > 0 ? Theme.primary : Theme.surfaceText
                                    visible: parent.status === Image.Error || parent.status === Image.Null || parent.source === ""
                                }
                            }

                            Column {
                                width: parent.width - (20 + Theme.spacingM)
                                spacing: Theme.spacingXS

                                Row {
                                    width: parent.width
                                    spacing: Theme.spacingS

                                    StyledText {
                                        text: ApplicationAudioService.getApplicationName(modelData)
                                        font.pixelSize: Theme.fontSizeMedium
                                        font.weight: Font.Medium
                                        color: Theme.surfaceText
                                        elide: Text.ElideRight
                                        width: parent.width - 100
                                        renderType: Text.QtRendering
                                        antialiasing: true
                                        smooth: true
                                    }

                                    StyledText {
                                        text: `${Math.round(appVolume * 100)}%`
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        renderType: Text.QtRendering
                                        antialiasing: true
                                        smooth: true
                                    }

                                    StyledText {
                                        text: appMuted ? 'Muted' : 'Active'
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        renderType: Text.QtRendering
                                        antialiasing: true
                                        smooth: true
                                    }
                                }

                                EHSlider {
                                    id: slider
                                    width: parent.width
                                    height: 35
                                    enabled: nodeAudio && modelData.ready
                                    minimum: 0
                                    maximum: 100
                                    value: Math.round(appVolume * 100)
                                    showValue: false
                                    thumbOutlineColor: Theme.surfaceContainer
                                    scaleFactor: 0.8
                                    trackColor: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, Theme.getContentBackgroundAlpha() * 0.60)
                                    onSliderValueChanged: function(newValue) {
                                        if (nodeAudio && modelData && modelData.ready !== false) {
                                            try {
                                                ApplicationAudioService.setApplicationVolume(modelData, newValue)
                                            } catch (e) {
                                                console.log("Failed to set volume:", e)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Input Applications Section
            Rectangle {
                width: parent.width
                height: inputAppsColumn.height + Theme.spacingM * 1.6
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.15)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.12)
                border.width: 1
                visible: (ApplicationAudioService.applicationInputStreams || []).length > 0

                Column {
                    id: inputAppsColumn
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: Theme.spacingM * 0.6
                    spacing: Theme.spacingS * 0.8

                    Row {
                        id: inputHeader
                        width: parent.width
                        spacing: Theme.spacingS * 0.6

                        EHIcon {
                            name: "mic"
                            size: 16
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Input Applications"
                            font.pixelSize: Theme.fontSizeSmall
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Repeater {
                        model: ApplicationAudioService.applicationInputStreams || []

                        delegate: Rectangle {
                            required property var modelData
                            required property int index

                            property var nodeAudio: (modelData && modelData.audio) ? modelData.audio : null
                            property real appVolume: (nodeAudio && nodeAudio.volume !== undefined) ? nodeAudio.volume : 0.0
                            property bool appMuted: (nodeAudio && nodeAudio.muted !== undefined) ? nodeAudio.muted : false

                            width: parent.width
                            height: 80
                            radius: Theme.cornerRadius
                            color: index % 2 === 0 ? Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.25) : Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.15)
                            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.12)
                            border.width: 1

                            Column {
                                anchors.fill: parent
                                anchors.margins: Theme.spacingM
                                spacing: Theme.spacingS

                                Row {
                                    id: inputAppContent
                                    width: parent.width
                                    spacing: Theme.spacingM

                                    Image {
                                        width: 20
                                        height: 20
                                        source: ApplicationAudioService.getApplicationIcon(modelData)
                                        sourceSize.width: 20 * 25
                                        sourceSize.height: 20 * 25
                                        smooth: true
                                        mipmap: true
                                        fillMode: Image.PreserveAspectFit
                                        cache: true
                                        asynchronous: true
                                        anchors.top: parent.top

                                        EHIcon {
                                            anchors.fill: parent
                                            name: "mic"
                                            size: 20
                                            color: nodeAudio && !appMuted && appVolume > 0 ? Theme.primary : Theme.surfaceText
                                            visible: parent.status === Image.Error || parent.status === Image.Null || parent.source === ""
                                        }
                                    }

                                    Column {
                                        width: parent.width - (20 + Theme.spacingM)
                                        spacing: Theme.spacingXS

                                        Row {
                                            width: parent.width
                                            spacing: Theme.spacingS

                                            StyledText {
                                                text: ApplicationAudioService.getApplicationName(modelData)
                                                font.pixelSize: Theme.fontSizeMedium
                                                font.weight: Font.Medium
                                                color: Theme.surfaceText
                                                elide: Text.ElideRight
                                                width: parent.width - 100
                                                renderType: Text.QtRendering
                                                antialiasing: true
                                                smooth: true
                                            }

                                            StyledText {
                                                text: `${Math.round(appVolume * 100)}%`
                                                font.pixelSize: Theme.fontSizeSmall
                                                color: Theme.surfaceVariantText
                                                renderType: Text.QtRendering
                                                antialiasing: true
                                                smooth: true
                                            }

                                            StyledText {
                                                text: appMuted ? 'Muted' : 'Active'
                                                font.pixelSize: Theme.fontSizeSmall
                                                color: Theme.surfaceVariantText
                                                renderType: Text.QtRendering
                                                antialiasing: true
                                                smooth: true
                                            }
                                        }

                                        EHSlider {
                                            id: inputSlider
                                            width: parent.width
                                            height: 35
                                            enabled: nodeAudio && modelData.ready
                                            minimum: 0
                                            maximum: 100
                                            value: Math.round(appVolume * 100)
                                            showValue: false
                                            thumbOutlineColor: Theme.surfaceContainer
                                            scaleFactor: 0.8
                                            trackColor: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, Theme.getContentBackgroundAlpha() * 0.60)
                                            onSliderValueChanged: function(newValue) {
                                                if (nodeAudio && modelData && modelData.ready !== false) {
                                                    try {
                                                        ApplicationAudioService.setApplicationInputVolume(modelData, newValue)
                                                    } catch (e) {
                                                        console.log("Failed to set input volume:", e)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            StyledText {
                text: "No applications with audio"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
                anchors.horizontalCenter: parent.horizontalCenter
                visible: (ApplicationAudioService.applicationStreams || []).length === 0 && (ApplicationAudioService.applicationInputStreams || []).length === 0
            }

            StyledText {
                text: "No applications with audio input"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
                anchors.horizontalCenter: parent.horizontalCenter
                visible: (ApplicationAudioService.applicationInputStreams || []).length === 0 && (ApplicationAudioService.applicationStreams || []).length > 0
            }
        }
    }
}
