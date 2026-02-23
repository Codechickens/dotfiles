import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Qt.labs.platform 1.1
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modals.FileBrowser

Item {
    id: layoutManagerTab

    property var parentModal: null
    property string importSelectedFilePath: ""

    ListModel {
        id: savedLayoutsModel
    }

    Component.onCompleted: {
        // Delay loading to ensure Quickshell is available
        loadTimer.start()
    }

    Timer {
        id: loadTimer
        interval: 100 // 100ms delay
        repeat: false
        onTriggered: {
            loadSavedLayouts()
        }
    }

    // Layout presets with detailed information
    readonly property var defaultLayouts: [
        {
            "name": "Windows 11",
            "description": "Custom Windows 11 layout loaded from your windows_11.json file."
        },
        {
            "name": "macOS",
            "description": "Custom macOS layout loaded from your macos.json file."
        },
        {
            "name": "GNOME",
            "description": "Custom GNOME layout loaded from your gnome.json file."
        },
        {
            "name": "Super Dock",
            "description": "A Dock for the ages loaded from your super_dock.json file."
        },
        {
            "name": "ZorinOS",
            "description": "Zorin's look and feel loaded from your zorinos.json file."
        },
        {
            "name": "KDE",
            "description": "Watch out for the bugs loaded from your kde.json file."
        }
    ]

    function showMessage(msg) {
        if (typeof ToastService !== "undefined" && ToastService.showInfo) {
            ToastService.showInfo(msg)
        }
    }

    function showSuccess(msg) {
        if (typeof ToastService !== "undefined" && ToastService.showSuccess) {
            ToastService.showSuccess(msg)
        }
    }

    function loadPresetLayoutFromFile(layoutName) {
        try {
            // Convert layout name to filename (lowercase, replace spaces with underscores)
            var fileName = layoutName.toLowerCase().replace(/\s+/g, "_") + ".json"
            var layoutsDir = `${StandardPaths.writableLocation(StandardPaths.ConfigLocation)}/quickshell/Layouts/`

            var filePath = layoutsDir + fileName
            console.log("Loading preset layout from:", filePath)

            // Create FileView to read the preset file
            var presetFile = Qt.createQmlObject('
                import QtQuick
                import Quickshell.Io
                FileView {
                    blockLoading: true
                }
            ', layoutManagerTab)

            if (presetFile) {
                presetFile.path = filePath
                var fileContent = presetFile.text()
                if (fileContent && fileContent.trim()) {
                    var layout = JSON.parse(fileContent.trim())
                    console.log("Successfully loaded preset layout from file:", layoutName)
                    return layout
                } else {
                    console.log("Preset layout file is empty or could not be read:", filePath)
                }
            } else {
                console.log("Could not create FileView for preset layout")
            }
        } catch (e) {
            console.log("Failed to load preset layout from file:", layoutName, e)
        }
        return null
    }

    function showError(msg) {
        if (typeof ToastService !== "undefined" && ToastService.showError) {
            ToastService.showError(msg)
        }
    }

    function loadSavedLayouts() {
        savedLayoutsModel.clear()
        var layouts = []

        try {
            // Load from DarkMaterialShell/Layouts directory for saved layouts gallery
            var configUrl = StandardPaths.writableLocation(StandardPaths.ConfigLocation)
            var configPath = configUrl.toString().replace("file://", "")
            var darkMaterialDir = configPath + "/DarkMaterialShell/Layouts/"
            console.log("Loading saved layouts from:", darkMaterialDir)

            // Check if directory exists
            try {
                if (typeof Quickshell !== "undefined" && typeof Quickshell.exec === "function") {
                    var dirCheck = Quickshell.exec(["test", "-d", darkMaterialDir])
                    console.log("Directory exists check result:", dirCheck)
                    if (dirCheck === 0) {
                        console.log("Directory exists")
                    } else {
                        console.log("Directory does not exist")
                    }
                }
            } catch (e) {
                console.log("Could not check directory:", e)
            }

            // Load all .json files from DarkMaterialShell directory

            // Use FileView to read files from the Layouts directory
            // Since XMLHttpRequest is disabled for local files, we use a different approach
            console.log("Scanning for layout files using FileView...")
            
            // Scan for all .json files in the Layouts directory
            console.log("Scanning for layout files using FileView...")
            
            // Use a glob-like approach to find all JSON files
            // First, let's try to read the directory listing
            var testFilePath = darkMaterialDir + "test_listing.txt"
            
            // Create a FileView to test directory access
            var testView = Qt.createQmlObject('
                import QtQuick
                import Quickshell.Io
                FileView {
                    blockLoading: true
                    printErrors: false
                }
            ', layoutManagerTab)
            
            // Known layout files to check (for backwards compatibility and guaranteed detection)
            var knownLayoutFiles = [
                "super_dock.json"
            ]
            
            // Try to find more files by checking common naming patterns
            var possibleLayoutNames = [
                "windows_11.json", "macos.json", "gnome.json", "kde.json", "zorinos.json",
                "dockbar.json", "super_dock.json", "windows_11_layout.json", "custom_layout.json"
            ]
            
            // Combine all files to check
            var allFilesToCheck = [...new Set([...knownLayoutFiles, ...possibleLayoutNames])]
            
            // Try to load each file using FileView
            allFilesToCheck.forEach(function(fileName) {
                var filePath = darkMaterialDir + fileName
                try {
                    console.log("Checking for layout file:", filePath)
                    
                    // Create a FileView to read the layout file
                    var layoutFile = Qt.createQmlObject('
                        import QtQuick
                        import Quickshell.Io
                        FileView {
                            blockLoading: true
                            printErrors: false
                        }
                    ', layoutManagerTab)

                    if (layoutFile) {
                        layoutFile.path = filePath
                        var fileContent = layoutFile.text()
                        
                        if (fileContent && fileContent.trim()) {
                            console.log("Found and loaded layout file:", filePath)
                            try {
                                var layout = JSON.parse(fileContent.trim())
                                layout.filePath = filePath
                                layout.isCustom = true
                                layouts.push(layout)
                                console.log("Added layout to gallery:", layout.name)
                            } catch (parseError) {
                                console.log("Failed to parse JSON from:", filePath, parseError)
                            }
                        } else {
                            console.log("File exists but is empty:", filePath)
                        }
                    } else {
                        console.log("Failed to create FileView for:", filePath)
                    }
                } catch (e) {
                    // Silently ignore missing files - only log at debug level
                    console.log("Layout file not found (this is OK):", fileName)
                }
            })

            if (layouts.length === 0) {
                console.log("No layout files found in:", darkMaterialDir)
            } else {
                console.log("Found and loaded", layouts.length, "layout files")
            }
        } catch (e) {
            console.error("Failed to load saved layouts:", e)
        }

        // Sort by timestamp (newest first)
        layouts.sort(function(a, b) {
            var timeA = a.timestamp ? new Date(a.timestamp).getTime() : 0
            var timeB = b.timestamp ? new Date(b.timestamp).getTime() : 0
            return timeB - timeA
        })

        // Add to ListModel
        layouts.forEach(function(layout) {
            savedLayoutsModel.append(layout)
        })

        // Debug: Show how many layouts were loaded
        console.log("Loaded", layouts.length, "saved layouts")
    }


    function getLayoutIcon(layoutName) {
        switch (layoutName) {
            case "Windows 11": return "grid_view"
            case "macOS": return "dock"
            case "GNOME": return "view_sidebar"
            default: return "dashboard"
        }
    }

    function createCurrentLayoutSnapshot() {
        return {
            "version": "1.0",
            "name": "Current Layout",
            "description": "Current layout snapshot",
            "timestamp": new Date().toISOString(),
            "topBar": {
                "visible": SettingsData.topBarVisible !== undefined ? SettingsData.topBarVisible : false,
                "position": SettingsData.topBarPosition || "top",
                "float": SettingsData.topBarFloat !== undefined ? SettingsData.topBarFloat : false,
                "roundedCorners": SettingsData.topBarRoundedCorners !== undefined ? SettingsData.topBarRoundedCorners : false,
                "cornerRadius": SettingsData.topBarCornerRadius !== undefined ? SettingsData.topBarCornerRadius : 12,
                "iconSize": SettingsData.topbarIconSize !== undefined ? SettingsData.topbarIconSize : 24,
                "iconSpacing": SettingsData.topbarIconSpacing !== undefined ? SettingsData.topbarIconSpacing : 2,
                "widgets": {
                    "left": SettingsData.topBarLeftWidgets || [],
                    "center": SettingsData.topBarCenterWidgets || [],
                    "right": SettingsData.topBarRightWidgets || []
                }
            },
            "dock": {
                "visible": SettingsData.showDock !== undefined ? SettingsData.showDock : false,
                "widgetsEnabled": SettingsData.dockWidgetsEnabled !== undefined ? SettingsData.dockWidgetsEnabled : false,
                "position": SettingsData.dockPosition || "bottom",
                "expandToScreen": SettingsData.dockExpandToScreen !== undefined ? SettingsData.dockExpandToScreen : false,
                "iconSize": SettingsData.dockIconSize !== undefined ? SettingsData.dockIconSize : 40,
                "iconSpacing": SettingsData.dockIconSpacing !== undefined ? SettingsData.dockIconSpacing : 2,
                "pinnedAppsIconSize": SettingsData.dockPinnedAppsIconSize !== undefined ? SettingsData.dockPinnedAppsIconSize : 40,
                "pinnedAppsIconSpacing": SettingsData.dockPinnedAppsIconSpacing !== undefined ? SettingsData.dockPinnedAppsIconSpacing : 2,
                "widgets": {
                    "left": SettingsData.dockLeftWidgets || [],
                    "center": SettingsData.dockCenterWidgets || [],
                    "right": SettingsData.dockRightWidgets || []
                }
            },
            "taskBar": {
                "visible": SettingsData.taskBarVisible !== undefined ? SettingsData.taskBarVisible : true,
                "float": SettingsData.taskBarFloat !== undefined ? SettingsData.taskBarFloat : false,
                "roundedCorners": SettingsData.taskBarRoundedCorners !== undefined ? SettingsData.taskBarRoundedCorners : false,
                "cornerRadius": SettingsData.taskBarCornerRadius !== undefined ? SettingsData.taskBarCornerRadius : 32,
                "iconSize": SettingsData.taskbarIconSize !== undefined ? SettingsData.taskbarIconSize : 30,
                "iconSpacing": SettingsData.taskbarIconSpacing !== undefined ? SettingsData.taskbarIconSpacing : 2,
                "widgets": {
                    "left": SettingsData.taskBarLeftWidgets || [],
                    "center": SettingsData.taskBarCenterWidgets || [],
                    "right": SettingsData.taskBarRightWidgets || []
                }
            },
            "global": {
                "cornerRadius": SettingsData.cornerRadius !== undefined ? SettingsData.cornerRadius : 32
            }
        }
    }

    function applyLayout(layout) {
        if (!layout) return false

        try {
            // Apply top bar settings
            if (layout.topBar) {
                if (layout.topBar.visible !== undefined) {
                    SettingsData.topBarVisible = layout.topBar.visible
                }
                if (layout.topBar.position) {
                    SettingsData.topBarPosition = layout.topBar.position
                }
                if (layout.topBar.float !== undefined) {
                    SettingsData.topBarFloat = layout.topBar.float
                }
                if (layout.topBar.roundedCorners !== undefined) {
                    SettingsData.topBarRoundedCorners = layout.topBar.roundedCorners
                }
                if (layout.topBar.cornerRadius !== undefined) {
                    SettingsData.topBarCornerRadius = layout.topBar.cornerRadius
                }
                if (layout.topBar.iconSize !== undefined) {
                    SettingsData.topbarIconSize = layout.topBar.iconSize
                }
                if (layout.topBar.iconSpacing !== undefined) {
                    SettingsData.topbarIconSpacing = layout.topBar.iconSpacing
                }
                if (layout.topBar.widgets) {
                    if (layout.topBar.widgets.left) {
                        SettingsData.setTopBarLeftWidgets(layout.topBar.widgets.left)
                    }
                    if (layout.topBar.widgets.center) {
                        SettingsData.setTopBarCenterWidgets(layout.topBar.widgets.center)
                    }
                    if (layout.topBar.widgets.right) {
                        SettingsData.setTopBarRightWidgets(layout.topBar.widgets.right)
                    }
                }
            }

            // Apply dock settings
            if (layout.dock) {
                if (layout.dock.visible !== undefined) {
                    SettingsData.showDock = layout.dock.visible
                }
                if (layout.dock.widgetsEnabled !== undefined) {
                    SettingsData.dockWidgetsEnabled = layout.dock.widgetsEnabled
                }
                if (layout.dock.position) {
                    SettingsData.dockPosition = layout.dock.position
                }
                if (layout.dock.expandToScreen !== undefined) {
                    SettingsData.dockExpandToScreen = layout.dock.expandToScreen
                }
                if (layout.dock.iconSize !== undefined) {
                    SettingsData.dockIconSize = layout.dock.iconSize
                }
                if (layout.dock.iconSpacing !== undefined) {
                    SettingsData.dockIconSpacing = layout.dock.iconSpacing
                }
                if (layout.dock.pinnedAppsIconSize !== undefined) {
                    SettingsData.dockPinnedAppsIconSize = layout.dock.pinnedAppsIconSize
                }
                if (layout.dock.pinnedAppsIconSpacing !== undefined) {
                    SettingsData.dockPinnedAppsIconSpacing = layout.dock.pinnedAppsIconSpacing
                }
                if (layout.dock.widgets) {
                    if (layout.dock.widgets.left) {
                        SettingsData.setDockLeftWidgets(layout.dock.widgets.left)
                    }
                    if (layout.dock.widgets.center) {
                        SettingsData.setDockCenterWidgets(layout.dock.widgets.center)
                    }
                    if (layout.dock.widgets.right) {
                        SettingsData.setDockRightWidgets(layout.dock.widgets.right)
                    }
                }
            }

            // Apply task bar settings
            if (layout.taskBar) {
                if (layout.taskBar.visible !== undefined) {
                    SettingsData.taskBarVisible = layout.taskBar.visible
                }
                if (layout.taskBar.float !== undefined) {
                    SettingsData.taskBarFloat = layout.taskBar.float
                }
                if (layout.taskBar.roundedCorners !== undefined) {
                    SettingsData.taskBarRoundedCorners = layout.taskBar.roundedCorners
                }
                if (layout.taskBar.cornerRadius !== undefined) {
                    SettingsData.taskBarCornerRadius = layout.taskBar.cornerRadius
                }
                if (layout.taskBar.iconSize !== undefined) {
                    SettingsData.taskbarIconSize = layout.taskBar.iconSize
                }
                if (layout.taskBar.iconSpacing !== undefined) {
                    SettingsData.taskbarIconSpacing = layout.taskBar.iconSpacing
                }
                if (layout.taskBar.widgets) {
                    if (layout.taskBar.widgets.left) {
                        SettingsData.setTaskBarLeftWidgets(layout.taskBar.widgets.left)
                    }
                    if (layout.taskBar.widgets.center) {
                        SettingsData.setTaskBarCenterWidgets(layout.taskBar.widgets.center)
                    }
                    if (layout.taskBar.widgets.right) {
                        SettingsData.setTaskBarRightWidgets(layout.taskBar.widgets.right)
                    }
                }
            }

            // Apply global settings
            if (layout.global) {
                if (layout.global.cornerRadius !== undefined) {
                    SettingsData.cornerRadius = layout.global.cornerRadius
                }
            }

            return true
        } catch (e) {
            console.error("Failed to apply layout:", e)
            return false
        }
    }

    function deleteLayout(layout, index) {
        if (!layout || !layout.filePath) {
            showError("Cannot delete: layout has no file path")
            console.error("Layout or filePath is null/undefined:", layout)
            return false
        }

        console.log("Attempting to delete layout:", layout.name, "at path:", layout.filePath)
        
        // Use Quickshell.execDetached to run rm command
        if (typeof Quickshell !== "undefined" && typeof Quickshell.execDetached === "function") {
            Quickshell.execDetached(["rm", "-f", layout.filePath])
            console.log("Delete command issued for:", layout.filePath)
            
            // Remove from model immediately (the file will be deleted in background)
            savedLayoutsModel.remove(index)
            showSuccess("Layout '" + (layout.name || "Custom") + "' deleted successfully")
            console.log("Layout removed from model")
            return true
        } else {
            console.error("Quickshell.execDetached is not available")
            showError("Delete operation not available")
            return false
        }
    }

    function exportLayoutToFile(layoutName, description, filePath, showSuccessMessage = true) {
        try {
            console.log("=== EXPORT LAYOUT TO FILE STARTED ===")
            console.log("Exporting layout to:", filePath)
            console.log("Layout name:", layoutName)
            console.log("Description:", description)

            // Create current layout snapshot
            var layout = createCurrentLayoutSnapshot()
            layout.name = layoutName
            layout.description = description || ""

            var layoutJson = JSON.stringify(layout, null, 2)
            console.log("Layout JSON length:", layoutJson.length)
            console.log("Layout JSON preview:", layoutJson.substring(0, 200) + "...")

            // Try to create directory using Quickshell if available
            var dirPath = filePath.substring(0, filePath.lastIndexOf('/'))
            console.log("Creating directory:", dirPath)

            var dirCreated = false
            if (typeof Quickshell !== "undefined" && typeof Quickshell.exec === "function") {
                try {
                    console.log("Using Quickshell.exec for mkdir")
                    var mkdirResult = Quickshell.exec(["mkdir", "-p", dirPath])
                    console.log("mkdir result:", mkdirResult)
                    dirCreated = true
                } catch (e) {
                    console.log("Could not create directory with Quickshell:", e)
                }
            }

            if (!dirCreated) {
                console.log("Quickshell.exec not available or failed, trying alternative mkdir")
                // Try to use a shell command as fallback
                try {
                    var mkdirFallback = Quickshell.exec(["bash", "-c", "mkdir -p '" + dirPath + "'"])
                    console.log("mkdir fallback result:", mkdirFallback)
                    dirCreated = true
                } catch (e) {
                    console.log("Could not create directory with fallback:", e)
                }
            }

            // Check if directory exists now
            try {
                var checkResult = Quickshell.exec(["test", "-d", dirPath])
                console.log("Directory check result:", checkResult)
                if (checkResult !== 0) {
                    console.log("Directory does not exist after creation attempt")
                } else {
                    console.log("Directory exists")
                }
            } catch (e) {
                console.log("Could not check directory:", e)
            }

            // Create a FileView to save the layout file (similar to how settings are saved)
            console.log("Creating FileView for path:", filePath)
            var saveFile = Qt.createQmlObject('
                import QtQuick
                import Quickshell.Io
                FileView {
                    blockLoading: true
                    atomicWrites: true
                }
            ', layoutManagerTab)

            if (saveFile) {
                saveFile.path = filePath
                console.log("Saving layout data...")
                // Save the layout data
                saveFile.setText(layoutJson)
                console.log("Layout saved successfully")

                // Check if file was actually created
                try {
                    var fileCheck = Quickshell.exec(["test", "-f", filePath])
                    console.log("File existence check result:", fileCheck)
                    if (fileCheck === 0) {
                        console.log("File was created successfully")
                    } else {
                        console.log("File was NOT created")
                    }
                } catch (e) {
                    console.log("Could not check file existence:", e)
                }

                // Reload saved layouts to include the new one (if saved to layouts directory)
                if (filePath.includes("/layouts/") || filePath.includes("/DarkMaterialShell/Layouts/")) {
                    console.log("Reloading saved layouts...")
                    loadSavedLayouts()
                }


                if (showSuccessMessage) {
                    showSuccess("Layout exported as '" + filePath.split('/').pop() + "'!")
                }
            } else {
                console.error("Could not create FileView for saving")
                showError("Failed to save layout file")
            }
        } catch (e) {
            console.error("Failed to export layout:", e)
            showError("Failed to export layout")
        }
        console.log("=== EXPORT LAYOUT TO FILE COMPLETED ===")
    }

    function exportCurrentLayout(layoutName, description) {
        // This is now deprecated - we use exportLayoutToFile with a file path
        var fileName = layoutName.replace(/[^a-zA-Z0-9]/g, "_").toLowerCase() + ".json"
        var filePath = `${StandardPaths.writableLocation(StandardPaths.ConfigLocation)}/DarkMaterialShell/Layouts/${fileName}`
        exportLayoutToFile(layoutName, description, filePath)
    }

    function importLayout(filePath) {
        console.log("=== IMPORT LAYOUT STARTED ===")
        console.log("Importing from file:", filePath)

        try {
            console.log("Creating FileView for path:", filePath)

            // Create a FileView to read the layout file
            var layoutFile = Qt.createQmlObject('
                import QtQuick
                import Quickshell.Io
                FileView {
                    blockLoading: true
                }
            ', layoutManagerTab)

            if (layoutFile) {
                layoutFile.path = filePath
                console.log("FileView created and path set")
            } else {
                console.log("Failed to create FileView")
            }

            // Wait for the file to load and get content
            if (layoutFile) {
                var fileContent = layoutFile.text()
                console.log("File content length:", fileContent ? fileContent.length : "undefined")
                console.log("File content preview:", fileContent ? fileContent.substring(0, 100) + "..." : "empty")

                if (fileContent && fileContent.trim()) {
                    console.log("Parsing JSON...")
                    var layout = JSON.parse(fileContent.trim())
                    console.log("Parsed layout:", layout.name, layout.version)

                    console.log("Applying layout...")
                    if (applyLayout(layout)) {
                        console.log("Layout applied successfully")

                        // Save the imported layout to the layouts directory so it appears in the gallery
                        var layoutName = layout.name || "Imported Layout"
                        var fileName = layoutName.replace(/[^a-zA-Z0-9]/g, "_").toLowerCase() + ".json"
                        var savePath = `${StandardPaths.writableLocation(StandardPaths.ConfigLocation)}/DarkMaterialShell/Layouts/${fileName}`

                        console.log("Saving imported layout to:", savePath)

                        // Use the same export function to save it (without showing success message)
                        exportLayoutToFile(layoutName, layout.description || "Imported layout", savePath, false)

                        // Force reload saved layouts to update the gallery
                        loadSavedLayouts()

                        showSuccess("Layout '" + layoutName + "' imported and added to gallery!")
                        console.log("=== IMPORT LAYOUT COMPLETED ===")
                    } else {
                        console.error("Failed to apply layout")
                        showError("Failed to apply imported layout")
                    }
                } else {
                    console.error("File content is empty or undefined")
                    console.error("FileView text() result:", fileContent)
                    showError("Layout file is empty or could not be read")
                }
            } else {
                console.error("Could not create FileView for reading")
                showError("Failed to read layout file")
            }
        } catch (e) {
            console.error("Failed to import layout:", e)
            console.error("Error details:", e.message)
            console.error("Error stack:", e.stack)
            showError("Failed to import layout - invalid file format")
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacingXL
        spacing: Theme.spacingXL

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingM
            Layout.bottomMargin: Theme.spacingM

            EHIcon {
                name: "dashboard"
                size: Theme.iconSize
                color: Theme.primary
                Layout.alignment: Qt.AlignVCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingXS

                StyledText {
                    text: "Layout Manager"
                    font.pixelSize: Theme.fontSizeXLarge
                    font.weight: Font.Medium
                    color: Theme.surfaceText
                }

                StyledText {
                    text: "Manage and switch between different desktop layouts"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceVariantText
                }
            }

            Row {
                spacing: Theme.spacingS
                Layout.alignment: Qt.AlignVCenter

                StyledRect {
                    width: 100
                    height: 32
                    radius: Theme.cornerRadius
                    color: importButtonArea.containsMouse ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1) : "transparent"
                    border.color: Theme.primary
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: Theme.spacingXS

                        EHIcon {
                            name: "file_download"
                            size: 14
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Import"
                            font.pixelSize: Theme.fontSizeSmall
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: importButtonArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            importFileBrowser.open()
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.shortDuration
                            easing.type: Theme.standardEasing
                        }
                    }
                }

                StyledRect {
                    width: 100
                    height: 32
                    radius: Theme.cornerRadius
                    color: exportButtonArea.containsMouse ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.8) : Theme.primary
                    border.color: Theme.primary
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: Theme.spacingXS

                        EHIcon {
                            name: "file_upload"
                            size: 14
                            color: Theme.primaryText
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Export"
                            font.pixelSize: Theme.fontSizeSmall
                            font.weight: Font.Medium
                            color: Theme.primaryText
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: exportButtonArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            exportDialog.visible = true
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.shortDuration
                            easing.type: Theme.standardEasing
                        }
                    }
                }
            }
        }

        // Preset Layouts
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingM
            Layout.bottomMargin: Theme.spacingL

            StyledText {
                text: "Preset Layouts"
                font.pixelSize: Theme.fontSizeLarge
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.bottomMargin: Theme.spacingS
            }

            StyledText {
                text: "Choose from popular desktop layouts"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
                Layout.bottomMargin: Theme.spacingM
            }

            // Layout Cards Container
            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacingM

                Repeater {
                    model: layoutManagerTab.defaultLayouts

                    StyledRect {
                        width: Math.min(280, (parent.width - Theme.spacingM) / Math.max(1, Math.floor(parent.width / 290)))
                        height: layoutCardContent.implicitHeight + Theme.spacingM * 2
                        radius: Theme.cornerRadius
                        color: Theme.surfaceContainer
                        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                        border.width: 1

                        Column {
                            id: layoutCardContent
                            anchors.fill: parent
                            anchors.margins: Theme.spacingM
                            spacing: Theme.spacingM

                            // Header with icon and title
                            Row {
                                width: parent.width
                                spacing: Theme.spacingS
                                height: Theme.iconSize

                                EHIcon {
                                    name: getLayoutIcon(modelData.name)
                                    size: Theme.iconSize
                                    color: Theme.primary
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                StyledText {
                                    text: modelData.name
                                    font.pixelSize: Theme.fontSizeLarge
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - Theme.iconSize - Theme.spacingS
                                    elide: Text.ElideRight
                                }
                            }

                            // Description
                            StyledText {
                                text: modelData.description
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                width: parent.width
                                wrapMode: Text.WordWrap
                                lineHeight: 1.3
                            }

                            // Action button with its own mouse area
                            StyledRect {
                                width: parent.width
                                height: 32
                                radius: Theme.cornerRadius
                                color: applyPresetMouseArea.containsMouse ? Theme.primary : Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1)
                                border.color: Theme.primary
                                border.width: 1

                                Row {
                                    anchors.centerIn: parent
                                    spacing: Theme.spacingXS

                                    EHIcon {
                                        name: "check_circle"
                                        size: 14
                                        color: applyPresetMouseArea.containsMouse ? Theme.primaryText : Theme.primary
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    StyledText {
                                        text: "Apply Layout"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: Font.Medium
                                        color: applyPresetMouseArea.containsMouse ? Theme.primaryText : Theme.primary
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                Behavior on color {
                                    ColorAnimation {
                                        duration: Theme.shortDuration
                                        easing.type: Theme.standardEasing
                                    }
                                }

                                MouseArea {
                                    id: applyPresetMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        // Apply preset layouts
                                        var layout = loadPresetLayoutFromFile(modelData.name)
                                        if (!layout) {
                                            // Fall back to hardcoded presets if file doesn't exist
                                            switch (modelData.name) {
                                                case "Windows 11":
                                                layout = {
                                                    "topBar": {
                                                        "visible": true,
                                                        "position": "top",
                                                        "widgets": {
                                                            "left": ["launcherButton"],
                                                            "center": ["workspaceSwitcher"],
                                                            "right": ["systemTray", "clock", "notificationButton", "controlCenterButton"]
                                                        }
                                                    },
                                                    "dock": {
                                                        "visible": false,
                                                        "widgetsEnabled": false,
                                                        "position": "bottom",
                                                        "widgets": {
                                                            "left": [],
                                                            "center": [],
                                                            "right": []
                                                        }
                                                    },
                                                    "taskBar": {
                                                        "visible": false,
                                                        "widgets": {
                                                            "left": [],
                                                            "center": [],
                                                            "right": []
                                                        }
                                                    }
                                                }
                                                break
                                            case "macOS":
                                                layout = {
                                                    "topBar": {
                                                        "visible": true,
                                                        "position": "top",
                                                        "widgets": {
                                                            "left": ["applications"],
                                                            "center": [],
                                                            "right": ["battery", "wifi", "volume", "clock"]
                                                        }
                                                    },
                                                    "dock": {
                                                        "visible": true,
                                                        "widgetsEnabled": true,
                                                        "position": "bottom",
                                                        "widgets": {
                                                            "left": [],
                                                            "center": [{"id": "runningApps", "enabled": true}, {"id": "spacer", "enabled": true}, {"id": "systemTray", "enabled": true}],
                                                            "right": []
                                                        }
                                                    },
                                                    "taskBar": {
                                                        "visible": false,
                                                        "widgets": {
                                                            "left": [],
                                                            "center": [],
                                                            "right": []
                                                        }
                                                    }
                                                }
                                                break
                                            case "GNOME":
                                                layout = {
                                                    "topBar": {
                                                        "visible": true,
                                                        "position": "top",
                                                        "widgets": {
                                                            "left": ["launcherButton", "workspaceSwitcher"],
                                                            "center": [],
                                                            "right": ["clock", "systemTray", "notificationButton"]
                                                        }
                                                    },
                                                    "dock": {
                                                        "visible": true,
                                                        "widgetsEnabled": true,
                                                        "position": "left",
                                                        "widgets": {
                                                            "left": [],
                                                            "center": [{"id": "runningApps", "enabled": true}],
                                                            "right": []
                                                        }
                                                    },
                                                    "taskBar": {
                                                        "visible": false,
                                                        "widgets": {
                                                            "left": [],
                                                            "center": [],
                                                            "right": []
                                                        }
                                                    }
                                                }
                                                break
                                            }
                                        }

                                        if (layout && applyLayout(layout)) {
                                            showSuccess("Applied " + modelData.name + " layout successfully!")
                                        } else {
                                            showError("Failed to apply " + modelData.name + " layout")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

            // Current Layout Status
            StyledRect {
                Layout.preferredWidth: Math.min(parent.width * 1.2, parent.parent ? parent.parent.width - 48 : parent.width * 1.2)
                Layout.preferredHeight: statusSection.implicitHeight + Theme.spacingL * 2
                Layout.alignment: Qt.AlignHCenter
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g,
                               Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g,
                                      Theme.outline.b, 0.2)
                border.width: 1

                Column {
                    id: statusSection
                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingM

                    RowLayout {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "info"
                            size: Theme.iconSize
                            color: Theme.primary
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Column {
                            Layout.fillWidth: true
                            spacing: Theme.spacingXS

                            StyledText {
                                text: "Current Layout Status"
                                font.pixelSize: Theme.fontSizeLarge
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }

                            StyledText {
                                text: "Your current desktop configuration"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                            }
                        }

                    }

                    GridLayout {
                        width: parent.width
                        columns: 2
                        columnSpacing: Theme.spacingXL
                        rowSpacing: Theme.spacingS

                        // Top Bar Status
                        StyledText {
                            text: "Top Bar:"
                            font.pixelSize: Theme.fontSizeSmall
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                        }

                        StyledText {
                            text: (SettingsData.topBarVisible ? "Visible" : "Hidden") +
                                  " • " + (SettingsData.topBarPosition || "top") +
                                  " • " + ((SettingsData.topBarLeftWidgets || []).length +
                                           (SettingsData.topBarCenterWidgets || []).length +
                                           (SettingsData.topBarRightWidgets || []).length) + " widgets"
                            font.pixelSize: Theme.fontSizeSmall
                            color: SettingsData.topBarVisible ? Theme.primary : Theme.surfaceVariantText
                        }

                        // Dock Status
                        StyledText {
                            text: "Dock:"
                            font.pixelSize: Theme.fontSizeSmall
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                        }

                        StyledText {
                            text: (SettingsData.showDock ? "Visible" : "Hidden") +
                                  (SettingsData.dockWidgetsEnabled ? " with widgets" : " without widgets") +
                                  " • " + (SettingsData.dockPosition || "bottom") +
                                  " • " + ((SettingsData.dockLeftWidgets || []).length +
                                           (SettingsData.dockCenterWidgets || []).length +
                                           (SettingsData.dockRightWidgets || []).length) + " widgets"
                            font.pixelSize: Theme.fontSizeSmall
                            color: SettingsData.showDock ? Theme.primary : Theme.surfaceVariantText
                        }

                        // Task Bar (Bottom Panel) Status
                        StyledText {
                            text: "Task Bar:"
                            font.pixelSize: Theme.fontSizeSmall
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                        }

                        StyledText {
                            text: (SettingsData.taskBarVisible ? "Visible" : "Hidden") +
                                  " • " + ((SettingsData.taskBarLeftWidgets || []).length +
                                           (SettingsData.taskBarCenterWidgets || []).length +
                                           (SettingsData.taskBarRightWidgets || []).length) + " widgets" +
                                  " • Bottom panel"
                            font.pixelSize: Theme.fontSizeSmall
                            color: SettingsData.taskBarVisible ? Theme.primary : Theme.surfaceVariantText
                        }

                        // Configuration Summary
                        StyledText {
                            text: "Active Bars:"
                            font.pixelSize: Theme.fontSizeSmall
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                        }

                        StyledText {
                            text: (SettingsData.topBarVisible ? "Top" : "") +
                                  (SettingsData.topBarVisible && (SettingsData.showDock || SettingsData.taskBarVisible) ? " + " : "") +
                                  (SettingsData.showDock ? "Dock" : "") +
                                  ((SettingsData.showDock || SettingsData.topBarVisible) && SettingsData.taskBarVisible ? " + " : "") +
                                  (SettingsData.taskBarVisible ? "Task Bar" : "")
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.secondary
                            font.weight: Font.Medium
                        }
                    }
                }
            }

        // Saved Layouts
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingM

            StyledText {
                text: "Saved Layouts"
                font.pixelSize: Theme.fontSizeLarge
                font.weight: Font.Medium
                color: Theme.surfaceText
                Layout.bottomMargin: Theme.spacingS
            }

            StyledText {
                text: savedLayoutsModel.count > 0 ?
                      savedLayoutsModel.count + " custom layout" + (savedLayoutsModel.count !== 1 ? "s" : "") + " available" :
                      "No saved layouts yet"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
                Layout.bottomMargin: Theme.spacingM
            }

            // Refresh button (always visible to check for new layouts)
            StyledRect {
                Layout.preferredWidth: refreshButtonRow.implicitWidth + Theme.spacingM * 2
                Layout.preferredHeight: 32
                radius: Theme.cornerRadius
                color: refreshArea.containsMouse ? Qt.rgba(Theme.secondary.r, Theme.secondary.g, Theme.secondary.b, 0.1) : "transparent"
                border.color: Theme.secondary
                border.width: 1
                Layout.bottomMargin: Theme.spacingM

                Row {
                    id: refreshButtonRow
                    anchors.centerIn: parent
                    spacing: Theme.spacingXS

                    EHIcon {
                        name: "refresh"
                        size: 14
                        color: Theme.secondary
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    StyledText {
                        text: "Check for Layouts"
                        font.pixelSize: Theme.fontSizeSmall
                        font.weight: Font.Medium
                        color: Theme.secondary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: refreshArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        loadSavedLayouts()
                        showMessage("Refreshed saved layouts (" + savedLayoutsModel.count + " found)")
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.shortDuration
                        easing.type: Theme.standardEasing
                    }
                }
            }

            // Empty State
            ColumnLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                spacing: 16
                visible: savedLayoutsModel.count === 0

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: Theme.surfaceContainer
                    border.color: Theme.outline
                    border.width: 1

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 12

                        EHIcon {
                            name: "folder_open"
                            size: 32
                            color: Theme.surfaceVariantText
                            Layout.alignment: Qt.AlignHCenter
                        }

                        StyledText {
                            text: "No saved layouts yet"
                            font.pixelSize: 16
                            font.weight: Font.Medium
                            color: Theme.surfaceVariantText
                            Layout.alignment: Qt.AlignHCenter
                        }

                        StyledText {
                            text: "Export a layout to create your first saved preset"
                            font.pixelSize: 14
                            color: Theme.surfaceVariantText
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }

            // Saved Layouts Grid
            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacingM
                visible: savedLayoutsModel.count > 0

                    Repeater {
                        model: savedLayoutsModel

                        StyledRect {
                            id: savedLayoutCard
                            width: Math.min(320, (parent.width - Theme.spacingM) / Math.max(1, Math.floor(parent.width / 340)))
                            height: customLayoutCardContent.implicitHeight + Theme.spacingM * 2
                            radius: Theme.cornerRadius
                            color: Theme.surfaceContainer
                            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                            border.width: 1

                            Column {
                                id: customLayoutCardContent
                                anchors.fill: parent
                                anchors.margins: Theme.spacingM
                                spacing: Theme.spacingM

                                // Header with centered icon/title and delete button in corner
                                Item {
                                    width: parent.width
                                    height: Theme.iconSize

                                    // Centered icon and title
                                    Row {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: Theme.spacingS
                                        height: parent.height

                                        EHIcon {
                                            name: "save"
                                            size: Theme.iconSize
                                            color: Theme.secondary
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        StyledText {
                                            text: model.name || "Custom Layout"
                                            font.pixelSize: Theme.fontSizeLarge
                                            font.weight: Font.Medium
                                            color: Theme.surfaceText
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    // Delete button (trash bin icon) in top right
                                    EHIcon {
                                        name: "delete"
                                        size: 18
                                        color: deleteMouseArea.containsMouse ? Theme.error : Theme.surfaceVariantText
                                        anchors.top: parent.top
                                        anchors.right: parent.right

                                        MouseArea {
                                            id: deleteMouseArea
                                            width: 24
                                            height: 24
                                            anchors.centerIn: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                // Show confirmation before deleting
                                                deleteConfirmDialog.layoutToDelete = model
                                                deleteConfirmDialog.layoutIndex = index
                                                deleteConfirmDialog.layoutName = model.name || "Custom Layout"
                                                deleteConfirmDialog.visible = true
                                            }
                                        }
                                    }
                                }

                                // Description (centered)
                                StyledText {
                                    text: model.description || "Custom saved layout"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceVariantText
                                    width: parent.width
                                    wrapMode: Text.WordWrap
                                    maximumLineCount: 2
                                    elide: Text.ElideRight
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                // Layout summary (centered)
                                Item {
                                    width: parent.width
                                    height: contentRow.implicitHeight

                                    Row {
                                        id: contentRow
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        spacing: Theme.spacingM

                                        StyledText {
                                            text: "Bars:"
                                            font.pixelSize: Theme.fontSizeSmall
                                            font.weight: Font.Medium
                                            color: Theme.surfaceText
                                        }

                                        StyledText {
                                            text: (model.topBar && model.topBar.visible ? "Top" : "") +
                                                  (model.topBar && model.topBar.visible && model.dock && model.dock.visible ? "+" : "") +
                                                  (model.dock && model.dock.visible ? "Dock" : "") +
                                                  (model.dock && model.dock.visible && model.taskBar && model.taskBar.visible ? "+" : "") +
                                                  (model.taskBar && model.taskBar.visible ? "Task" : "")
                                            font.pixelSize: Theme.fontSizeSmall
                                            color: Theme.secondary
                                            font.weight: Font.Medium
                                        }
                                    }
                                }

                                // Action button with its own mouse area
                                StyledRect {
                                    width: parent.width
                                    height: 32
                                    radius: Theme.cornerRadius
                                    color: applyLayoutMouseArea.containsMouse ? Theme.primary : Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1)
                                    border.color: Theme.primary
                                    border.width: 1

                                    Row {
                                        anchors.centerIn: parent
                                        spacing: Theme.spacingXS

                                        EHIcon {
                                            name: "check_circle"
                                            size: 14
                                            color: applyLayoutMouseArea.containsMouse ? Theme.primaryText : Theme.primary
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        StyledText {
                                            text: "Apply Layout"
                                            font.pixelSize: Theme.fontSizeSmall
                                            font.weight: Font.Medium
                                            color: applyLayoutMouseArea.containsMouse ? Theme.primaryText : Theme.primary
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    Behavior on color {
                                        ColorAnimation {
                                            duration: Theme.shortDuration
                                            easing.type: Theme.standardEasing
                                        }
                                    }

                                    MouseArea {
                                        id: applyLayoutMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (applyLayout(model)) {
                                                showSuccess("Applied custom layout '" + (model.name || "Custom") + "' successfully!")
                                            } else {
                                                showError("Failed to apply custom layout")
                                            }
                                        }
                                    }
                                }
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: Theme.shortDuration
                                    easing.type: Theme.standardEasing
                                }
                            }

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: Theme.shortDuration
                                    easing.type: Theme.standardEasing
                                }
                            }
                        }
                    }
                }
            }
        }

    // Import Dialog
    FloatingWindow {
        id: importDialog
        title: "Import Layout"
        minimumSize: Qt.size(400, 300)
        implicitWidth: 500
        implicitHeight: 400
        visible: false

        onVisibleChanged: {
            if (!visible) {
                layoutManagerTab.importSelectedFilePath = ""
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: Theme.spacingL
            spacing: Theme.spacingL

            StyledText {
                text: "Import a layout configuration from a JSON file"
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.surfaceText
                wrapMode: Text.WordWrap
                width: parent.width
            }

            StyledRect {
                width: parent.width
                height: 120
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
                border.width: 1

                Column {
                    anchors.fill: parent
                    anchors.margins: Theme.spacingM
                    spacing: Theme.spacingM

                    StyledText {
                        text: layoutManagerTab.importSelectedFilePath ? "Selected file: " + layoutManagerTab.importSelectedFilePath.split('/').pop() : "No file selected"
                        font.pixelSize: Theme.fontSizeSmall
                        color: layoutManagerTab.importSelectedFilePath ? Theme.primary : Theme.surfaceVariantText
                        width: parent.width
                        elide: Text.ElideMiddle
                    }

                    StyledRect {
                        width: parent.width
                        height: 40
                        radius: Theme.cornerRadius
                        color: fileSelectArea.containsMouse ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1) : "transparent"
                        border.color: Theme.primary
                        border.width: 1

                        Row {
                            anchors.centerIn: parent
                            spacing: Theme.spacingXS

                            EHIcon {
                                name: "folder_open"
                                size: 16
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: "Choose Layout File"
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: Font.Medium
                                color: Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: fileSelectArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                importFileBrowser.open()
                            }
                        }
                    }
                }
            }

            Row {
                width: parent.width
                spacing: Theme.spacingM
                layoutDirection: Qt.RightToLeft

                StyledRect {
                    width: 100
                    height: 36
                    radius: Theme.cornerRadius
                    color: cancelArea.containsMouse ? Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.1) : "transparent"

                    StyledText {
                        anchors.centerIn: parent
                        text: "Cancel"
                        font.pixelSize: Theme.fontSizeSmall
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    MouseArea {
                        id: cancelArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            importDialog.hide()
                        }
                    }
                }

                    StyledRect {
                        width: 100
                        height: 36
                        radius: Theme.cornerRadius
                        color: layoutManagerTab.importSelectedFilePath && importArea.containsMouse ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.8) : Theme.primary
                        enabled: layoutManagerTab.importSelectedFilePath !== ""

                    StyledText {
                        anchors.centerIn: parent
                        text: "Import"
                        font.pixelSize: Theme.fontSizeSmall
                        font.weight: Font.Medium
                        color: Theme.primaryText
                        opacity: parent.enabled ? 1.0 : 0.5
                    }

                    MouseArea {
                        id: importArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        enabled: layoutManagerTab.importSelectedFilePath !== ""
                        onClicked: {
                            console.log("Import dialog button clicked")
                            console.log("Selected file path:", layoutManagerTab.importSelectedFilePath)
                            if (layoutManagerTab.importSelectedFilePath) {
                                console.log("Calling importLayout...")
                                importLayout(layoutManagerTab.importSelectedFilePath)
                                importDialog.hide()
                            } else {
                                console.log("No file selected")
                            }
                        }
                    }
                }
            }
        }

        FloatingWindowControls {
            targetWindow: importDialog
        }
    }

    // Export Dialog
    FloatingWindow {
        id: exportDialog
        title: "Export Current Layout"
        minimumSize: Qt.size(550, 700)
        implicitWidth: 600
        implicitHeight: 750
        visible: false

        onVisibleChanged: {
            if (visible) {
                // Pre-fill with current date/time for name
                var now = new Date()
                layoutNameField.text = "My Layout " + Qt.formatDate(now, "yyyy-MM-dd") + " " + Qt.formatTime(now, "hh:mm")
                layoutDescriptionField.text = "Custom layout exported on " + Qt.formatDate(now, "MMMM d, yyyy") + " at " + Qt.formatTime(now, "h:mm AP")
            }
        }

        ScrollView {
            anchors.fill: parent
            anchors.margins: 0
            clip: true

            ColumnLayout {
                width: Math.max(exportDialog.width - 40, 560)
                spacing: 24

                // Header
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 32
                    Layout.leftMargin: 32
                    Layout.rightMargin: 32
                    spacing: 8

                    StyledText {
                        text: "Export Layout"
                        font.pixelSize: 24
                        font.weight: Font.Bold
                        color: Theme.surfaceText
                    }

                    StyledText {
                        text: "Save your current desktop configuration as a reusable layout preset."
                        font.pixelSize: 14
                        color: Theme.surfaceVariantText
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }

                // Layout Name Section
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 32
                    Layout.rightMargin: 32
                    spacing: 8

                    StyledText {
                        text: "Layout Name"
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    TextField {
                        id: layoutNameField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        font.pixelSize: 14
                        color: Theme.surfaceText
                        placeholderText: "Enter a name for your layout"
                        background: Rectangle {
                            color: Theme.surfaceContainer
                            border.color: layoutNameField.activeFocus ? Theme.primary : Theme.outline
                            border.width: layoutNameField.activeFocus ? 2 : 1
                            radius: 8
                        }
                        leftPadding: 16
                        rightPadding: 16
                        selectByMouse: true
                    }
                }

                // Description Section
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 32
                    Layout.rightMargin: 32
                    spacing: 8

                    StyledText {
                        text: "Description (Optional)"
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    TextArea {
                        id: layoutDescriptionField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 96
                        font.pixelSize: 14
                        color: Theme.surfaceText
                        placeholderText: "Add notes about your layout configuration..."
                        wrapMode: TextArea.Wrap
                        background: Rectangle {
                            color: Theme.surfaceContainer
                            border.color: layoutDescriptionField.activeFocus ? Theme.primary : Theme.outline
                            border.width: layoutDescriptionField.activeFocus ? 2 : 1
                            radius: 8
                        }
                        leftPadding: 16
                        rightPadding: 16
                        topPadding: 12
                        bottomPadding: 12
                        selectByMouse: true
                    }
                }

                // Preview Section
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 32
                    Layout.rightMargin: 32
                    spacing: 12

                    StyledText {
                        text: "Layout Preview"
                        font.pixelSize: 18
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                        Layout.alignment: Qt.AlignLeft
                    }

                    StyledRect {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        radius: 12
                        color: Theme.surfaceContainer
                        border.color: Theme.outline
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 16

                            // Top Bar
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 12

                                Rectangle {
                                    width: 32
                                    height: 32
                                    radius: 6
                                    color: SettingsData.topBarVisible ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1) : Qt.rgba(Theme.surfaceVariantText.r, Theme.surfaceVariantText.g, Theme.surfaceVariantText.b, 0.1)

                                    EHIcon {
                                        anchors.centerIn: parent
                                        name: "horizontal_distribute"
                                        size: 18
                                        color: SettingsData.topBarVisible ? Theme.primary : Theme.surfaceVariantText
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    StyledText {
                                        text: "Top Bar"
                                        font.pixelSize: 15
                                        font.weight: Font.Medium
                                        color: SettingsData.topBarVisible ? Theme.primary : Theme.surfaceVariantText
                                    }

                                    StyledText {
                                        text: (SettingsData.topBarVisible ? "Visible" : "Hidden") + " • " +
                                              (SettingsData.topBarPosition || "top") + " • " +
                                              (((SettingsData.topBarLeftWidgets || []).length +
                                                (SettingsData.topBarCenterWidgets || []).length +
                                                (SettingsData.topBarRightWidgets || []).length)) + " widgets"
                                        font.pixelSize: 13
                                        color: Theme.surfaceVariantText
                                    }
                                }
                            }

                            // Dock
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 12

                                Rectangle {
                                    width: 32
                                    height: 32
                                    radius: 6
                                    color: SettingsData.showDock ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1) : Qt.rgba(Theme.surfaceVariantText.r, Theme.surfaceVariantText.g, Theme.surfaceVariantText.b, 0.1)

                                    EHIcon {
                                        anchors.centerIn: parent
                                        name: "dock"
                                        size: 18
                                        color: SettingsData.showDock ? Theme.primary : Theme.surfaceVariantText
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    StyledText {
                                        text: "Dock"
                                        font.pixelSize: 15
                                        font.weight: Font.Medium
                                        color: SettingsData.showDock ? Theme.primary : Theme.surfaceVariantText
                                    }

                                    StyledText {
                                        text: (SettingsData.showDock ? "Visible" : "Hidden") +
                                              (SettingsData.dockWidgetsEnabled ? " with widgets" : " without widgets") + " • " +
                                              (((SettingsData.dockLeftWidgets || []).length +
                                                (SettingsData.dockCenterWidgets || []).length +
                                                (SettingsData.dockRightWidgets || []).length)) + " widgets"
                                        font.pixelSize: 13
                                        color: Theme.surfaceVariantText
                                    }
                                }
                            }

                            // Task Bar
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 12

                                Rectangle {
                                    width: 32
                                    height: 32
                                    radius: 6
                                    color: SettingsData.taskBarVisible ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1) : Qt.rgba(Theme.surfaceVariantText.r, Theme.surfaceVariantText.g, Theme.surfaceVariantText.b, 0.1)

                                    EHIcon {
                                        anchors.centerIn: parent
                                        name: "view_column"
                                        size: 18
                                        color: SettingsData.taskBarVisible ? Theme.primary : Theme.surfaceVariantText
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    StyledText {
                                        text: "Task Bar"
                                        font.pixelSize: 15
                                        font.weight: Font.Medium
                                        color: SettingsData.taskBarVisible ? Theme.primary : Theme.surfaceVariantText
                                    }

                                    StyledText {
                                        text: (SettingsData.taskBarVisible ? "Visible" : "Hidden") + " • " +
                                              (((SettingsData.taskBarLeftWidgets || []).length +
                                                (SettingsData.taskBarCenterWidgets || []).length +
                                                (SettingsData.taskBarRightWidgets || []).length)) + " widgets"
                                        font.pixelSize: 13
                                        color: Theme.surfaceVariantText
                                    }
                                }
                            }
                        }
                    }
                }

                // Buttons
                RowLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 32
                    Layout.rightMargin: 32
                    Layout.bottomMargin: 32
                    spacing: 12

                    Item {
                        Layout.fillWidth: true
                    }

                    StyledRect {
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 48
                        radius: 8
                        color: cancelExportArea.containsMouse ? Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.05) : "transparent"
                        border.color: Theme.outline
                        border.width: 1

                        StyledText {
                            anchors.centerIn: parent
                            text: "Cancel"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            color: Theme.surfaceText
                        }

                        MouseArea {
                            id: cancelExportArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                exportDialog.hide()
                            }
                        }
                    }

                    StyledRect {
                        Layout.preferredWidth: 160
                        Layout.preferredHeight: 48
                        radius: 8
                        color: layoutNameField.text.trim() && exportConfirmArea.containsMouse ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.8) : Theme.primary
                        enabled: layoutNameField.text.trim() !== ""
                        border.color: Theme.primary
                        border.width: 1

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            EHIcon {
                                name: "save"
                                size: 18
                                color: Theme.primaryText
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: "Export Layout"
                                font.pixelSize: 15
                                font.weight: Font.Medium
                                color: Theme.primaryText
                            }
                        }

                        MouseArea {
                            id: exportConfirmArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            enabled: layoutNameField.text.trim() !== ""
                            onClicked: {
                                if (layoutNameField.text.trim()) {
                                    var filePath = `${StandardPaths.writableLocation(StandardPaths.ConfigLocation)}/DarkMaterialShell/Layouts/${layoutNameField.text.trim().replace(/[^a-zA-Z0-9]/g, "_").toLowerCase()}.json`
                                    console.log("Export file path:", filePath)

                                    exportLayoutToFile(layoutNameField.text, layoutDescriptionField.text, filePath)
                                    exportDialog.hide()
                                    console.log("=== EXPORT LAYOUT COMPLETED ===")
                                }
                            }
                        }
                    }
                }
            }
        }

        FloatingWindowControls {
            targetWindow: exportDialog
        }
    }

    FileBrowserModal {
        id: importFileBrowser

        browserTitle: "Select Layout File"
        browserIcon: "file_download"
        browserType: "import"
        fileExtensions: ["*.json", "*.jso"]
        selectFolderMode: false
        onFileSelected: path => {
            layoutManagerTab.importSelectedFilePath = path
            layoutManagerTab.importLayout(path)
            close()
        }
        onDialogClosed: {
            // Allow stacking again if needed
        }
    }

    // Delete Confirmation Dialog
    FloatingWindow {
        id: deleteConfirmDialog
        title: "Delete Layout"
        minimumSize: Qt.size(360, 180)
        implicitWidth: 400
        implicitHeight: 200
        visible: false

        property var layoutToDelete: null
        property int layoutIndex: -1
        property string layoutName: ""

        Column {
            anchors.fill: parent
            anchors.margins: Theme.spacingL
            spacing: Theme.spacingL

            Row {
                spacing: Theme.spacingM
                width: parent.width

                EHIcon {
                    name: "warning"
                    size: 32
                    color: Theme.error
                    anchors.verticalCenter: parent.verticalCenter
                }

                Column {
                    spacing: Theme.spacingXS
                    width: parent.width - Theme.iconSize - Theme.spacingM

                    StyledText {
                        text: "Delete Layout?"
                        font.pixelSize: Theme.fontSizeLarge
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    StyledText {
                        text: "Are you sure you want to delete \"" + deleteConfirmDialog.layoutName + "\"? This action cannot be undone."
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }

            // Buttons
            RowLayout {
                width: parent.width
                spacing: Theme.spacingM

                Item {
                    Layout.fillWidth: true
                }

                StyledRect {
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40
                    radius: 8
                    color: cancelDeleteArea.containsMouse ? Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.05) : "transparent"
                    border.color: Theme.outline
                    border.width: 1

                    StyledText {
                        anchors.centerIn: parent
                        text: "Cancel"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                    }

                    MouseArea {
                        id: cancelDeleteArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            deleteConfirmDialog.visible = false
                        }
                    }
                }

                StyledRect {
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40
                    radius: 8
                    color: confirmDeleteArea.containsMouse ? Theme.error : Qt.rgba(Theme.error.r, Theme.error.g, Theme.error.b, 0.8)
                    border.color: Theme.error
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 6

                        EHIcon {
                            name: "delete"
                            size: 16
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: "Delete"
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: confirmDeleteArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (deleteConfirmDialog.layoutToDelete && deleteConfirmDialog.layoutIndex >= 0) {
                                deleteLayout(deleteConfirmDialog.layoutToDelete, deleteConfirmDialog.layoutIndex)
                            }
                            deleteConfirmDialog.visible = false
                        }
                    }
                }
            }
        }

        FloatingWindowControls {
            targetWindow: deleteConfirmDialog
        }
    }
}