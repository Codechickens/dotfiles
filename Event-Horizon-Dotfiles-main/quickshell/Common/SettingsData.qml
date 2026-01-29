pragma Singleton

pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services

Singleton {
    id: root

    property var audioRoutesOutput: ({})
    property var audioRoutesInput: ({})
    property int audioVolumeStep: 5
    property bool audioVolumeOverdrive: true
    property string currentThemeName: "blue"
    property string customThemeFile: ""
    property var savedColorThemes: []
    property string currentColorTheme: ""
    property real colorVibrance: 1.0
    property bool extractedColorTextOverrideEnabled: false
    property int extractedColorTextR: 255
    property int extractedColorTextG: 255
    property int extractedColorTextB: 255
    property var savedTextColorPresets: []
    property bool handheldMode: false
    property real topBarTransparency: 0.75
    property real topBarWidgetTransparency: 0.85
    property real popupTransparency: 0.92
    property real modalTransparency: 0.85
    property bool settingsModalDimmingEnabled: false
    property real notificationTransparency: 0.9
    property real controlCenterTransparency: 0.85
    property real appDrawerTransparency: 0.92
    property real controlCenterWidgetBackgroundOpacity: 0.60
    property real controlCenterBorderOpacity: 0.30
    property real controlCenterBorderThickness: 1
    property real settingsBorderOpacity: 0.30
    property real settingsBorderThickness: 1
    property real settingsBrightness: 1.0
    property real settingsContrast: 1.0
    property real settingsWhiteBalance: 1.0
    property real settingsHighlights: 1.0
    property real launcherLogoRed: 1.0
    property real launcherLogoGreen: 1.0
    property real launcherLogoBlue: 1.0
    property bool launcherLogoAutoSync: false
    property real darkDashTransparency: 0.92
    property real darkDashBorderOpacity: 0.0
    property real darkDashBorderThickness: 0
    property real darkDashTabBarOpacity: 1.0
    property real darkDashContentBackgroundOpacity: 1.0
    property real darkDashAnimatedTintOpacity: 0.04
    property bool darkDashTintAnimateEnabled: true
    
    property real desktopDarkDashTransparency: 0.92
    property real desktopDarkDashBorderOpacity: 0.0
    property real desktopDarkDashBorderThickness: 0
    property real desktopDarkDashTabBarOpacity: 1.0
    property real desktopDarkDashContentBackgroundOpacity: 1.0
    property real desktopDarkDashAnimatedTintOpacity: 0.04
    property bool systemIconTinting: false
    property real iconTintIntensity: 0.5
    property int settingsWindowWidth: 0
    property int settingsWindowHeight: 0
    property int settingsWindowX: -1
    property int settingsWindowY: -1
    property bool desktopWidgetsEnabled: false
    property bool desktopIconsEnabled: false
    property bool desktopCpuTempEnabled: true
    property bool desktopGpuTempEnabled: true
    property bool desktopSystemMonitorEnabled: true
    property bool desktopClockEnabled: true
    property bool desktopWeatherEnabled: false
    property bool desktopTerminalEnabled: false
    property bool desktopDarkDashEnabled: false
    property string desktopWidgetsDisplay: "primary"
    property string desktopWidgetsPosition: "top-left"
    
    property string desktopCpuTempPosition: "top-left"
    property string desktopGpuTempPosition: "top-center"
    property string desktopSystemMonitorPosition: "top-right"
    property string desktopClockPosition: "bottom-right"
    property string desktopWeatherPosition: "top-left"
    property string desktopTerminalPosition: "bottom-left"
    property string desktopDarkDashPosition: "top-right"
    
    property real desktopCpuTempOpacity: 0.9
    property real desktopGpuTempOpacity: 0.9
    property real desktopSystemMonitorOpacity: 0.9
    property string desktopSystemMonitorCustomGpuName: ""
    property string desktopSystemMonitorCustomCpuName: ""
    property real desktopClockOpacity: 0.9
    property real desktopClockBackgroundOpacity: 0.9
    property real desktopWeatherOpacity: 0.9
    property real desktopTerminalOpacity: 0.9
    
    property real desktopWidgetBorderOpacity: 0.3
    property real desktopWidgetBorderThickness: 1
    
    property real desktopWidgetWidth: 180
    property real desktopWidgetHeight: 80
    property real desktopWidgetFontSize: 14
    property real desktopWidgetIconSize: 20
    
    property real desktopSystemMonitorWidth: 320
    property real desktopSystemMonitorHeight: 200
    property real desktopWeatherWidth: 800
    property real desktopWeatherHeight: 500
    property real desktopTerminalWidth: 600
    property real desktopTerminalHeight: 400
    property real desktopTerminalFontSize: 12
    property real desktopDarkDashWidth: 700
    property real desktopDarkDashHeight: 500
    
    property var desktopWidgetPositions: {}
    property var desktopWidgetGridSettings: {}
    property var desktopWidgetInstances: []
    property real desktopWeatherFontSize: 20
    property real desktopWeatherIconSize: 24
    property real desktopWeatherSpacing: 8
    property real desktopWeatherPadding: 16
    property real desktopWeatherBorderRadius: 8
    property real desktopWeatherCurrentTempSize: 2.0
    property real desktopWeatherCitySize: 2.0
    property real desktopWeatherDetailsSize: 1.2
    property real desktopWeatherForecastSize: 1.2
    property string desktopGpuSelection: "auto"
    property real dockTransparency: 1
    
    property bool dockBorderEnabled: false
    property real dockBorderWidth: 2
    property real dockBorderRadius: 8
    property real dockRadius: 12
    property real dockBorderRed: 0.0
    property real dockBorderGreen: 0.0
    property real dockBorderBlue: 0.0
    property real dockBorderAlpha: 1.0
    property bool dockDynamicBorderColors: false
     
    property bool topBarBorderEnabled: false
    property bool topBarDynamicBorderColors: false
    
    property bool taskBarBorderEnabled: false
    property real taskBarBorderWidth: 2
    property real taskBarBorderRadius: 8
    property real taskBarBorderRed: 0.0
    property real taskBarBorderGreen: 0.0
    property real taskBarBorderBlue: 0.0
    property real taskBarBorderAlpha: 1.0
    property bool taskBarDynamicBorderColors: false
    property bool taskBarBorderTop: true
    property bool taskBarBorderLeft: true
    property bool taskBarBorderRight: true
    property bool taskBarBorderBottom: true
    property real taskBarBorderBottomLeftInset: 1
    property real taskBarBorderBottomRightInset: 1
    
    property real topBarBorderWidth: 2
    property real topBarBorderRadius: 8
    property real topBarBorderRed: 0.0
    property real topBarBorderGreen: 0.0
    property real topBarBorderBlue: 0.0
    property real topBarBorderAlpha: 1.0
    property bool topBarBorderTop: true
    property bool topBarBorderLeft: true
    property bool topBarBorderRight: true
    property bool topBarBorderBottom: true
    property real topBarBorderBottomLeftInset: 1
    property real topBarBorderBottomRightInset: 1

    
    property bool topBarFloat: false
    property bool topBarRoundedCorners: false
    property real topBarCornerRadius: 12
    property real topBarLeftMargin: 0
    property real topBarRightMargin: 0
    property real topBarTopMargin: 0
    property real topBarHeight: 40
    property string topBarPosition: "top"
    property real taskBarHeight: 54
    property real taskBarTransparency: 0.5
    property string taskBarPinnedAppsPosition: "left"
    property real taskBarIconSize: 39
    property real taskBarIconSpacing: 0
    property bool taskBarFloat: false
    property bool taskBarRoundedCorners: false
    property real taskBarCornerRadius: 32
    property real taskBarBottomMargin: 3
    property real taskBarExclusiveZone: 56
    property bool taskBarAutoHide: true
    property bool taskBarVisible: true
    property bool taskBarGroupApps: true
    property real taskBarLeftPadding: 0
    property real taskBarRightPadding: 0
    property real taskBarTopPadding: 0
    property real taskBarBottomPadding: 0
    property bool use24HourClock: true
    property bool showAmPmIn24Hour: false
    property bool clockStackedFormat: false
    property bool clockBoldFont: false
    property bool useFahrenheit: false
    property bool nightModeEnabled: false
    property string weatherLocation: "New York, NY"
    property string weatherCoordinates: "40.7128,-74.0060"
    property bool useAutoLocation: false
    property bool showLauncherButton: true
    property bool showWorkspaceSwitcher: true
    property bool showFocusedWindow: true
    property bool showWeather: true
    property bool showMusic: true
    property bool showClipboard: true
    property bool showCpuUsage: true
    property bool showMemUsage: true
    property bool showCpuTemp: true
    property bool showGpuTemp: true
    property int selectedGpuIndex: 0
    property var enabledGpuPciIds: []
    property bool showSystemTray: true
    property bool showClock: true
    property bool showNotificationButton: true
    property bool showBattery: true
    property bool showControlCenterButton: true
    property bool controlCenterShowNetworkIcon: true
    property bool controlCenterShowBluetoothIcon: true
    property bool controlCenterShowAudioIcon: true
    property bool controlCenterShowMicIcon: true
    property var controlCenterWidgets: [
        {"id": "wifi", "enabled": true, "width": 50},
        {"id": "bluetooth", "enabled": true, "width": 50},
        {"id": "audioOutput", "enabled": true, "width": 50},
        {"id": "audioInput", "enabled": true, "width": 50},
        {"id": "volumeMixer", "enabled": true, "width": 100},
        {"id": "performance", "enabled": true, "width": 50},
        {"id": "darkMode", "enabled": true, "width": 50}
    ]
    property bool showWorkspaceIndex: true
    property bool showWorkspacePadding: false
    property bool showWorkspaceApps: true
    property int maxWorkspaceIcons: 3
    property int maxWorkspaces: 10
    property bool workspacesPerMonitor: true
    property var workspaceNameIcons: ({})
    property bool waveProgressEnabled: true
    property bool clockCompactMode: false
    property bool focusedWindowCompactMode: false
    property bool runningAppsCompactMode: true
    property bool runningAppsCurrentWorkspace: false
    property string clockDateFormat: ""
    property string lockDateFormat: ""
    property bool dockClockShowFullDate: false
    property bool dockClockShowSeconds: false
    property bool dockClockUse12Hour: true
    property bool dockClockShowAmPm: true
    property real dockClockFontSize: 1.0
    property int firstDayOfWeek: 1
    property string weekNumbering: "ISO"
    property string systemTimezone: ""
    property int mediaSize: 1
    property bool mediaScrollEnabled: true
    property var topBarLeftWidgets: []
    property var topBarCenterWidgets: []
    property var topBarRightWidgets: []
    property alias topBarLeftWidgetsModel: leftWidgetsModel
    property alias topBarCenterWidgetsModel: centerWidgetsModel
    property alias topBarRightWidgetsModel: rightWidgetsModel
    
    property var dockLeftWidgets: []
    property var dockCenterWidgets: []
    property var dockRightWidgets: []
    
    property var taskBarLeftWidgets: []
    property var taskBarCenterWidgets: []
    property var taskBarRightWidgets: []
    property alias taskBarLeftWidgetsModel: taskBarLeftWidgetsModel
    property alias taskBarCenterWidgetsModel: taskBarCenterWidgetsModel
    property alias taskBarRightWidgetsModel: taskBarRightWidgetsModel
    
    property string notificationCenterPosition: "top-right"
    property string clipboardPosition: "bottom-right"
    
    property real startMenuXOffset: 0.0
    property real startMenuYOffset: 0.0
    property real controlCenterXOffset: 0.0
    property real controlCenterYOffset: 0.0
    property real darkDashXOffset: 0.0
    property real darkDashYOffset: 0.0
    property real applicationsXOffset: 0.0
    property real applicationsYOffset: 0.0
    
    property alias dockLeftWidgetsModel: dockLeftWidgetsModel
    property alias dockCenterWidgetsModel: dockCenterWidgetsModel
    property alias dockRightWidgetsModel: dockRightWidgetsModel
    property string appLauncherViewMode: "list"
    property string spotlightModalViewMode: "list"
    property string networkPreference: "auto"
    property string iconTheme: "System Default"
    property var availableIconThemes: ["System Default"]
    property string systemDefaultIconTheme: ""
    property bool qt5ctAvailable: false
    property bool qt6ctAvailable: false
    property bool gtkAvailable: false
    
    property var availableGtkThemes: ["System Default"]
    property string systemDefaultGtkTheme: ""
    property string gtkTheme: "System Default"
    
    property var availableQtThemes: ["System Default"]
    property string systemDefaultQtTheme: ""
    property string qtTheme: "System Default"
    
    property var availableShellThemes: ["System Default"]
    property string systemDefaultShellTheme: ""
    property string shellTheme: "System Default"
    property bool userThemeExtensionAvailable: false
    property bool userThemeExtensionEnabled: false
    
    property var availableCursorThemes: ["System Default"]
    property string systemDefaultCursorTheme: ""
    property string cursorTheme: "System Default"
    property int cursorSize: 24
    property bool useOSLogo: false
    property string osLogoColorOverride: ""
    property real osLogoBrightness: 0.5
    property real osLogoContrast: 1
    property bool useCustomLauncherImage: false
    property string customLauncherImagePath: ""
    property string keybindsPath: ""
    property real launcherLogoSize: 24
    property string launcherPosition: "bottom-center"
    property bool wallpaperDynamicTheming: true
    property bool weatherEnabled: true
    property string fontFamily: defaultFontFamily
    property string monoFontFamily: defaultMonoFontFamily
    property int fontWeight: Font.Normal
    property real fontScale: 1.0
    property real fontLetterSpacing: 0.0
    property real fontWordSpacing: 0.0
    property real fontLineHeight: 1.2
    property int fontCapitalization: Font.MixedCase
    property int fontStretch: Font.NormalStretch
    property bool fontItalic: false
    property bool fontUnderline: false
    property bool fontStrikeout: false
    property int fontHintingPreference: Font.PreferDefaultHinting
    property int fontRenderType: Text.QtRendering
    property bool fontAntialiasing: true
    property real settingsUiScale: 1.0
    property bool settingsUiAdvancedScaling: false
    property real settingsUiWindowScale: 1.0
    property real settingsUiControlScale: 1.0
    property real settingsUiIconScale: 1.0
    property bool notepadUseMonospace: true
    property string notepadFontFamily: ""
    property real notepadFontSize: 14
    property bool notepadShowLineNumbers: false
    property real notepadTransparencyOverride: -1
    property real notepadLastCustomTransparency: 0.7
    property string terminalEmulator: ""
    property var availableTerminals: []
    property string aurHelper: ""
    property var availableAurHelpers: []

    onNotepadUseMonospaceChanged: saveSettings()
    onNotepadFontFamilyChanged: saveSettings()
    onNotepadFontSizeChanged: saveSettings()
    onNotepadShowLineNumbersChanged: saveSettings()
    onNotepadTransparencyOverrideChanged: {
        if (notepadTransparencyOverride > 0) {
            notepadLastCustomTransparency = notepadTransparencyOverride
        }
        saveSettings()
    }
    onNotepadLastCustomTransparencyChanged: saveSettings()
    onTerminalEmulatorChanged: saveSettings()
    onAurHelperChanged: saveSettings()
    onSettingsUiScaleChanged: saveSettings()
    onFontLetterSpacingChanged: saveSettings()
    onFontWordSpacingChanged: saveSettings()
    onFontLineHeightChanged: saveSettings()
    onFontCapitalizationChanged: saveSettings()
    onFontStretchChanged: saveSettings()
    onFontItalicChanged: saveSettings()
    onFontUnderlineChanged: saveSettings()
    onFontStrikeoutChanged: saveSettings()
    onFontHintingPreferenceChanged: saveSettings()
    onFontRenderTypeChanged: saveSettings()
    onFontAntialiasingChanged: saveSettings()
    onSettingsUiAdvancedScalingChanged: saveSettings()
    onSettingsUiWindowScaleChanged: saveSettings()
    onSettingsUiControlScaleChanged: saveSettings()
    onSettingsUiIconScaleChanged: saveSettings()
    onTopBarPositionChanged: {
        saveSettings()
    }
    onDesktopSystemMonitorPositionChanged: saveSettings()
    onDesktopSystemMonitorCustomGpuNameChanged: saveSettings()
    onDesktopSystemMonitorCustomCpuNameChanged: saveSettings()
    onDockClockShowFullDateChanged: saveSettings()
    onDockClockShowSecondsChanged: saveSettings()
    onDockClockUse12HourChanged: saveSettings()
    onDockClockShowAmPmChanged: saveSettings()
    onDockClockFontSizeChanged: saveSettings()
    property bool gtkThemingEnabled: false
    property bool qtThemingEnabled: false
    property bool hyprlandThemingEnabled: true
    property bool showDock: false
    property string dockPosition: "bottom"
    property bool dockWidgetsEnabled: false
    property bool dockAutoHide: false
    property bool dockGroupApps: true
    property bool dockHideOnGames: true
    property bool dockExpandToScreen: false
    property bool dockCenterApps: false
    property real dockBottomGap: 1
    property real dockExclusiveZone: 65
    property bool dockUseDynamicZones: false
    property real dockLeftPadding: 0
    property real dockRightPadding: 0
    property real dockTopPadding: 0
    property real dockBottomPadding: 0
    property bool dockTooltipsEnabled: true
    property real dockScale: 1.0
    property real dockIconSize: 40
    property real dockIconSpacing: 2
    property real dockPinnedAppsIconSize: 40
    property real dockPinnedAppsIconSpacing: 2
    property bool dockPinnedAppsPillEnabled: false
    property bool dockTrashPillEnabled: false
    property bool dockLaunchpadPillEnabled: false
    property real taskbarScale: 1.0
    property real taskbarIconSize: 30
    property real taskbarIconSpacing: 2
    property real topbarScale: 1.0
    property real topbarIconSize: 24
    property real topbarIconSpacing: 2
    property real dockWidgetAreaOpacity: 0.30
    property real dockBackgroundTintOpacity: 0.04
    property real dockCollapsedHeight: 20
    property real dockSlideDistance: 60
    property int dockAnimationDuration: 200
    property real dockLeftWidgetAreaMinWidth: 60
    property real dockRightWidgetAreaMinWidth: 40
    property real cornerRadius: 32
    property bool notificationOverlayEnabled: false
    
    property real hyprlandBlurSize: 2
    property int hyprlandBlurPasses: 2
    property int hyprlandBorderSize: 4
    property real hyprlandBorderHue: 0.0
    property real hyprlandBorderAlpha: 1.0

    // Decoration properties
    property int hyprlandDecorationRounding: 10
    property int hyprlandDecorationRoundingPower: 15
    property bool hyprlandDecorationBlurEnabled: true
    property bool hyprlandDecorationBlurXray: true
    property bool hyprlandDecorationBlurSpecial: true
    property bool hyprlandDecorationBlurNewOptimizations: true
    property bool hyprlandDecorationBlurIgnoreOpacity: true
    property int hyprlandDecorationBlurSize: 1
    property int hyprlandDecorationBlurPasses: 5
    property real hyprlandDecorationBlurBrightness: 0.2
    property bool hyprlandDecorationBlurBrightnessEnabled: true
    property real hyprlandDecorationBlurNoise: 0.01
    property real hyprlandDecorationBlurContrast: 0
    property bool hyprlandDecorationBlurContrastEnabled: true
    property real hyprlandDecorationBlurVibrancy: 0.1696
    property real hyprlandDecorationBlurVibrancyDarkness: 0.0
    property bool hyprlandDecorationBlurPopups: true
    property real hyprlandDecorationBlurPopupsIgnorealpha: 0.6
    property bool hyprlandDecorationBlurInputMethods: false
    property real hyprlandDecorationBlurInputMethodsIgnorealpha: 0.2
    property bool hyprlandDecorationShadowEnabled: false
    property bool hyprlandDecorationShadowIgnoreWindow: true
    property int hyprlandDecorationShadowRange: 12
    property string hyprlandDecorationShadowOffset: "0 2"
    property int hyprlandDecorationShadowRenderPower: 2
    property string hyprlandDecorationShadowColor: "rgba(0000002A)"
    property bool hyprlandDecorationDimInactive: false
    property real hyprlandDecorationDimStrength: 0.0
    property real hyprlandDecorationDimSpecial: 0

    property string hyprlandInputKbLayout: ""
    property string hyprlandInputKbVariant: ""
    property string hyprlandInputKbModel: ""
    property string hyprlandInputKbOptions: ""
    property string hyprlandInputKbRules: ""
    property int hyprlandInputRepeatRate: 25
    property int hyprlandInputRepeatDelay: 600
    property bool hyprlandInputNumlockByDefault: false
    property int hyprlandInputFollowMouse: 1
    property int hyprlandInputFollowMouseThreshold: 0
    property real hyprlandInputSensitivity: 0.0
    property string hyprlandInputAccelProfile: "adaptive"
    property bool hyprlandInputNaturalScroll: false
    property bool hyprlandInputLeftHanded: false
    property var hyprlandInputDeviceRotations: ({})

    // Render properties
    property bool hyprlandRenderNewScheduling: true
    property int hyprlandRenderCmFsPassthrough: 1
    property bool hyprlandRenderCmEnabled: true
    property bool hyprlandRenderSendContentType: true
    property bool hyprlandRenderCmAutoHdr: true
    property int hyprlandRenderDirectScanout: 2
    property bool hyprlandRenderExpandUndersizedTextures: true

    // General properties
    property int hyprlandGeneralGapsIn: 0
    property int hyprlandGeneralGapsOut: 0
    property int hyprlandGeneralGapsWorkspaces: 0
    property int hyprlandGeneralBorderSize: 3
    property bool hyprlandGeneralResizeOnBorder: true
    property bool hyprlandGeneralNoFocusFallback: true
    property bool hyprlandGeneralAllowTearing: true

    // Snap properties
    property bool hyprlandSnapEnabled: true
    property int hyprlandSnapWindowGap: 10
    property int hyprlandSnapMonitorGap: 10
    property bool hyprlandSnapBorderOverlap: false
    property bool hyprlandSnapRespectGaps: false

    // Groupbar properties
    property bool hyprlandGroupbarEnabled: true
    property string hyprlandGroupbarColActive: "rgba(2d2d2dFF) rgba(1a1a1aFF) 45deg"
    property string hyprlandGroupbarColInactive: "rgba(1a1a1aFF)"
    property int hyprlandGroupbarHeight: 32
    property int hyprlandGroupbarPriority: 3
    property bool hyprlandGroupbarRenderTitles: true
    property string hyprlandGroupbarFontFamily: "Inter Variable, Inter, Roboto, Ubuntu, Noto Sans, sans-serif"
    property int hyprlandGroupbarFontSize: 13
    property bool hyprlandGroupbarGradients: true
    property string hyprlandGroupbarTextColor: "rgba(e0e0e0FF)"
    property int hyprlandGroupbarRounding: 8

    // Dwindle properties
    property bool hyprlandDwindlePreserveSplit: true
    property bool hyprlandDwindleSmartSplit: false
    property bool hyprlandDwindleSmartResizing: false

    // Cursor properties
    property int hyprlandCursorNoHardwareCursors: 2
    property int hyprlandCursorNoBreakFsVrr: 2
    property int hyprlandCursorMinRefreshRate: 24
    property int hyprlandCursorHotspotPadding: 1
    property real hyprlandCursorInactiveTimeout: 0
    property bool hyprlandCursorNoWarps: false
    property bool hyprlandCursorPersistentWarps: false
    property int hyprlandCursorWarpOnChangeWorkspace: 0
    property int hyprlandCursorWarpOnToggleSpecial: 0
    property string hyprlandCursorDefaultMonitor: ""
    property real hyprlandCursorZoomFactor: 1.0
    property bool hyprlandCursorZoomRigid: false
    property bool hyprlandCursorZoomDetachedCamera: true
    property bool hyprlandCursorEnableHyprcursor: true
    property bool hyprlandCursorHideOnKeyPress: false
    property bool hyprlandCursorHideOnTouch: true
    property bool hyprlandCursorHideOnTablet: true
    property int hyprlandCursorUseCpuBuffer: 2
    property bool hyprlandCursorWarpBackAfterNonMouseInput: false
    property bool hyprlandCursorZoomDisableAa: false

    onHyprlandBorderSizeChanged: {
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            updateHyprlandBorderSize(hyprlandBorderSize)
        }
    }

    onHyprlandBorderHueChanged: {
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            updateHyprlandBorderColors()
        }
    }

    onHyprlandBorderAlphaChanged: {
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            updateHyprlandBorderColors()
        }
    }
    property bool topBarAutoHide: false
    property bool topBarOpenOnOverview: false
    property bool topBarVisible: false
    property real topBarSpacing: 4
    property real topBarBottomGap: 0
    property real topBarInnerPadding: 8
    property bool topBarSquareCorners: false
    property bool topBarNoBackground: true
    property bool topBarGothCornersEnabled: false
    property bool lockScreenShowPowerActions: true
    property bool hideBrightnessSlider: false
    property string widgetBackgroundColor: "sth"
    property int notificationTimeoutLow: 5000
    property int notificationTimeoutNormal: 5000
    property int notificationTimeoutCritical: 0
    property var screenPreferences: ({})
    property string defaultFontFamily: "Inter Variable"
    property string defaultMonoFontFamily: "Fira Code"
    readonly property string _shellDir: Paths.strip(Qt.resolvedUrl(".").toString()).replace("/Common/", "")
    readonly property string bundledFontsDir: _shellDir + "/assets/fonts"
    property var bundledFontPaths: []
    property var bundledFontLoaders: []
    readonly property string _homeUrl: StandardPaths.writableLocation(StandardPaths.HomeLocation)
    readonly property string _configUrl: StandardPaths.writableLocation(StandardPaths.ConfigLocation)
    readonly property string _configDir: Paths.strip(_configUrl)

    signal forceTopBarLayoutRefresh
    signal widgetDataChanged
    signal workspaceIconsUpdated

    property bool _loading: false

    function getEffectiveTimeFormat() {
        if (use24HourClock) {
            return showAmPmIn24Hour ? "HH:mm AP" : "HH:mm"
        } else {
            return "h:mm AP"
        }
    }

    function getEffectiveClockDateFormat() {
        return clockDateFormat && clockDateFormat.length > 0 ? clockDateFormat : "ddd d"
    }

    function getEffectiveLockDateFormat() {
        return lockDateFormat && lockDateFormat.length > 0 ? lockDateFormat : Locale.LongFormat
    }

    function initializeListModels() {
        var dummyItem = {
            "widgetId": "dummy",
            "enabled": true,
            "size": 20,
            "selectedGpuIndex": 0,
            "pciId": ""
        }
        leftWidgetsModel.append(dummyItem)
        centerWidgetsModel.append(dummyItem)
        rightWidgetsModel.append(dummyItem)

        updateListModel(leftWidgetsModel, topBarLeftWidgets)
        updateListModel(centerWidgetsModel, topBarCenterWidgets)
        updateListModel(rightWidgetsModel, topBarRightWidgets)
        
        // Initialize task bar widget models
        taskBarLeftWidgetsModel.append(dummyItem)
        taskBarCenterWidgetsModel.append(dummyItem)
        taskBarRightWidgetsModel.append(dummyItem)
        
        updateListModel(taskBarLeftWidgetsModel, taskBarLeftWidgets)
        updateListModel(taskBarCenterWidgetsModel, taskBarCenterWidgets)
        updateListModel(taskBarRightWidgetsModel, taskBarRightWidgets)
    }

    function loadSettings() {
        _loading = true
        parseSettings(settingsFile.text())
        _loading = false
        
        // Initialize defaults for new users with empty widget arrays (handles empty/invalid settings files)
        if (topBarLeftWidgets.length === 0 && topBarCenterWidgets.length === 0 && topBarRightWidgets.length === 0) {
            topBarLeftWidgets = ["launcherButton"]
            topBarCenterWidgets = ["workspaceSwitcher"]
            topBarRightWidgets = ["systemTray", "weather", "clock", "notificationButton", "controlCenterButton", "systemUpdate"]
            updateListModel(leftWidgetsModel, topBarLeftWidgets)
            updateListModel(centerWidgetsModel, topBarCenterWidgets)
            updateListModel(rightWidgetsModel, topBarRightWidgets)
        }
        
        // Initialize defaults for task bar widgets if empty
        if (taskBarLeftWidgets.length === 0 && taskBarCenterWidgets.length === 0 && taskBarRightWidgets.length === 0) {
            // Set default taskbar widget configuration
            taskBarLeftWidgets = [{"id": "launcherButton", "enabled": true}, {"id": "workspaceSwitcher", "enabled": true}]
            taskBarCenterWidgets = [{"id": "pinnedApps", "enabled": true}, {"id": "separator", "enabled": false}, {"id": "runningApps", "enabled": true}]
            taskBarRightWidgets = ["systemTray", "weather", "clock", "controlCenterButton", "systemUpdate"]
            updateListModel(taskBarLeftWidgetsModel, taskBarLeftWidgets)
            updateListModel(taskBarCenterWidgetsModel, taskBarCenterWidgets)
            updateListModel(taskBarRightWidgetsModel, taskBarRightWidgets)
        }
    }

    function parseSettings(content) {
        _loading = true
        try {
            if (content && content.trim()) {
                var settings = JSON.parse(content)
                if (settings.themeIndex !== undefined || settings.themeIsDynamic !== undefined) {
                    const themeNames = ["blue", "deepBlue", "purple", "green", "orange", "red", "cyan", "pink", "amber", "coral"]
                    if (settings.themeIsDynamic) {
                        currentThemeName = "dynamic"
                    } else if (settings.themeIndex >= 0 && settings.themeIndex < themeNames.length) {
                        currentThemeName = themeNames[settings.themeIndex]
                    }
                } else {
                    currentThemeName = settings.currentThemeName !== undefined ? settings.currentThemeName : "blue"
                }
                customThemeFile = settings.customThemeFile !== undefined ? settings.customThemeFile : ""
                savedColorThemes = settings.savedColorThemes !== undefined ? settings.savedColorThemes : []
                currentColorTheme = settings.currentColorTheme !== undefined ? settings.currentColorTheme : ""
                colorVibrance = settings.colorVibrance !== undefined ? settings.colorVibrance : 1.0
                extractedColorTextOverrideEnabled = settings.extractedColorTextOverrideEnabled !== undefined ? settings.extractedColorTextOverrideEnabled : false
                extractedColorTextR = settings.extractedColorTextR !== undefined ? settings.extractedColorTextR : 255
                extractedColorTextG = settings.extractedColorTextG !== undefined ? settings.extractedColorTextG : 255
                extractedColorTextB = settings.extractedColorTextB !== undefined ? settings.extractedColorTextB : 255
                savedTextColorPresets = settings.savedTextColorPresets !== undefined ? settings.savedTextColorPresets : []
                topBarTransparency = settings.topBarTransparency !== undefined ? (settings.topBarTransparency > 1 ? settings.topBarTransparency / 100 : settings.topBarTransparency) : 0.75
                topBarWidgetTransparency = settings.topBarWidgetTransparency !== undefined ? (settings.topBarWidgetTransparency > 1 ? settings.topBarWidgetTransparency / 100 : settings.topBarWidgetTransparency) : 0.85
                popupTransparency = settings.popupTransparency !== undefined ? (settings.popupTransparency > 1 ? settings.popupTransparency / 100 : settings.popupTransparency) : 0.92
                modalTransparency = settings.modalTransparency !== undefined ? (settings.modalTransparency > 1 ? settings.modalTransparency / 100 : settings.modalTransparency) : 0.85
                settingsModalDimmingEnabled = settings.settingsModalDimmingEnabled !== undefined ? settings.settingsModalDimmingEnabled : false
                notificationTransparency = settings.notificationTransparency !== undefined ? (settings.notificationTransparency > 1 ? settings.notificationTransparency / 100 : settings.notificationTransparency) : 0.9
                controlCenterTransparency = settings.controlCenterTransparency !== undefined ? (settings.controlCenterTransparency > 1 ? settings.controlCenterTransparency / 100 : settings.controlCenterTransparency) : 0.85
                appDrawerTransparency = settings.appDrawerTransparency !== undefined ? (settings.appDrawerTransparency > 1 ? settings.appDrawerTransparency / 100 : settings.appDrawerTransparency) : 0.92
                controlCenterWidgetBackgroundOpacity = settings.controlCenterWidgetBackgroundOpacity !== undefined ? (settings.controlCenterWidgetBackgroundOpacity > 1 ? settings.controlCenterWidgetBackgroundOpacity / 100 : settings.controlCenterWidgetBackgroundOpacity) : 0.60
                audioRoutesOutput = settings.audioRoutesOutput !== undefined ? settings.audioRoutesOutput : ({})
                audioRoutesInput = settings.audioRoutesInput !== undefined ? settings.audioRoutesInput : ({})
                controlCenterBorderOpacity = settings.controlCenterBorderOpacity !== undefined ? (settings.controlCenterBorderOpacity > 1 ? settings.controlCenterBorderOpacity / 100 : settings.controlCenterBorderOpacity) : 0.30
                controlCenterBorderThickness = settings.controlCenterBorderThickness !== undefined ? settings.controlCenterBorderThickness : 1
                settingsBorderOpacity = settings.settingsBorderOpacity !== undefined ? (settings.settingsBorderOpacity > 1 ? settings.settingsBorderOpacity / 100 : settings.settingsBorderOpacity) : 0.30
                settingsBorderThickness = settings.settingsBorderThickness !== undefined ? settings.settingsBorderThickness : 1
                settingsBrightness = settings.settingsBrightness !== undefined ? settings.settingsBrightness : 1.0
                settingsContrast = settings.settingsContrast !== undefined ? settings.settingsContrast : 1.0
                settingsWhiteBalance = settings.settingsWhiteBalance !== undefined ? settings.settingsWhiteBalance : 1.0
                settingsHighlights = settings.settingsHighlights !== undefined ? settings.settingsHighlights : 1.0
                launcherLogoRed = settings.launcherLogoRed !== undefined ? (settings.launcherLogoRed > 1 ? settings.launcherLogoRed / 255 : settings.launcherLogoRed) : 1.0
                launcherLogoGreen = settings.launcherLogoGreen !== undefined ? (settings.launcherLogoGreen > 1 ? settings.launcherLogoGreen / 255 : settings.launcherLogoGreen) : 1.0
                launcherLogoBlue = settings.launcherLogoBlue !== undefined ? (settings.launcherLogoBlue > 1 ? settings.launcherLogoBlue / 255 : settings.launcherLogoBlue) : 1.0
                launcherLogoAutoSync = settings.launcherLogoAutoSync !== undefined ? settings.launcherLogoAutoSync : false
                darkDashTransparency = settings.darkDashTransparency !== undefined ? (settings.darkDashTransparency > 1 ? settings.darkDashTransparency / 100 : settings.darkDashTransparency) : 0.92
                darkDashBorderOpacity = settings.darkDashBorderOpacity !== undefined ? (settings.darkDashBorderOpacity > 1 ? settings.darkDashBorderOpacity / 100 : settings.darkDashBorderOpacity) : 0.0
                darkDashBorderThickness = settings.darkDashBorderThickness !== undefined ? settings.darkDashBorderThickness : 0
                darkDashTabBarOpacity = settings.darkDashTabBarOpacity !== undefined ? (settings.darkDashTabBarOpacity > 1 ? settings.darkDashTabBarOpacity / 100 : settings.darkDashTabBarOpacity) : 1.0
                darkDashContentBackgroundOpacity = settings.darkDashContentBackgroundOpacity !== undefined ? (settings.darkDashContentBackgroundOpacity > 1 ? settings.darkDashContentBackgroundOpacity / 100 : settings.darkDashContentBackgroundOpacity) : 1.0
                darkDashAnimatedTintOpacity = settings.darkDashAnimatedTintOpacity !== undefined ? (settings.darkDashAnimatedTintOpacity > 1 ? settings.darkDashAnimatedTintOpacity / 100 : settings.darkDashAnimatedTintOpacity) : 0.04
                darkDashTintAnimateEnabled = settings.darkDashTintAnimateEnabled !== undefined ? settings.darkDashTintAnimateEnabled : true
                desktopDarkDashTransparency = settings.desktopDarkDashTransparency !== undefined ? (settings.desktopDarkDashTransparency > 1 ? settings.desktopDarkDashTransparency / 100 : settings.desktopDarkDashTransparency) : 0.92
                desktopDarkDashBorderOpacity = settings.desktopDarkDashBorderOpacity !== undefined ? (settings.desktopDarkDashBorderOpacity > 1 ? settings.desktopDarkDashBorderOpacity / 100 : settings.desktopDarkDashBorderOpacity) : 0.0
                desktopDarkDashBorderThickness = settings.desktopDarkDashBorderThickness !== undefined ? settings.desktopDarkDashBorderThickness : 0
                desktopDarkDashTabBarOpacity = settings.desktopDarkDashTabBarOpacity !== undefined ? (settings.desktopDarkDashTabBarOpacity > 1 ? settings.desktopDarkDashTabBarOpacity / 100 : settings.desktopDarkDashTabBarOpacity) : 1.0
                desktopDarkDashContentBackgroundOpacity = settings.desktopDarkDashContentBackgroundOpacity !== undefined ? (settings.desktopDarkDashContentBackgroundOpacity > 1 ? settings.desktopDarkDashContentBackgroundOpacity / 100 : settings.desktopDarkDashContentBackgroundOpacity) : 1.0
                desktopDarkDashAnimatedTintOpacity = settings.desktopDarkDashAnimatedTintOpacity !== undefined ? (settings.desktopDarkDashAnimatedTintOpacity > 1 ? settings.desktopDarkDashAnimatedTintOpacity / 100 : settings.desktopDarkDashAnimatedTintOpacity) : 0.04
                systemIconTinting = settings.systemIconTinting !== undefined ? settings.systemIconTinting : false
                iconTintIntensity = settings.iconTintIntensity !== undefined ? settings.iconTintIntensity : 0.5
                settingsWindowWidth = settings.settingsWindowWidth !== undefined ? settings.settingsWindowWidth : 0
                settingsWindowHeight = settings.settingsWindowHeight !== undefined ? settings.settingsWindowHeight : 0
                settingsWindowX = settings.settingsWindowX !== undefined ? settings.settingsWindowX : -1
                settingsWindowY = settings.settingsWindowY !== undefined ? settings.settingsWindowY : -1
                desktopWidgetsEnabled = settings.desktopWidgetsEnabled !== undefined ? settings.desktopWidgetsEnabled : false
                desktopIconsEnabled = settings.desktopIconsEnabled !== undefined ? settings.desktopIconsEnabled : false
                desktopCpuTempEnabled = settings.desktopCpuTempEnabled !== undefined ? settings.desktopCpuTempEnabled : true
                desktopGpuTempEnabled = settings.desktopGpuTempEnabled !== undefined ? settings.desktopGpuTempEnabled : true
                desktopSystemMonitorEnabled = settings.desktopSystemMonitorEnabled !== undefined ? settings.desktopSystemMonitorEnabled : true
                desktopClockEnabled = settings.desktopClockEnabled !== undefined ? settings.desktopClockEnabled : true
                desktopWeatherEnabled = settings.desktopWeatherEnabled !== undefined ? settings.desktopWeatherEnabled : false
                desktopTerminalEnabled = settings.desktopTerminalEnabled !== undefined ? settings.desktopTerminalEnabled : false
                desktopDarkDashEnabled = settings.desktopDarkDashEnabled !== undefined ? settings.desktopDarkDashEnabled : false
        desktopWidgetsDisplay = settings.desktopWidgetsDisplay !== undefined ? settings.desktopWidgetsDisplay : "primary"
        desktopWidgetsPosition = settings.desktopWidgetsPosition !== undefined ? settings.desktopWidgetsPosition : "top-left"
        desktopCpuTempPosition = settings.desktopCpuTempPosition !== undefined ? settings.desktopCpuTempPosition : "top-left"
        desktopGpuTempPosition = settings.desktopGpuTempPosition !== undefined ? settings.desktopGpuTempPosition : "top-center"
        desktopSystemMonitorPosition = settings.desktopSystemMonitorPosition !== undefined ? settings.desktopSystemMonitorPosition : "top-right"
        desktopClockPosition = settings.desktopClockPosition !== undefined ? settings.desktopClockPosition : "bottom-right"
        desktopWeatherPosition = settings.desktopWeatherPosition !== undefined ? settings.desktopWeatherPosition : "top-left"
        desktopTerminalPosition = settings.desktopTerminalPosition !== undefined ? settings.desktopTerminalPosition : "bottom-left"
        desktopDarkDashPosition = settings.desktopDarkDashPosition !== undefined ? settings.desktopDarkDashPosition : "top-right"
        desktopWidgetPositions = settings.desktopWidgetPositions !== undefined ? settings.desktopWidgetPositions : {}
        desktopWidgetGridSettings = settings.desktopWidgetGridSettings !== undefined ? settings.desktopWidgetGridSettings : {}
        desktopWidgetInstances = settings.desktopWidgetInstances !== undefined ? settings.desktopWidgetInstances : []
        desktopCpuTempOpacity = settings.desktopCpuTempOpacity !== undefined ? settings.desktopCpuTempOpacity : 0.9
        desktopGpuTempOpacity = settings.desktopGpuTempOpacity !== undefined ? settings.desktopGpuTempOpacity : 0.9
        desktopSystemMonitorOpacity = settings.desktopSystemMonitorOpacity !== undefined ? settings.desktopSystemMonitorOpacity : 0.9
        desktopSystemMonitorCustomGpuName = settings.desktopSystemMonitorCustomGpuName !== undefined ? settings.desktopSystemMonitorCustomGpuName : ""
        desktopSystemMonitorCustomCpuName = settings.desktopSystemMonitorCustomCpuName !== undefined ? settings.desktopSystemMonitorCustomCpuName : ""
        desktopClockOpacity = settings.desktopClockOpacity !== undefined ? settings.desktopClockOpacity : 0.9
        desktopClockBackgroundOpacity = settings.desktopClockBackgroundOpacity !== undefined ? settings.desktopClockBackgroundOpacity : 0.9
        desktopWeatherOpacity = settings.desktopWeatherOpacity !== undefined ? settings.desktopWeatherOpacity : 0.9
        desktopTerminalOpacity = settings.desktopTerminalOpacity !== undefined ? settings.desktopTerminalOpacity : 0.9
        desktopWidgetBorderOpacity = settings.desktopWidgetBorderOpacity !== undefined ? settings.desktopWidgetBorderOpacity : 0.3
        desktopWidgetBorderThickness = settings.desktopWidgetBorderThickness !== undefined ? settings.desktopWidgetBorderThickness : 1
        desktopWidgetWidth = settings.desktopWidgetWidth !== undefined ? settings.desktopWidgetWidth : 180
        desktopWidgetHeight = settings.desktopWidgetHeight !== undefined ? settings.desktopWidgetHeight : 80
        desktopWidgetFontSize = settings.desktopWidgetFontSize !== undefined ? settings.desktopWidgetFontSize : 14
        desktopWidgetIconSize = settings.desktopWidgetIconSize !== undefined ? settings.desktopWidgetIconSize : 20
        desktopSystemMonitorWidth = settings.desktopSystemMonitorWidth !== undefined ? settings.desktopSystemMonitorWidth : 320
        desktopSystemMonitorHeight = settings.desktopSystemMonitorHeight !== undefined ? settings.desktopSystemMonitorHeight : 200
        desktopWeatherWidth = settings.desktopWeatherWidth !== undefined ? settings.desktopWeatherWidth : 400
        desktopWeatherHeight = settings.desktopWeatherHeight !== undefined ? settings.desktopWeatherHeight : 500
        desktopWeatherFontSize = settings.desktopWeatherFontSize !== undefined ? settings.desktopWeatherFontSize : 20
        desktopTerminalWidth = settings.desktopTerminalWidth !== undefined ? settings.desktopTerminalWidth : 600
        desktopTerminalHeight = settings.desktopTerminalHeight !== undefined ? settings.desktopTerminalHeight : 400
        desktopTerminalFontSize = settings.desktopTerminalFontSize !== undefined ? settings.desktopTerminalFontSize : 12
        desktopDarkDashWidth = settings.desktopDarkDashWidth !== undefined ? settings.desktopDarkDashWidth : 700
        desktopDarkDashHeight = settings.desktopDarkDashHeight !== undefined ? settings.desktopDarkDashHeight : 500
        desktopWeatherIconSize = settings.desktopWeatherIconSize !== undefined ? settings.desktopWeatherIconSize : 24
        desktopWeatherSpacing = settings.desktopWeatherSpacing !== undefined ? settings.desktopWeatherSpacing : 8
        desktopWeatherPadding = settings.desktopWeatherPadding !== undefined ? settings.desktopWeatherPadding : 16
        desktopWeatherBorderRadius = settings.desktopWeatherBorderRadius !== undefined ? settings.desktopWeatherBorderRadius : 8
        desktopWeatherCurrentTempSize = settings.desktopWeatherCurrentTempSize !== undefined ? settings.desktopWeatherCurrentTempSize : 2.0
        desktopWeatherCitySize = settings.desktopWeatherCitySize !== undefined ? settings.desktopWeatherCitySize : 2.0
        desktopWeatherDetailsSize = settings.desktopWeatherDetailsSize !== undefined ? settings.desktopWeatherDetailsSize : 1.2
        desktopWeatherForecastSize = settings.desktopWeatherForecastSize !== undefined ? settings.desktopWeatherForecastSize : 1.2
        desktopGpuSelection = settings.desktopGpuSelection !== undefined ? settings.desktopGpuSelection : "auto"
                dockTransparency = settings.dockTransparency !== undefined ? (settings.dockTransparency > 1 ? settings.dockTransparency / 100 : settings.dockTransparency) : 1
                
                dockBorderEnabled = settings.dockBorderEnabled !== undefined ? settings.dockBorderEnabled : false
                dockBorderWidth = settings.dockBorderWidth !== undefined ? settings.dockBorderWidth : 2
                dockBorderRadius = settings.dockBorderRadius !== undefined ? settings.dockBorderRadius : 8
                dockRadius = settings.dockRadius !== undefined ? settings.dockRadius : 12
                dockBorderRed = settings.dockBorderRed !== undefined ? settings.dockBorderRed : 0.0
                dockBorderGreen = settings.dockBorderGreen !== undefined ? settings.dockBorderGreen : 0.0
                dockBorderBlue = settings.dockBorderBlue !== undefined ? settings.dockBorderBlue : 0.0
                dockBorderAlpha = settings.dockBorderAlpha !== undefined ? settings.dockBorderAlpha : 1.0
                dockDynamicBorderColors = settings.dockDynamicBorderColors !== undefined ? settings.dockDynamicBorderColors : false
                
                topBarBorderEnabled = settings.topBarBorderEnabled !== undefined ? settings.topBarBorderEnabled : false
                topBarDynamicBorderColors = settings.topBarDynamicBorderColors !== undefined ? settings.topBarDynamicBorderColors : false
                
                taskBarBorderEnabled = settings.taskBarBorderEnabled !== undefined ? settings.taskBarBorderEnabled : false
                taskBarBorderWidth = settings.taskBarBorderWidth !== undefined ? settings.taskBarBorderWidth : 2
                taskBarBorderRadius = settings.taskBarBorderRadius !== undefined ? settings.taskBarBorderRadius : 8
                taskBarBorderRed = settings.taskBarBorderRed !== undefined ? settings.taskBarBorderRed : 0.0
                taskBarBorderGreen = settings.taskBarBorderGreen !== undefined ? settings.taskBarBorderGreen : 0.0
                taskBarBorderBlue = settings.taskBarBorderBlue !== undefined ? settings.taskBarBorderBlue : 0.0
                taskBarBorderAlpha = settings.taskBarBorderAlpha !== undefined ? settings.taskBarBorderAlpha : 1.0
                taskBarDynamicBorderColors = settings.taskBarDynamicBorderColors !== undefined ? settings.taskBarDynamicBorderColors : false
                taskBarBorderTop = settings.taskBarBorderTop !== undefined ? settings.taskBarBorderTop : true
                taskBarBorderLeft = settings.taskBarBorderLeft !== undefined ? settings.taskBarBorderLeft : true
                taskBarBorderRight = settings.taskBarBorderRight !== undefined ? settings.taskBarBorderRight : true
                taskBarBorderBottom = settings.taskBarBorderBottom !== undefined ? settings.taskBarBorderBottom : true
                taskBarBorderBottomLeftInset = settings.taskBarBorderBottomLeftInset !== undefined ? settings.taskBarBorderBottomLeftInset : 1
                taskBarBorderBottomRightInset = settings.taskBarBorderBottomRightInset !== undefined ? settings.taskBarBorderBottomRightInset : 1
                
                topBarBorderWidth = settings.topBarBorderWidth !== undefined ? settings.topBarBorderWidth : 2
                topBarBorderRadius = settings.topBarBorderRadius !== undefined ? settings.topBarBorderRadius : 8
                topBarBorderRed = settings.topBarBorderRed !== undefined ? settings.topBarBorderRed : 0.0
                topBarBorderGreen = settings.topBarBorderGreen !== undefined ? settings.topBarBorderGreen : 0.0
                topBarBorderBlue = settings.topBarBorderBlue !== undefined ? settings.topBarBorderBlue : 0.0
                topBarBorderAlpha = settings.topBarBorderAlpha !== undefined ? settings.topBarBorderAlpha : 1.0
                topBarBorderTop = settings.topBarBorderTop !== undefined ? settings.topBarBorderTop : true
                topBarBorderLeft = settings.topBarBorderLeft !== undefined ? settings.topBarBorderLeft : true
                topBarBorderRight = settings.topBarBorderRight !== undefined ? settings.topBarBorderRight : true
                topBarBorderBottom = settings.topBarBorderBottom !== undefined ? settings.topBarBorderBottom : true
                topBarBorderBottomLeftInset = settings.topBarBorderBottomLeftInset !== undefined ? settings.topBarBorderBottomLeftInset : 1
                topBarBorderBottomRightInset = settings.topBarBorderBottomRightInset !== undefined ? settings.topBarBorderBottomRightInset : 1
                topBarFloat = settings.topBarFloat !== undefined ? settings.topBarFloat : false
                topBarRoundedCorners = settings.topBarRoundedCorners !== undefined ? settings.topBarRoundedCorners : false
                topBarCornerRadius = settings.topBarCornerRadius !== undefined ? settings.topBarCornerRadius : 12
                topBarLeftMargin = settings.topBarLeftMargin !== undefined ? settings.topBarLeftMargin : 0
                topBarRightMargin = settings.topBarRightMargin !== undefined ? settings.topBarRightMargin : 0
                topBarTopMargin = settings.topBarTopMargin !== undefined ? settings.topBarTopMargin : 0
                topBarHeight = settings.topBarHeight !== undefined ? settings.topBarHeight : 40
                topBarPosition = settings.topBarPosition !== undefined ? settings.topBarPosition : "top"
                taskBarHeight = settings.taskBarHeight !== undefined ? settings.taskBarHeight : 54
                taskBarTransparency = settings.taskBarTransparency !== undefined ? (settings.taskBarTransparency > 1 ? settings.taskBarTransparency / 100 : settings.taskBarTransparency) : 0.5
                taskBarPinnedAppsPosition = settings.taskBarPinnedAppsPosition !== undefined ? settings.taskBarPinnedAppsPosition : "left"
                taskBarIconSize = settings.taskBarIconSize !== undefined ? settings.taskBarIconSize : 39
                taskBarIconSpacing = settings.taskBarIconSpacing !== undefined ? settings.taskBarIconSpacing : 0
                taskBarFloat = settings.taskBarFloat !== undefined ? settings.taskBarFloat : false
                taskBarRoundedCorners = settings.taskBarRoundedCorners !== undefined ? settings.taskBarRoundedCorners : false
                taskBarCornerRadius = settings.taskBarCornerRadius !== undefined ? settings.taskBarCornerRadius : 32
                taskBarBottomMargin = settings.taskBarBottomMargin !== undefined ? settings.taskBarBottomMargin : 3
                taskBarExclusiveZone = settings.taskBarExclusiveZone !== undefined ? settings.taskBarExclusiveZone : 56
                taskBarLeftPadding = settings.taskBarLeftPadding !== undefined ? settings.taskBarLeftPadding : 0
                taskBarRightPadding = settings.taskBarRightPadding !== undefined ? settings.taskBarRightPadding : 0
                taskBarTopPadding = settings.taskBarTopPadding !== undefined ? settings.taskBarTopPadding : 0
                taskBarBottomPadding = settings.taskBarBottomPadding !== undefined ? settings.taskBarBottomPadding : 0
                taskBarAutoHide = settings.taskBarAutoHide !== undefined ? settings.taskBarAutoHide : true
                taskBarVisible = settings.taskBarVisible !== undefined ? settings.taskBarVisible : true
                taskBarGroupApps = settings.taskBarGroupApps !== undefined ? settings.taskBarGroupApps : true
                use24HourClock = settings.use24HourClock !== undefined ? settings.use24HourClock : true
                showAmPmIn24Hour = settings.showAmPmIn24Hour !== undefined ? settings.showAmPmIn24Hour : false
                clockStackedFormat = settings.clockStackedFormat !== undefined ? settings.clockStackedFormat : false
                clockBoldFont = settings.clockBoldFont !== undefined ? settings.clockBoldFont : false
                dockClockShowFullDate = settings.dockClockShowFullDate !== undefined ? settings.dockClockShowFullDate : false
                dockClockShowSeconds = settings.dockClockShowSeconds !== undefined ? settings.dockClockShowSeconds : false
                dockClockUse12Hour = settings.dockClockUse12Hour !== undefined ? settings.dockClockUse12Hour : true
                dockClockShowAmPm = settings.dockClockShowAmPm !== undefined ? settings.dockClockShowAmPm : true
                dockClockFontSize = settings.dockClockFontSize !== undefined ? settings.dockClockFontSize : 1.0
                useFahrenheit = settings.useFahrenheit !== undefined ? settings.useFahrenheit : false
                nightModeEnabled = settings.nightModeEnabled !== undefined ? settings.nightModeEnabled : false
                weatherLocation = settings.weatherLocation !== undefined ? settings.weatherLocation : "New York, NY"
                weatherCoordinates = settings.weatherCoordinates !== undefined ? settings.weatherCoordinates : "40.7128,-74.0060"
                useAutoLocation = settings.useAutoLocation !== undefined ? settings.useAutoLocation : false
                weatherEnabled = settings.weatherEnabled !== undefined ? settings.weatherEnabled : true
                showLauncherButton = settings.showLauncherButton !== undefined ? settings.showLauncherButton : true
                showWorkspaceSwitcher = settings.showWorkspaceSwitcher !== undefined ? settings.showWorkspaceSwitcher : true
                showFocusedWindow = settings.showFocusedWindow !== undefined ? settings.showFocusedWindow : true
                showWeather = settings.showWeather !== undefined ? settings.showWeather : true
                showMusic = settings.showMusic !== undefined ? settings.showMusic : true
                showClipboard = settings.showClipboard !== undefined ? settings.showClipboard : true
                showCpuUsage = settings.showCpuUsage !== undefined ? settings.showCpuUsage : true
                showMemUsage = settings.showMemUsage !== undefined ? settings.showMemUsage : true
                showCpuTemp = settings.showCpuTemp !== undefined ? settings.showCpuTemp : true
                showGpuTemp = settings.showGpuTemp !== undefined ? settings.showGpuTemp : true
                selectedGpuIndex = settings.selectedGpuIndex !== undefined ? settings.selectedGpuIndex : 0
                enabledGpuPciIds = settings.enabledGpuPciIds !== undefined ? settings.enabledGpuPciIds : []
                showSystemTray = settings.showSystemTray !== undefined ? settings.showSystemTray : true
                showClock = settings.showClock !== undefined ? settings.showClock : true
                showNotificationButton = settings.showNotificationButton !== undefined ? settings.showNotificationButton : true
                showBattery = settings.showBattery !== undefined ? settings.showBattery : true
                showControlCenterButton = settings.showControlCenterButton !== undefined ? settings.showControlCenterButton : true
                controlCenterShowNetworkIcon = settings.controlCenterShowNetworkIcon !== undefined ? settings.controlCenterShowNetworkIcon : true
                controlCenterShowBluetoothIcon = settings.controlCenterShowBluetoothIcon !== undefined ? settings.controlCenterShowBluetoothIcon : true
                controlCenterShowAudioIcon = settings.controlCenterShowAudioIcon !== undefined ? settings.controlCenterShowAudioIcon : true
                controlCenterShowMicIcon = settings.controlCenterShowMicIcon !== undefined ? settings.controlCenterShowMicIcon : true
                controlCenterWidgets = settings.controlCenterWidgets !== undefined ? settings.controlCenterWidgets : [
                    {"id": "wifi", "enabled": true, "width": 50},
                    {"id": "bluetooth", "enabled": true, "width": 50},
                    {"id": "audioOutput", "enabled": true, "width": 50},
                    {"id": "audioInput", "enabled": true, "width": 50},
                    {"id": "volumeMixer", "enabled": true, "width": 100},
                    {"id": "performance", "enabled": true, "width": 50},
                    {"id": "darkMode", "enabled": true, "width": 50}
                ]
                showWorkspaceIndex = settings.showWorkspaceIndex !== undefined ? settings.showWorkspaceIndex : false
                showWorkspacePadding = settings.showWorkspacePadding !== undefined ? settings.showWorkspacePadding : false
                showWorkspaceApps = settings.showWorkspaceApps !== undefined ? settings.showWorkspaceApps : false
                maxWorkspaceIcons = settings.maxWorkspaceIcons !== undefined ? settings.maxWorkspaceIcons : 3
                maxWorkspaces = settings.maxWorkspaces !== undefined ? settings.maxWorkspaces : 10
                workspaceNameIcons = settings.workspaceNameIcons !== undefined ? settings.workspaceNameIcons : ({})
                workspacesPerMonitor = settings.workspacesPerMonitor !== undefined ? settings.workspacesPerMonitor : true
                waveProgressEnabled = settings.waveProgressEnabled !== undefined ? settings.waveProgressEnabled : true
                clockCompactMode = settings.clockCompactMode !== undefined ? settings.clockCompactMode : false
                focusedWindowCompactMode = settings.focusedWindowCompactMode !== undefined ? settings.focusedWindowCompactMode : false
                runningAppsCompactMode = settings.runningAppsCompactMode !== undefined ? settings.runningAppsCompactMode : true
                runningAppsCurrentWorkspace = settings.runningAppsCurrentWorkspace !== undefined ? settings.runningAppsCurrentWorkspace : false
                clockDateFormat = settings.clockDateFormat !== undefined ? settings.clockDateFormat : ""
                lockDateFormat = settings.lockDateFormat !== undefined ? settings.lockDateFormat : ""
                firstDayOfWeek = settings.firstDayOfWeek !== undefined ? settings.firstDayOfWeek : 1
                weekNumbering = settings.weekNumbering !== undefined ? settings.weekNumbering : "ISO"
                systemTimezone = settings.systemTimezone !== undefined ? settings.systemTimezone : ""
                mediaSize = settings.mediaSize !== undefined ? settings.mediaSize : (settings.mediaCompactMode !== undefined ? (settings.mediaCompactMode ? 0 : 1) : 1)
                mediaScrollEnabled = settings.mediaScrollEnabled !== undefined ? settings.mediaScrollEnabled : true
                if (settings.topBarWidgetOrder) {
                    topBarLeftWidgets = settings.topBarWidgetOrder.filter(w => {
                                                                              return ["launcherButton", "workspaceSwitcher", "focusedWindow"].includes(w)
                                                                          })
                    topBarCenterWidgets = settings.topBarWidgetOrder.filter(w => {
                                                                                return ["clock", "music", "weather"].includes(w)
                                                                            })
                    topBarRightWidgets = settings.topBarWidgetOrder.filter(w => {
                                                                               return ["systemTray", "clipboard", "systemResources", "notificationButton", "battery", "controlCenterButton"].includes(w)
                                                                           })
                } else {
                    var leftWidgets = settings.topBarLeftWidgets !== undefined ? settings.topBarLeftWidgets : []
                    var centerWidgets = settings.topBarCenterWidgets !== undefined ? settings.topBarCenterWidgets : []
                    var rightWidgets = settings.topBarRightWidgets !== undefined ? settings.topBarRightWidgets : []
                    
                    // Initialize defaults for new users with empty widget arrays
                    if (leftWidgets.length === 0 && centerWidgets.length === 0 && rightWidgets.length === 0) {
                        leftWidgets = ["launcherButton"]
                        centerWidgets = ["workspaceSwitcher"]
                        rightWidgets = ["systemTray", "weather", "clock", "notificationButton", "controlCenterButton", "systemUpdate"]
                    }
                    
                    topBarLeftWidgets = leftWidgets
                    topBarCenterWidgets = centerWidgets
                    topBarRightWidgets = rightWidgets
                    updateListModel(leftWidgetsModel, leftWidgets)
                    updateListModel(centerWidgetsModel, centerWidgets)
                    updateListModel(rightWidgetsModel, rightWidgets)
                }
                
                dockLeftWidgets = settings.dockLeftWidgets !== undefined ? settings.dockLeftWidgets : []
                dockCenterWidgets = settings.dockCenterWidgets !== undefined ? settings.dockCenterWidgets : []
                dockRightWidgets = settings.dockRightWidgets !== undefined ? settings.dockRightWidgets : []
                if (settings.dockCenterWidgets === undefined) {
                    dockCenterWidgets = [{"id": "launchpad", "enabled": true}, {"id": "pinnedApps", "enabled": true}, {"id": "trash", "enabled": true}]
                }
                updateListModel(dockLeftWidgetsModel, dockLeftWidgets)
                updateListModel(dockCenterWidgetsModel, dockCenterWidgets)
                updateListModel(dockRightWidgetsModel, dockRightWidgets)
                
                taskBarLeftWidgets = settings.taskBarLeftWidgets !== undefined ? settings.taskBarLeftWidgets : []
                taskBarCenterWidgets = settings.taskBarCenterWidgets !== undefined ? settings.taskBarCenterWidgets : []
                taskBarRightWidgets = settings.taskBarRightWidgets !== undefined ? settings.taskBarRightWidgets : []
                
                // Initialize defaults for task bar widgets if empty
                if (taskBarLeftWidgets.length === 0 && taskBarCenterWidgets.length === 0 && taskBarRightWidgets.length === 0) {
                    // Set default taskbar widget configuration
                    taskBarLeftWidgets = ["launcherButton", {"id": "workspaceSwitcher", "enabled": true}]
                    taskBarCenterWidgets = [{"id": "pinnedApps", "enabled": true}, {"id": "trash", "enabled": true}]
                    taskBarRightWidgets = ["systemTray", "weather", "clock", "notificationButton", "controlCenterButton", "systemUpdate"]
                }
                
                updateListModel(taskBarLeftWidgetsModel, taskBarLeftWidgets)
                updateListModel(taskBarCenterWidgetsModel, taskBarCenterWidgets)
                updateListModel(taskBarRightWidgetsModel, taskBarRightWidgets)
                
                notificationCenterPosition = settings.notificationCenterPosition !== undefined ? settings.notificationCenterPosition : "top-right"
                clipboardPosition = settings.clipboardPosition !== undefined ? settings.clipboardPosition : "bottom-right"
                
                startMenuXOffset = settings.startMenuXOffset !== undefined ? settings.startMenuXOffset : 0.0
                startMenuYOffset = settings.startMenuYOffset !== undefined ? settings.startMenuYOffset : 0.0
                controlCenterXOffset = settings.controlCenterXOffset !== undefined ? settings.controlCenterXOffset : 0.0
                controlCenterYOffset = settings.controlCenterYOffset !== undefined ? settings.controlCenterYOffset : 0.0
                darkDashXOffset = settings.darkDashXOffset !== undefined ? settings.darkDashXOffset : 0.0
                darkDashYOffset = settings.darkDashYOffset !== undefined ? settings.darkDashYOffset : 0.0
                applicationsXOffset = settings.applicationsXOffset !== undefined ? settings.applicationsXOffset : 0.0
                applicationsYOffset = settings.applicationsYOffset !== undefined ? settings.applicationsYOffset : 0.0
                
                appLauncherViewMode = settings.appLauncherViewMode !== undefined ? settings.appLauncherViewMode : "list"
                spotlightModalViewMode = settings.spotlightModalViewMode !== undefined ? settings.spotlightModalViewMode : "list"
                networkPreference = settings.networkPreference !== undefined ? settings.networkPreference : "auto"
                iconTheme = settings.iconTheme !== undefined ? settings.iconTheme : "System Default"
                gtkTheme = settings.gtkTheme !== undefined ? settings.gtkTheme : "System Default"
                qtTheme = settings.qtTheme !== undefined ? settings.qtTheme : "System Default"
                shellTheme = settings.shellTheme !== undefined ? settings.shellTheme : "System Default"
                cursorTheme = settings.cursorTheme !== undefined ? settings.cursorTheme : "System Default"
                cursorSize = settings.cursorSize !== undefined ? settings.cursorSize : 24
                useOSLogo = settings.useOSLogo !== undefined ? settings.useOSLogo : false
                osLogoColorOverride = settings.osLogoColorOverride !== undefined ? settings.osLogoColorOverride : ""
                osLogoBrightness = settings.osLogoBrightness !== undefined ? settings.osLogoBrightness : 0.5
                osLogoContrast = settings.osLogoContrast !== undefined ? settings.osLogoContrast : 1
                useCustomLauncherImage = settings.useCustomLauncherImage !== undefined ? settings.useCustomLauncherImage : false
                customLauncherImagePath = settings.customLauncherImagePath !== undefined ? settings.customLauncherImagePath : ""
                keybindsPath = settings.keybindsPath !== undefined ? settings.keybindsPath : ""
                launcherLogoSize = settings.launcherLogoSize !== undefined ? settings.launcherLogoSize : 24
                launcherPosition = settings.launcherPosition !== undefined ? settings.launcherPosition : "bottom-center"
                wallpaperDynamicTheming = settings.wallpaperDynamicTheming !== undefined ? settings.wallpaperDynamicTheming : true
                fontFamily = settings.fontFamily !== undefined ? settings.fontFamily : defaultFontFamily
                monoFontFamily = settings.monoFontFamily !== undefined ? settings.monoFontFamily : defaultMonoFontFamily
                fontWeight = settings.fontWeight !== undefined ? settings.fontWeight : Font.Normal
                fontScale = settings.fontScale !== undefined ? settings.fontScale : 1.0
                fontLetterSpacing = 0.0
                fontWordSpacing = 0.0
                fontLineHeight = settings.fontLineHeight !== undefined ? settings.fontLineHeight : 1.2
                fontCapitalization = settings.fontCapitalization !== undefined ? settings.fontCapitalization : Font.MixedCase
                fontStretch = settings.fontStretch !== undefined ? settings.fontStretch : Font.NormalStretch
                fontItalic = settings.fontItalic !== undefined ? settings.fontItalic : false
                fontUnderline = settings.fontUnderline !== undefined ? settings.fontUnderline : false
                fontStrikeout = settings.fontStrikeout !== undefined ? settings.fontStrikeout : false
                fontHintingPreference = settings.fontHintingPreference !== undefined ? settings.fontHintingPreference : Font.PreferDefaultHinting
                fontRenderType = settings.fontRenderType !== undefined ? settings.fontRenderType : Text.QtRendering
                fontAntialiasing = settings.fontAntialiasing !== undefined ? settings.fontAntialiasing : true
                settingsUiScale = settings.settingsUiScale !== undefined ? settings.settingsUiScale : 1.0
                settingsUiAdvancedScaling = settings.settingsUiAdvancedScaling !== undefined ? settings.settingsUiAdvancedScaling : false
                settingsUiWindowScale = settings.settingsUiWindowScale !== undefined ? settings.settingsUiWindowScale : 1.0
                settingsUiControlScale = settings.settingsUiControlScale !== undefined ? settings.settingsUiControlScale : 1.0
                settingsUiIconScale = settings.settingsUiIconScale !== undefined ? settings.settingsUiIconScale : 1.0
                notepadUseMonospace = settings.notepadUseMonospace !== undefined ? settings.notepadUseMonospace : true
                notepadFontFamily = settings.notepadFontFamily !== undefined ? settings.notepadFontFamily : ""
                notepadFontSize = settings.notepadFontSize !== undefined ? settings.notepadFontSize : 14
                notepadShowLineNumbers = settings.notepadShowLineNumbers !== undefined ? settings.notepadShowLineNumbers : false
                notepadTransparencyOverride = settings.notepadTransparencyOverride !== undefined ? settings.notepadTransparencyOverride : -1
                notepadLastCustomTransparency = settings.notepadLastCustomTransparency !== undefined ? settings.notepadLastCustomTransparency : 0.95
                terminalEmulator = settings.terminalEmulator !== undefined ? settings.terminalEmulator : ""
                aurHelper = settings.aurHelper !== undefined ? settings.aurHelper : ""
                gtkThemingEnabled = settings.gtkThemingEnabled !== undefined ? settings.gtkThemingEnabled : false
                qtThemingEnabled = settings.qtThemingEnabled !== undefined ? settings.qtThemingEnabled : false
                hyprlandThemingEnabled = settings.hyprlandThemingEnabled !== undefined ? settings.hyprlandThemingEnabled : true
                showDock = settings.showDock !== undefined ? settings.showDock : false
                dockWidgetsEnabled = settings.dockWidgetsEnabled !== undefined ? settings.dockWidgetsEnabled : false
                dockAutoHide = settings.dockAutoHide !== undefined ? settings.dockAutoHide : false
                dockGroupApps = settings.dockGroupApps !== undefined ? settings.dockGroupApps : true
                dockHideOnGames = settings.dockHideOnGames !== undefined ? settings.dockHideOnGames : true
                dockExpandToScreen = settings.dockExpandToScreen !== undefined ? settings.dockExpandToScreen : false
                dockCenterApps = settings.dockCenterApps !== undefined ? settings.dockCenterApps : false
                dockBottomGap = settings.dockBottomGap !== undefined ? settings.dockBottomGap : 1
                dockExclusiveZone = settings.dockExclusiveZone !== undefined ? settings.dockExclusiveZone : 65
                dockUseDynamicZones = settings.dockUseDynamicZones !== undefined ? settings.dockUseDynamicZones : false
                dockLeftPadding = settings.dockLeftPadding !== undefined ? settings.dockLeftPadding : 0
                dockRightPadding = settings.dockRightPadding !== undefined ? settings.dockRightPadding : 0
                dockTopPadding = settings.dockTopPadding !== undefined ? settings.dockTopPadding : 0
                dockBottomPadding = settings.dockBottomPadding !== undefined ? settings.dockBottomPadding : 0
                dockTooltipsEnabled = settings.dockTooltipsEnabled !== undefined ? settings.dockTooltipsEnabled : true
                dockScale = settings.dockScale !== undefined ? settings.dockScale : 1.0
                dockIconSize = settings.dockIconSize !== undefined ? settings.dockIconSize : 40
                dockIconSpacing = settings.dockIconSpacing !== undefined ? settings.dockIconSpacing : 2
                dockPinnedAppsIconSize = settings.dockPinnedAppsIconSize !== undefined ? settings.dockPinnedAppsIconSize : dockIconSize
                dockPinnedAppsIconSpacing = settings.dockPinnedAppsIconSpacing !== undefined ? settings.dockPinnedAppsIconSpacing : dockIconSpacing
                dockPinnedAppsPillEnabled = settings.dockPinnedAppsPillEnabled !== undefined ? settings.dockPinnedAppsPillEnabled : false
                dockTrashPillEnabled = settings.dockTrashPillEnabled !== undefined ? settings.dockTrashPillEnabled : false
                dockLaunchpadPillEnabled = settings.dockLaunchpadPillEnabled !== undefined ? settings.dockLaunchpadPillEnabled : false
                taskbarScale = settings.taskbarScale !== undefined ? settings.taskbarScale : 1.0
                taskbarIconSize = settings.taskbarIconSize !== undefined ? settings.taskbarIconSize : 30
                taskbarIconSpacing = settings.taskbarIconSpacing !== undefined ? settings.taskbarIconSpacing : 2
                topbarScale = settings.topbarScale !== undefined ? settings.topbarScale : 1.0
                topbarIconSize = settings.topbarIconSize !== undefined ? settings.topbarIconSize : 24
                topbarIconSpacing = settings.topbarIconSpacing !== undefined ? settings.topbarIconSpacing : 2
                dockWidgetAreaOpacity = settings.dockWidgetAreaOpacity !== undefined ? (settings.dockWidgetAreaOpacity > 1 ? settings.dockWidgetAreaOpacity / 100 : settings.dockWidgetAreaOpacity) : 0.30
                dockBackgroundTintOpacity = settings.dockBackgroundTintOpacity !== undefined ? (settings.dockBackgroundTintOpacity > 1 ? settings.dockBackgroundTintOpacity / 100 : settings.dockBackgroundTintOpacity) : 0.04
                dockCollapsedHeight = settings.dockCollapsedHeight !== undefined ? settings.dockCollapsedHeight : 20
                dockSlideDistance = settings.dockSlideDistance !== undefined ? settings.dockSlideDistance : 60
                dockAnimationDuration = settings.dockAnimationDuration !== undefined ? settings.dockAnimationDuration : 200
                dockLeftWidgetAreaMinWidth = settings.dockLeftWidgetAreaMinWidth !== undefined ? settings.dockLeftWidgetAreaMinWidth : 60
                dockRightWidgetAreaMinWidth = settings.dockRightWidgetAreaMinWidth !== undefined ? settings.dockRightWidgetAreaMinWidth : 40
                cornerRadius = settings.cornerRadius !== undefined ? settings.cornerRadius : 32
                notificationOverlayEnabled = settings.notificationOverlayEnabled !== undefined ? settings.notificationOverlayEnabled : false
                hyprlandBlurSize = settings.hyprlandBlurSize !== undefined ? settings.hyprlandBlurSize : 2
                hyprlandBlurPasses = settings.hyprlandBlurPasses !== undefined ? settings.hyprlandBlurPasses : 2
                hyprlandBorderSize = settings.hyprlandBorderSize !== undefined ? settings.hyprlandBorderSize : 4
                hyprlandBorderHue = settings.hyprlandBorderHue !== undefined ? settings.hyprlandBorderHue : 0.0
                hyprlandBorderAlpha = settings.hyprlandBorderAlpha !== undefined ? settings.hyprlandBorderAlpha : 1.0
                hyprlandDecorationRounding = settings.hyprlandDecorationRounding !== undefined ? settings.hyprlandDecorationRounding : 10
                hyprlandDecorationRoundingPower = settings.hyprlandDecorationRoundingPower !== undefined ? settings.hyprlandDecorationRoundingPower : 15
                hyprlandDecorationBlurEnabled = settings.hyprlandDecorationBlurEnabled !== undefined ? settings.hyprlandDecorationBlurEnabled : true
                hyprlandDecorationBlurXray = settings.hyprlandDecorationBlurXray !== undefined ? settings.hyprlandDecorationBlurXray : true
                hyprlandDecorationBlurSpecial = settings.hyprlandDecorationBlurSpecial !== undefined ? settings.hyprlandDecorationBlurSpecial : true
                hyprlandDecorationBlurNewOptimizations = settings.hyprlandDecorationBlurNewOptimizations !== undefined ? settings.hyprlandDecorationBlurNewOptimizations : true
                hyprlandDecorationBlurIgnoreOpacity = settings.hyprlandDecorationBlurIgnoreOpacity !== undefined ? settings.hyprlandDecorationBlurIgnoreOpacity : true
                hyprlandDecorationBlurSize = settings.hyprlandDecorationBlurSize !== undefined ? settings.hyprlandDecorationBlurSize : 1
                hyprlandDecorationBlurPasses = settings.hyprlandDecorationBlurPasses !== undefined ? settings.hyprlandDecorationBlurPasses : 5
                hyprlandDecorationBlurBrightness = settings.hyprlandDecorationBlurBrightness !== undefined ? settings.hyprlandDecorationBlurBrightness : 0.2
                hyprlandDecorationBlurBrightnessEnabled = settings.hyprlandDecorationBlurBrightnessEnabled !== undefined ? settings.hyprlandDecorationBlurBrightnessEnabled : true
                hyprlandDecorationBlurNoise = settings.hyprlandDecorationBlurNoise !== undefined ? settings.hyprlandDecorationBlurNoise : 0.01
                hyprlandDecorationBlurContrast = settings.hyprlandDecorationBlurContrast !== undefined ? settings.hyprlandDecorationBlurContrast : 0
                hyprlandDecorationBlurContrastEnabled = settings.hyprlandDecorationBlurContrastEnabled !== undefined ? settings.hyprlandDecorationBlurContrastEnabled : true
                hyprlandDecorationBlurVibrancy = settings.hyprlandDecorationBlurVibrancy !== undefined ? settings.hyprlandDecorationBlurVibrancy : 0.1696
                hyprlandDecorationBlurVibrancyDarkness = settings.hyprlandDecorationBlurVibrancyDarkness !== undefined ? settings.hyprlandDecorationBlurVibrancyDarkness : 0.0
                hyprlandDecorationBlurPopups = settings.hyprlandDecorationBlurPopups !== undefined ? settings.hyprlandDecorationBlurPopups : true
                hyprlandDecorationBlurPopupsIgnorealpha = settings.hyprlandDecorationBlurPopupsIgnorealpha !== undefined ? settings.hyprlandDecorationBlurPopupsIgnorealpha : 0.6
                hyprlandDecorationBlurInputMethods = settings.hyprlandDecorationBlurInputMethods !== undefined ? settings.hyprlandDecorationBlurInputMethods : false
                hyprlandDecorationBlurInputMethodsIgnorealpha = settings.hyprlandDecorationBlurInputMethodsIgnorealpha !== undefined ? settings.hyprlandDecorationBlurInputMethodsIgnorealpha : 0.2
                hyprlandDecorationShadowEnabled = settings.hyprlandDecorationShadowEnabled !== undefined ? settings.hyprlandDecorationShadowEnabled : false
                hyprlandDecorationShadowIgnoreWindow = settings.hyprlandDecorationShadowIgnoreWindow !== undefined ? settings.hyprlandDecorationShadowIgnoreWindow : true
                hyprlandDecorationShadowRange = settings.hyprlandDecorationShadowRange !== undefined ? settings.hyprlandDecorationShadowRange : 12
                hyprlandDecorationShadowOffset = settings.hyprlandDecorationShadowOffset !== undefined ? settings.hyprlandDecorationShadowOffset : "0 2"
                hyprlandDecorationShadowRenderPower = settings.hyprlandDecorationShadowRenderPower !== undefined ? settings.hyprlandDecorationShadowRenderPower : 2
                hyprlandDecorationShadowColor = settings.hyprlandDecorationShadowColor !== undefined ? settings.hyprlandDecorationShadowColor : "rgba(0000002A)"
                hyprlandDecorationDimInactive = settings.hyprlandDecorationDimInactive !== undefined ? settings.hyprlandDecorationDimInactive : false
                hyprlandDecorationDimStrength = settings.hyprlandDecorationDimStrength !== undefined ? settings.hyprlandDecorationDimStrength : 0.0
                hyprlandDecorationDimSpecial = settings.hyprlandDecorationDimSpecial !== undefined ? settings.hyprlandDecorationDimSpecial : 0
                hyprlandInputKbLayout = settings.hyprlandInputKbLayout !== undefined ? settings.hyprlandInputKbLayout : ""
                hyprlandInputKbVariant = settings.hyprlandInputKbVariant !== undefined ? settings.hyprlandInputKbVariant : ""
                hyprlandInputKbModel = settings.hyprlandInputKbModel !== undefined ? settings.hyprlandInputKbModel : ""
                hyprlandInputKbOptions = settings.hyprlandInputKbOptions !== undefined ? settings.hyprlandInputKbOptions : ""
                hyprlandInputKbRules = settings.hyprlandInputKbRules !== undefined ? settings.hyprlandInputKbRules : ""
                hyprlandInputRepeatRate = settings.hyprlandInputRepeatRate !== undefined ? settings.hyprlandInputRepeatRate : 25
                hyprlandInputRepeatDelay = settings.hyprlandInputRepeatDelay !== undefined ? settings.hyprlandInputRepeatDelay : 600
                hyprlandInputNumlockByDefault = settings.hyprlandInputNumlockByDefault !== undefined ? settings.hyprlandInputNumlockByDefault : false
                hyprlandInputFollowMouse = settings.hyprlandInputFollowMouse !== undefined ? settings.hyprlandInputFollowMouse : 1
                hyprlandInputFollowMouseThreshold = settings.hyprlandInputFollowMouseThreshold !== undefined ? settings.hyprlandInputFollowMouseThreshold : 0
                hyprlandInputSensitivity = settings.hyprlandInputSensitivity !== undefined ? settings.hyprlandInputSensitivity : 0.0
                hyprlandInputAccelProfile = settings.hyprlandInputAccelProfile !== undefined ? settings.hyprlandInputAccelProfile : "adaptive"
                hyprlandInputNaturalScroll = settings.hyprlandInputNaturalScroll !== undefined ? settings.hyprlandInputNaturalScroll : false
                hyprlandInputLeftHanded = settings.hyprlandInputLeftHanded !== undefined ? settings.hyprlandInputLeftHanded : false
                hyprlandInputDeviceRotations = settings.hyprlandInputDeviceRotations !== undefined ? settings.hyprlandInputDeviceRotations : ({})
                hyprlandRenderNewScheduling = settings.hyprlandRenderNewScheduling !== undefined ? settings.hyprlandRenderNewScheduling : true
                hyprlandRenderCmFsPassthrough = settings.hyprlandRenderCmFsPassthrough !== undefined ? settings.hyprlandRenderCmFsPassthrough : 1
                hyprlandRenderCmEnabled = settings.hyprlandRenderCmEnabled !== undefined ? settings.hyprlandRenderCmEnabled : true
                hyprlandRenderSendContentType = settings.hyprlandRenderSendContentType !== undefined ? settings.hyprlandRenderSendContentType : true
                hyprlandRenderCmAutoHdr = settings.hyprlandRenderCmAutoHdr !== undefined ? settings.hyprlandRenderCmAutoHdr : true
                hyprlandRenderDirectScanout = settings.hyprlandRenderDirectScanout !== undefined ? settings.hyprlandRenderDirectScanout : 2
                hyprlandRenderExpandUndersizedTextures = settings.hyprlandRenderExpandUndersizedTextures !== undefined ? settings.hyprlandRenderExpandUndersizedTextures : true
                hyprlandGeneralGapsIn = settings.hyprlandGeneralGapsIn !== undefined ? settings.hyprlandGeneralGapsIn : 0
                hyprlandGeneralGapsOut = settings.hyprlandGeneralGapsOut !== undefined ? settings.hyprlandGeneralGapsOut : 0
                hyprlandGeneralGapsWorkspaces = settings.hyprlandGeneralGapsWorkspaces !== undefined ? settings.hyprlandGeneralGapsWorkspaces : 0
                hyprlandGeneralBorderSize = settings.hyprlandGeneralBorderSize !== undefined ? settings.hyprlandGeneralBorderSize : 3
                hyprlandGeneralResizeOnBorder = settings.hyprlandGeneralResizeOnBorder !== undefined ? settings.hyprlandGeneralResizeOnBorder : true
                hyprlandGeneralNoFocusFallback = settings.hyprlandGeneralNoFocusFallback !== undefined ? settings.hyprlandGeneralNoFocusFallback : true
                hyprlandGeneralAllowTearing = settings.hyprlandGeneralAllowTearing !== undefined ? settings.hyprlandGeneralAllowTearing : true
                hyprlandSnapEnabled = settings.hyprlandSnapEnabled !== undefined ? settings.hyprlandSnapEnabled : true
                hyprlandSnapWindowGap = settings.hyprlandSnapWindowGap !== undefined ? settings.hyprlandSnapWindowGap : 10
                hyprlandSnapMonitorGap = settings.hyprlandSnapMonitorGap !== undefined ? settings.hyprlandSnapMonitorGap : 10
                hyprlandSnapBorderOverlap = settings.hyprlandSnapBorderOverlap !== undefined ? settings.hyprlandSnapBorderOverlap : false
                hyprlandSnapRespectGaps = settings.hyprlandSnapRespectGaps !== undefined ? settings.hyprlandSnapRespectGaps : false
                hyprlandGroupbarEnabled = settings.hyprlandGroupbarEnabled !== undefined ? settings.hyprlandGroupbarEnabled : true
                hyprlandGroupbarColActive = settings.hyprlandGroupbarColActive !== undefined ? settings.hyprlandGroupbarColActive : "rgba(2d2d2dFF) rgba(1a1a1aFF) 45deg"
                hyprlandGroupbarColInactive = settings.hyprlandGroupbarColInactive !== undefined ? settings.hyprlandGroupbarColInactive : "rgba(1a1a1aFF)"
                hyprlandGroupbarHeight = settings.hyprlandGroupbarHeight !== undefined ? settings.hyprlandGroupbarHeight : 32
                hyprlandGroupbarPriority = settings.hyprlandGroupbarPriority !== undefined ? settings.hyprlandGroupbarPriority : 3
                hyprlandGroupbarRenderTitles = settings.hyprlandGroupbarRenderTitles !== undefined ? settings.hyprlandGroupbarRenderTitles : true
                hyprlandGroupbarFontFamily = settings.hyprlandGroupbarFontFamily !== undefined ? settings.hyprlandGroupbarFontFamily : "Inter Variable, Inter, Roboto, Ubuntu, Noto Sans, sans-serif"
                hyprlandGroupbarFontSize = settings.hyprlandGroupbarFontSize !== undefined ? settings.hyprlandGroupbarFontSize : 13
                hyprlandGroupbarGradients = settings.hyprlandGroupbarGradients !== undefined ? settings.hyprlandGroupbarGradients : true
                hyprlandGroupbarTextColor = settings.hyprlandGroupbarTextColor !== undefined ? settings.hyprlandGroupbarTextColor : "rgba(e0e0e0FF)"
                hyprlandGroupbarRounding = settings.hyprlandGroupbarRounding !== undefined ? settings.hyprlandGroupbarRounding : 8
                hyprlandDwindlePreserveSplit = settings.hyprlandDwindlePreserveSplit !== undefined ? settings.hyprlandDwindlePreserveSplit : true
                hyprlandDwindleSmartSplit = settings.hyprlandDwindleSmartSplit !== undefined ? settings.hyprlandDwindleSmartSplit : false
                hyprlandDwindleSmartResizing = settings.hyprlandDwindleSmartResizing !== undefined ? settings.hyprlandDwindleSmartResizing : false
                hyprlandCursorNoHardwareCursors = settings.hyprlandCursorNoHardwareCursors !== undefined ? settings.hyprlandCursorNoHardwareCursors : 2
                hyprlandCursorNoBreakFsVrr = settings.hyprlandCursorNoBreakFsVrr !== undefined ? settings.hyprlandCursorNoBreakFsVrr : 2
                hyprlandCursorMinRefreshRate = settings.hyprlandCursorMinRefreshRate !== undefined ? settings.hyprlandCursorMinRefreshRate : 24
                hyprlandCursorHotspotPadding = settings.hyprlandCursorHotspotPadding !== undefined ? settings.hyprlandCursorHotspotPadding : 1
                hyprlandCursorInactiveTimeout = settings.hyprlandCursorInactiveTimeout !== undefined ? settings.hyprlandCursorInactiveTimeout : 0
                hyprlandCursorNoWarps = settings.hyprlandCursorNoWarps !== undefined ? settings.hyprlandCursorNoWarps : false
                hyprlandCursorPersistentWarps = settings.hyprlandCursorPersistentWarps !== undefined ? settings.hyprlandCursorPersistentWarps : false
                hyprlandCursorWarpOnChangeWorkspace = settings.hyprlandCursorWarpOnChangeWorkspace !== undefined ? settings.hyprlandCursorWarpOnChangeWorkspace : 0
                hyprlandCursorWarpOnToggleSpecial = settings.hyprlandCursorWarpOnToggleSpecial !== undefined ? settings.hyprlandCursorWarpOnToggleSpecial : 0
                hyprlandCursorDefaultMonitor = settings.hyprlandCursorDefaultMonitor !== undefined ? settings.hyprlandCursorDefaultMonitor : ""
                hyprlandCursorZoomFactor = settings.hyprlandCursorZoomFactor !== undefined ? settings.hyprlandCursorZoomFactor : 1.0
                hyprlandCursorZoomRigid = settings.hyprlandCursorZoomRigid !== undefined ? settings.hyprlandCursorZoomRigid : false
                hyprlandCursorZoomDetachedCamera = settings.hyprlandCursorZoomDetachedCamera !== undefined ? settings.hyprlandCursorZoomDetachedCamera : true
                hyprlandCursorEnableHyprcursor = settings.hyprlandCursorEnableHyprcursor !== undefined ? settings.hyprlandCursorEnableHyprcursor : true
                hyprlandCursorHideOnKeyPress = settings.hyprlandCursorHideOnKeyPress !== undefined ? settings.hyprlandCursorHideOnKeyPress : false
                hyprlandCursorHideOnTouch = settings.hyprlandCursorHideOnTouch !== undefined ? settings.hyprlandCursorHideOnTouch : true
                hyprlandCursorHideOnTablet = settings.hyprlandCursorHideOnTablet !== undefined ? settings.hyprlandCursorHideOnTablet : true
                hyprlandCursorUseCpuBuffer = settings.hyprlandCursorUseCpuBuffer !== undefined ? settings.hyprlandCursorUseCpuBuffer : 2
                hyprlandCursorWarpBackAfterNonMouseInput = settings.hyprlandCursorWarpBackAfterNonMouseInput !== undefined ? settings.hyprlandCursorWarpBackAfterNonMouseInput : false
                hyprlandCursorZoomDisableAa = settings.hyprlandCursorZoomDisableAa !== undefined ? settings.hyprlandCursorZoomDisableAa : false
                topBarAutoHide = settings.topBarAutoHide !== undefined ? settings.topBarAutoHide : false
                topBarOpenOnOverview = settings.topBarOpenOnOverview !== undefined ? settings.topBarOpenOnOverview : false
                topBarVisible = settings.topBarVisible !== undefined ? settings.topBarVisible : false
                notificationTimeoutLow = settings.notificationTimeoutLow !== undefined ? settings.notificationTimeoutLow : 5000
                notificationTimeoutNormal = settings.notificationTimeoutNormal !== undefined ? settings.notificationTimeoutNormal : 5000
                notificationTimeoutCritical = settings.notificationTimeoutCritical !== undefined ? settings.notificationTimeoutCritical : 0
                topBarSpacing = settings.topBarSpacing !== undefined ? settings.topBarSpacing : 4
                topBarBottomGap = settings.topBarBottomGap !== undefined ? settings.topBarBottomGap : 0
                topBarInnerPadding = settings.topBarInnerPadding !== undefined ? settings.topBarInnerPadding : 8
                topBarSquareCorners = settings.topBarSquareCorners !== undefined ? settings.topBarSquareCorners : false
                topBarNoBackground = settings.topBarNoBackground !== undefined ? settings.topBarNoBackground : true
                topBarGothCornersEnabled = settings.topBarGothCornersEnabled !== undefined ? settings.topBarGothCornersEnabled : false
                lockScreenShowPowerActions = settings.lockScreenShowPowerActions !== undefined ? settings.lockScreenShowPowerActions : true
                hideBrightnessSlider = settings.hideBrightnessSlider !== undefined ? settings.hideBrightnessSlider : false
                widgetBackgroundColor = settings.widgetBackgroundColor !== undefined ? settings.widgetBackgroundColor : "sth"
                screenPreferences = settings.screenPreferences !== undefined ? settings.screenPreferences : ({})
                applyStoredTheme()
                detectAvailableIconThemes()
                detectQtTools()
                updateGtkIconTheme(iconTheme)
                applyStoredIconTheme()
                applyStoredGtkTheme()
                applyStoredQtTheme()
                applyStoredShellTheme()
                applyStoredCursorTheme()
            } else {
                applyStoredTheme()
            }
        } catch (e) {
            applyStoredTheme()
        } finally {
            _loading = false
        }
    }

    function saveSettings() {
        if (_loading) {
            return
        }
        settingsFile.setText(JSON.stringify({
                                                "currentThemeName": currentThemeName,
                                                "customThemeFile": customThemeFile,
                                                "savedColorThemes": savedColorThemes,
                                                "currentColorTheme": currentColorTheme,
                                                "colorVibrance": colorVibrance,
                                                "extractedColorTextOverrideEnabled": extractedColorTextOverrideEnabled,
                                                "extractedColorTextR": extractedColorTextR,
                                                "extractedColorTextG": extractedColorTextG,
                                                "extractedColorTextB": extractedColorTextB,
                                                "savedTextColorPresets": savedTextColorPresets,
                                                "topBarTransparency": topBarTransparency,
                                                "topBarWidgetTransparency": topBarWidgetTransparency,
                                                "popupTransparency": popupTransparency,
                                                "modalTransparency": modalTransparency,
                                                "settingsModalDimmingEnabled": settingsModalDimmingEnabled,
                                                "notificationTransparency": notificationTransparency,
                                                "controlCenterTransparency": controlCenterTransparency,
                                                "appDrawerTransparency": appDrawerTransparency,
                                                "controlCenterWidgetBackgroundOpacity": controlCenterWidgetBackgroundOpacity,
                                                "controlCenterBorderOpacity": controlCenterBorderOpacity,
                                                "controlCenterBorderThickness": controlCenterBorderThickness,
                                                "settingsBorderOpacity": settingsBorderOpacity,
                                                "settingsBorderThickness": settingsBorderThickness,
                                                "settingsBrightness": settingsBrightness,
                                                "settingsContrast": settingsContrast,
                                                "settingsWhiteBalance": settingsWhiteBalance,
                                                "settingsHighlights": settingsHighlights,
                                                "audioRoutesOutput": audioRoutesOutput,
                                                "audioRoutesInput": audioRoutesInput,
                                                "launcherLogoRed": launcherLogoRed,
                                                "launcherLogoGreen": launcherLogoGreen,
                                                "launcherLogoBlue": launcherLogoBlue,
                                                "launcherLogoAutoSync": launcherLogoAutoSync,
                                                "darkDashTransparency": darkDashTransparency,
                                                "darkDashBorderOpacity": darkDashBorderOpacity,
                                                "darkDashBorderThickness": darkDashBorderThickness,
                                                "darkDashTabBarOpacity": darkDashTabBarOpacity,
                                                "darkDashContentBackgroundOpacity": darkDashContentBackgroundOpacity,
                                                "darkDashAnimatedTintOpacity": darkDashAnimatedTintOpacity,
                                                "darkDashTintAnimateEnabled": darkDashTintAnimateEnabled,
                                                "desktopDarkDashTransparency": desktopDarkDashTransparency,
                                                "desktopDarkDashBorderOpacity": desktopDarkDashBorderOpacity,
                                                "desktopDarkDashBorderThickness": desktopDarkDashBorderThickness,
                                                "desktopDarkDashTabBarOpacity": desktopDarkDashTabBarOpacity,
                                                "desktopDarkDashContentBackgroundOpacity": desktopDarkDashContentBackgroundOpacity,
                                                "desktopDarkDashAnimatedTintOpacity": desktopDarkDashAnimatedTintOpacity,
                                                "systemIconTinting": systemIconTinting,
                                                "iconTintIntensity": iconTintIntensity,
                                                "settingsWindowWidth": settingsWindowWidth,
                                                "settingsWindowHeight": settingsWindowHeight,
                                                "settingsWindowX": settingsWindowX,
                                                "settingsWindowY": settingsWindowY,
                                                "desktopWidgetsEnabled": desktopWidgetsEnabled,
                                                "desktopIconsEnabled": desktopIconsEnabled,
                                                "desktopCpuTempEnabled": desktopCpuTempEnabled,
                                                "desktopGpuTempEnabled": desktopGpuTempEnabled,
                                                "desktopSystemMonitorEnabled": desktopSystemMonitorEnabled,
                                                "desktopClockEnabled": desktopClockEnabled,
                                                "desktopWeatherEnabled": desktopWeatherEnabled,
                                                "desktopTerminalEnabled": desktopTerminalEnabled,
                                                "desktopDarkDashEnabled": desktopDarkDashEnabled,
            "desktopWidgetsDisplay": desktopWidgetsDisplay,
            "desktopWidgetsPosition": desktopWidgetsPosition,
            "desktopCpuTempPosition": desktopCpuTempPosition,
            "desktopGpuTempPosition": desktopGpuTempPosition,
            "desktopSystemMonitorPosition": desktopSystemMonitorPosition,
            "desktopClockPosition": desktopClockPosition,
            "desktopWeatherPosition": desktopWeatherPosition,
            "desktopTerminalPosition": desktopTerminalPosition,
            "desktopDarkDashPosition": desktopDarkDashPosition,
            "desktopWidgetPositions": desktopWidgetPositions,
            "desktopWidgetGridSettings": desktopWidgetGridSettings,
            "desktopWidgetInstances": desktopWidgetInstances,
            "desktopCpuTempOpacity": desktopCpuTempOpacity,
            "desktopGpuTempOpacity": desktopGpuTempOpacity,
                                                "desktopSystemMonitorOpacity": desktopSystemMonitorOpacity,
                                                "desktopSystemMonitorCustomGpuName": desktopSystemMonitorCustomGpuName,
                                                "desktopSystemMonitorCustomCpuName": desktopSystemMonitorCustomCpuName,
            "desktopClockOpacity": desktopClockOpacity,
            "desktopClockBackgroundOpacity": desktopClockBackgroundOpacity,
            "desktopWeatherOpacity": desktopWeatherOpacity,
            "desktopTerminalOpacity": desktopTerminalOpacity,
            "desktopWidgetBorderOpacity": desktopWidgetBorderOpacity,
            "desktopWidgetBorderThickness": desktopWidgetBorderThickness,
            "desktopWidgetWidth": desktopWidgetWidth,
            "desktopWidgetHeight": desktopWidgetHeight,
            "desktopWidgetFontSize": desktopWidgetFontSize,
            "desktopWidgetIconSize": desktopWidgetIconSize,
            "desktopSystemMonitorWidth": desktopSystemMonitorWidth,
            "desktopSystemMonitorHeight": desktopSystemMonitorHeight,
            "desktopWeatherWidth": desktopWeatherWidth,
            "desktopWeatherHeight": desktopWeatherHeight,
            "desktopWeatherFontSize": desktopWeatherFontSize,
            "desktopWeatherIconSize": desktopWeatherIconSize,
            "desktopTerminalWidth": desktopTerminalWidth,
            "desktopTerminalHeight": desktopTerminalHeight,
            "desktopTerminalFontSize": desktopTerminalFontSize,
            "desktopDarkDashWidth": desktopDarkDashWidth,
            "desktopDarkDashHeight": desktopDarkDashHeight,
            "desktopWeatherSpacing": desktopWeatherSpacing,
            "desktopWeatherPadding": desktopWeatherPadding,
            "desktopWeatherBorderRadius": desktopWeatherBorderRadius,
            "desktopWeatherCurrentTempSize": desktopWeatherCurrentTempSize,
            "desktopWeatherCitySize": desktopWeatherCitySize,
            "desktopWeatherDetailsSize": desktopWeatherDetailsSize,
            "desktopWeatherForecastSize": desktopWeatherForecastSize,
            "desktopGpuSelection": desktopGpuSelection,
                                                "dockTransparency": dockTransparency,
                                                "dockWidgetAreaOpacity": dockWidgetAreaOpacity,
                                                "dockBackgroundTintOpacity": dockBackgroundTintOpacity,
                                                "dockCollapsedHeight": dockCollapsedHeight,
                                                "dockSlideDistance": dockSlideDistance,
                                                "dockAnimationDuration": dockAnimationDuration,
                                                "dockLeftWidgetAreaMinWidth": dockLeftWidgetAreaMinWidth,
                                                "dockRightWidgetAreaMinWidth": dockRightWidgetAreaMinWidth,
                                                "dockBorderEnabled": dockBorderEnabled,
                                                "dockBorderWidth": dockBorderWidth,
                                                "dockBorderRadius": dockBorderRadius,
                                                "dockRadius": dockRadius,
                                                "dockBorderRed": dockBorderRed,
                                                "dockBorderGreen": dockBorderGreen,
                                                "dockBorderBlue": dockBorderBlue,
                                                "dockBorderAlpha": dockBorderAlpha,
                                                "dockDynamicBorderColors": dockDynamicBorderColors,
                                                "topBarBorderEnabled": topBarBorderEnabled,
                                                "topBarDynamicBorderColors": topBarDynamicBorderColors,
                                                "taskBarBorderEnabled": taskBarBorderEnabled,
                                                "taskBarBorderWidth": taskBarBorderWidth,
                                                "taskBarBorderRadius": taskBarBorderRadius,
                                                "taskBarBorderRed": taskBarBorderRed,
                                                "taskBarBorderGreen": taskBarBorderGreen,
                                                "taskBarBorderBlue": taskBarBorderBlue,
                                                "taskBarBorderAlpha": taskBarBorderAlpha,
                                                "taskBarDynamicBorderColors": taskBarDynamicBorderColors,
                                                "taskBarBorderTop": taskBarBorderTop,
                                                "taskBarBorderLeft": taskBarBorderLeft,
                                                "taskBarBorderRight": taskBarBorderRight,
                                                "taskBarBorderBottom": taskBarBorderBottom,
                                                "taskBarBorderBottomLeftInset": taskBarBorderBottomLeftInset,
                                                "taskBarBorderBottomRightInset": taskBarBorderBottomRightInset,
                                                
                                                "topBarBorderWidth": topBarBorderWidth,
                                                "topBarBorderRadius": topBarBorderRadius,
                                                "topBarBorderRed": topBarBorderRed,
                                                "topBarBorderGreen": topBarBorderGreen,
                                                "topBarBorderBlue": topBarBorderBlue,
                                                "topBarBorderAlpha": topBarBorderAlpha,
                                                "topBarBorderTop": topBarBorderTop,
                                                "topBarBorderLeft": topBarBorderLeft,
                                                "topBarBorderRight": topBarBorderRight,
                                                "topBarBorderBottom": topBarBorderBottom,
                                                "topBarBorderBottomLeftInset": topBarBorderBottomLeftInset,
                                                "topBarBorderBottomRightInset": topBarBorderBottomRightInset,
                                                "topBarFloat": topBarFloat,
                                                "topBarRoundedCorners": topBarRoundedCorners,
                                                "topBarCornerRadius": topBarCornerRadius,
                                                "topBarLeftMargin": topBarLeftMargin,
                                                "topBarRightMargin": topBarRightMargin,
                                                "topBarTopMargin": topBarTopMargin,
                                                "topBarHeight": topBarHeight,
                                                "topBarPosition": topBarPosition,
                                                "taskBarHeight": taskBarHeight,
                                                "taskBarTransparency": taskBarTransparency,
                                                "taskBarPinnedAppsPosition": taskBarPinnedAppsPosition,
                                                "taskBarIconSize": taskBarIconSize,
                                                "taskBarIconSpacing": taskBarIconSpacing,
                                                "taskBarFloat": taskBarFloat,
                                                "taskBarRoundedCorners": taskBarRoundedCorners,
                                                "taskBarCornerRadius": taskBarCornerRadius,
                                                "taskBarBottomMargin": taskBarBottomMargin,
                                                "taskBarExclusiveZone": taskBarExclusiveZone,
                                                "taskBarLeftPadding": taskBarLeftPadding,
                                                "taskBarRightPadding": taskBarRightPadding,
                                                "taskBarTopPadding": taskBarTopPadding,
                                                "taskBarBottomPadding": taskBarBottomPadding,
                                                "taskBarAutoHide": taskBarAutoHide,
                                                "taskBarVisible": taskBarVisible,
                                                "taskBarGroupApps": taskBarGroupApps,
                                                "use24HourClock": use24HourClock,
                                                "showAmPmIn24Hour": showAmPmIn24Hour,
                                                "clockStackedFormat": clockStackedFormat,
                                                "clockBoldFont": clockBoldFont,
                                                "dockClockShowFullDate": dockClockShowFullDate,
                                                "dockClockShowSeconds": dockClockShowSeconds,
                                                "dockClockUse12Hour": dockClockUse12Hour,
                                                "dockClockShowAmPm": dockClockShowAmPm,
                                                "dockClockFontSize": dockClockFontSize,
                                                "useFahrenheit": useFahrenheit,
                                                "nightModeEnabled": nightModeEnabled,
                                                "weatherLocation": weatherLocation,
                                                "weatherCoordinates": weatherCoordinates,
                                                "useAutoLocation": useAutoLocation,
                                                "weatherEnabled": weatherEnabled,
                                                "showLauncherButton": showLauncherButton,
                                                "showWorkspaceSwitcher": showWorkspaceSwitcher,
                                                "showFocusedWindow": showFocusedWindow,
                                                "showWeather": showWeather,
                                                "showMusic": showMusic,
                                                "showClipboard": showClipboard,
                                                "showCpuUsage": showCpuUsage,
                                                "showMemUsage": showMemUsage,
                                                "showCpuTemp": showCpuTemp,
                                                "showGpuTemp": showGpuTemp,
                                                "selectedGpuIndex": selectedGpuIndex,
                                                "enabledGpuPciIds": enabledGpuPciIds,
                                                "showSystemTray": showSystemTray,
                                                "showClock": showClock,
                                                "showNotificationButton": showNotificationButton,
                                                "showBattery": showBattery,
                                                "showControlCenterButton": showControlCenterButton,
                                                "controlCenterShowNetworkIcon": controlCenterShowNetworkIcon,
                                                "controlCenterShowBluetoothIcon": controlCenterShowBluetoothIcon,
                                                "controlCenterShowAudioIcon": controlCenterShowAudioIcon,
                                                "controlCenterWidgets": controlCenterWidgets,
                                                "showWorkspaceIndex": showWorkspaceIndex,
                                                "showWorkspacePadding": showWorkspacePadding,
                                                "showWorkspaceApps": showWorkspaceApps,
                                                "maxWorkspaceIcons": maxWorkspaceIcons,
                                                "maxWorkspaces": maxWorkspaces,
                                                "workspacesPerMonitor": workspacesPerMonitor,
                                                "workspaceNameIcons": workspaceNameIcons,
                                                "waveProgressEnabled": waveProgressEnabled,
                                                "clockCompactMode": clockCompactMode,
                                                "focusedWindowCompactMode": focusedWindowCompactMode,
                                                "runningAppsCompactMode": runningAppsCompactMode,
                                                "runningAppsCurrentWorkspace": runningAppsCurrentWorkspace,
                                                "clockDateFormat": clockDateFormat,
                                                "lockDateFormat": lockDateFormat,
                                                "firstDayOfWeek": firstDayOfWeek,
                                                "weekNumbering": weekNumbering,
                                                "systemTimezone": systemTimezone,
                                                "mediaSize": mediaSize,
                                                "mediaScrollEnabled": mediaScrollEnabled,
                                                "topBarLeftWidgets": topBarLeftWidgets,
                                                "topBarCenterWidgets": topBarCenterWidgets,
                                                "topBarRightWidgets": topBarRightWidgets,
                                                "dockLeftWidgets": dockLeftWidgets,
                                                "dockCenterWidgets": dockCenterWidgets,
                                                "dockRightWidgets": dockRightWidgets,
                                                "taskBarLeftWidgets": taskBarLeftWidgets,
                                                "taskBarCenterWidgets": taskBarCenterWidgets,
                                                "taskBarRightWidgets": taskBarRightWidgets,
                                                "notificationCenterPosition": notificationCenterPosition,
                                                "clipboardPosition": clipboardPosition,
                                                "startMenuXOffset": startMenuXOffset,
                                                "startMenuYOffset": startMenuYOffset,
                                                "controlCenterXOffset": controlCenterXOffset,
                                                "controlCenterYOffset": controlCenterYOffset,
                                                "darkDashXOffset": darkDashXOffset,
                                                "darkDashYOffset": darkDashYOffset,
                                                "applicationsXOffset": applicationsXOffset,
                                                "applicationsYOffset": applicationsYOffset,
                                                "appLauncherViewMode": appLauncherViewMode,
                                                "spotlightModalViewMode": spotlightModalViewMode,
                                                "networkPreference": networkPreference,
                                                "iconTheme": iconTheme,
                                                "gtkTheme": gtkTheme,
                                                "qtTheme": qtTheme,
                                                "shellTheme": shellTheme,
                                                "cursorTheme": cursorTheme,
                                                "cursorSize": cursorSize,
                                                "useOSLogo": useOSLogo,
                                                "osLogoColorOverride": osLogoColorOverride,
                                                "osLogoBrightness": osLogoBrightness,
                                                "osLogoContrast": osLogoContrast,
                                                "useCustomLauncherImage": useCustomLauncherImage,
                                                "customLauncherImagePath": customLauncherImagePath,
                                                "keybindsPath": keybindsPath,
                                                "launcherLogoSize": launcherLogoSize,
                                                "launcherPosition": launcherPosition,
                                                "wallpaperDynamicTheming": wallpaperDynamicTheming,
                                                "fontFamily": fontFamily,
                                                "monoFontFamily": monoFontFamily,
                                                "fontWeight": fontWeight,
                                                "fontScale": fontScale,
                                                "fontLetterSpacing": fontLetterSpacing,
                                                "fontWordSpacing": fontWordSpacing,
                                                "fontLineHeight": fontLineHeight,
                                                "fontCapitalization": fontCapitalization,
                                                "fontStretch": fontStretch,
                                                "fontItalic": fontItalic,
                                                "fontUnderline": fontUnderline,
                                                "fontStrikeout": fontStrikeout,
                                                "fontHintingPreference": fontHintingPreference,
                                                "fontRenderType": fontRenderType,
                                                "fontAntialiasing": fontAntialiasing,
                                                "settingsUiScale": settingsUiScale,
                                                "settingsUiAdvancedScaling": settingsUiAdvancedScaling,
                                                "settingsUiWindowScale": settingsUiWindowScale,
                                                "settingsUiControlScale": settingsUiControlScale,
                                                "settingsUiIconScale": settingsUiIconScale,
                                                "notepadUseMonospace": notepadUseMonospace,
                                                "notepadFontFamily": notepadFontFamily,
                                                "notepadFontSize": notepadFontSize,
                                                "notepadShowLineNumbers": notepadShowLineNumbers,
                                                "notepadTransparencyOverride": notepadTransparencyOverride,
                                                "notepadLastCustomTransparency": notepadLastCustomTransparency,
                                                "terminalEmulator": terminalEmulator,
                                                "aurHelper": aurHelper,
                                                "gtkThemingEnabled": gtkThemingEnabled,
                                                "qtThemingEnabled": qtThemingEnabled,
                                                "hyprlandThemingEnabled": hyprlandThemingEnabled,
                                                "showDock": showDock,
                                                "dockWidgetsEnabled": dockWidgetsEnabled,
                                                "dockAutoHide": dockAutoHide,
                                                "dockGroupApps": dockGroupApps,
                                                "dockHideOnGames": dockHideOnGames,
                                                "dockExpandToScreen": dockExpandToScreen,
                                                "dockCenterApps": dockCenterApps,
                                                "dockBottomGap": dockBottomGap,
                                                "dockExclusiveZone": dockExclusiveZone,
                                                "dockUseDynamicZones": dockUseDynamicZones,
                                                "dockTooltipsEnabled": dockTooltipsEnabled,
                                                "dockScale": dockScale,
                                                "dockIconSize": dockIconSize,
                                                "dockIconSpacing": dockIconSpacing,
                                                "dockPinnedAppsIconSize": dockPinnedAppsIconSize,
                                                "dockPinnedAppsIconSpacing": dockPinnedAppsIconSpacing,
                                                "dockPinnedAppsPillEnabled": dockPinnedAppsPillEnabled,
                                                "dockTrashPillEnabled": dockTrashPillEnabled,
                                                "dockLaunchpadPillEnabled": dockLaunchpadPillEnabled,
                                                "taskbarScale": taskbarScale,
                                                "taskbarIconSize": taskbarIconSize,
                                                "taskbarIconSpacing": taskbarIconSpacing,
                                                "topbarScale": topbarScale,
                                                "topbarIconSize": topbarIconSize,
                                                "topbarIconSpacing": topbarIconSpacing,
                                                "cornerRadius": cornerRadius,
                                                "notificationOverlayEnabled": notificationOverlayEnabled,
                                                "hyprlandBlurSize": hyprlandBlurSize,
                                                "hyprlandBlurPasses": hyprlandBlurPasses,
                                                "hyprlandBorderSize": hyprlandBorderSize,
                                                "hyprlandBorderHue": hyprlandBorderHue,
                                                "hyprlandBorderAlpha": hyprlandBorderAlpha,
                                                "hyprlandDecorationRounding": hyprlandDecorationRounding,
                                                "hyprlandDecorationRoundingPower": hyprlandDecorationRoundingPower,
                                                "hyprlandDecorationBlurEnabled": hyprlandDecorationBlurEnabled,
                                                "hyprlandDecorationBlurXray": hyprlandDecorationBlurXray,
                                                "hyprlandDecorationBlurSpecial": hyprlandDecorationBlurSpecial,
                                                "hyprlandDecorationBlurNewOptimizations": hyprlandDecorationBlurNewOptimizations,
                                                "hyprlandDecorationBlurIgnoreOpacity": hyprlandDecorationBlurIgnoreOpacity,
                                                "hyprlandDecorationBlurSize": hyprlandDecorationBlurSize,
                                                "hyprlandDecorationBlurPasses": hyprlandDecorationBlurPasses,
                                                "hyprlandDecorationBlurBrightness": hyprlandDecorationBlurBrightness,
                                                "hyprlandDecorationBlurBrightnessEnabled": hyprlandDecorationBlurBrightnessEnabled,
                                                "hyprlandDecorationBlurNoise": hyprlandDecorationBlurNoise,
                                                "hyprlandDecorationBlurContrast": hyprlandDecorationBlurContrast,
                                                "hyprlandDecorationBlurContrastEnabled": hyprlandDecorationBlurContrastEnabled,
                                                "hyprlandDecorationBlurVibrancy": hyprlandDecorationBlurVibrancy,
                                                "hyprlandDecorationBlurVibrancyDarkness": hyprlandDecorationBlurVibrancyDarkness,
                                                "hyprlandDecorationBlurPopups": hyprlandDecorationBlurPopups,
                                                "hyprlandDecorationBlurPopupsIgnorealpha": hyprlandDecorationBlurPopupsIgnorealpha,
                                                "hyprlandDecorationBlurInputMethods": hyprlandDecorationBlurInputMethods,
                                                "hyprlandDecorationBlurInputMethodsIgnorealpha": hyprlandDecorationBlurInputMethodsIgnorealpha,
                                                "hyprlandDecorationShadowEnabled": hyprlandDecorationShadowEnabled,
                                                "hyprlandDecorationShadowIgnoreWindow": hyprlandDecorationShadowIgnoreWindow,
                                                "hyprlandDecorationShadowRange": hyprlandDecorationShadowRange,
                                                "hyprlandDecorationShadowOffset": hyprlandDecorationShadowOffset,
                                                "hyprlandDecorationShadowRenderPower": hyprlandDecorationShadowRenderPower,
                                                "hyprlandDecorationShadowColor": hyprlandDecorationShadowColor,
                                                "hyprlandDecorationDimInactive": hyprlandDecorationDimInactive,
                                                "hyprlandDecorationDimStrength": hyprlandDecorationDimStrength,
                                                "hyprlandDecorationDimSpecial": hyprlandDecorationDimSpecial,
                                                "hyprlandInputKbLayout": hyprlandInputKbLayout,
                                                "hyprlandInputKbVariant": hyprlandInputKbVariant,
                                                "hyprlandInputKbModel": hyprlandInputKbModel,
                                                "hyprlandInputKbOptions": hyprlandInputKbOptions,
                                                "hyprlandInputKbRules": hyprlandInputKbRules,
                                                "hyprlandInputRepeatRate": hyprlandInputRepeatRate,
                                                "hyprlandInputRepeatDelay": hyprlandInputRepeatDelay,
                                                "hyprlandInputNumlockByDefault": hyprlandInputNumlockByDefault,
                                                "hyprlandInputFollowMouse": hyprlandInputFollowMouse,
                                                "hyprlandInputFollowMouseThreshold": hyprlandInputFollowMouseThreshold,
                                                "hyprlandInputSensitivity": hyprlandInputSensitivity,
                                                "hyprlandInputAccelProfile": hyprlandInputAccelProfile,
                                                "hyprlandInputNaturalScroll": hyprlandInputNaturalScroll,
                                                "hyprlandInputLeftHanded": hyprlandInputLeftHanded,
                                                "hyprlandInputDeviceRotations": hyprlandInputDeviceRotations,
                                                "hyprlandRenderNewScheduling": hyprlandRenderNewScheduling,
                                                "hyprlandRenderCmFsPassthrough": hyprlandRenderCmFsPassthrough,
                                                "hyprlandRenderCmEnabled": hyprlandRenderCmEnabled,
                                                "hyprlandRenderSendContentType": hyprlandRenderSendContentType,
                                                "hyprlandRenderCmAutoHdr": hyprlandRenderCmAutoHdr,
                                                "hyprlandRenderDirectScanout": hyprlandRenderDirectScanout,
                                                "hyprlandRenderExpandUndersizedTextures": hyprlandRenderExpandUndersizedTextures,
                                                "hyprlandGeneralGapsIn": hyprlandGeneralGapsIn,
                                                "hyprlandGeneralGapsOut": hyprlandGeneralGapsOut,
                                                "hyprlandGeneralGapsWorkspaces": hyprlandGeneralGapsWorkspaces,
                                                "hyprlandGeneralBorderSize": hyprlandGeneralBorderSize,
                                                "hyprlandGeneralResizeOnBorder": hyprlandGeneralResizeOnBorder,
                                                "hyprlandGeneralNoFocusFallback": hyprlandGeneralNoFocusFallback,
                                                "hyprlandGeneralAllowTearing": hyprlandGeneralAllowTearing,
                                                "hyprlandSnapEnabled": hyprlandSnapEnabled,
                                                "hyprlandSnapWindowGap": hyprlandSnapWindowGap,
                                                "hyprlandSnapMonitorGap": hyprlandSnapMonitorGap,
                                                "hyprlandSnapBorderOverlap": hyprlandSnapBorderOverlap,
                                                "hyprlandSnapRespectGaps": hyprlandSnapRespectGaps,
                                                "hyprlandGroupbarEnabled": hyprlandGroupbarEnabled,
                                                "hyprlandGroupbarColActive": hyprlandGroupbarColActive,
                                                "hyprlandGroupbarColInactive": hyprlandGroupbarColInactive,
                                                "hyprlandGroupbarHeight": hyprlandGroupbarHeight,
                                                "hyprlandGroupbarPriority": hyprlandGroupbarPriority,
                                                "hyprlandGroupbarRenderTitles": hyprlandGroupbarRenderTitles,
                                                "hyprlandGroupbarFontFamily": hyprlandGroupbarFontFamily,
                                                "hyprlandGroupbarFontSize": hyprlandGroupbarFontSize,
                                                "hyprlandGroupbarGradients": hyprlandGroupbarGradients,
                                                "hyprlandGroupbarTextColor": hyprlandGroupbarTextColor,
                                                "hyprlandGroupbarRounding": hyprlandGroupbarRounding,
                                                "hyprlandDwindlePreserveSplit": hyprlandDwindlePreserveSplit,
                                                "hyprlandDwindleSmartSplit": hyprlandDwindleSmartSplit,
                                                "hyprlandDwindleSmartResizing": hyprlandDwindleSmartResizing,
                                                "hyprlandCursorNoHardwareCursors": hyprlandCursorNoHardwareCursors,
                                                "hyprlandCursorNoBreakFsVrr": hyprlandCursorNoBreakFsVrr,
                                                "hyprlandCursorMinRefreshRate": hyprlandCursorMinRefreshRate,
                                                "hyprlandCursorHotspotPadding": hyprlandCursorHotspotPadding,
                                                "hyprlandCursorInactiveTimeout": hyprlandCursorInactiveTimeout,
                                                "hyprlandCursorNoWarps": hyprlandCursorNoWarps,
                                                "hyprlandCursorPersistentWarps": hyprlandCursorPersistentWarps,
                                                "hyprlandCursorWarpOnChangeWorkspace": hyprlandCursorWarpOnChangeWorkspace,
                                                "hyprlandCursorWarpOnToggleSpecial": hyprlandCursorWarpOnToggleSpecial,
                                                "hyprlandCursorDefaultMonitor": hyprlandCursorDefaultMonitor,
                                                "hyprlandCursorZoomFactor": hyprlandCursorZoomFactor,
                                                "hyprlandCursorZoomRigid": hyprlandCursorZoomRigid,
                                                "hyprlandCursorZoomDetachedCamera": hyprlandCursorZoomDetachedCamera,
                                                "hyprlandCursorEnableHyprcursor": hyprlandCursorEnableHyprcursor,
                                                "hyprlandCursorHideOnKeyPress": hyprlandCursorHideOnKeyPress,
                                                "hyprlandCursorHideOnTouch": hyprlandCursorHideOnTouch,
                                                "hyprlandCursorHideOnTablet": hyprlandCursorHideOnTablet,
                                                "hyprlandCursorUseCpuBuffer": hyprlandCursorUseCpuBuffer,
                                                "hyprlandCursorWarpBackAfterNonMouseInput": hyprlandCursorWarpBackAfterNonMouseInput,
                                                "hyprlandCursorZoomDisableAa": hyprlandCursorZoomDisableAa,
                                                "topBarAutoHide": topBarAutoHide,
                                                "topBarOpenOnOverview": topBarOpenOnOverview,
                                                "topBarVisible": topBarVisible,
                                                "topBarSpacing": topBarSpacing,
                                                "topBarBottomGap": topBarBottomGap,
                                                "topBarInnerPadding": topBarInnerPadding,
                                                "topBarSquareCorners": topBarSquareCorners,
                                                "topBarNoBackground": topBarNoBackground,
                                                "topBarGothCornersEnabled": topBarGothCornersEnabled,
                                                "lockScreenShowPowerActions": lockScreenShowPowerActions,
                                                "hideBrightnessSlider": hideBrightnessSlider,
                                                "widgetBackgroundColor": widgetBackgroundColor,
                                                "notificationTimeoutLow": notificationTimeoutLow,
                                                "notificationTimeoutNormal": notificationTimeoutNormal,
                                                "notificationTimeoutCritical": notificationTimeoutCritical,
                                                "screenPreferences": screenPreferences
                                            }, null, 2))
    }

    function setShowWorkspaceIndex(enabled) {
        showWorkspaceIndex = enabled
        saveSettings()
    }

    function setShowWorkspacePadding(enabled) {
        showWorkspacePadding = enabled
        saveSettings()
    }

    function setShowWorkspaceApps(enabled) {
        showWorkspaceApps = enabled
        saveSettings()
    }

    function setMaxWorkspaces(count) {
        maxWorkspaces = Math.max(1, Math.min(10, count))
        saveSettings()
    }

    function setMaxWorkspaceIcons(maxIcons) {
        maxWorkspaceIcons = maxIcons
        saveSettings()
    }

    function setWorkspacesPerMonitor(enabled) {
        workspacesPerMonitor = enabled
        saveSettings()
    }

    function setWaveProgressEnabled(enabled) {
        waveProgressEnabled = enabled
        saveSettings()
    }

    function setWorkspaceNameIcon(workspaceName, iconData) {
        var iconMap = JSON.parse(JSON.stringify(workspaceNameIcons))
        iconMap[workspaceName] = iconData
        workspaceNameIcons = iconMap
        saveSettings()
        workspaceIconsUpdated()
    }

    function removeWorkspaceNameIcon(workspaceName) {
        var iconMap = JSON.parse(JSON.stringify(workspaceNameIcons))
        delete iconMap[workspaceName]
        workspaceNameIcons = iconMap
        saveSettings()
        workspaceIconsUpdated()
    }

    function getWorkspaceNameIcon(workspaceName) {
        return workspaceNameIcons[workspaceName] || null
    }

    function hasNamedWorkspaces() {
        if (typeof NiriService === "undefined" || !CompositorService.isNiri)
            return false

        for (var i = 0; i < NiriService.allWorkspaces.length; i++) {
            var ws = NiriService.allWorkspaces[i]
            if (ws.name && ws.name.trim() !== "")
                return true
        }
        return false
    }

    function getNamedWorkspaces() {
        var namedWorkspaces = []
        if (typeof NiriService === "undefined" || !CompositorService.isNiri)
            return namedWorkspaces

        for (const ws of NiriService.allWorkspaces) {
            if (ws.name && ws.name.trim() !== "") {
                namedWorkspaces.push(ws.name)
            }
        }
        return namedWorkspaces
    }

    function setClockCompactMode(enabled) {
        clockCompactMode = enabled
        saveSettings()
    }

    function setFocusedWindowCompactMode(enabled) {
        focusedWindowCompactMode = enabled
        saveSettings()
    }

    function setRunningAppsCompactMode(enabled) {
        runningAppsCompactMode = enabled
        saveSettings()
    }

    function setRunningAppsCurrentWorkspace(enabled) {
        runningAppsCurrentWorkspace = enabled
        saveSettings()
    }

    function setClockDateFormat(format) {
        clockDateFormat = format || ""
        saveSettings()
    }

    function setLockDateFormat(format) {
        lockDateFormat = format || ""
        saveSettings()
    }

    function setFirstDayOfWeek(day) {
        firstDayOfWeek = day
        saveSettings()
    }

    function setWeekNumbering(mode) {
        weekNumbering = mode
        saveSettings()
    }

    function setSystemTimezone(timezone) {
        systemTimezone = timezone
        saveSettings()
    }

    function setMediaSize(size) {
        mediaSize = size
        saveSettings()
    }

    function setMediaScrollEnabled(enabled) {
        mediaScrollEnabled = enabled
        saveSettings()
    }

    function applyStoredTheme() {
        if (typeof Theme !== "undefined")
            Theme.switchTheme(currentThemeName, false)
        else
            Qt.callLater(() => {
                             if (typeof Theme !== "undefined")
                             Theme.switchTheme(currentThemeName, false)
                         })
    }

    function setTheme(themeName) {
        currentThemeName = themeName
        saveSettings()
    }

    function setCustomThemeFile(filePath) {
        customThemeFile = filePath
        saveSettings()
    }

    function setColorVibrance(vibrance) {
        colorVibrance = vibrance
        saveSettings()
    }
    
    function setExtractedColorTextOverrideEnabled(enabled) {
        extractedColorTextOverrideEnabled = enabled
        saveSettings()
    }

    function setExtractedColorTextR(value) {
        extractedColorTextR = value
        saveSettings()
        if (typeof ColorPaletteService !== 'undefined') {
            ColorPaletteService.textColorAdjustmentChanged()
            ColorPaletteService.updateCurrentThemeTextColors()
        }
    }
    
    function setExtractedColorTextG(value) {
        extractedColorTextG = value
        saveSettings()
        if (typeof ColorPaletteService !== 'undefined') {
            ColorPaletteService.textColorAdjustmentChanged()
            ColorPaletteService.updateCurrentThemeTextColors()
        }
    }
    
    function setExtractedColorTextB(value) {
        extractedColorTextB = value
        saveSettings()
        if (typeof ColorPaletteService !== 'undefined') {
            ColorPaletteService.textColorAdjustmentChanged()
            ColorPaletteService.updateCurrentThemeTextColors()
        }
    }
    
    function saveTextColorPreset(presetName) {
        const name = presetName || currentColorTheme || "Preset " + (savedTextColorPresets.length + 1)
        const themeName = currentColorTheme || ""
        

        savedTextColorPresets = savedTextColorPresets.filter(p => !(p.name === name && p.themeName === themeName))
        
        const preset = {
            name: name,
            r: extractedColorTextR,
            g: extractedColorTextG,
            b: extractedColorTextB,
            themeName: themeName
        }
        savedTextColorPresets.push(preset)
        saveSettings()
    }
    
    function loadTextColorPreset(presetName) {
        const preset = savedTextColorPresets.find(p => p.name === presetName)
        if (preset) {
            setExtractedColorTextR(preset.r)
            setExtractedColorTextG(preset.g)
            setExtractedColorTextB(preset.b)
            return true
        }
        return false
    }
    
    function loadTextColorFromTheme(themeName) {

        if (themeName && savedTextColorPresets.length > 0) {
            const themePreset = savedTextColorPresets.find(p => p.themeName === themeName)
            if (themePreset) {
                extractedColorTextR = themePreset.r
                extractedColorTextG = themePreset.g
                extractedColorTextB = themePreset.b
                if (typeof ColorPaletteService !== 'undefined') {
                    ColorPaletteService.textColorAdjustmentChanged()
                    ColorPaletteService.updateCurrentThemeTextColors()
                }
                return true
            }
        }
        return false
    }

    function setSavedColorThemes(themes) {
        savedColorThemes = themes
        saveSettings()
    }

    function setCurrentColorTheme(themeName) {
        currentColorTheme = themeName
        saveSettings()
    }

    function setTopBarTransparency(transparency) {
        topBarTransparency = transparency
        saveSettings()
    }

    function setTopBarWidgetTransparency(transparency) {
        topBarWidgetTransparency = transparency
        saveSettings()
    }

    function setPopupTransparency(transparency) {
        popupTransparency = transparency
        saveSettings()
    }

    function setModalTransparency(transparency) {
        modalTransparency = transparency
        saveSettings()
    }

    function setNotificationTransparency(transparency) {
        notificationTransparency = transparency
        saveSettings()
    }

    function setControlCenterTransparency(transparency) {
        controlCenterTransparency = transparency
        saveSettings()
    }

    function setAppDrawerTransparency(transparency) {
        appDrawerTransparency = transparency
        saveSettings()
    }

    function setControlCenterWidgetBackgroundOpacity(opacity) {
        controlCenterWidgetBackgroundOpacity = opacity
        saveSettings()
    }

    function setControlCenterBorderOpacity(opacity) {
        controlCenterBorderOpacity = opacity
        saveSettings()
    }

    function setControlCenterBorderThickness(thickness) {
        controlCenterBorderThickness = thickness
        saveSettings()
    }

    function setSettingsBorderOpacity(opacity) {
        settingsBorderOpacity = opacity
        saveSettings()
    }

    function setSettingsBorderThickness(thickness) {
        settingsBorderThickness = thickness
        saveSettings()
    }

    function setSettingsBrightness(value) {
        settingsBrightness = Math.max(0.6, Math.min(1.4, value))
        saveSettings()
    }

    function setSettingsContrast(value) {
        settingsContrast = Math.max(0.6, Math.min(1.4, value))
        saveSettings()
    }

    function setSettingsWhiteBalance(value) {
        settingsWhiteBalance = Math.max(0.8, Math.min(1.2, value))
        saveSettings()
    }

    function setSettingsHighlights(value) {
        settingsHighlights = Math.max(0.8, Math.min(1.2, value))
        saveSettings()
    }

    function setLauncherLogoRed(red) {
        launcherLogoRed = red
        saveSettings()
    }

    function setLauncherLogoGreen(green) {
        launcherLogoGreen = green
        saveSettings()
    }

    function setLauncherLogoBlue(blue) {
        launcherLogoBlue = blue
        saveSettings()
    }

    function setLauncherLogoAutoSync(enabled) {
        launcherLogoAutoSync = enabled
        saveSettings()
    }

    function syncLauncherLogoWithWallpaper() {
        if (launcherLogoAutoSync && typeof Theme !== 'undefined' && Theme.primary) {
            const primaryColor = Theme.primary
            if (Math.abs(launcherLogoRed - primaryColor.r) > 0.001 ||
                Math.abs(launcherLogoGreen - primaryColor.g) > 0.001 ||
                Math.abs(launcherLogoBlue - primaryColor.b) > 0.001) {
                launcherLogoRed = primaryColor.r
                launcherLogoGreen = primaryColor.g
                launcherLogoBlue = primaryColor.b
                saveSettings()
            }
        }
    }

    function setDarkDashTransparency(transparency) {
        darkDashTransparency = transparency
        saveSettings()
    }

    function setDarkDashBorderOpacity(opacity) {
        darkDashBorderOpacity = opacity
        saveSettings()
    }

    function setDarkDashBorderThickness(thickness) {
        darkDashBorderThickness = thickness
        saveSettings()
    }

    function setDarkDashTabBarOpacity(opacity) {
        darkDashTabBarOpacity = opacity
        saveSettings()
    }

    function setDarkDashContentBackgroundOpacity(opacity) {
        darkDashContentBackgroundOpacity = opacity
        saveSettings()
    }

    function setDarkDashAnimatedTintOpacity(opacity) {
        darkDashAnimatedTintOpacity = opacity
        saveSettings()
    }
    function setDarkDashTintAnimateEnabled(enabled) {
        darkDashTintAnimateEnabled = enabled
        saveSettings()
    }
    function setDesktopDarkDashTransparency(transparency) {
        desktopDarkDashTransparency = transparency
        saveSettings()
    }
    function setDesktopDarkDashBorderOpacity(opacity) {
        desktopDarkDashBorderOpacity = opacity
        saveSettings()
    }
    function setDesktopDarkDashBorderThickness(thickness) {
        desktopDarkDashBorderThickness = thickness
        saveSettings()
    }
    function setDesktopDarkDashTabBarOpacity(opacity) {
        desktopDarkDashTabBarOpacity = opacity
        saveSettings()
    }
    function setDesktopDarkDashContentBackgroundOpacity(opacity) {
        desktopDarkDashContentBackgroundOpacity = opacity
        saveSettings()
    }
    function setDesktopDarkDashAnimatedTintOpacity(opacity) {
        desktopDarkDashAnimatedTintOpacity = opacity
        saveSettings()
    }

    function setSystemIconTinting(enabled) {
        systemIconTinting = enabled
        saveSettings()
    }

    function setIconTintIntensity(intensity) {
        iconTintIntensity = Math.max(0.0, Math.min(1.0, intensity))
        saveSettings()
    }
    function setSettingsWindowWidth(width) {
        settingsWindowWidth = width
        saveSettings()
    }
    function setSettingsWindowHeight(height) {
        settingsWindowHeight = height
        saveSettings()
    }
    function setSettingsWindowX(x) {
        settingsWindowX = x
        saveSettings()
    }
    function setSettingsWindowY(y) {
        settingsWindowY = y
        saveSettings()
    }
    function setDesktopWidgetsEnabled(enabled) {
        desktopWidgetsEnabled = enabled
        saveSettings()
    }
    function setDesktopIconsEnabled(enabled) {
        desktopIconsEnabled = enabled
        saveSettings()
    }
    function setDesktopCpuTempEnabled(enabled) {
        desktopCpuTempEnabled = enabled
        saveSettings()
    }
    function setDesktopGpuTempEnabled(enabled) {
        desktopGpuTempEnabled = enabled
        saveSettings()
    }
    function setDesktopSystemMonitorEnabled(enabled) {
        desktopSystemMonitorEnabled = enabled
        saveSettings()
    }
    function setDesktopClockEnabled(enabled) {
        desktopClockEnabled = enabled
        saveSettings()
    }
    function setDesktopWidgetsDisplay(display) {
        desktopWidgetsDisplay = display
        saveSettings()
    }
    function setDesktopWidgetsPosition(position) {
        desktopWidgetsPosition = position
        saveSettings()
    }
    function setDesktopCpuTempPosition(position) {
        desktopCpuTempPosition = position
        saveSettings()
    }
    function setDesktopGpuTempPosition(position) {
        desktopGpuTempPosition = position
        saveSettings()
    }
    function setDesktopSystemMonitorPosition(position) {
        desktopSystemMonitorPosition = position
        saveSettings()
    }
    function setDesktopClockPosition(position) {
        desktopClockPosition = position
        saveSettings()
    }
    
    function getScreenDisplayName(screen) {
        if (!screen) return "primary"
        return screen.name || (screen.modelData ? screen.modelData.name : null) || "primary"
    }
    
    function getDesktopWidgetPosition(widgetId, screenKey, property, defaultValue) {
        const pos = desktopWidgetPositions?.[widgetId]?.[screenKey]?.[property]
        return pos !== undefined ? pos : defaultValue
    }
    
    function updateDesktopWidgetPosition(widgetId, screenKey, updates) {
        const allPositions = JSON.parse(JSON.stringify(desktopWidgetPositions || {}))
        if (!allPositions[widgetId])
            allPositions[widgetId] = {}
        allPositions[widgetId][screenKey] = Object.assign({}, allPositions[widgetId][screenKey] || {}, updates)
        desktopWidgetPositions = allPositions
        saveSettings()
    }
    
    function getDesktopWidgetGridSetting(screenKey, property, defaultValue) {
        const val = desktopWidgetGridSettings?.[screenKey]?.[property]
        return val !== undefined ? val : defaultValue
    }
    
    function setDesktopWidgetGridSetting(screenKey, property, value) {
        const allSettings = JSON.parse(JSON.stringify(desktopWidgetGridSettings || {}))
        if (!allSettings[screenKey])
            allSettings[screenKey] = {}
        allSettings[screenKey][property] = value
        desktopWidgetGridSettings = allSettings
        saveSettings()
    }
    
    function setDesktopCpuTempOpacity(opacity) {
        desktopCpuTempOpacity = opacity
        saveSettings()
    }
    
    function setDesktopGpuTempOpacity(opacity) {
        desktopGpuTempOpacity = opacity
        saveSettings()
    }
    
    function setDesktopSystemMonitorOpacity(opacity) {
        desktopSystemMonitorOpacity = opacity
        saveSettings()
    }

    function setDesktopSystemMonitorCustomGpuName(name) {
        desktopSystemMonitorCustomGpuName = name
        saveSettings()
    }

    function setDesktopSystemMonitorCustomCpuName(name) {
        desktopSystemMonitorCustomCpuName = name
        saveSettings()
    }
    
    function setDesktopClockOpacity(opacity) {
        desktopClockOpacity = opacity
        saveSettings()
    }
    
    function setDesktopClockBackgroundOpacity(opacity) {
        desktopClockBackgroundOpacity = opacity
        saveSettings()
    }
    
    function setDesktopWeatherEnabled(enabled) {
        desktopWeatherEnabled = enabled
        saveSettings()
    }
    
    function setDesktopWeatherPosition(position) {
        desktopWeatherPosition = position
        saveSettings()
    }
    
    function setDesktopTerminalEnabled(enabled) {
        desktopTerminalEnabled = enabled
        saveSettings()
    }
    
    function setDesktopTerminalPosition(position) {
        desktopTerminalPosition = position
        saveSettings()
    }
    
    function setDesktopTerminalOpacity(opacity) {
        desktopTerminalOpacity = opacity
        saveSettings()
    }
    function setDesktopWidgetBorderOpacity(opacity) {
        desktopWidgetBorderOpacity = opacity
        saveSettings()
    }
    function setDesktopWidgetBorderThickness(thickness) {
        desktopWidgetBorderThickness = thickness
        saveSettings()
    }
    
    function migrateDesktopWidgetsFromOldSystem() {
        // Only migrate if no instances exist
        if (desktopWidgetInstances && desktopWidgetInstances.length > 0)
            return;
        
        const instances = [];
        const screenWidth = 1920;  // Default, will be adjusted per screen
        const screenHeight = 1080;
        const margin = 20;
        
        function getPositionFromString(position, defaultWidth, defaultHeight) {
            switch(position) {
                case "top-left": return { x: margin, y: margin };
                case "top-center": return { x: screenWidth / 2 - defaultWidth / 2, y: margin };
                case "top-right": return { x: screenWidth - defaultWidth - margin, y: margin };
                case "middle-left": return { x: margin, y: screenHeight / 2 - defaultHeight / 2 };
                case "middle-center": return { x: screenWidth / 2 - defaultWidth / 2, y: screenHeight / 2 - defaultHeight / 2 };
                case "middle-right": return { x: screenWidth - defaultWidth - margin, y: screenHeight / 2 - defaultHeight / 2 };
                case "bottom-left": return { x: margin, y: screenHeight - defaultHeight - margin };
                case "bottom-center": return { x: screenWidth / 2 - defaultWidth / 2, y: screenHeight - defaultHeight - margin };
                case "bottom-right": return { x: screenWidth - defaultWidth - margin, y: screenHeight - defaultHeight - margin };
                default: return { x: screenWidth / 2 - defaultWidth / 2, y: screenHeight / 2 - defaultHeight / 2 };
            }
        }
        
        // Migrate Clock
        if (desktopClockEnabled) {
            const clockPos = getPositionFromString(desktopClockPosition, 180, 80);
            instances.push({
                id: "dw_clock_" + Date.now(),
                widgetType: "desktopClock",
                name: "Desktop Clock",
                enabled: true,
                config: {
                    transparency: desktopClockOpacity,
                    displayPreferences: ["all"]
                },
                positions: {
                    "primary": {
                        x: clockPos.x,
                        y: clockPos.y,
                        width: 180,
                        height: 80
                    }
                }
            });
        }
        
        // Migrate System Monitor
        if (desktopSystemMonitorEnabled) {
            const monitorPos = getPositionFromString(desktopSystemMonitorPosition, 200, 120);
            instances.push({
                id: "dw_systemmonitor_" + Date.now(),
                widgetType: "systemMonitor",
                name: "System Monitor",
                enabled: true,
                config: {
                    transparency: 0.9,
                    displayPreferences: ["all"]
                },
                positions: {
                    "primary": {
                        x: monitorPos.x,
                        y: monitorPos.y,
                        width: 200,
                        height: 120
                    }
                }
            });
        }
        
        // Migrate CPU Temp
        if (desktopCpuTempEnabled) {
            const cpuTempPos = getPositionFromString(desktopCpuTempPosition, 300, 150);
            instances.push({
                id: "dw_cputemp_" + Date.now(),
                widgetType: "desktopCpuTemp",
                name: "CPU Temperature",
                enabled: true,
                config: {
                    transparency: desktopCpuTempOpacity,
                    displayPreferences: ["all"]
                },
                positions: {
                    "primary": {
                        x: cpuTempPos.x,
                        y: cpuTempPos.y,
                        width: 300,
                        height: 150
                    }
                }
            });
        }
        
        // Migrate GPU Temp
        if (desktopGpuTempEnabled) {
            const gpuTempPos = getPositionFromString(desktopGpuTempPosition, 120, 60);
            instances.push({
                id: "dw_gputemp_" + Date.now(),
                widgetType: "desktopGpuTemp",
                name: "GPU Temperature",
                enabled: true,
                config: {
                    transparency: desktopGpuTempOpacity,
                    displayPreferences: ["all"]
                },
                positions: {
                    "primary": {
                        x: gpuTempPos.x,
                        y: gpuTempPos.y,
                        width: 120,
                        height: 60
                    }
                }
            });
        }
        
        // Migrate Terminal
        if (desktopTerminalEnabled) {
            const terminalPos = getPositionFromString(desktopTerminalPosition, desktopTerminalWidth || 600, desktopTerminalHeight || 400);
            instances.push({
                id: "dw_terminal_" + Date.now(),
                widgetType: "desktopTerminal",
                name: "Desktop Terminal",
                enabled: true,
                config: {
                    transparency: desktopTerminalOpacity,
                    width: desktopTerminalWidth || 600,
                    height: desktopTerminalHeight || 400,
                    displayPreferences: ["all"]
                },
                positions: {
                    "primary": {
                        x: terminalPos.x,
                        y: terminalPos.y,
                        width: desktopTerminalWidth || 600,
                        height: desktopTerminalHeight || 400
                    }
                }
            });
        }
        
        desktopWidgetInstances = instances;
        saveSettings();
    }
    
    function createDesktopWidgetInstance(widgetType, name, config) {
        const id = "dw_" + Date.now() + "_" + Math.random().toString(36).substr(2, 9);
        const instance = {
            id: id,
            widgetType: widgetType,
            name: name || widgetType,
            enabled: true,
            config: config || {},
            positions: {}
        };
        const instances = JSON.parse(JSON.stringify(desktopWidgetInstances || []));
        instances.push(instance);
        desktopWidgetInstances = instances;
        saveSettings();
        return instance;
    }

    function updateDesktopWidgetInstance(instanceId, updates) {
        const instances = JSON.parse(JSON.stringify(desktopWidgetInstances || []));
        const idx = instances.findIndex(inst => inst.id === instanceId);
        if (idx === -1)
            return;
        Object.assign(instances[idx], updates);
        desktopWidgetInstances = instances;
        saveSettings();
    }

    function updateDesktopWidgetInstanceConfig(instanceId, configUpdates) {
        const instances = JSON.parse(JSON.stringify(desktopWidgetInstances || []));
        const idx = instances.findIndex(inst => inst.id === instanceId);
        if (idx === -1)
            return;
        if (!instances[idx].config)
            instances[idx].config = {};
        instances[idx].config = Object.assign({}, instances[idx].config || {}, configUpdates);
        desktopWidgetInstances = instances;
        saveSettings();
    }

    function updateDesktopWidgetInstancePosition(instanceId, screenKey, positionUpdates) {
        const instances = JSON.parse(JSON.stringify(desktopWidgetInstances || []));
        const idx = instances.findIndex(inst => inst.id === instanceId);
        if (idx === -1)
            return;
        if (!instances[idx].positions)
            instances[idx].positions = {};
        instances[idx].positions[screenKey] = Object.assign({}, instances[idx].positions[screenKey] || {}, positionUpdates);
        desktopWidgetInstances = instances;
        saveSettings();
    }

    function removeDesktopWidgetInstance(instanceId) {
        const instances = (desktopWidgetInstances || []).filter(inst => inst.id !== instanceId);
        // Create a new array reference to ensure QML detects the change
        desktopWidgetInstances = JSON.parse(JSON.stringify(instances));
        saveSettings();
    }

    function duplicateDesktopWidgetInstance(instanceId) {
        const source = getDesktopWidgetInstance(instanceId);
        if (!source)
            return null;
        const newId = "dw_" + Date.now() + "_" + Math.random().toString(36).substr(2, 9);
        const instance = {
            id: newId,
            widgetType: source.widgetType,
            name: source.name + " (Copy)",
            enabled: source.enabled,
            config: JSON.parse(JSON.stringify(source.config || {})),
            positions: {}
        };
        const instances = JSON.parse(JSON.stringify(desktopWidgetInstances || []));
        instances.push(instance);
        desktopWidgetInstances = instances;
        saveSettings();
        return instance;
    }

    function getDesktopWidgetInstance(instanceId) {
        return (desktopWidgetInstances || []).find(inst => inst.id === instanceId) || null;
    }

    function getDesktopWidgetInstancesOfType(widgetType) {
        return (desktopWidgetInstances || []).filter(inst => inst.widgetType === widgetType);
    }

    function getEnabledDesktopWidgetInstances() {
        return (desktopWidgetInstances || []).filter(inst => inst.enabled);
    }
    
    function setDesktopTerminalWidth(width) {
        desktopTerminalWidth = width
        saveSettings()
    }
    
    function setDesktopTerminalHeight(height) {
        desktopTerminalHeight = height
        saveSettings()
    }
    
    function setDesktopTerminalFontSize(size) {
        desktopTerminalFontSize = Math.max(1, size || 12)
        saveSettings()
    }
    
    function setDesktopDarkDashEnabled(enabled) {
        desktopDarkDashEnabled = enabled
        saveSettings()
    }
    
    function setDesktopDarkDashPosition(position) {
        desktopDarkDashPosition = position
        saveSettings()
    }
    
    function setDesktopDarkDashWidth(width) {
        desktopDarkDashWidth = width
        saveSettings()
    }
    
    function setDesktopDarkDashHeight(height) {
        desktopDarkDashHeight = height
        saveSettings()
    }
    
    function setStartMenuXOffset(offset) {
        startMenuXOffset = Math.max(-1.0, Math.min(1.0, offset))
        saveSettings()
    }
    
    function setStartMenuYOffset(offset) {
        startMenuYOffset = Math.max(-1.0, Math.min(1.0, offset))
        saveSettings()
    }
    
    function setControlCenterXOffset(offset) {
        controlCenterXOffset = Math.max(-1.0, Math.min(1.0, offset))
        saveSettings()
    }
    
    function setControlCenterYOffset(offset) {
        controlCenterYOffset = Math.max(-1.0, Math.min(1.0, offset))
        saveSettings()
    }
    
    function setDarkDashXOffset(offset) {
        darkDashXOffset = Math.max(-1.15, Math.min(1.15, offset))
        saveSettings()
    }
    
    function setDarkDashYOffset(offset) {
        darkDashYOffset = Math.max(-1.15, Math.min(1.15, offset))
        saveSettings()
    }

    function setApplicationsXOffset(offset) {
        applicationsXOffset = Math.max(-1.15, Math.min(1.15, offset))
        saveSettings()
    }

    function setApplicationsYOffset(offset) {
        applicationsYOffset = Math.max(-1.15, Math.min(1.15, offset))
        saveSettings()
    }
    
    function setDesktopWeatherOpacity(opacity) {
        desktopWeatherOpacity = opacity
        saveSettings()
    }
    
    function setDesktopWeatherWidth(width) {
        desktopWeatherWidth = width
        saveSettings()
    }
    
    function setDesktopWeatherHeight(height) {
        desktopWeatherHeight = height
        saveSettings()
    }
    
    function setDesktopWeatherFontSize(fontSize) {
        desktopWeatherFontSize = fontSize
        saveSettings()
    }
    
    function setDesktopWeatherIconSize(iconSize) {
        desktopWeatherIconSize = iconSize
        saveSettings()
    }
    
    function setDesktopWeatherSpacing(spacing) {
        desktopWeatherSpacing = spacing
        saveSettings()
    }
    
    function setDesktopWeatherPadding(padding) {
        desktopWeatherPadding = padding
        saveSettings()
    }
    
    function setDesktopWeatherBorderRadius(radius) {
        desktopWeatherBorderRadius = radius
        saveSettings()
    }
    
    function setDesktopWeatherCurrentTempSize(size) {
        desktopWeatherCurrentTempSize = size
        saveSettings()
    }
    
    function setDesktopWeatherCitySize(size) {
        desktopWeatherCitySize = size
        saveSettings()
    }
    
    function setDesktopWeatherDetailsSize(size) {
        desktopWeatherDetailsSize = size
        saveSettings()
    }
    
    function setDesktopWeatherForecastSize(size) {
        desktopWeatherForecastSize = size
        saveSettings()
    }
    
    function setDesktopSystemMonitorWidth(width) {
        desktopSystemMonitorWidth = width
        saveSettings()
    }
    
    function setDesktopSystemMonitorHeight(height) {
        desktopSystemMonitorHeight = height
        saveSettings()
    }

    function setDesktopWidgetWidth(width) {
        desktopWidgetWidth = width
        saveSettings()
    }

    function setDesktopWidgetHeight(height) {
        desktopWidgetHeight = height
        saveSettings()
    }

    function setDesktopWidgetFontSize(fontSize) {
        desktopWidgetFontSize = fontSize
        saveSettings()
    }

    function setDesktopWidgetIconSize(iconSize) {
        desktopWidgetIconSize = iconSize
        saveSettings()
    }

    function setDesktopGpuSelection(gpuSelection) {
        desktopGpuSelection = gpuSelection
        saveSettings()
    }

    function getGpuDropdownOptions() {
        if (!DgopService.availableGpus || DgopService.availableGpus.length === 0) {
            return ["No GPUs detected"];
        }
        
        const options = ["auto"];
        for (let i = 0; i < DgopService.availableGpus.length; i++) {
            const gpu = DgopService.availableGpus[i];
            let displayName = gpu.displayName || gpu.fullName || "Unknown GPU";
            displayName = displayName.replace(/^GeForce\s+/i, "").replace(/^Radeon\s+/i, "").replace(/^AMD\s+/i, "").trim();
            options.push(displayName);
        }
        
        return options;
    }

    function setDockBorderEnabled(enabled) {
        dockBorderEnabled = enabled
        saveSettings()
    }

    function setDockBorderWidth(width) {
        dockBorderWidth = width
        saveSettings()
    }

    function setDockBorderRadius(radius) {
        var newRadius = Number(radius)
        if (dockBorderRadius !== newRadius) {
            dockBorderRadius = newRadius
            saveSettings()
        }
    }

    function setDockRadius(radius) {
        dockRadius = radius
        saveSettings()
    }

    function setDockBorderRed(red) {
        dockBorderRed = red
        saveSettings()
    }

    function setDockBorderGreen(green) {
        dockBorderGreen = green
        saveSettings()
    }

    function setDockBorderBlue(blue) {
        dockBorderBlue = blue
        saveSettings()
    }

    function setDockBorderAlpha(alpha) {
        dockBorderAlpha = alpha
        saveSettings()
    }

    function setTopBarBorderEnabled(enabled) {
        topBarBorderEnabled = enabled
        saveSettings()
    }

    function setTopBarBorderWidth(width) {
        topBarBorderWidth = width
        saveSettings()
    }

    function setTopBarBorderRadius(radius) {
        var newRadius = Number(radius)
        if (topBarBorderRadius !== newRadius) {
            topBarBorderRadius = newRadius
            saveSettings()
        }
    }

    function setTopBarBorderRed(red) {
        topBarBorderRed = red
        saveSettings()
    }

    function setTopBarBorderGreen(green) {
        topBarBorderGreen = green
        saveSettings()
    }

    function setTopBarBorderBlue(blue) {
        topBarBorderBlue = blue
        saveSettings()
    }

    function setTopBarBorderAlpha(alpha) {
        topBarBorderAlpha = alpha
        saveSettings()
    }

    function setTopBarBorderTop(enabled) {
        topBarBorderTop = enabled
        saveSettings()
    }

    function setTopBarBorderLeft(enabled) {
        topBarBorderLeft = enabled
        saveSettings()
    }

    function setTopBarBorderRight(enabled) {
        topBarBorderRight = enabled
        saveSettings()
    }

    function setTopBarBorderBottom(enabled) {
        topBarBorderBottom = enabled
        saveSettings()
    }

    function setTopBarBorderBottomLeftInset(inset) {
        topBarBorderBottomLeftInset = inset
        saveSettings()
    }

    function setTopBarBorderBottomRightInset(inset) {
        topBarBorderBottomRightInset = inset
        saveSettings()
    }

    function setDockDynamicBorderColors(enabled) {
        dockDynamicBorderColors = enabled
        saveSettings()
    }

    function setTopBarDynamicBorderColors(enabled) {
        topBarDynamicBorderColors = enabled
        saveSettings()
    }

    function setTaskBarBorderEnabled(enabled) {
        taskBarBorderEnabled = enabled
        saveSettings()
    }

    function setTaskBarBorderWidth(width) {
        taskBarBorderWidth = width
        saveSettings()
    }

    function setTaskBarBorderRadius(radius) {
        var newRadius = Number(radius)
        if (taskBarBorderRadius !== newRadius) {
            taskBarBorderRadius = newRadius
            saveSettings()
        }
    }

    function setTaskBarBorderRed(red) {
        taskBarBorderRed = red
        saveSettings()
    }

    function setTaskBarBorderGreen(green) {
        taskBarBorderGreen = green
        saveSettings()
    }

    function setTaskBarBorderBlue(blue) {
        taskBarBorderBlue = blue
        saveSettings()
    }

    function setTaskBarBorderAlpha(alpha) {
        taskBarBorderAlpha = alpha
        saveSettings()
    }

    function setTaskBarDynamicBorderColors(enabled) {
        taskBarDynamicBorderColors = enabled
        saveSettings()
    }

    function setTaskBarBorderTop(enabled) {
        taskBarBorderTop = enabled
        saveSettings()
    }

    function setTaskBarBorderLeft(enabled) {
        taskBarBorderLeft = enabled
        saveSettings()
    }

    function setTaskBarBorderRight(enabled) {
        taskBarBorderRight = enabled
        saveSettings()
    }

    function setTaskBarBorderBottom(enabled) {
        taskBarBorderBottom = enabled
        saveSettings()
    }

    function setTaskBarBorderBottomLeftInset(inset) {
        taskBarBorderBottomLeftInset = inset
        saveSettings()
    }

    function setTaskBarBorderBottomRightInset(inset) {
        taskBarBorderBottomRightInset = inset
        saveSettings()
    }

    function setTopBarFloat(enabled) {
        topBarFloat = enabled
        saveSettings()
    }

    function setTopBarRoundedCorners(enabled) {
        topBarRoundedCorners = enabled
        saveSettings()
    }

    function setTopBarCornerRadius(radius) {
        topBarCornerRadius = radius
        saveSettings()
    }

    function setTopBarLeftMargin(margin) {
        topBarLeftMargin = margin
        saveSettings()
    }

    function setTopBarRightMargin(margin) {
        topBarRightMargin = margin
        saveSettings()
    }

    function setTopBarTopMargin(margin) {
        topBarTopMargin = margin
        saveSettings()
    }

    function setTopBarHeight(height) {
        topBarHeight = height
        saveSettings()
    }

    function setTaskBarHeight(height) {
        taskBarHeight = height
        saveSettings()
    }

    function setTaskBarTransparency(transparency) {
        taskBarTransparency = transparency
        saveSettings()
    }

    function setTaskBarPinnedAppsPosition(position) {
        taskBarPinnedAppsPosition = position
        saveSettings()
    }

    function setTaskBarIconSize(size) {
        taskBarIconSize = size
        saveSettings()
    }

    function setTaskBarIconSpacing(spacing) {
        taskBarIconSpacing = spacing
        saveSettings()
    }

    function setTaskBarFloat(enabled) {
        taskBarFloat = enabled
        saveSettings()
    }

    function setTaskBarRoundedCorners(enabled) {
        taskBarRoundedCorners = enabled
        saveSettings()
    }

    function setTaskBarCornerRadius(radius) {
        taskBarCornerRadius = radius
        saveSettings()
    }

    function setTaskBarBottomMargin(margin) {
        taskBarBottomMargin = margin
        saveSettings()
    }

    function setTaskBarExclusiveZone(zone) {
        taskBarExclusiveZone = zone
        saveSettings()
    }

    function setTaskBarLeftPadding(padding) {
        taskBarLeftPadding = padding
        saveSettings()
    }

    function setTaskBarRightPadding(padding) {
        taskBarRightPadding = padding
        saveSettings()
    }

    function setTaskBarTopPadding(padding) {
        taskBarTopPadding = padding
        saveSettings()
    }

    function setTaskBarBottomPadding(padding) {
        taskBarBottomPadding = padding
        saveSettings()
    }

    function setTaskBarAutoHide(enabled) {
        taskBarAutoHide = enabled
        saveSettings()
    }

    function setTaskBarVisible(visible) {
        taskBarVisible = visible
        saveSettings()
    }

    function setTaskBarGroupApps(enabled) {
        taskBarGroupApps = enabled
        saveSettings()
    }

    function setDockTransparency(transparency) {
        dockTransparency = transparency
        saveSettings()
    }

    function setClockStackedFormat(stacked) {
        clockStackedFormat = stacked
        saveSettings()
        widgetDataChanged()
    }
    function setClockBoldFont(bold) {
        clockBoldFont = bold
        saveSettings()
        widgetDataChanged()
    }
    function setClockFormat(use24Hour) {
        if (use24HourClock !== use24Hour) {
            use24HourClock = use24Hour
            saveSettings()

            widgetDataChanged()
        } else {
        }
    }
    function setShowAmPmIn24Hour(show) {
        if (showAmPmIn24Hour !== show) {
            showAmPmIn24Hour = show
            saveSettings()
            widgetDataChanged()
        }
    }

    function setTemperatureUnit(fahrenheit) {
        useFahrenheit = fahrenheit
        saveSettings()
    }

    function setNightModeEnabled(enabled) {
        nightModeEnabled = enabled
        saveSettings()
    }

    function setShowLauncherButton(enabled) {
        showLauncherButton = enabled
        saveSettings()
    }

    function setShowWorkspaceSwitcher(enabled) {
        showWorkspaceSwitcher = enabled
        saveSettings()
    }

    function setShowFocusedWindow(enabled) {
        showFocusedWindow = enabled
        saveSettings()
    }

    function setShowWeather(enabled) {
        showWeather = enabled
        saveSettings()
    }

    function setShowMusic(enabled) {
        showMusic = enabled
        saveSettings()
    }

    function setShowClipboard(enabled) {
        showClipboard = enabled
        saveSettings()
    }

    function setShowCpuUsage(enabled) {
        showCpuUsage = enabled
        saveSettings()
    }

    function setShowMemUsage(enabled) {
        showMemUsage = enabled
        saveSettings()
    }

    function setShowCpuTemp(enabled) {
        showCpuTemp = enabled
        saveSettings()
    }

    function setShowGpuTemp(enabled) {
        showGpuTemp = enabled
        saveSettings()
    }

    function setSelectedGpuIndex(index) {
        selectedGpuIndex = index
        saveSettings()
    }

    function setEnabledGpuPciIds(pciIds) {
        enabledGpuPciIds = pciIds
        saveSettings()
    }

    function setShowSystemTray(enabled) {
        showSystemTray = enabled
        saveSettings()
    }

    function setShowClock(enabled) {
        showClock = enabled
        saveSettings()
    }

    function setShowNotificationButton(enabled) {
        showNotificationButton = enabled
        saveSettings()
    }

    function setShowBattery(enabled) {
        showBattery = enabled
        saveSettings()
    }

    function setShowControlCenterButton(enabled) {
        showControlCenterButton = enabled
        saveSettings()
    }

    function setControlCenterShowNetworkIcon(enabled) {
        controlCenterShowNetworkIcon = enabled
        saveSettings()
    }

    function setControlCenterShowBluetoothIcon(enabled) {
        controlCenterShowBluetoothIcon = enabled
        saveSettings()
    }

    function setControlCenterShowAudioIcon(enabled) {
        controlCenterShowAudioIcon = enabled
        saveSettings()
    }

    function setControlCenterShowMicIcon(enabled) {
        controlCenterShowMicIcon = enabled
        saveSettings()
    }
    function setControlCenterWidgets(widgets) {
        controlCenterWidgets = widgets
        saveSettings()
    }

    function setTopBarWidgetOrder(order) {
        topBarWidgetOrder = order
        saveSettings()
    }

    function setTopBarLeftWidgets(order) {
        topBarLeftWidgets = order
        updateListModel(leftWidgetsModel, order)
        saveSettings()
    }

    function setTopBarCenterWidgets(order) {
        topBarCenterWidgets = order
        updateListModel(centerWidgetsModel, order)
        saveSettings()
    }

    function setTopBarRightWidgets(order) {
        topBarRightWidgets = order
        updateListModel(rightWidgetsModel, order)
        saveSettings()
    }

    function setDockLeftWidgets(order) {
        dockLeftWidgets = order
        updateListModel(dockLeftWidgetsModel, order)
        saveSettings()
    }

    function setDockCenterWidgets(order) {
        dockCenterWidgets = order
        updateListModel(dockCenterWidgetsModel, order)
        saveSettings()
    }

    function setDockRightWidgets(order) {
        dockRightWidgets = order
        updateListModel(dockRightWidgetsModel, order)
        saveSettings()
    }

    function setTaskBarLeftWidgets(order) {
        taskBarLeftWidgets = order
        updateListModel(taskBarLeftWidgetsModel, order)
        saveSettings()
    }

    function setTaskBarCenterWidgets(order) {
        taskBarCenterWidgets = order
        updateListModel(taskBarCenterWidgetsModel, order)
        saveSettings()
    }

    function setTaskBarRightWidgets(order) {
        taskBarRightWidgets = order
        updateListModel(taskBarRightWidgetsModel, order)
        saveSettings()
    }

    function setAudioRoute(appKey, deviceId, isInput) {
        if (!appKey || !deviceId)
            return
        if (isInput) {
            audioRoutesInput[appKey] = deviceId
        } else {
            audioRoutesOutput[appKey] = deviceId
        }
        saveSettings()
    }
    function getAudioRoute(appKey, isInput) {
        if (!appKey)
            return ""
        return isInput ? (audioRoutesInput[appKey] || "") : (audioRoutesOutput[appKey] || "")
    }

    function updateListModel(listModel, order) {
        listModel.clear()
        for (var i = 0; i < order.length; i++) {
            var widgetId = typeof order[i] === "string" ? order[i] : order[i].id
            var enabled = typeof order[i] === "string" ? true : order[i].enabled
            var size = typeof order[i] === "string" ? undefined : order[i].size
            var selectedGpuIndex = typeof order[i] === "string" ? undefined : order[i].selectedGpuIndex
            var pciId = typeof order[i] === "string" ? undefined : order[i].pciId
            var item = {
                "widgetId": widgetId,
                "enabled": enabled
            }
            if (size !== undefined)
                item.size = size
            if (selectedGpuIndex !== undefined)
                item.selectedGpuIndex = selectedGpuIndex
            if (pciId !== undefined)
                item.pciId = pciId

            listModel.append(item)
        }
        widgetDataChanged()
    }

    function resetTopBarWidgetsToDefault() {
        var defaultLeft = ["launcherButton"]
        var defaultCenter = ["workspaceSwitcher"]
        var defaultRight = ["systemTray", "weather", "clock", "notificationButton", "controlCenterButton", "systemUpdate"]
        topBarLeftWidgets = defaultLeft
        topBarCenterWidgets = defaultCenter
        topBarRightWidgets = defaultRight
        updateListModel(leftWidgetsModel, defaultLeft)
        updateListModel(centerWidgetsModel, defaultCenter)
        updateListModel(rightWidgetsModel, defaultRight)
        showLauncherButton = true
        showWorkspaceSwitcher = true
        showFocusedWindow = true
        showWeather = true
        showMusic = true
        showClipboard = true
        showCpuUsage = true
        showMemUsage = true
        showCpuTemp = true
        showGpuTemp = true
        showSystemTray = true
        showClock = true
        showNotificationButton = true
        showBattery = true
        showControlCenterButton = true
        saveSettings()
    }

    function setAppLauncherViewMode(mode) {
        appLauncherViewMode = mode
        saveSettings()
    }

    function setSpotlightModalViewMode(mode) {
        spotlightModalViewMode = mode
        saveSettings()
    }

    function setWeatherLocation(displayName, coordinates) {
        weatherLocation = displayName
        weatherCoordinates = coordinates
        saveSettings()
    }

    function setAutoLocation(enabled) {
        useAutoLocation = enabled
        saveSettings()
    }

    function setWeatherEnabled(enabled) {
        weatherEnabled = enabled
        saveSettings()
    }

    function setNetworkPreference(preference) {
        networkPreference = preference
        saveSettings()
    }

    function detectAvailableIconThemes() {
        systemDefaultDetectionProcess.running = true
    }

    function detectQtTools() {
        qtToolsDetectionProcess.running = true
    }

    function setIconTheme(themeName) {
        iconTheme = themeName
        updateGtkIconTheme(themeName)
        updateQtIconTheme(themeName)
        saveSettings()
        if (typeof Theme !== "undefined" && Theme.currentTheme === Theme.dynamic)
            Theme.generateSystemThemes()
    }

    function updateGtkIconTheme(themeName) {
        var gtkThemeName = (themeName === "System Default") ? systemDefaultIconTheme : themeName
        if (gtkThemeName !== "System Default" && gtkThemeName !== "") {
            var script = "if command -v gsettings >/dev/null 2>&1 && gsettings list-schemas | grep -q org.gnome.desktop.interface; then\n"
                    + "    gsettings set org.gnome.desktop.interface icon-theme '" + gtkThemeName + "'\n" + "    echo 'Updated via gsettings'\n" + "elif command -v dconf >/dev/null 2>&1; then\n" + "    dconf write /org/gnome/desktop/interface/icon-theme \\\"" + gtkThemeName + "\\\"\n"
                    + "    echo 'Updated via dconf'\n" + "fi\n" + "\n" + "# Ensure config directories exist\n" + "mkdir -p " + _configDir + "/gtk-3.0 " + _configDir
                    + "/gtk-4.0\n" + "\n" + "# Update settings.ini files (keep existing gtk-theme-name)\n" + "for config_dir in " + _configDir + "/gtk-3.0 " + _configDir + "/gtk-4.0; do\n"
                    + "    settings_file=\"$config_dir/settings.ini\"\n" + "    if [ -f \"$settings_file\" ]; then\n" + "        # Update existing icon-theme-name line or add it\n" + "        if grep -q '^gtk-icon-theme-name=' \"$settings_file\"; then\n" + "            sed -i 's/^gtk-icon-theme-name=.*/gtk-icon-theme-name=" + gtkThemeName + "/' \"$settings_file\"\n" + "        else\n"
                    + "            # Add icon theme setting to [Settings] section or create it\n" + "            if grep -q '\\[Settings\\]' \"$settings_file\"; then\n" + "                sed -i '/\\[Settings\\]/a gtk-icon-theme-name=" + gtkThemeName + "' \"$settings_file\"\n" + "            else\n" + "                echo -e '\\n[Settings]\\ngtk-icon-theme-name=" + gtkThemeName
                    + "' >> \"$settings_file\"\n" + "            fi\n" + "        fi\n" + "    else\n" + "        # Create new settings.ini file\n" + "        echo -e '[Settings]\\ngtk-icon-theme-name=" + gtkThemeName + "' > \"$settings_file\"\n"
                    + "    fi\n" + "    echo \"Updated $settings_file\"\n" + "done\n" + "\n" + "# Clear icon cache and force refresh\n" + "rm -rf ~/.cache/icon-cache ~/.cache/thumbnails 2>/dev/null || true\n" + "# Send SIGHUP to running GTK applications to reload themes (Fedora-specific)\n" + "pkill -HUP -f 'gtk' 2>/dev/null || true\n"
            Quickshell.execDetached(["sh", "-lc", script])
        }
    }

    function updateQtIconTheme(themeName) {
        var qtThemeName = (themeName === "System Default") ? "" : themeName
        var home = _shq(Paths.strip(root._homeUrl))
        if (!qtThemeName) {
            return
        }
        var script = "mkdir -p " + _configDir + "/qt5ct " + _configDir + "/qt6ct " + _configDir + "/environment.d 2>/dev/null || true\n" + "update_qt_icon_theme() {\n" + "  local config_file=\"$1\"\n"
                + "  local theme_name=\"$2\"\n" + "  if [ -f \"$config_file\" ]; then\n" + "    if grep -q '^\\[Appearance\\]' \"$config_file\"; then\n" + "      if grep -q '^icon_theme=' \"$config_file\"; then\n" + "        sed -i \"s/^icon_theme=.*/icon_theme=$theme_name/\" \"$config_file\"\n" + "      else\n" + "        sed -i \"/^\\[Appearance\\]/a icon_theme=$theme_name\" \"$config_file\"\n" + "      fi\n"
                + "    else\n" + "      printf '\\n[Appearance]\\nicon_theme=%s\\n' \"$theme_name\" >> \"$config_file\"\n" + "    fi\n" + "  else\n" + "    printf '[Appearance]\\nicon_theme=%s\\n' \"$theme_name\" > \"$config_file\"\n" + "  fi\n" + "}\n" + "update_qt_icon_theme " + _configDir + "/qt5ct/qt5ct.conf " + _shq(
                    qtThemeName) + "\n" + "update_qt_icon_theme " + _configDir + "/qt6ct/qt6ct.conf " + _shq(qtThemeName) + "\n" + "rm -rf " + home + "/.cache/icon-cache " + home + "/.cache/thumbnails 2>/dev/null || true\n"
        Quickshell.execDetached(["sh", "-lc", script])
    }

    function applyStoredIconTheme() {
        updateGtkIconTheme(iconTheme)
        updateQtIconTheme(iconTheme)
    }

    function detectAvailableGtkThemes() {
        systemDefaultGtkThemeProcess.running = true
    }

    function setGtkTheme(themeName) {
        gtkTheme = themeName
        updateGtkTheme(themeName)
        saveSettings()
    }

    function updateGtkTheme(themeName) {
        var gtkThemeName = (themeName === "System Default") ? systemDefaultGtkTheme : themeName
        if (gtkThemeName !== "System Default" && gtkThemeName !== "") {
            var escapedTheme = _shq(gtkThemeName)
            var script = "if command -v gsettings >/dev/null 2>&1 && gsettings list-schemas | grep -q org.gnome.desktop.interface; then\n"
                    + "    gsettings set org.gnome.desktop.interface gtk-theme " + escapedTheme + "\n"
                    + "    echo 'Updated via gsettings'\n"
                    + "elif command -v dconf >/dev/null 2>&1; then\n"
                    + "    dconf write /org/gnome/desktop/interface/gtk-theme " + escapedTheme + "\n"
                    + "    echo 'Updated via dconf'\n"
                    + "fi\n"
                    + "\n"
                    + "# Ensure config directories exist\n"
                    + "mkdir -p " + _configDir + "/gtk-3.0 " + _configDir + "/gtk-4.0\n"
                    + "\n"
                    + "# Update settings.ini files (keep existing icon-theme-name and other settings)\n"
                    + "for config_dir in " + _configDir + "/gtk-3.0 " + _configDir + "/gtk-4.0; do\n"
                    + "    settings_file=\"$config_dir/settings.ini\"\n"
                    + "    if [ -f \"$settings_file\" ]; then\n"
                    + "        # Update existing gtk-theme-name line or add it\n"
                    + "        if grep -q '^gtk-theme-name=' \"$settings_file\"; then\n"
                    + "            sed -i 's/^gtk-theme-name=.*/gtk-theme-name=" + gtkThemeName.replace(/'/g, "'\\''") + "/' \"$settings_file\"\n"
                    + "        else\n"
                    + "            # Add theme setting to [Settings] section or create it\n"
                    + "            if grep -q '\\[Settings\\]' \"$settings_file\"; then\n"
                    + "                sed -i '/\\[Settings\\]/a gtk-theme-name=" + gtkThemeName.replace(/'/g, "'\\''") + "' \"$settings_file\"\n"
                    + "            else\n"
                    + "                echo -e '\\n[Settings]\\ngtk-theme-name=" + gtkThemeName.replace(/'/g, "'\\''") + "' >> \"$settings_file\"\n"
                    + "            fi\n"
                    + "        fi\n"
                    + "    else\n"
                    + "        # Create new settings.ini file\n"
                    + "        echo -e '[Settings]\\ngtk-theme-name=" + gtkThemeName.replace(/'/g, "'\\''") + "' > \"$settings_file\"\n"
                    + "    fi\n"
                    + "    echo \"Updated $settings_file\"\n"
                    + "done\n"
                    + "\n"
                    + "# Update GTK2 config\n"
                    + "if [ ! -f ~/.gtkrc-2.0 ]; then\n"
                    + "    echo 'gtk-theme-name=" + escapedTheme + "' > ~/.gtkrc-2.0\n"
                    + "else\n"
                    + "    if grep -q '^gtk-theme-name=' ~/.gtkrc-2.0; then\n"
                    + "        sed -i 's/^gtk-theme-name=.*/gtk-theme-name=" + escapedTheme + "/' ~/.gtkrc-2.0\n"
                    + "    else\n"
                    + "        echo 'gtk-theme-name=" + escapedTheme + "' >> ~/.gtkrc-2.0\n"
                    + "    fi\n"
                    + "fi\n"
                    + "\n"
                    + "# Send SIGHUP to running GTK applications to reload themes (optional, may not work on all systems)\n"
                    + "pkill -HUP -f 'gtk' 2>/dev/null || true\n"
            
            Quickshell.execDetached(["sh", "-lc", script])
        }
    }

    function applyStoredGtkTheme() {
        updateGtkTheme(gtkTheme)
    }

    function detectAvailableQtThemes() {
        systemDefaultQtThemeProcess.running = true
    }

    function setQtTheme(themeName) {
        qtTheme = themeName
        updateQtTheme(themeName)
        saveSettings()
    }

    function updateQtTheme(themeName) {
        var qtThemeName = (themeName === "System Default") ? systemDefaultQtTheme : themeName
        if (!qtThemeName || qtThemeName === "System Default" || qtThemeName === "") {
            return
        }
        
        var escapedTheme = _shq(qtThemeName)
        var home = _shq(Paths.strip(root._homeUrl))
        
        var script = "mkdir -p " + _configDir + "/qt5ct " + _configDir + "/qt6ct 2>/dev/null || true\n"
                + "update_qt_theme() {\n"
                + "  local config_file=\"$1\"\n"
                + "  local theme_name=\"$2\"\n"
                + "  if [ -f \"$config_file\" ]; then\n"
                + "    if grep -q '^\\[Appearance\\]' \"$config_file\"; then\n"
                + "      if grep -q '^style=' \"$config_file\"; then\n"
                + "        sed -i \"s/^style=.*/style=$theme_name/\" \"$config_file\"\n"
                + "      else\n"
                + "        sed -i \"/^\\[Appearance\\]/a style=$theme_name\" \"$config_file\"\n"
                + "      fi\n"
                + "    else\n"
                + "      printf '\\n[Appearance]\\nstyle=%s\\n' \"$theme_name\" >> \"$config_file\"\n"
                + "    fi\n"
                + "  else\n"
                + "    printf '[Appearance]\\nstyle=%s\\n' \"$theme_name\" > \"$config_file\"\n"
                + "  fi\n"
                + "}\n"
                + "update_qt_theme " + _configDir + "/qt5ct/qt5ct.conf " + escapedTheme + "\n"
                + "update_qt_theme " + _configDir + "/qt6ct/qt6ct.conf " + escapedTheme + "\n"
                + "rm -rf " + home + "/.cache/icon-cache " + home + "/.cache/thumbnails 2>/dev/null || true\n"
        
        Quickshell.execDetached(["sh", "-lc", script])
    }

    function applyStoredQtTheme() {
        updateQtTheme(qtTheme)
    }

    function detectAvailableShellThemes() {
        userThemeExtensionCheckProcess.running = true
    }

    function setShellTheme(themeName) {
        shellTheme = themeName
        updateShellTheme(themeName)
        saveSettings()
    }

    function updateShellTheme(themeName) {
        var shellThemeName = (themeName === "System Default") ? systemDefaultShellTheme : themeName
        var home = _shq(Paths.strip(root._homeUrl))
        
        if (shellThemeName !== "System Default" && shellThemeName !== "") {
            var escapedTheme = _shq(shellThemeName)
            
            var script = "# Try extension method first (preferred)\n"
                    + "if command -v gsettings >/dev/null 2>&1 && gsettings list-schemas | grep -q org.gnome.shell.extensions.user-theme; then\n"
                    + "    gsettings set org.gnome.shell.extensions.user-theme name " + escapedTheme + "\n"
                    + "    echo 'Updated via user-theme extension (gsettings)'\n"
                    + "elif command -v dconf >/dev/null 2>&1 && dconf list /org/gnome/shell/extensions/user-theme/ 2>/dev/null | grep -q name; then\n"
                    + "    dconf write /org/gnome/shell/extensions/user-theme/name " + escapedTheme + "\n"
                    + "    echo 'Updated via user-theme extension (dconf)'\n"
                    + "else\n"
                    + "    # Fallback: Copy theme CSS to ~/.config/gnome-shell/gnome-shell.css\n"
                    + "    # This works without the extension but only applies CSS (not full theme assets)\n"
                    + "    theme_css=\"\"\n"
                    + "    for dir in " + home + "/.themes " + home + "/.local/share/themes /usr/share/themes; do\n"
                    + "        if [ -f \"$dir/" + shellThemeName.replace(/'/g, "'\\''") + "/gnome-shell/gnome-shell.css\" ]; then\n"
                    + "            theme_css=\"$dir/" + shellThemeName.replace(/'/g, "'\\''") + "/gnome-shell/gnome-shell.css\"\n"
                    + "            break\n"
                    + "        fi\n"
                    + "    done\n"
                    + "    \n"
                    + "    if [ -n \"$theme_css\" ] && [ -f \"$theme_css\" ]; then\n"
                    + "        mkdir -p " + home + "/.config/gnome-shell\n"
                    + "        cp \"$theme_css\" " + home + "/.config/gnome-shell/gnome-shell.css\n"
                    + "        echo 'Updated via CSS file copy (extension not available)'\n"
                    + "    else\n"
                    + "        echo 'Error: Theme CSS file not found'\n"
                    + "        exit 1\n"
                    + "    fi\n"
                    + "fi\n"
            
            Quickshell.execDetached(["sh", "-lc", script])
            
            if (typeof ToastService !== "undefined") {
                if (userThemeExtensionAvailable && userThemeExtensionEnabled) {
                    ToastService.showInfo("Shell theme changed", "Restart GNOME Shell to see changes:\nPress Alt+F2, type 'r', then press Enter")
                } else {
                    ToastService.showInfo("Shell theme changed (CSS only)", "Applied theme CSS without extension.\nNote: Only CSS is applied, not full theme assets.\nRestart GNOME Shell (Alt+F2, type 'r', Enter) to see changes.")
                }
            }
        } else if (themeName === "System Default") {
            var script = "# Try extension method first\n"
                    + "if command -v gsettings >/dev/null 2>&1 && gsettings list-schemas | grep -q org.gnome.shell.extensions.user-theme; then\n"
                    + "    gsettings reset org.gnome.shell.extensions.user-theme name\n"
                    + "    echo 'Reset to system default (extension)'\n"
                    + "elif command -v dconf >/dev/null 2>&1 && dconf list /org/gnome/shell/extensions/user-theme/ 2>/dev/null | grep -q name; then\n"
                    + "    dconf reset /org/gnome/shell/extensions/user-theme/name\n"
                    + "    echo 'Reset to system default (extension)'\n"
                    + "else\n"
                    + "    # Fallback: Remove custom CSS file\n"
                    + "    if [ -f " + home + "/.config/gnome-shell/gnome-shell.css ]; then\n"
                    + "        rm " + home + "/.config/gnome-shell/gnome-shell.css\n"
                    + "        echo 'Removed custom CSS file'\n"
                    + "    fi\n"
                    + "    echo 'Reset to system default (CSS fallback)'\n"
                    + "fi\n"
            Quickshell.execDetached(["sh", "-lc", script])
            
            if (typeof ToastService !== "undefined") {
                ToastService.showInfo("Shell theme reset", "Restart GNOME Shell to see changes:\nPress Alt+F2, type 'r', then press Enter")
            }
        }
    }

    function applyStoredShellTheme() {
        updateShellTheme(shellTheme)
    }

    function detectAvailableCursorThemes() {
        systemDefaultCursorThemeProcess.running = true
    }

    function setCursorTheme(themeName, size) {
        cursorTheme = themeName
        if (size !== undefined && size > 0) cursorSize = size
        updateCursorTheme(themeName, cursorSize)
        saveSettings()
    }

    function updateCursorTheme(themeName, size) {
        var cursorThemeName = (themeName === "System Default") ? systemDefaultCursorTheme : themeName
        var cursorSizeValue = size || 24
        
        if (cursorThemeName !== "System Default" && cursorThemeName !== "" && cursorSizeValue > 0) {
            var escapedTheme = _shq(cursorThemeName)
            var home = _shq(Paths.strip(root._homeUrl))
            
            var script = "# Update via gsettings/dconf\n"
                    + "if command -v gsettings >/dev/null 2>&1 && gsettings list-schemas | grep -q org.gnome.desktop.interface; then\n"
                    + "    gsettings set org.gnome.desktop.interface cursor-theme " + escapedTheme + "\n"
                    + "    gsettings set org.gnome.desktop.interface cursor-size " + cursorSizeValue + "\n"
                    + "    echo 'Updated via gsettings'\n"
                    + "elif command -v dconf >/dev/null 2>&1; then\n"
                    + "    dconf write /org/gnome/desktop/interface/cursor-theme " + escapedTheme + "\n"
                    + "    dconf write /org/gnome/desktop/interface/cursor-size " + cursorSizeValue + "\n"
                    + "    echo 'Updated via dconf'\n"
                    + "fi\n"
                    + "\n"
                    + "# Update GTK settings.ini files\n"
                    + "mkdir -p " + _configDir + "/gtk-3.0 " + _configDir + "/gtk-4.0\n"
                    + "\n"
                    + "for config_dir in " + _configDir + "/gtk-3.0 " + _configDir + "/gtk-4.0; do\n"
                    + "    settings_file=\"$config_dir/settings.ini\"\n"
                    + "    if [ -f \"$settings_file\" ]; then\n"
                    + "        # Update cursor theme name\n"
                    + "        if grep -q '^gtk-cursor-theme-name=' \"$settings_file\"; then\n"
                    + "            sed -i 's/^gtk-cursor-theme-name=.*/gtk-cursor-theme-name=" + cursorThemeName.replace(/'/g, "'\\''") + "/' \"$settings_file\"\n"
                    + "        else\n"
                    + "            if grep -q '\\[Settings\\]' \"$settings_file\"; then\n"
                    + "                sed -i '/\\[Settings\\]/a gtk-cursor-theme-name=" + cursorThemeName.replace(/'/g, "'\\''") + "' \"$settings_file\"\n"
                    + "            else\n"
                    + "                echo -e '\\n[Settings]\\ngtk-cursor-theme-name=" + cursorThemeName.replace(/'/g, "'\\''") + "' >> \"$settings_file\"\n"
                    + "            fi\n"
                    + "        fi\n"
                    + "        # Update cursor size\n"
                    + "        if grep -q '^gtk-cursor-theme-size=' \"$settings_file\"; then\n"
                    + "            sed -i 's/^gtk-cursor-theme-size=.*/gtk-cursor-theme-size=" + cursorSizeValue + "/' \"$settings_file\"\n"
                    + "        else\n"
                    + "            if grep -q '\\[Settings\\]' \"$settings_file\"; then\n"
                    + "                sed -i '/\\[Settings\\]/a gtk-cursor-theme-size=" + cursorSizeValue + "' \"$settings_file\"\n"
                    + "            fi\n"
                    + "        fi\n"
                    + "    else\n"
                    + "        # Create new settings.ini file\n"
                    + "        echo -e '[Settings]\\ngtk-cursor-theme-name=" + cursorThemeName.replace(/'/g, "'\\''") + "\\ngtk-cursor-theme-size=" + cursorSizeValue + "' > \"$settings_file\"\n"
                    + "    fi\n"
                    + "    echo \"Updated $settings_file\"\n"
                    + "done\n"
                    + "\n"
                    + "# Update X11 cursor theme\n"
                    + "xresources_file=" + home + "/.Xresources\n"
                    + "if [ -f \"$xresources_file\" ]; then\n"
                    + "    if grep -q '^Xcursor\\.theme:' \"$xresources_file\"; then\n"
                    + "        sed -i \"s/^Xcursor\\.theme:.*/Xcursor.theme: " + cursorThemeName.replace(/[.\\]/g, "\\$&") + "/\" \"$xresources_file\"\n"
                    + "    else\n"
                    + "        echo \"Xcursor.theme: " + cursorThemeName.replace(/[.\\]/g, "\\$&") + "\" >> \"$xresources_file\"\n"
                    + "    fi\n"
                    + "    if grep -q '^Xcursor\\.size:' \"$xresources_file\"; then\n"
                    + "        sed -i \"s/^Xcursor\\.size:.*/Xcursor.size: " + cursorSizeValue + "/\" \"$xresources_file\"\n"
                    + "    else\n"
                    + "        echo \"Xcursor.size: " + cursorSizeValue + "\" >> \"$xresources_file\"\n"
                    + "    fi\n"
                    + "    # Apply Xresources changes\n"
                    + "    if command -v xrdb >/dev/null 2>&1; then\n"
                    + "        xrdb -merge \"$xresources_file\"\n"
                    + "    fi\n"
                    + "else\n"
                    + "    echo \"Xcursor.theme: " + cursorThemeName.replace(/[.\\]/g, "\\$&") + "\" > \"$xresources_file\"\n"
                    + "    echo \"Xcursor.size: " + cursorSizeValue + "\" >> \"$xresources_file\"\n"
                    + "    if command -v xrdb >/dev/null 2>&1; then\n"
                    + "        xrdb -merge \"$xresources_file\"\n"
                    + "    fi\n"
                    + "fi\n"
                    + "\n"
                    + "# Update GTK2 config\n"
                    + "gtk2_file=" + home + "/.gtkrc-2.0\n"
                    + "if [ ! -f \"$gtk2_file\" ]; then\n"
                    + "    echo 'gtk-cursor-theme-name=" + escapedTheme + "' > \"$gtk2_file\"\n"
                    + "    echo 'gtk-cursor-theme-size=" + cursorSizeValue + "' >> \"$gtk2_file\"\n"
                    + "else\n"
                    + "    if grep -q '^gtk-cursor-theme-name=' \"$gtk2_file\"; then\n"
                    + "        sed -i 's/^gtk-cursor-theme-name=.*/gtk-cursor-theme-name=" + escapedTheme + "/' \"$gtk2_file\"\n"
                    + "    else\n"
                    + "        echo 'gtk-cursor-theme-name=" + escapedTheme + "' >> \"$gtk2_file\"\n"
                    + "    fi\n"
                    + "    if grep -q '^gtk-cursor-theme-size=' \"$gtk2_file\"; then\n"
                    + "        sed -i 's/^gtk-cursor-theme-size=.*/gtk-cursor-theme-size=" + cursorSizeValue + "/' \"$gtk2_file\"\n"
                    + "    else\n"
                    + "        echo 'gtk-cursor-theme-size=" + cursorSizeValue + "' >> \"$gtk2_file\"\n"
                    + "    fi\n"
                    + "fi\n"
            
            Quickshell.execDetached(["sh", "-lc", script])
        }
    }

    function applyStoredCursorTheme() {
        updateCursorTheme(cursorTheme, cursorSize)
    }

    function setUseOSLogo(enabled) {
        useOSLogo = enabled
        saveSettings()
    }

    function setOSLogoColorOverride(color) {
        osLogoColorOverride = color
        saveSettings()
    }

    function setOSLogoBrightness(brightness) {
        osLogoBrightness = brightness
        saveSettings()
    }

    function setOSLogoContrast(contrast) {
        osLogoContrast = contrast
        saveSettings()
    }

    function setUseCustomLauncherImage(enabled) {
        useCustomLauncherImage = enabled
        saveSettings()
    }

    function setCustomLauncherImagePath(path) {
        customLauncherImagePath = path
        saveSettings()
    }

    function setLauncherLogoSize(size) {
        launcherLogoSize = size
        saveSettings()
    }

    function setWallpaperDynamicTheming(enabled) {
        wallpaperDynamicTheming = enabled
        saveSettings()
    }

    function setFontFamily(family) {
        fontFamily = family
        saveSettings()
    }

    function setFontWeight(weight) {
        fontWeight = weight
        saveSettings()
    }

    function setMonoFontFamily(family) {
        monoFontFamily = family
        saveSettings()
    }

    function setFontScale(scale) {
        fontScale = scale
        saveSettings()
    }

    function setSettingsUiScale(scale) {
        var clamped = Math.max(0.7, Math.min(1.5, scale))
        settingsUiScale = clamped
        saveSettings()
    }

    function setGtkThemingEnabled(enabled) {
        gtkThemingEnabled = enabled
        saveSettings()
        if (enabled && typeof Theme !== "undefined") {
            Theme.generateSystemThemesFromCurrentTheme()
        }
    }

    function setQtThemingEnabled(enabled) {
        qtThemingEnabled = enabled
        saveSettings()
        if (enabled && typeof Theme !== "undefined") {
            Theme.generateSystemThemesFromCurrentTheme()
        }
    }

    function setShowDock(enabled) {
        showDock = enabled
        saveSettings()
    }

    function setDockWidgetsEnabled(enabled) {
        dockWidgetsEnabled = enabled
        saveSettings()
    }

    function setDockAutoHide(enabled) {
        dockAutoHide = enabled
        saveSettings()
    }

    function setDockGroupApps(enabled) {
        dockGroupApps = enabled
        saveSettings()
    }

    function setDockHideOnGames(enabled) {
        dockHideOnGames = enabled
        saveSettings()
    }

    function setDockExpandToScreen(enabled) {
        dockExpandToScreen = enabled
        saveSettings()
    }

    function setDockCenterApps(enabled) {
        dockCenterApps = enabled
        saveSettings()
    }

    function setDockBottomGap(gap) {
        dockBottomGap = gap
        saveSettings()
    }

    function setDockExclusiveZone(zone) {
        dockExclusiveZone = zone
        saveSettings()
    }

    function setDockLeftPadding(padding) {
        dockLeftPadding = padding
        saveSettings()
    }

    function setDockRightPadding(padding) {
        dockRightPadding = padding
        saveSettings()
    }

    function setDockTopPadding(padding) {
        dockTopPadding = padding
        saveSettings()
    }

    function setDockBottomPadding(padding) {
        dockBottomPadding = padding
        saveSettings()
    }

    function setDockTooltipsEnabled(enabled) {
        dockTooltipsEnabled = enabled
        saveSettings()
    }


    function setDockIconSize(size) {
        dockIconSize = size
        saveSettings()
    }

    function setDockPinnedAppsIconSize(size) {
        dockPinnedAppsIconSize = size
        saveSettings()
    }

    function setDockScale(scale) {
        dockScale = scale
        saveSettings()
    }

    function setTaskbarScale(scale) {
        taskbarScale = scale
        saveSettings()
    }

    function setTaskbarIconSize(size) {
        taskbarIconSize = size
        saveSettings()
    }

    function setTaskbarIconSpacing(spacing) {
        taskbarIconSpacing = spacing
        saveSettings()
    }

    function setTopbarScale(scale) {
        topbarScale = scale
        saveSettings()
    }

    function setTopbarIconSize(size) {
        topbarIconSize = size
        saveSettings()
    }

    function setTopbarIconSpacing(spacing) {
        topbarIconSpacing = spacing
        saveSettings()
    }

    function setDockIconSpacing(spacing) {
        dockIconSpacing = spacing
        saveSettings()
    }

    function setDockPinnedAppsIconSpacing(spacing) {
        dockPinnedAppsIconSpacing = spacing
        saveSettings()
    }

    function setDockPinnedAppsPillEnabled(enabled) {
        dockPinnedAppsPillEnabled = enabled
        saveSettings()
    }

    function setDockTrashPillEnabled(enabled) {
        dockTrashPillEnabled = enabled
        saveSettings()
    }

    function setDockLaunchpadPillEnabled(enabled) {
        dockLaunchpadPillEnabled = enabled
        saveSettings()
    }

    function setDockWidgetAreaOpacity(opacity) {
        dockWidgetAreaOpacity = opacity
        saveSettings()
    }

    function setDockBackgroundTintOpacity(opacity) {
        dockBackgroundTintOpacity = opacity
        saveSettings()
    }

    function setDockCollapsedHeight(height) {
        dockCollapsedHeight = height
        saveSettings()
    }

    function setDockSlideDistance(distance) {
        dockSlideDistance = distance
        saveSettings()
    }

    function setDockAnimationDuration(ms) {
        dockAnimationDuration = ms
        saveSettings()
    }

    function setDockLeftWidgetAreaMinWidth(width) {
        dockLeftWidgetAreaMinWidth = width
        saveSettings()
    }

    function setDockRightWidgetAreaMinWidth(width) {
        dockRightWidgetAreaMinWidth = width
        saveSettings()
    }

    function setCornerRadius(radius) {
        cornerRadius = radius
        saveSettings()
    }

    function setHyprlandBlurSize(size) {
        hyprlandBlurSize = size
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyBlurSettings(hyprlandBlurSize, hyprlandBlurPasses)
            CompositorService.updateBlurConfigSize(hyprlandBlurSize)
        }
    }

    function setHyprlandBlurPasses(passes) {
        hyprlandBlurPasses = passes
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyBlurSettings(hyprlandBlurSize, hyprlandBlurPasses)
            CompositorService.updateBlurConfigPasses(hyprlandBlurPasses)
        }
    }

    function setHyprlandThemingEnabled(enabled) {
        hyprlandThemingEnabled = enabled
        saveSettings()
        if (enabled) {
            updateHyprlandBorderColors()
        }
    }

    function setHyprlandBorderSize(size) {
        hyprlandBorderSize = size
        saveSettings()
        updateHyprlandBorderSize(size)
    }

    function updateHyprlandBorderSize(size) {
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyBorderSize(size)
        }
    }

    function setHyprlandBorderHue(hue) {
        hyprlandBorderHue = hue
        saveSettings()
        updateHyprlandBorderColors()
    }

    function setHyprlandBorderAlpha(alpha) {
        hyprlandBorderAlpha = alpha
        saveSettings()
        updateHyprlandBorderColors()
    }

    function updateHyprlandBorderColors() {
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyBorderColors(hyprlandBorderHue, hyprlandBorderAlpha)
        }
    }

    // Decoration setters
    function setHyprlandDecorationRounding(rounding) {
        hyprlandDecorationRounding = rounding
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationRounding(rounding)
        }
    }

    function setHyprlandDecorationRoundingPower(power) {
        hyprlandDecorationRoundingPower = power
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationRoundingPower(power)
        }
    }

    function setHyprlandDecorationBlurEnabled(enabled) {
        hyprlandDecorationBlurEnabled = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurEnabled(enabled)
        }
    }

    function setHyprlandDecorationBlurXray(xray) {
        hyprlandDecorationBlurXray = xray
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurXray(xray)
        }
    }

    function setHyprlandDecorationBlurSpecial(special) {
        hyprlandDecorationBlurSpecial = special
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurSpecial(special)
        }
    }

    function setHyprlandDecorationBlurNewOptimizations(optimizations) {
        hyprlandDecorationBlurNewOptimizations = optimizations
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurNewOptimizations(optimizations)
        }
    }

    function setHyprlandDecorationBlurIgnoreOpacity(ignore) {
        hyprlandDecorationBlurIgnoreOpacity = ignore
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurIgnoreOpacity(ignore)
        }
    }

    function setHyprlandDecorationBlurSize(size) {
        hyprlandDecorationBlurSize = size
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurSize(size)
        }
    }

    function setHyprlandDecorationBlurPasses(passes) {
        hyprlandDecorationBlurPasses = passes
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurPasses(passes)
        }
    }

    function setHyprlandDecorationBlurBrightness(brightness) {
        hyprlandDecorationBlurBrightness = brightness
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurBrightness(brightness)
        }
    }

    function setHyprlandDecorationBlurNoise(noise) {
        hyprlandDecorationBlurNoise = noise
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurNoise(noise)
        }
    }

    function setHyprlandDecorationBlurContrast(contrast) {
        hyprlandDecorationBlurContrast = contrast
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurContrast(contrast)
        }
    }

    function setHyprlandDecorationBlurVibrancy(vibrancy) {
        hyprlandDecorationBlurVibrancy = vibrancy
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurVibrancy(vibrancy)
        }
    }

    function setHyprlandDecorationBlurVibrancyDarkness(vibrancyDarkness) {
        hyprlandDecorationBlurVibrancyDarkness = vibrancyDarkness
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurVibrancyDarkness(vibrancyDarkness)
        }
    }

    function setHyprlandDecorationBlurBrightnessEnabled(enabled) {
        hyprlandDecorationBlurBrightnessEnabled = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurBrightnessEnabled(enabled)
        }
    }

    function setHyprlandDecorationBlurContrastEnabled(enabled) {
        hyprlandDecorationBlurContrastEnabled = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurContrastEnabled(enabled)
        }
    }

    function setHyprlandDecorationBlurPopups(popups) {
        hyprlandDecorationBlurPopups = popups
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurPopups(popups)
        }
    }

    function setHyprlandDecorationBlurPopupsIgnorealpha(alpha) {
        hyprlandDecorationBlurPopupsIgnorealpha = alpha
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurPopupsIgnorealpha(alpha)
        }
    }

    function setHyprlandDecorationBlurInputMethods(inputMethods) {
        hyprlandDecorationBlurInputMethods = inputMethods
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurInputMethods(inputMethods)
        }
    }

    function setHyprlandDecorationBlurInputMethodsIgnorealpha(alpha) {
        hyprlandDecorationBlurInputMethodsIgnorealpha = alpha
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationBlurInputMethodsIgnorealpha(alpha)
        }
    }

    function setHyprlandDecorationShadowEnabled(enabled) {
        hyprlandDecorationShadowEnabled = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationShadowEnabled(enabled)
        }
    }

    function setHyprlandDecorationShadowIgnoreWindow(ignore) {
        hyprlandDecorationShadowIgnoreWindow = ignore
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationShadowIgnoreWindow(ignore)
        }
    }

    function setHyprlandDecorationShadowRange(range) {
        hyprlandDecorationShadowRange = range
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationShadowRange(range)
        }
    }

    function setHyprlandDecorationShadowOffset(offset) {
        hyprlandDecorationShadowOffset = offset
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            // Note: offset is stored as string, no direct function needed
        }
    }

    function setHyprlandDecorationShadowRenderPower(power) {
        hyprlandDecorationShadowRenderPower = power
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationShadowRenderPower(power)
        }
    }

    function setHyprlandDecorationShadowColor(color) {
        hyprlandDecorationShadowColor = color
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationShadowColor(color)
        }
    }

    function setHyprlandDecorationDimInactive(inactive) {
        hyprlandDecorationDimInactive = inactive
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationDimInactive(inactive)
        }
    }

    function setHyprlandDecorationDimStrength(strength) {
        hyprlandDecorationDimStrength = strength
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationDimStrength(strength)
        }
    }

    function setHyprlandDecorationDimSpecial(special) {
        hyprlandDecorationDimSpecial = special
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyDecorationDimSpecial(special)
        }
    }

    function setHyprlandInputKbLayout(layout) {
        hyprlandInputKbLayout = layout
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("kb_layout", layout)
        }
    }

    function setHyprlandInputKbVariant(variant) {
        hyprlandInputKbVariant = variant
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("kb_variant", variant)
        }
    }

    function setHyprlandInputKbModel(model) {
        hyprlandInputKbModel = model
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("kb_model", model)
        }
    }

    function setHyprlandInputKbOptions(options) {
        hyprlandInputKbOptions = options
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("kb_options", options)
        }
    }

    function setHyprlandInputKbRules(rules) {
        hyprlandInputKbRules = rules
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("kb_rules", rules)
        }
    }

    function setHyprlandInputRepeatRate(rate) {
        hyprlandInputRepeatRate = rate
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("repeat_rate", rate)
        }
    }

    function setHyprlandInputRepeatDelay(delay) {
        hyprlandInputRepeatDelay = delay
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("repeat_delay", delay)
        }
    }

    function setHyprlandInputNumlockByDefault(enabled) {
        hyprlandInputNumlockByDefault = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("numlock_by_default", enabled ? "true" : "false")
        }
    }

    function setHyprlandInputFollowMouse(mode) {
        hyprlandInputFollowMouse = mode
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("follow_mouse", mode)
        }
    }

    function setHyprlandInputFollowMouseThreshold(threshold) {
        hyprlandInputFollowMouseThreshold = threshold
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("follow_mouse_threshold", threshold)
        }
    }

    function setHyprlandInputSensitivity(sensitivity) {
        hyprlandInputSensitivity = sensitivity
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("sensitivity", sensitivity)
        }
    }

    function setHyprlandInputAccelProfile(profile) {
        hyprlandInputAccelProfile = profile
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("accel_profile", profile)
        }
    }

    function setHyprlandInputNaturalScroll(enabled) {
        hyprlandInputNaturalScroll = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("natural_scroll", enabled ? "true" : "false")
        }
    }

    function setHyprlandInputLeftHanded(enabled) {
        hyprlandInputLeftHanded = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandInputSetting("left_handed", enabled ? "true" : "false")
        }
    }

    function getHyprlandInputDeviceRotation(deviceName) {
        if (!deviceName) {
            return 0
        }
        var rotations = hyprlandInputDeviceRotations || ({})
        var value = rotations[deviceName]
        return value !== undefined ? value : 0
    }

    function setHyprlandInputDeviceRotation(deviceName, rotation) {
        if (!deviceName) {
            return
        }
        var rotations = hyprlandInputDeviceRotations || ({})
        rotations[deviceName] = rotation
        hyprlandInputDeviceRotations = rotations
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandInputDeviceRotation(deviceName, rotation)
        }
    }

    function setHyprlandSnapEnabled(enabled) {
        hyprlandSnapEnabled = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandSnapEnabled(enabled)
        }
    }

    function setHyprlandSnapWindowGap(value) {
        hyprlandSnapWindowGap = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandSnapWindowGap(value)
        }
    }

    function setHyprlandSnapMonitorGap(value) {
        hyprlandSnapMonitorGap = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandSnapMonitorGap(value)
        }
    }

    function setHyprlandSnapBorderOverlap(enabled) {
        hyprlandSnapBorderOverlap = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandSnapBorderOverlap(enabled)
        }
    }

    function setHyprlandSnapRespectGaps(enabled) {
        hyprlandSnapRespectGaps = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandSnapRespectGaps(enabled)
        }
    }

    function setHyprlandGeneralGapsIn(value) {
        hyprlandGeneralGapsIn = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGeneralGapsIn(value)
        }
    }

    function setHyprlandGeneralGapsOut(value) {
        hyprlandGeneralGapsOut = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGeneralGapsOut(value)
        }
    }

    function setHyprlandGeneralGapsWorkspaces(value) {
        hyprlandGeneralGapsWorkspaces = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGeneralGapsWorkspaces(value)
        }
    }

    function setHyprlandGeneralBorderSize(value) {
        hyprlandGeneralBorderSize = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGeneralBorderSize(value)
        }
    }

    function setHyprlandGeneralResizeOnBorder(enabled) {
        hyprlandGeneralResizeOnBorder = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGeneralResizeOnBorder(enabled)
        }
    }

    function setHyprlandGeneralNoFocusFallback(enabled) {
        hyprlandGeneralNoFocusFallback = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGeneralNoFocusFallback(enabled)
        }
    }

    function setHyprlandGeneralAllowTearing(enabled) {
        hyprlandGeneralAllowTearing = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGeneralAllowTearing(enabled)
        }
    }

    function setHyprlandGroupbarEnabled(enabled) {
        hyprlandGroupbarEnabled = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGroupbarEnabled(enabled)
        }
    }

    function setHyprlandGroupbarColActive(value) {
        hyprlandGroupbarColActive = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGroupbarColActive(value)
        }
    }

    function setHyprlandGroupbarColInactive(value) {
        hyprlandGroupbarColInactive = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGroupbarColInactive(value)
        }
    }

    function setHyprlandGroupbarHeight(value) {
        hyprlandGroupbarHeight = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGroupbarHeight(value)
        }
    }

    function setHyprlandGroupbarPriority(value) {
        hyprlandGroupbarPriority = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGroupbarPriority(value)
        }
    }

    function setHyprlandGroupbarRenderTitles(enabled) {
        hyprlandGroupbarRenderTitles = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGroupbarRenderTitles(enabled)
        }
    }

    function setHyprlandGroupbarFontFamily(value) {
        hyprlandGroupbarFontFamily = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGroupbarFontFamily(value)
        }
    }

    function setHyprlandGroupbarFontSize(value) {
        hyprlandGroupbarFontSize = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGroupbarFontSize(value)
        }
    }

    function setHyprlandGroupbarGradients(enabled) {
        hyprlandGroupbarGradients = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGroupbarGradients(enabled)
        }
    }

    function setHyprlandGroupbarTextColor(value) {
        hyprlandGroupbarTextColor = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGroupbarTextColor(value)
        }
    }

    function setHyprlandGroupbarRounding(value) {
        hyprlandGroupbarRounding = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandGroupbarRounding(value)
        }
    }

    function setHyprlandDwindlePreserveSplit(enabled) {
        hyprlandDwindlePreserveSplit = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandDwindlePreserveSplit(enabled)
        }
    }

    function setHyprlandDwindleSmartSplit(enabled) {
        hyprlandDwindleSmartSplit = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandDwindleSmartSplit(enabled)
        }
    }

    function setHyprlandDwindleSmartResizing(enabled) {
        hyprlandDwindleSmartResizing = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyHyprlandDwindleSmartResizing(enabled)
        }
    }

    // Render setters
    function setHyprlandRenderNewScheduling(scheduling) {
        hyprlandRenderNewScheduling = scheduling
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyRenderNewScheduling(scheduling)
        }
    }

    function setHyprlandRenderCmFsPassthrough(passthrough) {
        hyprlandRenderCmFsPassthrough = passthrough
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyRenderCmFsPassthrough(passthrough)
        }
    }

    function setHyprlandRenderCmEnabled(enabled) {
        hyprlandRenderCmEnabled = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyRenderCmEnabled(enabled)
        }
    }

    function setHyprlandRenderSendContentType(send) {
        hyprlandRenderSendContentType = send
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyRenderSendContentType(send)
        }
    }

    function setHyprlandRenderCmAutoHdr(hdr) {
        hyprlandRenderCmAutoHdr = hdr
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyRenderCmAutoHdr(hdr)
        }
    }

    function setHyprlandRenderDirectScanout(scanout) {
        hyprlandRenderDirectScanout = scanout
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyRenderDirectScanout(scanout)
        }
    }

    function setHyprlandRenderExpandUndersizedTextures(enabled) {
        hyprlandRenderExpandUndersizedTextures = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland && hyprlandThemingEnabled) {
            CompositorService.applyRenderExpandUndersizedTextures(enabled)
        }
    }

    // Cursor setters
    function setHyprlandCursorNoHardwareCursors(value) {
        hyprlandCursorNoHardwareCursors = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("no_hardware_cursors", value)
        }
    }

    function setHyprlandCursorNoBreakFsVrr(value) {
        hyprlandCursorNoBreakFsVrr = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("no_break_fs_vrr", value)
        }
    }

    function setHyprlandCursorMinRefreshRate(value) {
        hyprlandCursorMinRefreshRate = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("min_refresh_rate", value)
        }
    }

    function setHyprlandCursorHotspotPadding(value) {
        hyprlandCursorHotspotPadding = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("hotspot_padding", value)
        }
    }

    function setHyprlandCursorInactiveTimeout(value) {
        hyprlandCursorInactiveTimeout = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("inactive_timeout", value)
        }
    }

    function setHyprlandCursorNoWarps(enabled) {
        hyprlandCursorNoWarps = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("no_warps", enabled ? "true" : "false")
        }
    }

    function setHyprlandCursorPersistentWarps(enabled) {
        hyprlandCursorPersistentWarps = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("persistent_warps", enabled ? "true" : "false")
        }
    }

    function setHyprlandCursorWarpOnChangeWorkspace(value) {
        hyprlandCursorWarpOnChangeWorkspace = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("warp_on_change_workspace", value)
        }
    }

    function setHyprlandCursorWarpOnToggleSpecial(value) {
        hyprlandCursorWarpOnToggleSpecial = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("warp_on_toggle_special", value)
        }
    }

    function setHyprlandCursorDefaultMonitor(value) {
        hyprlandCursorDefaultMonitor = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("default_monitor", value)
        }
    }

    function setHyprlandCursorZoomFactor(value) {
        hyprlandCursorZoomFactor = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("zoom_factor", value)
        }
    }

    function setHyprlandCursorZoomRigid(enabled) {
        hyprlandCursorZoomRigid = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("zoom_rigid", enabled ? "true" : "false")
        }
    }

    function setHyprlandCursorZoomDetachedCamera(enabled) {
        hyprlandCursorZoomDetachedCamera = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("zoom_detached_camera", enabled ? "true" : "false")
        }
    }

    function setHyprlandCursorEnableHyprcursor(enabled) {
        hyprlandCursorEnableHyprcursor = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("enable_hyprcursor", enabled ? "true" : "false")
        }
    }

    function setHyprlandCursorHideOnKeyPress(enabled) {
        hyprlandCursorHideOnKeyPress = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("hide_on_key_press", enabled ? "true" : "false")
        }
    }

    function setHyprlandCursorHideOnTouch(enabled) {
        hyprlandCursorHideOnTouch = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("hide_on_touch", enabled ? "true" : "false")
        }
    }

    function setHyprlandCursorHideOnTablet(enabled) {
        hyprlandCursorHideOnTablet = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("hide_on_tablet", enabled ? "true" : "false")
        }
    }

    function setHyprlandCursorUseCpuBuffer(value) {
        hyprlandCursorUseCpuBuffer = value
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("use_cpu_buffer", value)
        }
    }

    function setHyprlandCursorWarpBackAfterNonMouseInput(enabled) {
        hyprlandCursorWarpBackAfterNonMouseInput = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("warp_back_after_non_mouse_input", enabled ? "true" : "false")
        }
    }

    function setHyprlandCursorZoomDisableAa(enabled) {
        hyprlandCursorZoomDisableAa = enabled
        saveSettings()
        if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
            CompositorService.applyHyprlandCursorSetting("zoom_disable_aa", enabled ? "true" : "false")
        }
    }

    function setNotificationOverlayEnabled(enabled) {
        notificationOverlayEnabled = enabled
        saveSettings()
    }

    function setTopBarAutoHide(enabled) {
        topBarAutoHide = enabled
        saveSettings()
    }

    function setTopBarOpenOnOverview(enabled) {
        topBarOpenOnOverview = enabled
        saveSettings()
    }

    function setTopBarVisible(visible) {
        topBarVisible = visible
        saveSettings()
    }

    function toggleTopBarVisible() {
        topBarVisible = !topBarVisible
        saveSettings()
    }

    function setNotificationTimeoutLow(timeout) {
        notificationTimeoutLow = timeout
        saveSettings()
    }

    function setNotificationTimeoutNormal(timeout) {
        notificationTimeoutNormal = timeout
        saveSettings()
    }

    function setNotificationTimeoutCritical(timeout) {
        notificationTimeoutCritical = timeout
        saveSettings()
    }

    function setTopBarSpacing(spacing) {
        topBarSpacing = spacing
        saveSettings()
    }

    function setTopBarBottomGap(gap) {
        topBarBottomGap = gap
        saveSettings()
    }

    function setTopBarInnerPadding(padding) {
        topBarInnerPadding = padding
        saveSettings()
    }

    function setTopBarSquareCorners(enabled) {
        topBarSquareCorners = enabled
        saveSettings()
    }

    function setTopBarNoBackground(enabled) {
        topBarNoBackground = enabled
        saveSettings()
    }

    function setTopBarGothCornersEnabled(enabled) {
        topBarGothCornersEnabled = enabled
        saveSettings()
    }

    function setLockScreenShowPowerActions(enabled) {
        lockScreenShowPowerActions = enabled
        saveSettings()
    }

    function setHideBrightnessSlider(enabled) {
        hideBrightnessSlider = enabled
        saveSettings()
    }

    function setWidgetBackgroundColor(color) {
        widgetBackgroundColor = color
        saveSettings()
    }

    function setScreenPreferences(prefs) {
        screenPreferences = prefs
        saveSettings()
    }

    function setDesktopWidgetsScreen(screenName) {
        var prefs = screenPreferences || {}
        prefs["desktopWidgets"] = [screenName]
        screenPreferences = prefs
        saveSettings()
    }

    function getFilteredScreens(componentId) {
        var prefs = screenPreferences && screenPreferences[componentId] || ["all"]
        if (prefs.includes("all")) {
            return Quickshell.screens
        }
        return Quickshell.screens.filter(screen => prefs.includes(screen.name))
    }

    function _shq(s) {
        return "'" + String(s).replace(/'/g, "'\\''") + "'"
    }

    function updateDefaultFontFamily() {
        var available = Qt.fontFamilies()
        var preferred = available.includes("Inter Variable")
            ? "Inter Variable"
            : (available.includes("Inter") ? "Inter" : "Inter Variable")
        if (defaultFontFamily !== preferred) {
            var previousDefault = defaultFontFamily
            defaultFontFamily = preferred
            if (!_loading && fontFamily === previousDefault) {
                fontFamily = defaultFontFamily
            }
        }
        var preferredMono = available.includes("Fira Code") ? "Fira Code" : defaultMonoFontFamily
        if (defaultMonoFontFamily !== preferredMono) {
            var previousMono = defaultMonoFontFamily
            defaultMonoFontFamily = preferredMono
            if (!_loading && monoFontFamily === previousMono) {
                monoFontFamily = defaultMonoFontFamily
            }
        }
    }

    function loadBundledFonts(paths) {
        if (!paths || paths.length === 0) {
            return
        }
        for (var i = 0; i < paths.length; i++) {
            var rawPath = String(paths[i] || "").trim()
            if (!rawPath || bundledFontPaths.includes(rawPath)) {
                continue
            }
            bundledFontPaths.push(rawPath)
            var fileUrl = rawPath.startsWith("file:") ? rawPath : ("file://" + rawPath)
            var sourceLiteral = JSON.stringify(fileUrl)
            var loader = Qt.createQmlObject("import QtQuick; FontLoader { source: " + sourceLiteral + " }", root)
            bundledFontLoaders.push(loader)
        }
        updateDefaultFontFamily()
    }

    Component.onCompleted: {
        loadSettings()
        bundledFontsScanProcess.running = true
        updateDefaultFontFamily()
        fontCheckTimer.start()
        initializeListModels()
        terminalDetectionProcess.running = true
        aurHelperDetectionProcess.running = true
        detectAvailableGtkThemes()
        detectAvailableQtThemes()
        detectAvailableShellThemes()
        detectAvailableCursorThemes()
        Qt.callLater(migrateDesktopWidgetsFromOldSystem)
        
        if (!screenPreferences || !screenPreferences["desktopWidgets"]) {
            setDesktopWidgetsScreen("DP-2");
        }
        
        Qt.callLater(function() {
            if (typeof CompositorService !== 'undefined' && CompositorService.isHyprland) {
                CompositorService.applyBlurSettings(hyprlandBlurSize, hyprlandBlurPasses)
            }
        })
        
        if (launcherLogoAutoSync) {
            Qt.callLater(() => {
                syncLauncherLogoWithWallpaper()
            })
        }
    }

    Connections {
        target: typeof Theme !== "undefined" ? Theme : null
        function onColorUpdateTriggerChanged() {
            if (launcherLogoAutoSync) {
                Qt.callLater(() => {
                    syncLauncherLogoWithWallpaper()
                })
            }
        }
    }

    Connections {
        target: typeof ColorPaletteService !== "undefined" ? ColorPaletteService : null
        function onColorsExtracted() {
            if (launcherLogoAutoSync) {
                Qt.callLater(() => {
                    syncLauncherLogoWithWallpaper()
                })
            }
        }
    }

    Connections {
        target: typeof SessionData !== "undefined" ? SessionData : null
        function onWallpaperPathChanged() {
            if (launcherLogoAutoSync) {
                Qt.callLater(() => {
                    Qt.callLater(() => {
                        syncLauncherLogoWithWallpaper()
                    })
                })
            }
        }
    }

    onLauncherLogoAutoSyncChanged: {
        if (launcherLogoAutoSync) {
            syncLauncherLogoWithWallpaper()
        }
    }

    ListModel {
        id: leftWidgetsModel
    }

    ListModel {
        id: centerWidgetsModel
    }

    ListModel {
        id: rightWidgetsModel
    }

    ListModel {
        id: dockLeftWidgetsModel
    }

    ListModel {
        id: dockCenterWidgetsModel
    }

    ListModel {
        id: dockRightWidgetsModel
    }

    ListModel {
        id: taskBarLeftWidgetsModel
    }

    ListModel {
        id: taskBarCenterWidgetsModel
    }

    ListModel {
        id: taskBarRightWidgetsModel
    }

    Timer {
        id: fontCheckTimer

        interval: 3000
        repeat: false
        onTriggered: {
            var availableFonts = Qt.fontFamilies()
            var missingFonts = []
            if (fontFamily === defaultFontFamily && !availableFonts.includes(defaultFontFamily))
            missingFonts.push(defaultFontFamily)

            if (monoFontFamily === defaultMonoFontFamily && !availableFonts.includes(defaultMonoFontFamily))
            missingFonts.push(defaultMonoFontFamily)

            if (missingFonts.length > 0) {
                var message = "Missing fonts: " + missingFonts.join(", ") + ". Using system defaults."
                ToastService.showWarning(message)
            }
        }
    }

    Process {
        id: bundledFontsScanProcess

        command: ["sh", "-c", "if [ -d " + _shq(bundledFontsDir) + " ]; then find " + _shq(bundledFontsDir) + " -type f \\( -iname '*.otf' -o -iname '*.ttf' \\) | sort; fi"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                if (!text || !text.trim()) {
                    return
                }
                var lines = text.trim().split("\n")
                loadBundledFonts(lines)
            }
        }
    }

    property bool hasTriedDefaultSettings: false

    FileView {
        id: settingsFile

        path: `${StandardPaths.writableLocation(StandardPaths.ConfigLocation)}/DarkMaterialShell/settings.json`
        blockLoading: true
        blockWrites: true
        atomicWrites: true
        watchChanges: true
        onLoaded: {
            parseSettings(settingsFile.text())
            hasTriedDefaultSettings = false
        }
        onLoadFailed: error => {
            if (!hasTriedDefaultSettings) {
                hasTriedDefaultSettings = true
                defaultSettingsCheckProcess.running = true
            } else {
                applyStoredTheme()
            }
        }
    }

    Process {
        id: systemDefaultDetectionProcess

        command: ["sh", "-c", "gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | sed \"s/'//g\" || echo ''"]
        running: false
        onExited: exitCode => {
            if (exitCode === 0 && stdout && stdout.length > 0)
            systemDefaultIconTheme = stdout.trim()
            else
            systemDefaultIconTheme = ""
            iconThemeDetectionProcess.running = true
        }
    }

    Process {
        id: iconThemeDetectionProcess

        command: ["sh", "-c", "find /usr/share/icons ~/.local/share/icons ~/.icons -maxdepth 1 -type d 2>/dev/null | sed 's|.*/||' | grep -v '^icons$' | sort -u"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                var detectedThemes = ["System Default"]
                if (text && text.trim()) {
                    var themes = text.trim().split('\n')
                    for (var i = 0; i < themes.length; i++) {
                        var theme = themes[i].trim()
                        if (theme && theme !== "" && theme !== "default" && theme !== "hicolor" && theme !== "locolor")
                        detectedThemes.push(theme)
                    }
                }
                availableIconThemes = detectedThemes
            }
        }
    }

    Process {
        id: qtToolsDetectionProcess

        command: ["sh", "-c", "echo -n 'qt5ct:'; command -v qt5ct >/dev/null && echo 'true' || echo 'false'; echo -n 'qt6ct:'; command -v qt6ct >/dev/null && echo 'true' || echo 'false'; echo -n 'gtk:'; (command -v gsettings >/dev/null || command -v dconf >/dev/null) && echo 'true' || echo 'false'"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                if (text && text.trim()) {
                    var lines = text.trim().split('\n')
                    for (var i = 0; i < lines.length; i++) {
                        var line = lines[i]
                        if (line.startsWith('qt5ct:'))
                        qt5ctAvailable = line.split(':')[1] === 'true'
                        else if (line.startsWith('qt6ct:'))
                        qt6ctAvailable = line.split(':')[1] === 'true'
                        else if (line.startsWith('gtk:'))
                        gtkAvailable = line.split(':')[1] === 'true'
                    }
                }
            }
        }
    }

    Process {
        id: systemDefaultGtkThemeProcess
        
        command: ["sh", "-c", "gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | sed \"s/'//g\" || echo ''"]
        running: false
        onExited: exitCode => {
            if (exitCode === 0 && stdout && stdout.length > 0)
                systemDefaultGtkTheme = stdout.trim()
            else
                systemDefaultGtkTheme = ""
            gtkThemeDetectionProcess.running = true
        }
    }

    Process {
        id: gtkThemeDetectionProcess
        
        command: ["sh", "-c", "for dir in /usr/share/themes ~/.local/share/themes ~/.themes; do [ -d \"$dir\" ] && find \"$dir\" -maxdepth 1 -type d -exec sh -c 'test -d \"$1/gtk-3.0\" || test -d \"$1/gtk-4.0\"' _ {} \\; -print 2>/dev/null; done | sed 's|.*/||' | sort -u"]
        running: false
        
        stdout: StdioCollector {
            onStreamFinished: {
                var detectedThemes = ["System Default"]
                if (text && text.trim()) {
                    var themes = text.trim().split('\n')
                    for (var i = 0; i < themes.length; i++) {
                        var theme = themes[i].trim()
                        if (theme && theme !== "" && theme !== "default" && theme !== "hicolor" && theme !== "locolor") {
                            detectedThemes.push(theme)
                        }
                    }
                }
                availableGtkThemes = detectedThemes
            }
        }
    }

    Process {
        id: systemDefaultQtThemeProcess
        
        command: ["sh", "-c", "qt5_theme=\"\"; qt6_theme=\"\"; if [ -f ~/.config/qt5ct/qt5ct.conf ]; then qt5_theme=$(grep '^style=' ~/.config/qt5ct/qt5ct.conf 2>/dev/null | cut -d'=' -f2 | tr -d ' ' | head -n1); fi; if [ -f ~/.config/qt6ct/qt6ct.conf ]; then qt6_theme=$(grep '^style=' ~/.config/qt6ct/qt6ct.conf 2>/dev/null | cut -d'=' -f2 | tr -d ' ' | head -n1); fi; if [ -n \"$qt6_theme\" ]; then echo \"$qt6_theme\"; elif [ -n \"$qt5_theme\" ]; then echo \"$qt5_theme\"; else echo ''; fi"]
        running: false
        onExited: exitCode => {
            if (exitCode === 0 && stdout && stdout.length > 0) {
                var theme = stdout.trim()
                systemDefaultQtTheme = theme || ""
            } else {
                systemDefaultQtTheme = ""
            }
            qtThemeDetectionProcess.running = true
        }
    }

    Process {
        id: qtThemeDetectionProcess
        
        command: ["sh", "-c", `
            themes="Fusion\\nWindows\\nWindowsVista\\nGTK+\\n"
            
            # Check qt5ct/qt6ct theme/style directories (standard KDE locations)
            # These directories may contain additional style plugins or themes
            for base_dir in /usr/share/qt5ct /usr/share/qt6ct ~/.local/share/qt5ct ~/.local/share/qt6ct; do
                if [ -d "$base_dir" ]; then
                    # Check for themes directory
                    if [ -d "$base_dir/themes" ]; then
                        qt_themes=$(find "$base_dir/themes" -maxdepth 1 -type d ! -path "$base_dir/themes" 2>/dev/null | sed 's|.*/||' | sort -u)
                        if [ -n "$qt_themes" ]; then
                            themes="$themes$qt_themes\\n"
                        fi
                    fi
                    # Check for styles directory (some installations use this)
                    if [ -d "$base_dir/styles" ]; then
                        qt_styles=$(find "$base_dir/styles" -maxdepth 1 -type d ! -path "$base_dir/styles" 2>/dev/null | sed 's|.*/||' | sort -u)
                        if [ -n "$qt_styles" ]; then
                            themes="$themes$qt_styles\\n"
                        fi
                    fi
                    # Check for plugins directory (may contain style plugins)
                    if [ -d "$base_dir/plugins" ]; then
                        qt_plugins=$(find "$base_dir/plugins" -maxdepth 1 -type d ! -path "$base_dir/plugins" 2>/dev/null | sed 's|.*/||' | sort -u)
                        if [ -n "$qt_plugins" ]; then
                            themes="$themes$qt_plugins\\n"
                        fi
                    fi
                fi
            done
            
            # Check for Kvantum themes (KDE's popular theme engine)
            if [ -d /usr/share/Kvantum ] || [ -d ~/.config/Kvantum ]; then
                kvantum_themes=$(find /usr/share/Kvantum ~/.config/Kvantum -maxdepth 1 -type d -name "Kv*" 2>/dev/null | sed 's|.*/||' | sort -u)
                if [ -n "$kvantum_themes" ]; then
                    themes="$themes$kvantum_themes\\n"
                fi
            fi
            
            # Also check KDE-specific locations for QT styles
            # KDE may install additional QT styles in these locations
            for kde_dir in /usr/share/qt5/plugins/styles /usr/share/qt6/plugins/styles ~/.local/share/qt5/plugins/styles ~/.local/share/qt6/plugins/styles; do
                if [ -d "$kde_dir" ]; then
                    kde_styles=$(find "$kde_dir" -maxdepth 1 -type f -name "*.so" 2>/dev/null | sed 's|.*/||' | sed 's|^libq||' | sed 's|style\\.so$||' | sed 's|Style\\.so$||' | sort -u)
                    if [ -n "$kde_styles" ]; then
                        themes="$themes$kde_styles\\n"
                    fi
                fi
            done
            
            # Check KDE Plasma theme directories
            # Plasma themes may include QT styles or be usable as QT theme names
            for plasma_dir in /usr/share/plasma/look-and-feel /usr/share/plasma/desktoptheme ~/.local/share/plasma/look-and-feel ~/.local/share/plasma/desktoptheme; do
                if [ -d "$plasma_dir" ]; then
                    # Extract theme names from Plasma directories
                    # Handle both simple names (MacTahoe-Dark) and app IDs (com.github.vinceliuice.MacTahoe-Dark)
                    plasma_themes=$(find "$plasma_dir" -maxdepth 1 -type d ! -path "$plasma_dir" 2>/dev/null | sed 's|.*/||' | while read theme_name; do
                        # If it's an app ID (contains dots), extract the last part after the last dot
                        if echo "$theme_name" | grep -q '\.'; then
                            echo "$theme_name" | sed 's|.*\.||'
                        else
                            echo "$theme_name"
                        fi
                    done | sort -u)
                    if [ -n "$plasma_themes" ]; then
                        themes="$themes$plasma_themes\\n"
                    fi
                fi
            done
            
            echo -e "$themes" | sort -u
        `]
        running: false
        
        stdout: StdioCollector {
            onStreamFinished: {
                var detectedThemes = ["System Default"]
                if (text && text.trim()) {
                    var themes = text.trim().split('\n')
                    for (var i = 0; i < themes.length; i++) {
                        var theme = themes[i].trim()
                        if (theme && theme !== "" && theme !== "default")
                            detectedThemes.push(theme)
                    }
                }
                availableQtThemes = detectedThemes
            }
        }
    }

    Process {
        id: userThemeExtensionCheckProcess
        
        command: ["sh", "-c", "if command -v gsettings >/dev/null 2>&1 && gsettings list-schemas | grep -q org.gnome.shell.extensions.user-theme; then echo 'available'; gsettings get org.gnome.shell.extensions.user-theme name 2>/dev/null | sed \"s/'//g\" || echo ''; else echo ''; fi"]
        running: false
        onExited: exitCode => {
            if (exitCode === 0 && stdout && stdout.length > 0) {
                var lines = stdout.trim().split('\n')
                if (lines.length > 0 && lines[0] === 'available') {
                    userThemeExtensionAvailable = true
                    if (lines.length > 1 && lines[1].trim() !== '') {
                        systemDefaultShellTheme = lines[1].trim()
                    } else {
                        systemDefaultShellTheme = ""
                    }
                    extensionEnabledCheckProcess.running = true
                } else {
                    userThemeExtensionAvailable = false
                    userThemeExtensionEnabled = false
                    systemDefaultShellTheme = ""
                    shellThemeDetectionProcess.running = true
                }
            } else {
                userThemeExtensionAvailable = false
                userThemeExtensionEnabled = false
                systemDefaultShellTheme = ""
                shellThemeDetectionProcess.running = true
            }
        }
    }

    Process {
        id: extensionEnabledCheckProcess
        
        command: ["sh", "-c", "gsettings get org.gnome.shell enabled-extensions 2>/dev/null | grep -o 'user-theme' | head -n1"]
        running: false
        onExited: exitCode => {
            if (exitCode === 0 && stdout && stdout.trim() === 'user-theme') {
                userThemeExtensionEnabled = true
            } else {
                userThemeExtensionEnabled = false
            }
            shellThemeDetectionProcess.running = true
        }
    }

    Process {
        id: shellThemeDetectionProcess
        
        command: ["sh", "-c", "for dir in /usr/share/themes ~/.local/share/themes ~/.themes; do [ -d \"$dir\" ] && find \"$dir\" -maxdepth 1 -type d -exec sh -c 'test -f \"$1/gnome-shell/gnome-shell.css\"' _ {} \\; -print 2>/dev/null; done | sed 's|.*/||' | sort -u"]
        running: false
        
        stdout: StdioCollector {
            onStreamFinished: {
                var detectedThemes = ["System Default"]
                if (text && text.trim()) {
                    var themes = text.trim().split('\n')
                    for (var i = 0; i < themes.length; i++) {
                        var theme = themes[i].trim()
                        if (theme && theme !== "" && theme !== "default" && theme !== "hicolor" && theme !== "locolor")
                            detectedThemes.push(theme)
                    }
                }
                availableShellThemes = detectedThemes
            }
        }
    }

    Process {
        id: systemDefaultCursorThemeProcess
        
        command: ["sh", "-c", "gsettings get org.gnome.desktop.interface cursor-theme 2>/dev/null | sed \"s/'//g\" || echo ''"]
        running: false
        onExited: exitCode => {
            if (exitCode === 0 && stdout && stdout.length > 0)
                systemDefaultCursorTheme = stdout.trim()
            else
                systemDefaultCursorTheme = ""
            cursorThemeDetectionProcess.running = true
        }
    }

    Process {
        id: cursorThemeDetectionProcess
        
        command: ["sh", "-c", "find /usr/share/icons ~/.local/share/icons ~/.icons -maxdepth 1 -type d -exec test -f {}/cursors/left_ptr \\; -print 2>/dev/null | sed 's|.*/||' | sort -u"]
        running: false
        
        stdout: StdioCollector {
            onStreamFinished: {
                var detectedThemes = ["System Default"]
                if (text && text.trim()) {
                    var themes = text.trim().split('\n')
                    for (var i = 0; i < themes.length; i++) {
                        var theme = themes[i].trim()
                        if (theme && theme !== "" && theme !== "default" && theme !== "hicolor" && theme !== "locolor")
                            detectedThemes.push(theme)
                    }
                }
                availableCursorThemes = detectedThemes
            }
        }
    }

    Process {
        id: defaultSettingsCheckProcess

        command: ["sh", "-c", "CONFIG_DIR=\"" + _configDir
            + "/DarkMaterialShell\"; if [ -f \"$CONFIG_DIR/default-settings.json\" ] && [ ! -f \"$CONFIG_DIR/settings.json\" ]; then cp \"$CONFIG_DIR/default-settings.json\" \"$CONFIG_DIR/settings.json\" && echo 'copied'; else echo 'not_found'; fi"]
        running: false
        onExited: exitCode => {
            if (exitCode === 0) {
                settingsFile.reload()
            } else {
                applyStoredTheme()
            }
        }
    }

    Process {
        id: terminalDetectionProcess

        command: ["sh", "-c", "for term in alacritty foot kitty konsole gnome-terminal xterm termite st wezterm tilde rxvt urxvt xfce4-terminal lxterminal mate-terminal qterminal ptyxis; do which $term 2>/dev/null && echo $term; done"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                var terminals = []
                if (text && text.trim()) {
                    var lines = text.trim().split('\n')
                    for (var i = 0; i < lines.length; i++) {
                        var term = lines[i].trim()
                        if (term && term !== "" && !terminals.includes(term)) {
                            terminals.push(term)
                        }
                    }
                }
                if (terminals.length === 0) {
                    terminals = ["xterm", "gnome-terminal", "konsole"]
                }
                availableTerminals = terminals
                
                if (!terminalEmulator || terminalEmulator === "") {
                    var envTerminal = Quickshell.env("TERMINAL") || ""
                    if (envTerminal && terminals.includes(envTerminal)) {
                        terminalEmulator = envTerminal
                    } else if (terminals.length > 0) {
                        var preferred = ["alacritty", "foot", "kitty", "wezterm", "xterm"]
                        for (var j = 0; j < preferred.length; j++) {
                            if (terminals.includes(preferred[j])) {
                                terminalEmulator = preferred[j]
                                break
                            }
                        }
                        if (!terminalEmulator || terminalEmulator === "") {
                            terminalEmulator = terminals[0]
                        }
                    }
                }
            }
        }
    }

    Process {
        id: aurHelperDetectionProcess

        command: ["sh", "-c", "for helper in yay paru trizen aurutils pikaur pakku paruz yay-bin; do which $helper 2>/dev/null && echo $helper; done"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                var helpers = []
                if (text && text.trim()) {
                    var lines = text.trim().split('\n')
                    for (var i = 0; i < lines.length; i++) {
                        var helper = lines[i].trim()
                        if (helper && helper !== "" && !helpers.includes(helper)) {
                            helpers.push(helper)
                        }
                    }
                }
                availableAurHelpers = helpers
                
                if (!aurHelper || aurHelper === "") {
                    if (helpers.length > 0) {
                        var preferred = ["yay", "paru", "pikaur"]
                        for (var j = 0; j < preferred.length; j++) {
                            if (helpers.includes(preferred[j])) {
                                aurHelper = preferred[j]
                                break
                            }
                        }
                        if (!aurHelper || aurHelper === "") {
                            aurHelper = helpers[0]
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        function reveal(): string {
            root.setTopBarVisible(true)
            return "BAR_SHOW_SUCCESS"
        }

        function hide(): string {
            root.setTopBarVisible(false)
            return "BAR_HIDE_SUCCESS"
        }

        function toggle(): string {
            root.toggleTopBarVisible()
            return topBarVisible ? "BAR_SHOW_SUCCESS" : "BAR_HIDE_SUCCESS"
        }

        function status(): string {
            return topBarVisible ? "visible" : "hidden"
        }

        target: "bar"
    }

    function applyHandheldMode() {
        // Apply DarkMaterialShell handheld defaults
        // These are the settings from the DarkMaterialShell settings.json

        // Transparency and opacity settings
        topBarTransparency = 0.75
        topBarWidgetTransparency = 0.5
        popupTransparency = 0.5
        modalTransparency = 0.5
        settingsModalDimmingEnabled = false
        notificationTransparency = 0.5
        controlCenterTransparency = 0.5
        appDrawerTransparency = 0.5
        controlCenterWidgetBackgroundOpacity = 0.5
        controlCenterBorderOpacity = 0.48
        controlCenterBorderThickness = 5
        settingsBorderOpacity = 0.48
        settingsBorderThickness = 5

        // Launcher settings
        launcherLogoRed = 0
        launcherLogoGreen = 1
        launcherLogoBlue = 1
        launcherLogoAutoSync = false

        // DarkDash settings
        darkDashTransparency = 0.92
        darkDashBorderOpacity = 0
        darkDashBorderThickness = 0
        darkDashTabBarOpacity = 1
        darkDashContentBackgroundOpacity = 1
        darkDashAnimatedTintOpacity = 0.04
        darkDashTintAnimateEnabled = true

        // Desktop DarkDash (full screen version)
        desktopDarkDashTransparency = 1
        desktopDarkDashBorderOpacity = 1
        desktopDarkDashBorderThickness = 4
        desktopDarkDashTabBarOpacity = 1
        desktopDarkDashContentBackgroundOpacity = 0.02
        desktopDarkDashAnimatedTintOpacity = 0

        // Dock settings
        dockTransparency = 0.53
        dockWidgetAreaOpacity = 0.3
        dockBackgroundTintOpacity = 0
        dockCollapsedHeight = 20
        dockSlideDistance = 60
        dockAnimationDuration = 200
        dockLeftWidgetAreaMinWidth = 60
        dockRightWidgetAreaMinWidth = 40
        dockBorderEnabled = true
        dockBorderWidth = 2
        dockBorderRadius = 50
        dockRadius = 12
        dockBorderRed = 1
        dockBorderGreen = 1
        dockBorderBlue = 1
        dockBorderAlpha = 0.18
        showDock = true
        dockWidgetsEnabled = true
        dockAutoHide = false
        dockGroupApps = true
        dockHideOnGames = false
        dockExpandToScreen = false
        dockCenterApps = false
        dockBottomGap = 1
        dockExclusiveZone = 65
        dockUseDynamicZones = false
        dockScale = 1.0
        dockIconSize = 41
        dockIconSpacing = 3
        dockPinnedAppsIconSize = 41
        dockPinnedAppsIconSpacing = 3
        taskbarScale = 1.0
        taskbarIconSize = 30
        taskbarIconSpacing = 2
        topbarScale = 1.0
        topbarIconSize = 24
        topbarIconSpacing = 2
        cornerRadius = 32

        // Top bar settings
        topBarFloat = false
        topBarRoundedCorners = false
        topBarCornerRadius = 12
        topBarLeftMargin = 0
        topBarRightMargin = 0
        topBarTopMargin = 0
        topBarHeight = 40
        topBarPosition = "top"
        topBarAutoHide = false
        topBarOpenOnOverview = false
        topBarVisible = false
        topBarSpacing = 4
        topBarBottomGap = 0
        topBarInnerPadding = 8
        topBarSquareCorners = false
        topBarNoBackground = false
        topBarGothCornersEnabled = false
        showLauncherButton = true
        showWorkspaceSwitcher = true
        showFocusedWindow = true
        showWeather = true
        showMusic = true
        showClipboard = true
        showCpuUsage = true
        showMemUsage = true
        showCpuTemp = true
        showGpuTemp = true
        showSystemTray = true
        showClock = true
        showNotificationButton = true
        showBattery = true
        showControlCenterButton = true

        // Widget positioning
        notificationCenterPosition = "top-right"
        clipboardPosition = "bottom-right"
        startMenuXOffset = 0
        startMenuYOffset = 0
        controlCenterXOffset = -0.54
        controlCenterYOffset = 0
        darkDashXOffset = 0
        darkDashYOffset = 0
        applicationsXOffset = 0
        applicationsYOffset = 0

        // Top bar widget order
        topBarLeftWidgets = ["launcherButton", "workspaceSwitcher", "focusedWindow"]
        topBarCenterWidgets = ["music", "clock", "weather"]
        topBarRightWidgets = ["systemTray", "clipboard", "cpuUsage", "memUsage", "notificationButton", "battery", "controlCenterButton"]

        // Dock widget order
        dockLeftWidgets = []
        dockCenterWidgets = [{"id": "launchpad", "enabled": true}, {"id": "pinnedApps", "enabled": true}, {"id": "trash", "enabled": true}]
        dockRightWidgets = []

        // Control center widgets
        controlCenterWidgets = [
            {"id": "wifi", "enabled": true, "width": 50},
            {"id": "bluetooth", "enabled": true, "width": 50},
            {"id": "audioOutput", "enabled": true, "width": 50},
            {"id": "audioInput", "enabled": true, "width": 50},
            {"id": "volumeMixer", "enabled": true, "width": 100},
            {"id": "performance", "enabled": true, "width": 50},
            {"id": "darkMode", "enabled": true, "width": 50}
        ]

        // Font and scaling
        fontFamily = defaultFontFamily
        monoFontFamily = defaultMonoFontFamily
        fontWeight = 400
        fontScale = 1.22
        settingsUiScale = 1.18
        settingsUiAdvancedScaling = true
        settingsUiWindowScale = 0.97
        settingsUiControlScale = 1
        settingsUiIconScale = 1

        // Notification settings
        notificationTimeoutLow = 5000
        notificationTimeoutNormal = 5000
        notificationTimeoutCritical = 0

        // Hide desktop widgets for handheld mode
        desktopWidgetsEnabled = false
        desktopCpuTempEnabled = false
        desktopGpuTempEnabled = false
        desktopSystemMonitorEnabled = false
        desktopClockEnabled = false
        desktopWeatherEnabled = false
        desktopTerminalEnabled = false
        desktopDarkDashEnabled = false
    }

    function resetToDesktopMode() {
        // Reset to default desktop settings (opposite of handheld)
        // These would be the typical desktop defaults

        // Show desktop widgets
        desktopWidgetsEnabled = true
        desktopCpuTempEnabled = true
        desktopGpuTempEnabled = true
        desktopSystemMonitorEnabled = true
        desktopClockEnabled = true
        desktopWeatherEnabled = true
        desktopTerminalEnabled = true
        desktopDarkDashEnabled = true

        // Different transparency values for desktop
        topBarTransparency = 0.75
        topBarWidgetTransparency = 0.85
        popupTransparency = 0.92
        modalTransparency = 0.85

        // Enable top bar visibility
        topBarVisible = true

        // Larger dock
        dockScale = 1.2
        dockIconSize = 48
        dockPinnedAppsIconSize = 48
        dockPinnedAppsIconSpacing = 3
        dockTransparency = 0.8

        // Task bar defaults
        taskBarHeight = 54
        taskBarTransparency = 0.5
        taskBarPinnedAppsPosition = "left"
        taskBarIconSize = 39
        taskBarIconSpacing = 0
        taskBarFloat = false
        taskBarRoundedCorners = false
        taskBarCornerRadius = 32
        taskBarBottomMargin = 3
        taskBarExclusiveZone = 56
        taskBarLeftPadding = 0
        taskBarRightPadding = 0
        taskBarTopPadding = 0
        taskBarBottomPadding = 0
        taskBarAutoHide = true
        taskBarVisible = true
        taskBarGroupApps = true

        // Different widget arrangements
        topBarLeftWidgets = ["launcherButton", "workspaceSwitcher", "focusedWindow", "weather"]
        topBarCenterWidgets = ["music", "clock"]
        topBarRightWidgets = ["systemTray", "clipboard", "cpuUsage", "memUsage", "cpuTemp", "gpuTemp", "notificationButton", "battery", "controlCenterButton"]

        taskBarLeftWidgets = ["launcherButton", {"id": "workspaceSwitcher", "enabled": true}]
        taskBarCenterWidgets = [{"id": "pinnedApps", "enabled": true}, {"id": "trash", "enabled": true}]
        taskBarRightWidgets = ["systemTray", "weather", "clock", "notificationButton", "controlCenterButton", "systemUpdate"]
        updateListModel(taskBarLeftWidgetsModel, taskBarLeftWidgets)
        updateListModel(taskBarCenterWidgetsModel, taskBarCenterWidgets)
        updateListModel(taskBarRightWidgetsModel, taskBarRightWidgets)

        // Enable all desktop widgets
        showCpuTemp = true
        showGpuTemp = true
        showCpuUsage = true
        showMemUsage = true
    }

    onHandheldModeChanged: {
        if (handheldMode) {
            applyHandheldMode()
        } else {
            resetToDesktopMode()
        }
    }
}
