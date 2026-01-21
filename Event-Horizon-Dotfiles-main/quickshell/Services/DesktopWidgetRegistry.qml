pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.Common
import qs.Services

Singleton {
    id: root

    property var registeredWidgets: ({})
    property var registeredWidgetsList: []

    signal registryChanged

    Component.onCompleted: {
        registerBuiltins();
        Qt.callLater(syncPluginWidgets);
    }

    Connections {
        target: typeof PluginService !== 'undefined' ? PluginService : null
        enabled: typeof PluginService !== 'undefined'
        function onPluginLoaded(pluginId) {
            const plugin = PluginService.availablePlugins[pluginId];
            if (plugin?.type === "desktop")
                syncPluginWidgets();
        }
        function onPluginUnloaded(pluginId) {
            syncPluginWidgets();
        }
        function onPluginListUpdated() {
            syncPluginWidgets();
        }
    }

    function registerBuiltins() {
        registerWidget({
            id: "macOSClock",
            name: "macOS Clock",
            icon: "schedule",
            description: "Flip-style clock with macOS-inspired design",
            type: "builtin",
            component: "qs.Modules.Desktop.BuiltinWidgets.MacOSClockWidget",
            settingsComponent: "qs.Modules.Settings.DesktopWidgetSettings.MacOSClockSettings",
            defaultConfig: {
                transparency: 0.5,
                displayPreferences: ["all"]
            },
            defaultSize: {
                width: 220,
                height: 140
            }
        });

        registerWidget({
            id: "systemMonitorDetailed",
            name: "System Monitor Detailed",
            icon: "monitoring",
            description: "Detailed system monitor with graphs for CPU, GPU, RAM, and Network",
            type: "builtin",
            component: "qs.Modules.Desktop.BuiltinWidgets.SystemMonitor-3",
            settingsComponent: "qs.Modules.Settings.DesktopWidgetSettings.SystemMonitorSettings",
            defaultConfig: {
                transparency: 0.8,
                displayPreferences: ["all"]
            },
            defaultSize: {
                width: 512,
                height: 512
            }
        });

        registerWidget({
            id: "desktopSystemMonitorCard",
            name: "System Monitor Card",
            icon: "monitoring",
            description: "Compact system monitor card showing CPU usage, temperature, memory, GPU temp, VRAM, and network speeds",
            type: "builtin",
            component: "qs.Modules.Desktop.DesktopSystemMonitorCardWidget",
            settingsComponent: null,
            defaultConfig: {
                transparency: 0.9,
                displayPreferences: ["all"]
            },
            defaultSize: {
                width: 500,
                height: 200
            }
        });

        registerWidget({
            id: "desktopSystemMonitorCircle",
            name: "System Monitor Circle",
            icon: "monitoring",
            description: "Circular system monitor showing CPU usage, temperature, memory, GPU temp, VRAM, and network speeds",
            type: "builtin",
            component: "qs.Modules.Desktop.DesktopSystemMonitorCircleWidget",
            settingsComponent: null,
            defaultConfig: {
                transparency: 0.9,
                displayPreferences: ["all"]
            },
            defaultSize: {
                width: 500,
                height: 200
            }
        });

        registerWidget({
            id: "desktopDarkDash",
            name: "Desktop Dark Dash",
            icon: "dashboard",
            description: "Dark Dash widget for desktop with customizable tabs and content",
            type: "builtin",
            component: "qs.Modules.Desktop.DesktopDarkDashWidget",
            settingsComponent: null,
            defaultConfig: {
                displayPreferences: ["all"]
            },
            defaultSize: {
                width: 700,
                height: 500
            }
        });

        registerWidget({
            id: "desktopWeather",
            name: "Desktop Weather",
            icon: "wb_sunny",
            description: "Weather widget showing current conditions and forecast",
            type: "builtin",
            component: "qs.Modules.Desktop.DesktopWeatherWidget",
            settingsComponent: null,
            defaultConfig: {
                displayPreferences: ["all"]
            },
            defaultSize: {
                width: 800,
                height: 500
            }
        });

        registerWidget({
            id: "desktopWallpaperGallery",
            name: "Wallpaper Gallery",
            icon: "wallpaper",
            description: "Browse and select wallpapers from your collection with thumbnail grid view",
            type: "builtin",
            component: "qs.Modules.Desktop.BuiltinWidgets.DesktopWallpaperGalleryWidget",
            settingsComponent: "qs.Modules.Settings.DesktopWidgetSettings.WallpaperGallerySettings",
            defaultConfig: {
                displayPreferences: ["all"],
                showControls: true,
                showFileNames: true,
                gridColumns: 4,
                gridRows: 3,
                wallpaperDir: "",
                fontSize: 12,
                spacing: 4,
                padding: 16
            },
            defaultSize: {
                width: 600,
                height: 400
            }
        });

        registerWidget({
            id: "desktopFastfetch",
            name: "Fastfetch",
            icon: "info",
            description: "System information widget displaying OS, hardware, and system details in Fastfetch style",
            type: "builtin",
            component: "qs.Modules.Desktop.BuiltinWidgets.DesktopFastfetchWidget",
            settingsComponent: "qs.Modules.Settings.DesktopWidgetSettings.FastfetchSettings",
            defaultConfig: {
                displayPreferences: ["all"],
                showOs: true,
                showHost: true,
                showKernel: true,
                showUptime: true,
                showPackages: true,
                showShell: true,
                showRes: true,
                showDe: true,
                showWm: true,
                showTheme: true,
                showIcons: true,
                showFonts: true,
                showCpu: true,
                showGpu: true,
                showMemory: true,
                showDisk: true,
                showLocalIp: true,
                useCustomLogo: false,
                customLogoPath: ""
            },
            defaultSize: {
                width: 600,
                height: 400
            }
        });
    }

    function getDefaultSystemMonitorConfig() {
        return {
            showHeader: true,
            transparency: 0.8,
            colorMode: "primary",
            customColor: "#ffffff",
            showCpu: true,
            showCpuGraph: true,
            showCpuTemp: true,
            showGpuTemp: false,
            gpuPciId: "",
            showMemory: true,
            showMemoryGraph: true,
            showNetwork: true,
            showNetworkGraph: true,
            showDisk: true,
            showTopProcesses: false,
            topProcessCount: 3,
            topProcessSortBy: "cpu",
            layoutMode: "auto",
            graphInterval: 60,
            displayPreferences: ["all"]
        };
    }

    function registerWidget(widgetDef) {
        if (!widgetDef?.id)
            return;

        const newMap = Object.assign({}, registeredWidgets);
        newMap[widgetDef.id] = widgetDef;
        registeredWidgets = newMap;
        _updateWidgetsList();
        registryChanged();
    }

    function unregisterWidget(widgetId) {
        if (!registeredWidgets[widgetId])
            return;

        const newMap = Object.assign({}, registeredWidgets);
        delete newMap[widgetId];
        registeredWidgets = newMap;
        _updateWidgetsList();
        registryChanged();
    }

    function getWidget(widgetType) {
        return registeredWidgets[widgetType] ?? null;
    }

    function getDefaultConfig(widgetType) {
        const widget = getWidget(widgetType);
        if (!widget)
            return {};

        if (widget.type === "builtin") {
            switch (widgetType) {
            case "systemMonitorDetailed":
                return {
                    transparency: 0.8,
                    displayPreferences: ["all"]
                };
            default:
                return widget.defaultConfig ?? {};
            }
        }

        return widget.defaultConfig ?? {};
    }

    function getDefaultSize(widgetType) {
        const widget = getWidget(widgetType);
        return widget?.defaultSize ?? {
            width: 200,
            height: 200
        };
    }

    function syncPluginWidgets() {
        if (typeof PluginService === 'undefined')
            return;

        const desktopPlugins = PluginService.pluginDesktopComponents;
        const availablePlugins = PluginService.availablePlugins;
        const currentPluginIds = [];

        for (const pluginId in desktopPlugins) {
            currentPluginIds.push(pluginId);
            const plugin = availablePlugins[pluginId];
            if (!plugin)
                continue;

            if (registeredWidgets[pluginId]?.type === "plugin")
                continue;

            registerWidget({
                id: pluginId,
                name: plugin.name || pluginId,
                icon: plugin.icon || "extension",
                description: plugin.description || "",
                type: "plugin",
                component: null,
                settingsComponent: plugin.settingsPath || null,
                defaultConfig: {
                    displayPreferences: ["all"]
                },
                defaultSize: {
                    width: 200,
                    height: 200
                },
                pluginInfo: plugin
            });
        }

        const toRemove = [];
        for (const widgetId in registeredWidgets) {
            const widget = registeredWidgets[widgetId];
            if (widget.type !== "plugin")
                continue;
            if (!currentPluginIds.includes(widgetId))
                toRemove.push(widgetId);
        }

        for (const widgetId of toRemove) {
            unregisterWidget(widgetId);
        }
    }

    function _updateWidgetsList() {
        const result = [];
        for (const key in registeredWidgets) {
            result.push(registeredWidgets[key]);
        }
        result.sort((a, b) => {
            if (a.type === "builtin" && b.type !== "builtin")
                return -1;
            if (a.type !== "builtin" && b.type === "builtin")
                return 1;
            return (a.name || "").localeCompare(b.name || "");
        });
        registeredWidgetsList = result;
    }

    function getBuiltinWidgets() {
        return registeredWidgetsList.filter(w => w.type === "builtin");
    }

    function getPluginWidgets() {
        return registeredWidgetsList.filter(w => w.type === "plugin");
    }

    function getAllWidgets() {
        return registeredWidgetsList;
    }
}
