import QtQuick
import QtQuick.Layouts
import qs.Common
import qs.Modals.Settings
import qs.Widgets

Item {
    id: sidebarContainer

    property int currentIndex: 0
    property var parentModal: null
    property real cornerRadius: (parentModal && parentModal.cornerRadius !== undefined) ? parentModal.cornerRadius : Theme.cornerRadius
    property var expandedCategories: ({
    })
    readonly property var sidebarItems: [{
        "id": "user",
        "text": "User",
        "icon": "person",
        "tabIndex": 0
    }, {
        "id": "themeColors",
        "text": "Appearance",
        "icon": "palette",
        "children": [{
            "text": "Personalization",
            "icon": "person",
            "tabIndex": 98
        }, {
            "text": "Fonts",
            "icon": "font_download",
            "tabIndex": 99
        }, {
            "text": "Colors & Themes",
            "icon": "colorize",
            "tabIndex": 100
        }, {
            "text": "Appearance",
            "icon": "opacity",
            "tabIndex": 101
        }, {
            "text": "Components",
            "icon": "dashboard",
            "tabIndex": 102
        }, {
            "text": "System & Settings",
            "icon": "settings",
            "tabIndex": 103
        }, {
            "text": "Wallpaper",
            "icon": "wallpaper",
            "tabIndex": 3
        }, {
            "text": "Matugen",
            "icon": "tune",
            "tabIndex": 114
        }]
    }, {
        "id": "hyprlandTheme",
        "text": "Hyprland Theme",
        "icon": "window",
        "children": [{
            "text": "Border Colors",
            "icon": "palette",
            "tabIndex": 105
        }, {
            "text": "Window Rounding",
            "icon": "rounded_corner",
            "tabIndex": 106
        }, {
            "text": "Render",
            "icon": "settings",
            "tabIndex": 107
        }, {
            "text": "Input",
            "icon": "keyboard",
            "tabIndex": 108
        }, {
            "text": "Cursor",
            "icon": "mouse",
            "tabIndex": 109
        }, {
            "text": "General",
            "icon": "tune",
            "tabIndex": 110
        }, {
            "text": "Snap",
            "icon": "grid_view",
            "tabIndex": 111
        }, {
            "text": "Groupbar",
            "icon": "view_carousel",
            "tabIndex": 112
        }, {
            "text": "Dwindle",
            "icon": "splitscreen",
            "tabIndex": 113
        }]
    }, {
        "id": "panelsUi",
        "text": "Panels & UI",
        "icon": "view_quilt",
        "children": [{
            "text": "Task Bar",
            "icon": "view_agenda",
            "tabIndex": 4
        }, {
            "text": "Top Bar",
            "icon": "toolbar",
            "tabIndex": 5
        }, {
            "text": "Dock",
            "icon": "dock_to_bottom",
            "tabIndex": 6
        }, {
            "text": "Mini Panel",
            "icon": "space_dashboard",
            "tabIndex": 23
        }, {
            "text": "Desktop Widgets",
            "icon": "widgets",
            "tabIndex": 8
        }, {
            "text": "Launcher",
            "icon": "apps",
            "tabIndex": 10
        }]
    }, {
        "id": "workspacesCategory",
        "text": "Workspaces",
        "icon": "view_carousel",
        "children": [{
            "text": "Workspaces",
            "icon": "view_week",
            "tabIndex": 7
        }, {
            "text": "Workspace Overview",
            "icon": "space_dashboard",
            "tabIndex": 24
        }, {
            "text": "Layout Manager",
            "icon": "dashboard_customize",
            "tabIndex": 22
        }, {
            "text": "Keybinds",
            "icon": "keyboard",
            "tabIndex": 21
        }]
    }, {
        "id": "systemCategory",
        "text": "System",
        "icon": "settings",
        "children": [{
            "text": "UI Layout",
            "icon": "monitor",
            "tabIndex": 104
        }, {
            "text": "Default Apps",
            "icon": "apps",
            "tabIndex": 11
        }, {
            "text": "Monitors",
            "icon": "settings",
            "tabIndex": 12
        }, {
            "text": "Sound",
            "icon": "volume_up",
            "tabIndex": 13
        }, {
            "text": "Network",
            "icon": "wifi",
            "tabIndex": 14
        }, {
            "text": "Bluetooth",
            "icon": "bluetooth",
            "tabIndex": 15
        }, {
            "text": "Keyboard & Language",
            "icon": "keyboard",
            "tabIndex": 16
        }, {
            "text": "Time & Date",
            "icon": "schedule",
            "tabIndex": 17
        }, {
            "text": "Power",
            "icon": "power_settings_new",
            "tabIndex": 18
        }, {
            "text": "Weather",
            "icon": "cloud",
            "tabIndex": 20
        }]
    }]

    function adjustedColor(baseColor, alphaScale) {
        function applyContrast(channel) {
            return Math.min(1, Math.max(0, ((channel - 0.5) * contrast) + 0.5));
        }

        function applyHighlights(channel) {
            if (highlights === 1)
                return channel;

            if (highlights > 1) {
                var amount = Math.min(0.4, highlights - 1);
                return Math.min(1, channel + (1 - channel) * (amount / 0.4));
            }
            var reduce = Math.min(0.4, 1 - highlights);
            return Math.max(0, channel * (1 - (reduce / 0.4)));
        }

        var brightness = (typeof SettingsData !== "undefined" && SettingsData.settingsBrightness !== undefined) ? SettingsData.settingsBrightness : 1;
        var contrast = (typeof SettingsData !== "undefined" && SettingsData.settingsContrast !== undefined) ? SettingsData.settingsContrast : 1;
        var whiteBalance = (typeof SettingsData !== "undefined" && SettingsData.settingsWhiteBalance !== undefined) ? SettingsData.settingsWhiteBalance : 1;
        var highlights = (typeof SettingsData !== "undefined" && SettingsData.settingsHighlights !== undefined) ? SettingsData.settingsHighlights : 1;
        var alpha = baseColor.a;
        if (alphaScale !== undefined)
            alpha = alpha * alphaScale;

        return Qt.rgba(applyHighlights(applyContrast(Math.min(1, baseColor.r * brightness * whiteBalance))), applyHighlights(applyContrast(Math.min(1, baseColor.g * brightness))), applyHighlights(applyContrast(Math.min(1, baseColor.b * brightness * (2 - whiteBalance)))), alpha);
    }

    function toggleCategory(categoryId) {
        var newExpanded = Object.assign({
        }, expandedCategories);
        newExpanded[categoryId] = !isCategoryExpanded(categoryId);
        expandedCategories = newExpanded;
    }

    function isCategoryExpanded(categoryId) {
        if (expandedCategories[categoryId] !== undefined)
            return expandedCategories[categoryId];

        // Auto-expand if a child is active
        var category = sidebarItems.find((item) => {
            return item.id === categoryId;
        });
        if (category && category.children)
            return category.children.some((child) => {
                return child.tabIndex === currentIndex;
            });

        return false;
    }

    // Width is set by parent (SettingsModal), so we don't calculate it here
    // This allows the parent to control the width and make it reactive to window resizing
    height: parent.height

    Rectangle {
        id: sidebarBackground

        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 16
        width: sidebarContainer.width - 16
        color: adjustedColor(Theme.surfaceContainer, 0.6)
        radius: cornerRadius
        clip: false
        layer.enabled: true
        layer.smooth: true
        border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.08)
        border.width: 1

        EHFlickable {
            id: sidebarFlickable

            anchors.fill: parent
            contentHeight: sidebarColumn.height
            contentWidth: Math.max(width, sidebarColumn.implicitWidth)
            clip: false

            Column {
                id: sidebarColumn

                width: Math.max(parent.width, implicitWidth)
                spacing: 0

                ProfileSection {
                    id: profileSection

                    parentModal: sidebarContainer.parentModal
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.12)
                }

                Item {
                    width: parent.width
                    height: {
                        const baseHeight = 16;
                        const uiScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiScale !== undefined ? SettingsData.settingsUiScale : 1;
                        const controlScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiAdvancedScaling && SettingsData.settingsUiControlScale !== undefined ? SettingsData.settingsUiControlScale : 1;
                        return baseHeight * uiScale * controlScale;
                    }
                }

                Repeater {
                    id: sidebarRepeater

                    model: sidebarContainer.sidebarItems

                    Column {
                        id: navItemContainer

                        required property int index
                        required property var modelData
                        property bool hasChildren: !!(modelData.children && modelData.children.length > 0)
                        property bool isExpanded: hasChildren ? sidebarContainer.isCategoryExpanded(modelData.id || "") : false
                        property bool isCategoryActive: hasChildren ? modelData.children.some((child) => {
                            return child.tabIndex === sidebarContainer.currentIndex;
                        }) : false
                        property bool isActive: !hasChildren && sidebarContainer.currentIndex === (modelData.tabIndex !== undefined ? modelData.tabIndex : index)

                        width: parent.width
                        spacing: 0

                        Item {
                            id: navItem

                            property bool isActive: navItemContainer.isActive || navItemContainer.isCategoryActive

                            width: parent.width
                            height: {
                                const baseHeight = 40;
                                const uiScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiScale !== undefined ? SettingsData.settingsUiScale : 1;
                                const controlScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiAdvancedScaling && SettingsData.settingsUiControlScale !== undefined ? SettingsData.settingsUiControlScale : 1;
                                return baseHeight * uiScale * controlScale;
                            }

                            Rectangle {
                                id: activeIndicator

                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: 3
                                color: Theme.primary
                                visible: navItem.isActive
                                radius: 0
                            }

                            Rectangle {
                                id: backgroundLayer

                                anchors.fill: parent
                                radius: 0
                                color: {
                                    if (navItem.isActive)
                                        return Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1);

                                    if (navMouseArea.containsMouse)
                                        return Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.06);

                                    return "transparent";
                                }

                                Behavior on color {
                                    ColorAnimation {
                                        duration: Theme.shortDuration
                                        easing.type: Theme.standardEasing
                                    }

                                }

                            }

                            Row {
                                id: rowContent

                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.leftMargin: {
                                    const baseMargin = 20;
                                    const uiScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiScale !== undefined ? SettingsData.settingsUiScale : 1;
                                    const controlScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiAdvancedScaling && SettingsData.settingsUiControlScale !== undefined ? SettingsData.settingsUiControlScale : 1;
                                    return baseMargin * uiScale * controlScale;
                                }
                                anchors.rightMargin: {
                                    const baseMargin = 12;
                                    const uiScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiScale !== undefined ? SettingsData.settingsUiScale : 1;
                                    const controlScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiAdvancedScaling && SettingsData.settingsUiControlScale !== undefined ? SettingsData.settingsUiControlScale : 1;
                                    return baseMargin * uiScale * controlScale;
                                }
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: Theme.spacingM

                                EHIcon {
                                    name: navItemContainer.modelData.icon || ""
                                    size: Theme.iconSize
                                    color: {
                                        if (navItem.isActive)
                                            return Theme.primary;

                                        if (navMouseArea.containsMouse)
                                            return Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.85);

                                        return Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.7);
                                    }
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Item {
                                    width: Math.max(0, rowContent.width - Theme.iconSize - (navItemContainer.hasChildren ? (Theme.iconSize - 4) : 0) - (Theme.spacingM * (navItemContainer.hasChildren ? 2 : 1)))
                                    height: parent.height
                                    anchors.verticalCenter: parent.verticalCenter

                                    TextMetrics {
                                        id: textMetrics

                                        font.pixelSize: Theme.fontSizeMedium
                                        font.weight: navItem.isActive ? Font.Medium : Font.Normal
                                        text: navItemContainer.modelData.text || ""
                                    }

                                    StyledText {
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: navItemContainer.modelData.text || ""
                                        font.pixelSize: Theme.fontSizeMedium
                                        color: {
                                            if (navItem.isActive)
                                                return Theme.primary;

                                            if (navMouseArea.containsMouse)
                                                return Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.95);

                                            return Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.85);
                                        }
                                        font.weight: navItem.isActive ? Font.Medium : Font.Normal
                                        width: parent.width
                                        elide: Text.ElideRight
                                    }

                                }

                                EHIcon {
                                    name: navItemContainer.isExpanded ? "expand_less" : "expand_more"
                                    size: Theme.iconSize - 4
                                    color: Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.6)
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: navItemContainer.hasChildren
                                }

                            }

                            MouseArea {
                                id: navMouseArea

                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: () => {
                                    if (navItemContainer.hasChildren)
                                        sidebarContainer.toggleCategory(navItemContainer.modelData.id || "");
                                    else
                                        sidebarContainer.currentIndex = (navItemContainer.modelData.tabIndex !== undefined) ? navItemContainer.modelData.tabIndex : navItemContainer.index;
                                }
                            }

                        }

                        // Children sub-items
                        Column {
                            id: childrenColumn

                            width: parent.width
                            spacing: 0
                            visible: navItemContainer.hasChildren && navItemContainer.isExpanded

                            Repeater {
                                model: navItemContainer.modelData.children || []

                                Item {
                                    id: childNavItem

                                    required property int index
                                    required property var modelData
                                    property bool isActive: sidebarContainer.currentIndex === modelData.tabIndex

                                    width: parent.width
                                    height: {
                                        const baseHeight = 36;
                                        const uiScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiScale !== undefined ? SettingsData.settingsUiScale : 1;
                                        const controlScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiAdvancedScaling && SettingsData.settingsUiControlScale !== undefined ? SettingsData.settingsUiControlScale : 1;
                                        return baseHeight * uiScale * controlScale;
                                    }

                                    Rectangle {
                                        id: childActiveIndicator

                                        anchors.left: parent.left
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        width: 3
                                        color: Theme.primary
                                        visible: childNavItem.isActive
                                        radius: 0
                                    }

                                    Rectangle {
                                        id: childBackgroundLayer

                                        anchors.fill: parent
                                        radius: 0
                                        color: {
                                            if (childNavItem.isActive)
                                                return Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15);

                                            if (childMouseArea.containsMouse)
                                                return Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.06);

                                            return "transparent";
                                        }

                                        Behavior on color {
                                            ColorAnimation {
                                                duration: Theme.shortDuration
                                                easing.type: Theme.standardEasing
                                            }

                                        }

                                    }

                                    Row {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.leftMargin: {
                                            const baseMargin = 20;
                                            const uiScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiScale !== undefined ? SettingsData.settingsUiScale : 1;
                                            const controlScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiAdvancedScaling && SettingsData.settingsUiControlScale !== undefined ? SettingsData.settingsUiControlScale : 1;
                                            return (baseMargin + 24) * uiScale * controlScale;
                                        }
                                        anchors.rightMargin: {
                                            const baseMargin = 12;
                                            const uiScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiScale !== undefined ? SettingsData.settingsUiScale : 1;
                                            const controlScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiAdvancedScaling && SettingsData.settingsUiControlScale !== undefined ? SettingsData.settingsUiControlScale : 1;
                                            return baseMargin * uiScale * controlScale;
                                        }
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: Theme.spacingS

                                        EHIcon {
                                            name: childNavItem.modelData.icon || ""
                                            size: Theme.iconSize - 4
                                            color: {
                                                if (childNavItem.isActive)
                                                    return Theme.primary;

                                                if (childMouseArea.containsMouse)
                                                    return Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.85);

                                                return Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.7);
                                            }
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        StyledText {
                                            text: childNavItem.modelData.text || ""
                                            font.pixelSize: Theme.fontSizeSmall
                                            color: {
                                                if (childNavItem.isActive)
                                                    return Theme.primary;

                                                if (childMouseArea.containsMouse)
                                                    return Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.95);

                                                return Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.85);
                                            }
                                            font.weight: childNavItem.isActive ? Font.Medium : Font.Normal
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: Math.max(0, parent.width - (Theme.iconSize - 4) - Theme.spacingS)
                                            elide: Text.ElideRight
                                        }

                                    }

                                    MouseArea {
                                        id: childMouseArea

                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: () => {
                                            sidebarContainer.currentIndex = childNavItem.modelData.tabIndex;
                                        }
                                    }

                                }

                            }

                        }

                    }

                }

                Item {
                    width: parent.width
                    height: {
                        const baseHeight = 12;
                        const uiScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiScale !== undefined ? SettingsData.settingsUiScale : 1;
                        const controlScale = typeof SettingsData !== "undefined" && SettingsData.settingsUiAdvancedScaling && SettingsData.settingsUiControlScale !== undefined ? SettingsData.settingsUiControlScale : 1;
                        return baseHeight * uiScale * controlScale;
                    }
                }

            }

        }

    }

}
