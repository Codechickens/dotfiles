import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Common
import qs.Widgets

PanelWindow {
    id: root

    WlrLayershell.namespace: "quickshell:minipanel"
    WlrLayershell.layer: WlrLayershell.Top
    WlrLayershell.anchors: WlrLayershell.TopAnchor
    WlrLayershell.exclusionMode: ExclusionMode.Ignore 

    property var modelData
    screen: modelData

    // Center the panel horizontally
    // Since WlrLayershell.anchors is just Top, it might default to left.
    // To center, we might need to rely on the compositor or manual margin calculation.
    // Quickshell doesn't strictly support "Center" anchor in WlrLayershell yet (it's bitwise).
    // However, if we don't anchor Left or Right, standard behavior varies.
    // A safe bet for centering is to make it full width transparent, and put content in center.
    // BUT the user asked for the panel itself (the window) to be determined by width.
    // If the window is full width, it blocks clicks on the sides.
    // So we really want the window size to match content.
    
    // If we use anchors: Top, and set width, Hyprland usually centers it if Left/Right are not set? 
    // Let's try just TopAnchor first.
    
    color: "transparent"
    visible: SettingsData.showMiniPanel

    property bool autoHide: SettingsData.miniPanelAutohide
    property bool reveal: !autoHide || hoverArea.containsMouse
    
    implicitWidth: mainContainer.implicitWidth
    implicitHeight: mainContainer.implicitHeight + (autoHide ? 1 : 0) // Keep 1px for mouse detection if hidden?

    // Input region for autohide detection
    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        // Extend detection area slightly below if needed?
        // anchors.margins: -10 
    }

    Rectangle {
        id: mainContainer
        color: Theme.surfaceContainer
        radius: Theme.cornerRadius
        border.width: 1
        border.color: Theme.outline
        
        opacity: root.reveal ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        
        width: mainLayout.implicitWidth + (Theme.spacingM * 2)
        height: mainLayout.implicitHeight + (Theme.spacingS * 2)

        RowLayout {
            id: mainLayout
            spacing: Theme.spacingM
            anchors.centerIn: parent
            
            // Placeholder for sections
            Row {
                id: leftSection
                spacing: Theme.spacingS
                Text { 
                    text: "Left" 
                    color: Theme.surfaceText
                } 
            }
            
            Row {
                id: centerSection
                spacing: Theme.spacingS
                Text { 
                    text: "Center" 
                    color: Theme.surfaceText
                } 
            }
            
            Row {
                id: rightSection
                spacing: Theme.spacingS
                Text { 
                    text: "Right" 
                    color: Theme.surfaceText
                } 
            }
        }
    }
}