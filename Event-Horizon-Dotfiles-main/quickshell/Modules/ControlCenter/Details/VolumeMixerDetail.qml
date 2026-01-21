import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Services.Pipewire
import qs.Common
import qs.Services
import qs.Widgets

Rectangle {
    implicitHeight: headerRow.height + audioContent.height + Theme.spacingM
    radius: Theme.cornerRadius
    color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, Theme.getContentBackgroundAlpha() * SettingsData.controlCenterWidgetBackgroundOpacity)
    border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.08)
    border.width: 1
    
    
    Row {
        id: headerRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: Theme.spacingM
        anchors.rightMargin: Theme.spacingM
        anchors.topMargin: Theme.spacingS
        height: 40
        
        StyledText {
            id: headerText
            text: "Volume Mixer"
            font.pixelSize: Theme.fontSizeLarge
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
        anchors.margins: Theme.spacingM
        anchors.topMargin: Theme.spacingM
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
                    
                    // Track individual node to ensure properties are bound
                    PwObjectTracker {
                        objects: modelData ? [modelData] : []
                    }
                    
                    // Define audio properties like the working implementation
                    property var nodeAudio: (modelData && modelData.audio) ? modelData.audio : null
                    property real appVolume: (nodeAudio && nodeAudio.volume !== undefined) ? nodeAudio.volume : 0.0
                    property bool appMuted: (nodeAudio && nodeAudio.muted !== undefined) ? nodeAudio.muted : false
                    
                    width: parent.width
                    height: Math.max(105, appContent.height + slider.height + Theme.spacingM * 3)
                    radius: Theme.cornerRadius
                    color: deviceMouseArea.containsMouse ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.08) : Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, index % 2 === 0 ? 0.3 : 0.2)
                    border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.12)
                    border.width: 1
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: Theme.spacingM
                        spacing: Theme.spacingM
                    
                        Row {
                            id: appContent
                            width: parent.width
                            spacing: Theme.spacingM

                            Image {
                                width: Theme.iconSize
                                height: Theme.iconSize
                                source: ApplicationAudioService.getApplicationIcon(modelData)
                                sourceSize.width: Theme.iconSize * 25
                                sourceSize.height: Theme.iconSize * 25
                                smooth: true
                                mipmap: true
                                fillMode: Image.PreserveAspectFit
                                cache: true
                                asynchronous: true
                                anchors.top: parent.top

                                EHIcon {
                                    anchors.fill: parent
                                    name: "volume_up"
                                    size: Theme.iconSize
                                    color: nodeAudio && !appMuted && appVolume > 0 ? Theme.primary : Theme.surfaceText
                                    visible: parent.status === Image.Error || parent.status === Image.Null || parent.source === ""
                                }
                            }

                            Column {
                                width: parent.width - (Theme.iconSize + Theme.spacingM)
                                spacing: Theme.spacingXS

                                StyledText {
                                    id: appNameText
                                    text: ApplicationAudioService.getApplicationName(modelData)
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    width: parent.width
                                    wrapMode: Text.WordWrap
                                    renderType: Text.QtRendering
                                    antialiasing: true
                                    smooth: true
                                }

                                StyledText {
                                    text: `${Math.round(appVolume * 100)}% • ${appMuted ? 'Muted' : 'Active'}`
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceVariantText
                                    width: parent.width
                                    wrapMode: Text.WordWrap
                                    renderType: Text.QtRendering
                                    antialiasing: true
                                    smooth: true
                                }
                            }
                        }

                        EHSlider {
                            anchors.top: appContent.bottom
                            anchors.topMargin: Theme.spacingM
                            width: parent.width
                            height: 24
                            enabled: nodeAudio && modelData.ready
                            minimum: 0
                            maximum: 100
                            value: Math.round(appVolume * 100)
                            showValue: false
                            thumbOutlineColor: Theme.surfaceContainer
                            trackColor: {
                                const alpha = Theme.getContentBackgroundAlpha() * 0.60
                                return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, alpha)
                            }
                            onSliderValueChanged: function(newValue) {
                                if (nodeAudio && modelData && modelData.ready !== false) {
                                    try {
                                        nodeAudio.volume = newValue / 100.0
                                    } catch (e) {
                                        console.log("Failed to set volume:", e)
                                    }
                                }
                            }
                        }
                    }
                    
                    MouseArea {
                        id: deviceMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (nodeAudio && modelData.ready) {
                                nodeAudio.muted = !appMuted
                            }
                        }
                    }
                    
                    Behavior on color {
                        ColorAnimation { duration: Theme.shortDuration }
                    }
                }
            }
            
            Rectangle {
                width: parent.width
                height: 50
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.1)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.12)
                border.width: 1
                visible: (ApplicationAudioService.applicationStreams || []).length === 0
                
                StyledText {
                    text: "No applications with audio"
                    font.pixelSize: Theme.fontSizeSmall
                    font.family: Qt.fontFamilies().indexOf("Roboto") >= 0 ? "Roboto" : (typeof SettingsData !== "undefined" && SettingsData.fontFamily ? SettingsData.fontFamily : "sans-serif")
                    color: Theme.surfaceVariantText
                    anchors.centerIn: parent
                    renderType: Text.QtRendering
                    antialiasing: true
                    smooth: true
                    layer.enabled: false
                }
            }
        }
    }
}
