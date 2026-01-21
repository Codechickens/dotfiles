import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modals.FileBrowser

Column {
    id: root

    property string instanceId: ""
    property var instanceData: null

    readonly property var cfg: instanceData?.config ?? {}

    function updateConfig(key, value) {
        if (!instanceId)
            return;
        var updates = {};
        updates[key] = value;
        SettingsData.updateDesktopWidgetInstanceConfig(instanceId, updates);
    }

    function getToggleValue(key, defaultValue) {
        if (cfg && cfg.hasOwnProperty(key)) {
            return cfg[key];
        }
        return defaultValue;
    }

    function getValue(key, defaultValue) {
        if (cfg && cfg.hasOwnProperty(key)) {
            return cfg[key];
        }
        return defaultValue;
    }

    width: parent?.width ?? 400
    spacing: Theme.spacingM

    StyledText {
        text: "Wallpaper Directory"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    StyledText {
        text: "Select the folder containing your wallpaper images"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        width: parent.width
        wrapMode: Text.WordWrap
    }

    Row {
        width: parent.width
        spacing: Theme.spacingM

        StyledRect {
            width: 80
            height: 80
            radius: Theme.cornerRadius
            color: Theme.surfaceContainerHigh
            border.color: Theme.outline
            border.width: 1

            Item {
                anchors.fill: parent
                anchors.margins: 1

                EHIcon {
                    anchors.centerIn: parent
                    name: "folder"
                    size: 32
                    color: Theme.surfaceVariantText
                }

                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(0, 0, 0, 0.3)
                    visible: folderMouseArea.containsMouse

                    EHIcon {
                        anchors.centerIn: parent
                        name: "edit"
                        size: 20
                        color: Theme.surfaceText
                    }
                }

                MouseArea {
                    id: folderMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        wallpaperBrowser.open()
                    }
                }
            }
        }

        Column {
            width: parent.width - 80 - Theme.spacingM
            spacing: Theme.spacingS
            anchors.verticalCenter: parent.verticalCenter

            StyledText {
                text: getValue("wallpaperDir", "") ? getValue("wallpaperDir", "").split('/').pop() : "No folder selected"
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: getValue("wallpaperDir", "") ? Theme.surfaceText : Theme.outline
                elide: Text.ElideMiddle
                width: parent.width
            }

            StyledText {
                text: getValue("wallpaperDir", "") ? getValue("wallpaperDir", "") : "Click the folder icon to select a directory with wallpapers"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
                elide: Text.ElideMiddle
                width: parent.width
                maximumLineCount: 1
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outlineMedium
    }

    StyledText {
        text: "Display Options"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    StyledText {
        text: "Configure the appearance and behavior of the wallpaper gallery"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        width: parent.width
        wrapMode: Text.WordWrap
    }

    EHToggle {
        width: parent.width
        text: "Show Controls"
        description: "Display folder browser and navigation controls"
        checked: getToggleValue("showControls", true)
        onToggled: checked => {
            root.updateConfig("showControls", checked)
        }
    }

    EHToggle {
        width: parent.width
        text: "Show Filenames"
        description: "Display wallpaper filenames on hover"
        checked: getToggleValue("showFileNames", true)
        onToggled: checked => {
            root.updateConfig("showFileNames", checked)
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outlineMedium
    }

    StyledText {
        text: "Grid Layout"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    Row {
        width: parent.width
        spacing: Theme.spacingM

        Column {
            width: (parent.width - Theme.spacingM) / 2
            spacing: Theme.spacingS

            StyledText {
                text: "Columns"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }

            EHDropdown {
                width: parent.width
                model: [2, 3, 4, 5, 6, 7, 8]
                currentValue: getValue("gridColumns", 4)
                onActivated: value => {
                    root.updateConfig("gridColumns", value)
                }
            }
        }

        Column {
            width: (parent.width - Theme.spacingM) / 2
            spacing: Theme.spacingS

            StyledText {
                text: "Rows"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }

            EHDropdown {
                width: parent.width
                model: [2, 3, 4, 5, 6, 7, 8, 9, 10]
                currentValue: getValue("gridRows", 3)
                onActivated: value => {
                    root.updateConfig("gridRows", value)
                }
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outlineMedium
    }

    StyledText {
        text: "Appearance"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    Row {
        width: parent.width
        spacing: Theme.spacingM

        Column {
            width: (parent.width - Theme.spacingM) / 2
            spacing: Theme.spacingS

            StyledText {
                text: "Font Size"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }

            EHDropdown {
                width: parent.width
                model: [8, 9, 10, 11, 12, 13, 14, 15, 16]
                currentValue: getValue("fontSize", 12)
                onActivated: value => {
                    root.updateConfig("fontSize", value)
                }
            }
        }

        Column {
            width: (parent.width - Theme.spacingM) / 2
            spacing: Theme.spacingS

            StyledText {
                text: "Padding"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }

            EHDropdown {
                width: parent.width
                model: [8, 12, 16, 20, 24, 28, 32]
                currentValue: getValue("padding", 16)
                onActivated: value => {
                    root.updateConfig("padding", value)
                }
            }
        }
    }

    Column {
        width: parent.width
        spacing: Theme.spacingS

        StyledText {
            text: "Spacing"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceVariantText
        }

        EHDropdown {
            width: parent.width
            model: [2, 3, 4, 5, 6, 7, 8, 9, 10]
            currentValue: getValue("spacing", 4)
            onActivated: value => {
                root.updateConfig("spacing", value)
            }
        }
    }

    FileBrowserModal {
        id: wallpaperBrowser

        browserTitle: "Select Wallpaper Directory"
        browserIcon: "folder_open"
        browserType: "wallpaper"
        fileExtensions: ["*.jpg", "*.jpeg", "*.png", "*.bmp", "*.gif", "*.webp"]
        selectFolderMode: true
        onFolderSelected: folderPath => {
            var cleanPath = folderPath.replace(/^file:\/\//, '');
            root.updateConfig("wallpaperDir", cleanPath);
            close()
        }
    }
}