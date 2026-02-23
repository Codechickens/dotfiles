import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Modules.Settings
import qs.Services
import qs.Widgets

Item {
    // ============================================
    // CLEANER UI BASED ON DANK'S DESIGN
    // ============================================

    id: displayConfigTab

    property var monitors: []
    property var monitorCapabilities: ({
    })
    property var rawMonitorData: []
    property bool loading: true
    property bool hasUnsavedChanges: false
    property string originalContent: ""
    property string selectedMonitor: ""
    readonly property string monitorsConfPath: {
        if (CompositorService.isNiri)
            return (Quickshell.env("HOME") || Paths.stringify(StandardPaths.writableLocation(StandardPaths.HomeLocation))) + "/.config/niri/dms/outputs.kdl";

        return (Quickshell.env("HOME") || Paths.stringify(StandardPaths.writableLocation(StandardPaths.HomeLocation))) + "/.config/hypr/monitors.conf";
    }
    readonly property string capabilitiesCachePath: Paths.stringify(`${StandardPaths.writableLocation(StandardPaths.GenericConfigLocation)}/DarkMaterialShell/monitor-capabilities.json`)
    property var previousMonitorSetup: null
    property string pendingSaveContent: ""
    property string pendingCapabilitiesContent: ""

    signal tabActivated()

    function loadPreviousMonitorSetup() {
        capabilitiesCacheFile.path = "";
        capabilitiesCacheFile.path = capabilitiesCachePath;
    }

    function getFilteredMonitors() {
        if (selectedMonitor === "")
            return monitors;

        return monitors.filter(function(m) {
            return m.name === selectedMonitor;
        });
    }

    function parseMonitorsConf(content) {
        var monitors = [];
        var lines = content.split('\n');
        var currentMonitor = null;
        var inMonitorV2Block = false;
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim();
            if (line === '' || line.startsWith('#'))
                continue;

            if (line.startsWith('monitorv2') && line.includes('{')) {
                inMonitorV2Block = true;
                if (currentMonitor)
                    monitors.push(currentMonitor);

                currentMonitor = {
                    "name": "",
                    "resolution": "",
                    "position": "",
                    "scale": "1",
                    "refreshRate": "",
                    "transform": "",
                    "disabled": false,
                    "bitdepth": "",
                    "cm": "",
                    "sdrbrightness": 1,
                    "sdrsaturation": 1,
                    "sdr_eotf": 0,
                    "vrr": "",
                    "mirror": "",
                    "supports_wide_color": 0,
                    "supports_hdr": 0,
                    "sdr_min_luminance": 0,
                    "sdr_max_luminance": 200,
                    "min_luminance": 0,
                    "max_luminance": 0,
                    "max_avg_luminance": 0,
                    "isV2": true
                };
                continue;
            }
            if (inMonitorV2Block) {
                if (line === '}') {
                    inMonitorV2Block = false;
                    if (currentMonitor) {
                        monitors.push(currentMonitor);
                        currentMonitor = null;
                    }
                    continue;
                }
                var keyValue = line.split('=');
                if (keyValue.length === 2) {
                    var key = keyValue[0].trim();
                    var value = keyValue[1].trim().replace(/^["']|["']$/g, '');
                    if (key === 'output') {
                        currentMonitor.name = value;
                    } else if (key === 'mode') {
                        if (value.includes('@')) {
                            var parts = value.split('@');
                            currentMonitor.resolution = parts[0].trim();
                            currentMonitor.refreshRate = parts[1].trim();
                        } else {
                            currentMonitor.resolution = value;
                        }
                    } else if (key === 'position')
                        currentMonitor.position = value;
                    else if (key === 'scale')
                        currentMonitor.scale = value;
                    else if (key === 'transform')
                        currentMonitor.transform = value;
                    else if (key === 'disabled')
                        currentMonitor.disabled = value === 'true' || value === '1';
                    else if (key === 'bitdepth')
                        currentMonitor.bitdepth = value;
                    else if (key === 'cm')
                        currentMonitor.cm = value;
                    else if (key === 'sdrbrightness')
                        currentMonitor.sdrbrightness = parseFloat(value) || 1;
                    else if (key === 'sdrsaturation')
                        currentMonitor.sdrsaturation = parseFloat(value) || 1;
                    else if (key === 'sdr_eotf')
                        currentMonitor.sdr_eotf = parseInt(value) || 0;
                    else if (key === 'vrr')
                        currentMonitor.vrr = value;
                    else if (key === 'mirror')
                        currentMonitor.mirror = value;
                    else if (key === 'supports_wide_color')
                        currentMonitor.supports_wide_color = parseInt(value) || 0;
                    else if (key === 'supports_hdr')
                        currentMonitor.supports_hdr = parseInt(value) || 0;
                    else if (key === 'sdr_min_luminance')
                        currentMonitor.sdr_min_luminance = parseFloat(value) || 0;
                    else if (key === 'sdr_max_luminance')
                        currentMonitor.sdr_max_luminance = parseInt(value) || 200;
                    else if (key === 'min_luminance')
                        currentMonitor.min_luminance = parseFloat(value) || 0;
                    else if (key === 'max_luminance')
                        currentMonitor.max_luminance = parseInt(value) || 0;
                    else if (key === 'max_avg_luminance')
                        currentMonitor.max_avg_luminance = parseInt(value) || 0;
                }
                continue;
            }
            if (line.startsWith('monitor=')) {
                if (currentMonitor)
                    monitors.push(currentMonitor);

                currentMonitor = {
                    "name": "",
                    "resolution": "",
                    "position": "",
                    "scale": "1",
                    "refreshRate": "",
                    "transform": "",
                    "disabled": false,
                    "bitdepth": "",
                    "cm": "",
                    "sdrbrightness": 1,
                    "sdrsaturation": 1,
                    "sdr_eotf": 0,
                    "vrr": "",
                    "mirror": "",
                    "supports_wide_color": 0,
                    "supports_hdr": 0,
                    "sdr_min_luminance": 0,
                    "sdr_max_luminance": 200,
                    "min_luminance": 0,
                    "max_luminance": 0,
                    "max_avg_luminance": 0,
                    "isV2": false
                };
                var monitorValue = line.substring(9).trim();
                if (monitorValue.startsWith('"') && monitorValue.endsWith('"'))
                    monitorValue = monitorValue.slice(1, -1);

                if (monitorValue === 'disable') {
                    currentMonitor.disabled = true;
                    continue;
                }
                var parts = monitorValue.split(',');
                if (parts.length > 0) {
                    var namePart = parts[0].trim();
                    if (namePart.startsWith('"') && namePart.endsWith('"'))
                        namePart = namePart.slice(1, -1);

                    currentMonitor.name = namePart;
                    if (parts.length > 1) {
                        var resolutionPart = parts[1].trim();
                        if (resolutionPart.includes('@')) {
                            var resParts = resolutionPart.split('@');
                            currentMonitor.resolution = resParts[0].trim();
                            if (resParts.length > 1)
                                currentMonitor.refreshRate = resParts[1].trim();

                        } else {
                            currentMonitor.resolution = resolutionPart;
                        }
                    }
                    if (parts.length > 2)
                        currentMonitor.position = parts[2].trim();

                    if (parts.length > 3)
                        currentMonitor.scale = parts[3].trim();

                    if (parts.length > 4 && !currentMonitor.refreshRate)
                        currentMonitor.refreshRate = parts[4].trim();

                    if (parts.length > 5)
                        currentMonitor.transform = parts[5].trim();

                    for (var j = 6; j < parts.length; j += 2) {
                        if (j + 1 < parts.length) {
                            var argName = parts[j].trim();
                            var argValue = parts[j + 1].trim();
                            if (argName === 'bitdepth')
                                currentMonitor.bitdepth = argValue;
                            else if (argName === 'cm')
                                currentMonitor.cm = argValue;
                            else if (argName === 'sdrbrightness')
                                currentMonitor.sdrbrightness = parseFloat(argValue) || 1;
                            else if (argName === 'sdrsaturation')
                                currentMonitor.sdrsaturation = parseFloat(argValue) || 1;
                            else if (argName === 'sdr_eotf')
                                currentMonitor.sdr_eotf = parseInt(argValue) || 0;
                            else if (argName === 'vrr')
                                currentMonitor.vrr = argValue;
                            else if (argName === 'mirror')
                                currentMonitor.mirror = argValue;
                            else if (argName === 'transform')
                                currentMonitor.transform = argValue;
                        }
                    }
                }
            } else if (currentMonitor && line.startsWith('monitor:')) {
                var keyValue = line.substring(8).trim().split('=');
                if (keyValue.length === 2) {
                    var key = keyValue[0].trim();
                    var value = keyValue[1].trim();
                    if (key === 'hdr')
                        currentMonitor.supports_hdr = parseInt(value) || 0;
                    else if (key === 'sdrBrightness')
                        currentMonitor.sdrbrightness = parseFloat(value) || 1;
                    else if (key === 'colorManagement')
                        currentMonitor.cm = value;
                }
            }
        }
        if (currentMonitor)
            monitors.push(currentMonitor);

        return monitors;
    }

    function loadMonitorsConf() {
        loading = true;
        monitorsFile.path = "";
        monitorsFile.path = monitorsConfPath;
    }

    function checkEdidHdrSupport() {
        for (var i = 0; i < monitors.length; i++) {
            var monitor = monitors[i];
            if (!monitor || monitor.disabled)
                continue;

            var caps = displayConfigTab.monitorCapabilities[monitor.name];
            if (caps && caps.hdr === true)
                continue;

            checkEdidForMonitor(monitor.name, i);
        }
    }

    function checkForMonitorChanges(currentMonitorData) {
        var currentSetup = {
            "count": currentMonitorData.length,
            "monitors": []
        };
        for (var i = 0; i < currentMonitorData.length; i++) {
            var monitor = currentMonitorData[i];
            currentSetup.monitors.push({
                "name": monitor.name,
                "description": monitor.description,
                "width": monitor.width,
                "height": monitor.height,
                "refresh": monitor.refreshRate
            });
        }
        currentSetup.monitors.sort(function(a, b) {
            return a.name.localeCompare(b.name);
        });
        if (!previousMonitorSetup) {
            console.log("No previous monitor setup found - this appears to be a fresh configuration");
            wipeMonitorsConf();
        }
        previousMonitorSetup = JSON.parse(JSON.stringify(currentSetup));
    }

    function wipeMonitorsConf() {
        var basicConfig = ["# Monitor configuration reset due to monitor changes", "# Please configure your monitors through the Monitors tab", ""].join('\n');
        wipeMonitorsConfFile.path = "";
        Qt.callLater(() => {
            wipeMonitorsConfFile.path = monitorsConfPath;
            Qt.callLater(() => {
                wipeMonitorsConfFile.setText(basicConfig);
            });
        });
    }

    function checkEdidForMonitor(monitorName, index) {
        edidCheckProcess.command = ["sh", "-c", "monitor=\"" + monitorName + "\"; " + "hyprctl monitors all 2>/dev/null | grep -A 50 \"$monitor\" | grep -q 'colorManagementPreset.*hdr' && echo 'HDR' && exit 0; " + "ddcutil detect --terse 2>/dev/null | grep -i \"$monitor\" >/dev/null && " + "ddcutil capabilities 2>/dev/null | grep -qiE '(hdr|bt\\.2020|rec\\.2020|wide.*color.*gamut|color.*space.*extended)' && echo 'HDR' && exit 0; " + "for card in /sys/class/drm/card*\"$monitor\"/edid; do " + "if [ -r \"$card\" ] 2>/dev/null; then " + "output=$(cat \"$card\" 2>/dev/null | edid-decode 2>&1); " + "echo \"$output\" | grep -qiE '(hdr.*static.*metadata|hdr.*metadata.*block|hdr.*static|hdr.*support|bt\\.2020|rec\\.2020|dci.*p3|wide.*color.*gamut|extended.*color.*space)' && echo 'HDR' && exit 0; " + "fi; done"];
        edidCheckProcess.monitorName = monitorName;
        edidCheckProcess.monitorIndex = index;
        edidCheckProcess.running = true;
    }

    function saveMonitorsConf() {
        // Use niri-specific save function if running on niri
        if (CompositorService.isNiri) {
            saveNiriOutputsConf();
            return ;
        }
        var lines = [];
        var content = originalContent || "";
        var contentLines = content ? content.split('\n') : [];
        var startIndex = 0;
        while (startIndex < contentLines.length && contentLines[startIndex].trim() === '')
            startIndex++;

        contentLines = contentLines.slice(startIndex);
        var i = 0;
        while (i < contentLines.length) {
            var line = contentLines[i];
            var trimmed = line.trim();
            if (trimmed.startsWith('monitor=') || trimmed.startsWith('monitorv2')) {
                if (trimmed.startsWith('monitor=')) {
                    i++;
                    while (i < contentLines.length && contentLines[i].trim().startsWith('monitor:'))
                        i++;

                    continue;
                }
                if (trimmed.startsWith('monitorv2')) {
                    i++;
                    var braceCount = 1;
                    while (i < contentLines.length && braceCount > 0) {
                        var currentLine = contentLines[i];
                        if (currentLine.includes('{'))
                            braceCount++;

                        if (currentLine.includes('}'))
                            braceCount--;

                        i++;
                    }
                    continue;
                }
            }
            lines.push(line);
            i++;
        }
        for (var j = 0; j < monitors.length; j++) {
            var monitor = monitors[j];
            monitor.isV2 = true;
            lines.push("monitorv2 {");
            lines.push("  output = " + (monitor.name.includes(" ") ? '"' + monitor.name + '"' : monitor.name));
            if (monitor.disabled) {
                lines.push("  disabled = true");
            } else {
                if (monitor.resolution) {
                    var mode = monitor.resolution;
                    if (monitor.refreshRate)
                        mode += "@" + monitor.refreshRate;

                    lines.push("  mode = " + mode);
                }
                if (monitor.position)
                    lines.push("  position = " + monitor.position);

                if (monitor.scale && monitor.scale !== "1")
                    lines.push("  scale = " + monitor.scale);

                if (monitor.transform && monitor.transform !== "0")
                    lines.push("  transform = " + monitor.transform);

                if (monitor.bitdepth)
                    lines.push("  bitdepth = " + monitor.bitdepth);

                if (monitor.cm)
                    lines.push("  cm = " + monitor.cm);

                if (monitor.sdrbrightness && monitor.sdrbrightness !== "1.0" && monitor.sdrbrightness !== 1)
                    lines.push("  sdrbrightness = " + monitor.sdrbrightness);

                if (monitor.sdrsaturation && monitor.sdrsaturation !== "1.0" && monitor.sdrsaturation !== 1)
                    lines.push("  sdrsaturation = " + monitor.sdrsaturation);

                if (monitor.sdr_eotf && monitor.sdr_eotf !== "0" && monitor.sdr_eotf !== 0)
                    lines.push("  sdr_eotf = " + monitor.sdr_eotf);

                if (monitor.vrr !== undefined && monitor.vrr !== null && monitor.vrr !== "")
                    lines.push("  vrr = " + monitor.vrr);

                if (monitor.mirror)
                    lines.push("  mirror = " + monitor.mirror);

                if (monitor.supports_wide_color !== undefined && monitor.supports_wide_color !== null && monitor.supports_wide_color !== 0)
                    lines.push("  supports_wide_color = " + monitor.supports_wide_color);

                if (monitor.supports_hdr !== undefined && monitor.supports_hdr !== null && monitor.supports_hdr !== 0)
                    lines.push("  supports_hdr = " + monitor.supports_hdr);

                if (monitor.sdr_min_luminance && monitor.sdr_min_luminance !== 0)
                    lines.push("  sdr_min_luminance = " + monitor.sdr_min_luminance);

                if (monitor.sdr_max_luminance && monitor.sdr_max_luminance !== 200)
                    lines.push("  sdr_max_luminance = " + monitor.sdr_max_luminance);

                if (monitor.min_luminance && monitor.min_luminance !== 0)
                    lines.push("  min_luminance = " + monitor.min_luminance);

                if (monitor.max_luminance && monitor.max_luminance !== 0)
                    lines.push("  max_luminance = " + monitor.max_luminance);

                if (monitor.max_avg_luminance && monitor.max_avg_luminance !== 0)
                    lines.push("  max_avg_luminance = " + monitor.max_avg_luminance);

            }
            lines.push("}");
            lines.push("");
        }
        while (lines.length > 0 && lines[lines.length - 1].trim().length === 0)
            lines.pop();

        var newContent = lines.join('\n');
        var dirPath = monitorsConfPath.substring(0, monitorsConfPath.lastIndexOf('/'));
        ensureDirProcess.command = ["mkdir", "-p", dirPath];
        ensureDirProcess.running = true;
        pendingSaveContent = newContent;
    }

    function applyMonitorSetting(monitorName, setting, value) {
        var monitor = monitors.find(function(m) {
            return m.name === monitorName;
        });
        if (!monitor)
            return ;

        monitor[setting] = value;
        hasUnsavedChanges = true;
        saveMonitorsConf();
    }

    function updateMonitorResolution(monitorName, resolution) {
        applyMonitorSetting(monitorName, "resolution", resolution);
    }

    function updateMonitorRefreshRate(monitorName, refreshRate) {
        applyMonitorSetting(monitorName, "refreshRate", refreshRate);
    }

    function saveNiriOutputsConf() {
        var lines = [];
        for (var j = 0; j < monitors.length; j++) {
            var monitor = monitors[j];
            lines.push('output "' + monitor.name + '" {');
            if (monitor.disabled) {
                lines.push("    off");
            } else {
                if (monitor.resolution) {
                    var mode = monitor.resolution;
                    if (monitor.refreshRate)
                        mode += "@" + monitor.refreshRate;

                    lines.push('    mode "' + mode + '"');
                }
                if (monitor.position) {
                    var posParts = monitor.position.split('x');
                    if (posParts.length === 2)
                        lines.push('    position x=' + posParts[0] + ' y=' + posParts[1]);

                }
                if (monitor.scale && monitor.scale !== "1")
                    lines.push('    scale ' + monitor.scale);

                if (monitor.transform && monitor.transform !== "0" && monitor.transform !== "")
                    lines.push('    transform "' + monitor.transform + '"');

            }
            lines.push("}");
            lines.push("");
        }
        while (lines.length > 0 && lines[lines.length - 1].trim().length === 0)
            lines.pop();

        var newContent = lines.join('\n');
        var dirPath = monitorsConfPath.substring(0, monitorsConfPath.lastIndexOf('/'));
        ensureDirProcess.command = ["mkdir", "-p", dirPath];
        ensureDirProcess.running = true;
        pendingSaveContent = newContent;
    }

    function loadMonitorCapabilitiesFromCache() {
        capabilitiesCacheFile.path = "";
        capabilitiesCacheFile.path = capabilitiesCachePath;
    }

    function saveMonitorCapabilitiesToCache() {
        var cacheData = {
            "rawData": rawMonitorData,
            "processedData": monitorCapabilities,
            "timestamp": new Date().toISOString()
        };
        var capabilitiesJson = JSON.stringify(cacheData, null, 2);
        var dirPath = capabilitiesCachePath.substring(0, capabilitiesCachePath.lastIndexOf('/'));
        ensureCapabilitiesDirProcess.command = ["mkdir", "-p", dirPath];
        ensureCapabilitiesDirProcess.running = true;
        pendingCapabilitiesContent = capabilitiesJson;
    }

    function loadMonitorsFromHyprctl() {
        loadMonitorsFromHyprctlProcess.running = true;
    }

    function loadMonitorsFromNiri() {
        loadMonitorsFromNiriProcess.running = true;
    }

    function loadMonitorCapabilities() {
        if (CompositorService.isNiri)
            loadNiriCapabilitiesProcess.running = true;
        else
            loadCapabilitiesProcess.running = true;
        checkEdidHdrSupport();
    }

    Component.onCompleted: {
        loadMonitorsConf();
        loadMonitorCapabilitiesFromCache();
        Qt.callLater(() => {
            loadMonitorCapabilities();
        });
    }
    onTabActivated: {
        if (CompositorService.isNiri)
            loadNiriCapabilitiesProcess.running = true;
        else
            loadCapabilitiesProcess.running = true;
        checkEdidHdrSupport();
    }

    FileView {
        id: monitorsFile

        path: displayConfigTab.monitorsConfPath
        blockWrites: true
        blockLoading: false
        atomicWrites: true
        printErrors: true
        onLoaded: {
            var content = text();
            displayConfigTab.originalContent = content;
            var parsedMonitors = displayConfigTab.parseMonitorsConf(content);
            if (parsedMonitors.length === 0) {
                if (CompositorService.isNiri)
                    loadMonitorsFromNiri();
                else
                    loadMonitorsFromHyprctl();
            } else {
                displayConfigTab.monitors = parsedMonitors;
                displayConfigTab.loading = false;
                displayConfigTab.hasUnsavedChanges = false;
                if (Object.keys(displayConfigTab.monitorCapabilities).length === 0)
                    Qt.callLater(() => {
                        loadMonitorCapabilities();
                    });

            }
        }
        onLoadFailed: {
            if (CompositorService.isNiri)
                loadMonitorsFromNiri();
            else
                loadMonitorsFromHyprctl();
        }
    }

    Process {
        id: loadMonitorsFromHyprctlProcess

        command: ["hyprctl", "-j", "monitors"]
        running: false
        onExited: function(exitCode) {
            if (exitCode === 0) {
                try {
                    var json = JSON.parse(stdout.text);
                    var monitors = [];
                    for (var i = 0; i < json.length; i++) {
                        var monitor = json[i];
                        var monitorObj = {
                            "name": monitor.name || "Unknown",
                            "resolution": monitor.width + "x" + monitor.height,
                            "position": (monitor.x !== undefined && monitor.y !== undefined) ? (monitor.x + "x" + monitor.y) : "",
                            "scale": monitor.scale ? monitor.scale.toString() : "1",
                            "refreshRate": monitor.refresh ? monitor.refresh.toString() : "",
                            "transform": "",
                            "disabled": false,
                            "bitdepth": "",
                            "cm": "",
                            "sdrbrightness": 1,
                            "sdrsaturation": 1,
                            "sdr_eotf": 0,
                            "vrr": "",
                            "mirror": "",
                            "supports_wide_color": 0,
                            "supports_hdr": monitor.hdr || false,
                            "sdr_min_luminance": 0,
                            "sdr_max_luminance": 200,
                            "min_luminance": 0,
                            "max_luminance": 0,
                            "max_avg_luminance": 0,
                            "isV2": true
                        };
                        monitors.push(monitorObj);
                    }
                    displayConfigTab.monitors = monitors;
                    displayConfigTab.originalContent = "";
                    displayConfigTab.loading = false;
                    displayConfigTab.hasUnsavedChanges = false;
                } catch (e) {
                    displayConfigTab.monitors = [];
                }
            } else {
                displayConfigTab.monitors = [];
            }
            displayConfigTab.loading = false;
        }

        stdout: StdioCollector {
        }

    }

    Process {
        id: loadMonitorsFromNiriProcess

        command: ["niri", "msg", "-j", "outputs"]
        running: false
        onExited: function(exitCode) {
            if (exitCode === 0) {
                try {
                    var json = JSON.parse(stdout.text);
                    var monitors = [];
                    for (var outputName in json) {
                        var output = json[outputName];
                        if (!output)
                            continue;

                        var currentMode = output.current_mode || {
                        };
                        var width = currentMode.width || 0;
                        var height = currentMode.height || 0;
                        var refresh = currentMode.refresh_rate || 0;
                        var position = "";
                        if (output.x !== undefined && output.y !== undefined)
                            position = output.x + "x" + output.y;

                        var monitorObj = {
                            "name": outputName,
                            "resolution": width + "x" + height,
                            "position": position,
                            "scale": output.scale ? output.scale.toString() : "1",
                            "refreshRate": refresh ? (refresh / 1000).toString() : "",
                            "transform": output.transform || "",
                            "disabled": output.enabled === false,
                            "bitdepth": "",
                            "cm": "",
                            "sdrbrightness": 1,
                            "sdrsaturation": 1,
                            "sdr_eotf": 0,
                            "vrr": output.vrr_enabled ? "true" : "",
                            "mirror": "",
                            "supports_wide_color": 0,
                            "supports_hdr": false,
                            "sdr_min_luminance": 0,
                            "sdr_max_luminance": 200,
                            "min_luminance": 0,
                            "max_luminance": 0,
                            "max_avg_luminance": 0,
                            "isV2": true
                        };
                        monitors.push(monitorObj);
                    }
                    displayConfigTab.monitors = monitors;
                    displayConfigTab.originalContent = "";
                    displayConfigTab.loading = false;
                    displayConfigTab.hasUnsavedChanges = false;
                } catch (e) {
                    console.warn("Failed to parse niri outputs:", e);
                    displayConfigTab.monitors = [];
                }
            } else {
                displayConfigTab.monitors = [];
            }
            displayConfigTab.loading = false;
        }

        stdout: StdioCollector {
        }

    }

    Process {
        id: loadCapabilitiesProcess

        command: ["hyprctl", "-j", "monitors"]
        running: false
        onExited: function(exitCode) {
            if (exitCode === 0) {
                try {
                    var json = JSON.parse(stdout.text);
                    displayConfigTab.rawMonitorData = json;
                    var caps = {
                    };
                    for (var i = 0; i < json.length; i++) {
                        var monitor = json[i];
                        var refreshRates = [];
                        var resolutions = [];
                        var resolutionRefreshMap = {
                        };
                        if (monitor.availableModes && Array.isArray(monitor.availableModes)) {
                            for (var j = 0; j < monitor.availableModes.length; j++) {
                                var modeStr = monitor.availableModes[j];
                                var match = modeStr.match(/^(\d+)x(\d+)@([\d.]+)Hz$/);
                                if (match) {
                                    var width = parseInt(match[1]);
                                    var height = parseInt(match[2]);
                                    var refresh = parseFloat(match[3]);
                                    var res = width + "x" + height;
                                    if (!refreshRates.includes(refresh))
                                        refreshRates.push(refresh);

                                    if (!resolutions.includes(res))
                                        resolutions.push(res);

                                    if (!resolutionRefreshMap[res])
                                        resolutionRefreshMap[res] = [];

                                    if (!resolutionRefreshMap[res].includes(refresh))
                                        resolutionRefreshMap[res].push(refresh);

                                }
                            }
                        }
                        refreshRates = refreshRates.filter(function(value, index, self) {
                            return self.indexOf(value) === index;
                        }).sort(function(a, b) {
                            return b - a;
                        });
                        resolutions = resolutions.filter(function(value, index, self) {
                            return self.indexOf(value) === index;
                        }).sort(function(a, b) {
                            var aParts = a.split('x');
                            var bParts = b.split('x');
                            var aPixels = parseInt(aParts[0]) * parseInt(aParts[1]);
                            var bPixels = parseInt(bParts[0]) * parseInt(bParts[1]);
                            return bPixels - aPixels;
                        });
                        for (var res in resolutionRefreshMap) {
                            resolutionRefreshMap[res].sort(function(a, b) {
                                return b - a;
                            });
                        }
                        var hdrFromHyprctl = monitor.hdr === true || (monitor.colorManagementPreset && monitor.colorManagementPreset.toLowerCase().includes('hdr'));
                        var hdrFromConfig = false;
                        for (var k = 0; k < displayConfigTab.monitors.length; k++) {
                            var configMonitor = displayConfigTab.monitors[k];
                            if (configMonitor.name === monitor.name) {
                                var cm = (configMonitor.cm || "").toLowerCase();
                                hdrFromConfig = (cm === "hdr" || cm === "hdredid") || configMonitor.supports_hdr === true || configMonitor.supports_hdr === 1;
                                break;
                            }
                        }
                        caps[monitor.name] = {
                            "refreshRates": refreshRates,
                            "resolutions": resolutions,
                            "resolutionRefreshMap": resolutionRefreshMap,
                            "availableModes": monitor.availableModes || [],
                            "vrr": monitor.vrr !== undefined ? monitor.vrr : false,
                            "hdr": hdrFromHyprctl || hdrFromConfig,
                            "hdrFromEdid": false,
                            "currentMode": monitor.activeWorkspace ? monitor.activeWorkspace : null,
                            "width": monitor.width || 0,
                            "height": monitor.height || 0,
                            "refresh": monitor.refreshRate || monitor.refresh || 0,
                            "scale": monitor.scale || 1,
                            "description": monitor.description || "",
                            "make": monitor.make || "",
                            "model": monitor.model || "",
                            "transform": monitor.transform || 0,
                            "disabled": monitor.disabled || false,
                            "currentFormat": monitor.currentFormat || "",
                            "mirrorOf": monitor.mirrorOf || "none",
                            "colorManagementPreset": monitor.colorManagementPreset || "",
                            "sdrBrightness": monitor.sdrBrightness || 1,
                            "sdrSaturation": monitor.sdrSaturation || 1,
                            "sdrMinLuminance": monitor.sdrMinLuminance || 0,
                            "sdrMaxLuminance": monitor.sdrMaxLuminance || 0,
                            "dpmsStatus": monitor.dpmsStatus !== undefined ? monitor.dpmsStatus : true,
                            "focused": monitor.focused !== undefined ? monitor.focused : false
                        };
                    }
                    displayConfigTab.monitorCapabilities = caps;
                    checkForMonitorChanges(json);
                    saveMonitorCapabilitiesToCache();
                    Qt.callLater(() => {
                        checkEdidHdrSupport();
                    });
                } catch (e) {
                    displayConfigTab.monitorCapabilities = {
                    };
                    displayConfigTab.rawMonitorData = [];
                }
            } else {
                displayConfigTab.monitorCapabilities = {
                };
                displayConfigTab.rawMonitorData = [];
            }
        }

        stdout: StdioCollector {
        }

    }

    Process {
        id: loadNiriCapabilitiesProcess

        command: ["niri", "msg", "-j", "outputs"]
        running: false
        onExited: function(exitCode) {
            if (exitCode === 0) {
                try {
                    var json = JSON.parse(stdout.text);
                    displayConfigTab.rawMonitorData = json;
                    var caps = {
                    };
                    for (var outputName in json) {
                        var output = json[outputName];
                        if (!output)
                            continue;

                        var refreshRates = [];
                        var resolutions = [];
                        var resolutionRefreshMap = {
                        };
                        if (output.modes && Array.isArray(output.modes)) {
                            for (var j = 0; j < output.modes.length; j++) {
                                var mode = output.modes[j];
                                var width = mode.width || 0;
                                var height = mode.height || 0;
                                var refresh = mode.refresh_rate || 0;
                                var res = width + "x" + height;
                                var refreshHz = refresh / 1000;
                                if (!refreshRates.includes(refreshHz))
                                    refreshRates.push(refreshHz);

                                if (!resolutions.includes(res))
                                    resolutions.push(res);

                                if (!resolutionRefreshMap[res])
                                    resolutionRefreshMap[res] = [];

                                if (!resolutionRefreshMap[res].includes(refreshHz))
                                    resolutionRefreshMap[res].push(refreshHz);

                            }
                        }
                        refreshRates = refreshRates.filter(function(value, index, self) {
                            return self.indexOf(value) === index;
                        }).sort(function(a, b) {
                            return b - a;
                        });
                        resolutions = resolutions.filter(function(value, index, self) {
                            return self.indexOf(value) === index;
                        }).sort(function(a, b) {
                            var aParts = a.split('x');
                            var bParts = b.split('x');
                            var aPixels = parseInt(aParts[0]) * parseInt(aParts[1]);
                            var bPixels = parseInt(bParts[0]) * parseInt(bParts[1]);
                            return bPixels - aPixels;
                        });
                        for (var res in resolutionRefreshMap) {
                            resolutionRefreshMap[res].sort(function(a, b) {
                                return b - a;
                            });
                        }
                        var currentMode = output.current_mode || {
                        };
                        caps[outputName] = {
                            "refreshRates": refreshRates,
                            "resolutions": resolutions,
                            "resolutionRefreshMap": resolutionRefreshMap,
                            "availableModes": output.modes || [],
                            "vrr": output.vrr_enabled !== undefined ? output.vrr_enabled : false,
                            "hdr": false,
                            "hdrFromEdid": false,
                            "currentMode": currentMode,
                            "width": currentMode.width || 0,
                            "height": currentMode.height || 0,
                            "refresh": currentMode.refresh_rate ? (currentMode.refresh_rate / 1000) : 0,
                            "scale": output.scale || 1,
                            "description": output.description || "",
                            "make": output.make || "",
                            "model": output.model || "",
                            "transform": output.transform || 0,
                            "disabled": !output.enabled,
                            "currentFormat": "",
                            "mirrorOf": "none",
                            "colorManagementPreset": "",
                            "sdrBrightness": 1,
                            "sdrSaturation": 1,
                            "sdrMinLuminance": 0,
                            "sdrMaxLuminance": 0,
                            "dpmsStatus": true,
                            "focused": output.current_workspace !== undefined
                        };
                    }
                    displayConfigTab.monitorCapabilities = caps;
                    checkForMonitorChanges(json);
                    saveMonitorCapabilitiesToCache();
                } catch (e) {
                    console.warn("Failed to parse niri capabilities:", e);
                    displayConfigTab.monitorCapabilities = {
                    };
                    displayConfigTab.rawMonitorData = [];
                }
            } else {
                displayConfigTab.monitorCapabilities = {
                };
                displayConfigTab.rawMonitorData = [];
            }
        }

        stdout: StdioCollector {
        }

    }

    Process {
        id: edidCheckProcess

        property string monitorName: ""
        property int monitorIndex: -1

        running: false
        onExited: function(exitCode) {
            if (!monitorName)
                return ;

            var output = stdout.text.trim().toUpperCase();
            if (output.includes("HDR")) {
                var caps = Object.assign({
                }, displayConfigTab.monitorCapabilities);
                if (caps[monitorName]) {
                    caps[monitorName].hdr = true;
                    caps[monitorName].hdrFromEdid = true;
                    displayConfigTab.monitorCapabilities = caps;
                    Qt.callLater(() => {
                        saveMonitorCapabilitiesToCache();
                    });
                } else {
                    caps[monitorName] = {
                        "hdr": true,
                        "hdrFromEdid": true,
                        "refreshRates": [],
                        "resolutions": [],
                        "resolutionRefreshMap": {
                        },
                        "vrr": false
                    };
                    displayConfigTab.monitorCapabilities = caps;
                    Qt.callLater(() => {
                        saveMonitorCapabilitiesToCache();
                    });
                }
            }
        }

        stdout: StdioCollector {
        }

    }

    FileView {
        id: capabilitiesCacheFile

        path: displayConfigTab.capabilitiesCachePath
        blockWrites: true
        blockLoading: false
        atomicWrites: true
        printErrors: false
        onLoaded: {
            try {
                var cached = JSON.parse(text());
                if (cached && typeof cached === 'object') {
                    if (cached.rawData) {
                        displayConfigTab.rawMonitorData = cached.rawData;
                        var previousSetup = {
                            "count": cached.rawData.length,
                            "monitors": []
                        };
                        for (var i = 0; i < cached.rawData.length; i++) {
                            var monitor = cached.rawData[i];
                            previousSetup.monitors.push({
                                "name": monitor.name,
                                "description": monitor.description,
                                "width": monitor.width,
                                "height": monitor.height,
                                "refresh": monitor.refreshRate
                            });
                        }
                        previousSetup.monitors.sort(function(a, b) {
                            return a.name.localeCompare(b.name);
                        });
                        displayConfigTab.previousMonitorSetup = previousSetup;
                    }
                    if (cached.processedData)
                        displayConfigTab.monitorCapabilities = cached.processedData;
                    else if (cached.refreshRates || cached.resolutions)
                        displayConfigTab.monitorCapabilities = cached;
                }
            } catch (e) {
                displayConfigTab.monitorCapabilities = {
                };
                displayConfigTab.rawMonitorData = [];
                displayConfigTab.previousMonitorSetup = null;
            }
        }
        onLoadFailed: {
            displayConfigTab.monitorCapabilities = {
            };
            displayConfigTab.rawMonitorData = [];
        }
    }

    Process {
        id: ensureCapabilitiesDirProcess

        command: ["mkdir", "-p"]
        running: false
        onExited: (exitCode) => {
            if (pendingCapabilitiesContent !== "") {
                touchCapabilitiesFileProcess.command = ["touch", capabilitiesCachePath];
                touchCapabilitiesFileProcess.running = true;
            }
        }
    }

    Process {
        id: touchCapabilitiesFileProcess

        command: ["touch"]
        running: false
        onExited: (exitCode) => {
            if (pendingCapabilitiesContent !== "") {
                saveCapabilitiesCacheFile.path = "";
                Qt.callLater(() => {
                    saveCapabilitiesCacheFile.path = capabilitiesCachePath;
                    Qt.callLater(() => {
                        saveCapabilitiesCacheFile.setText(pendingCapabilitiesContent);
                    });
                });
            }
        }
    }

    FileView {
        id: saveCapabilitiesCacheFile

        blockWrites: false
        blockLoading: true
        atomicWrites: true
        printErrors: true
        onSaved: {
            pendingCapabilitiesContent = "";
        }
        onSaveFailed: (error) => {
            pendingCapabilitiesContent = "";
        }
    }

    Process {
        id: ensureDirProcess

        command: ["mkdir", "-p"]
        running: false
        onExited: (exitCode) => {
            if (pendingSaveContent !== "") {
                touchFileProcess.command = ["touch", monitorsConfPath];
                touchFileProcess.running = true;
            }
        }
    }

    Process {
        id: touchFileProcess

        command: ["touch"]
        running: false
        onExited: (exitCode) => {
            if (pendingSaveContent !== "") {
                saveMonitorsFile.path = "";
                Qt.callLater(() => {
                    saveMonitorsFile.path = monitorsConfPath;
                    Qt.callLater(() => {
                        saveMonitorsFile.setText(pendingSaveContent);
                    });
                });
            }
        }
    }

    FileView {
        id: saveMonitorsFile

        blockWrites: false
        blockLoading: true
        atomicWrites: true
        printErrors: true
        onSaved: {
            hasUnsavedChanges = false;
            if (typeof ToastService !== "undefined")
                ToastService.showInfo("Monitor configuration saved successfully");

            Qt.callLater(() => {
                monitorsFile.reload();
            });
            if (CompositorService.isNiri)
                reloadNiriProcess.running = true;
            else
                reloadHyprlandProcess.running = true;
            pendingSaveContent = "";
        }
        onSaveFailed: (error) => {
            if (typeof ToastService !== "undefined")
                ToastService.showError("Failed to save monitor configuration: " + (error || "Unknown error"));

            pendingSaveContent = "";
        }
    }

    Process {
        id: reloadHyprlandProcess

        command: ["hyprctl", "reload"]
        running: false
        onExited: (exitCode) => {
            if (exitCode === 0) {
                if (typeof ToastService !== "undefined")
                    ToastService.showInfo("Hyprland configuration reloaded");

                loadMonitorCapabilities();
            } else {
                if (typeof ToastService !== "undefined")
                    ToastService.showError("Failed to reload Hyprland configuration");

            }
        }
    }

    Process {
        id: reloadNiriProcess

        command: ["niri", "msg", "action", "reload-config-or-panic"]
        running: false
        onExited: (exitCode) => {
            if (exitCode === 0) {
                if (typeof ToastService !== "undefined")
                    ToastService.showInfo("niri configuration reloaded");

                loadMonitorCapabilities();
            } else {
                if (typeof ToastService !== "undefined")
                    ToastService.showError("Failed to reload niri configuration");

            }
        }
    }

    FileView {
        id: wipeMonitorsConfFile

        blockWrites: false
        blockLoading: true
        atomicWrites: true
        printErrors: true
        onSaved: {
            console.log("Successfully wiped monitors.conf");
            if (typeof ToastService !== "undefined")
                ToastService.showInfo("Monitor configuration has been reset due to monitor changes. Please reconfigure your displays.");

            Qt.callLater(() => {
                displayConfigTab.loadMonitorsConf();
            });
        }
        onSaveFailed: (error) => {
            console.error("Failed to wipe monitors.conf:", error);
            if (typeof ToastService !== "undefined")
                ToastService.showError("Failed to reset monitor configuration: " + (error || "Unknown error"));

        }
    }

    EHFlickable {
        id: flickable

        anchors.fill: parent
        anchors.topMargin: Theme.spacingM
        anchors.bottomMargin: Theme.spacingS
        clip: true
        contentHeight: mainColumn.height + Theme.spacingXL
        contentWidth: width

        Column {
            id: mainColumn

            width: parent.width - Theme.spacingL * 2
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.spacingXL
            topPadding: 4

            // ============================================
            // SECTION 1: Monitor Arrangement (Visual Canvas)
            // ============================================
            StyledRect {
                width: parent.width
                height: arrangementSection.implicitHeight + Theme.spacingL * 2
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.15)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.12)
                border.width: 1
                visible: displayConfigTab.monitors.length > 0 && !displayConfigTab.loading

                Column {
                    id: arrangementSection

                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingM

                    // Header with icon and title
                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "monitor"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            width: parent.width - Theme.iconSize - Theme.spacingM
                            spacing: Theme.spacingXS
                            anchors.verticalCenter: parent.verticalCenter

                            StyledText {
                                text: "Monitor Arrangement"
                                font.pixelSize: Theme.fontSizeLarge
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }

                            StyledText {
                                text: "Drag monitors to reposition - scroll to zoom"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                        }

                    }

                    // Monitor Canvas
                    MonitorArrangementWidget {
                        id: arrangementWidget

                        width: parent.width
                        monitors: displayConfigTab.monitors
                        monitorCapabilities: displayConfigTab.monitorCapabilities
                        selectedMonitor: displayConfigTab.selectedMonitor
                        onMonitorSelected: function(monitorName) {
                            displayConfigTab.selectedMonitor = monitorName;
                        }
                        onPositionChanged: function(monitorName, newPosition) {
                            displayConfigTab.applyMonitorSetting(monitorName, "position", newPosition);
                        }
                    }

                }

            }

            // ============================================
            // Loading / Empty States
            // ============================================
            StyledText {
                text: "Loading monitors..."
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.surfaceVariantText
                visible: displayConfigTab.loading
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            StyledText {
                text: displayConfigTab.monitors.length === 0 && !displayConfigTab.loading ? (CompositorService.isNiri ? "No monitors found. Make sure niri is running and monitors are configured." : "No monitors found. Make sure Hyprland is running and monitors are configured.") : ""
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.surfaceVariantText
                visible: displayConfigTab.monitors.length === 0 && !displayConfigTab.loading
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            // ============================================
            // SECTION 2: Monitor Configuration Cards
            // ============================================
            StyledRect {
                width: parent.width
                height: monitorsSection.implicitHeight + Theme.spacingL * 2
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.15)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.12)
                border.width: 1
                visible: displayConfigTab.monitors.length > 0 && !displayConfigTab.loading

                Column {
                    id: monitorsSection

                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingM

                    // Header with icon and title
                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "tune"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            width: parent.width - Theme.iconSize - Theme.spacingM
                            spacing: Theme.spacingXS
                            anchors.verticalCenter: parent.verticalCenter

                            StyledText {
                                text: "Monitor Configuration"
                                font.pixelSize: Theme.fontSizeLarge
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }

                            StyledText {
                                text: "Configure resolution, refresh rate, scale, and color settings"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                        }

                    }

                    // Show All button (when a specific monitor is selected)
                    Row {
                        width: parent.width
                        spacing: Theme.spacingM
                        visible: displayConfigTab.selectedMonitor !== ""

                        StyledRect {
                            height: 36
                            width: showAllButtonText.implicitWidth + Theme.spacingL * 2
                            radius: Theme.cornerRadius
                            color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1)
                            border.color: Theme.primary
                            border.width: 1

                            StyledText {
                                id: showAllButtonText

                                anchors.centerIn: parent
                                text: "Show All Monitors"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.primary
                            }

                            StateLayer {
                                stateColor: Theme.primary
                                cornerRadius: parent.radius
                                onClicked: {
                                    displayConfigTab.selectedMonitor = "";
                                }
                            }

                        }

                    }

                    // Monitor Cards
                    Repeater {
                        model: displayConfigTab.getFilteredMonitors()

                        delegate: MonitorConfigWidget {
                            width: parent.width
                            monitorData: modelData
                            monitorCapabilities: displayConfigTab.monitorCapabilities[modelData.name] || {
                            }
                            onSettingChanged: function(setting, value) {
                                displayConfigTab.applyMonitorSetting(modelData.name, setting, value);
                            }
                        }

                    }

                }

            }

            // ============================================
            // SECTION 3: VRR Settings (if supported)
            // ============================================
            StyledRect {
                width: parent.width
                height: vrrSection.implicitHeight + Theme.spacingL * 2
                radius: Theme.cornerRadius
                color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.15)
                border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.12)
                border.width: 1
                visible: {
                    if (displayConfigTab.monitors.length === 0 || displayConfigTab.loading)
                        return false;

                    for (var i = 0; i < displayConfigTab.monitors.length; i++) {
                        var caps = displayConfigTab.monitorCapabilities[displayConfigTab.monitors[i].name];
                        if (caps && caps.vrr !== undefined && caps.vrr !== null)
                            return true;

                    }
                    return false;
                }

                Column {
                    id: vrrSection

                    anchors.fill: parent
                    anchors.margins: Theme.spacingL
                    spacing: Theme.spacingM

                    // Header with icon and title
                    Row {
                        width: parent.width
                        spacing: Theme.spacingM

                        EHIcon {
                            name: "sync"
                            size: Theme.iconSize
                            color: Theme.primary
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            width: parent.width - Theme.iconSize - Theme.spacingM
                            spacing: Theme.spacingXS
                            anchors.verticalCenter: parent.verticalCenter

                            StyledText {
                                text: "Variable Refresh Rate"
                                font.pixelSize: Theme.fontSizeLarge
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                            }

                            StyledText {
                                text: "Configure VRR settings per monitor"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.surfaceVariantText
                                wrapMode: Text.WordWrap
                                width: parent.width
                            }

                        }

                    }

                    // VRR Settings per monitor
                    Repeater {
                        model: displayConfigTab.getFilteredMonitors()

                        delegate: Column {
                            width: parent.width
                            spacing: Theme.spacingS
                            visible: {
                                var caps = displayConfigTab.monitorCapabilities[modelData.name] || {
                                };
                                return (!modelData || !modelData.disabled) && (caps.vrr !== undefined && caps.vrr !== null);
                            }

                            StyledText {
                                text: modelData.name + " - VRR"
                                font.pixelSize: Theme.fontSizeMedium
                                font.weight: Font.Medium
                                color: Theme.surfaceText
                                width: parent.width
                            }

                            EHButtonGroup {
                                width: parent.width
                                buttonHeight: 42
                                minButtonWidth: 80
                                buttonPadding: Theme.spacingS
                                textSize: Theme.fontSizeSmall
                                checkIconSize: Theme.iconSizeSmall + 2
                                model: ["Disabled", "Global", "Fullscreen"]
                                currentIndex: {
                                    if (!modelData)
                                        return 0;

                                    var vrrValue = modelData.vrr;
                                    if (vrrValue === "0" || vrrValue === 0 || vrrValue === false)
                                        return 0;

                                    if (vrrValue === "1" || vrrValue === 1 || vrrValue === true)
                                        return 1;

                                    if (vrrValue === "2" || vrrValue === 2)
                                        return 2;

                                    return 0;
                                }
                                onSelectionChanged: (index, selected) => {
                                    if (!modelData || !selected)
                                        return ;

                                    var newValue = "0";
                                    if (index === 1)
                                        newValue = "1";
                                    else if (index === 2)
                                        newValue = "2";
                                    modelData.vrr = newValue;
                                    displayConfigTab.applyMonitorSetting(modelData.name, "vrr", newValue);
                                }
                            }

                        }

                    }

                }

            }

        }

    }

}
