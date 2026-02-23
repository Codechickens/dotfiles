pragma Singleton

pragma ComponentBehavior: Bound

import QtQuick
import QtCore
import Quickshell
import Quickshell.Io
import qs.Common

Singleton {
    id: root

    property int refCount: 0
    property int updateInterval: refCount > 0 ? 5000 : 30000
    property bool isUpdating: false
    property bool dgopAvailable: false
    property bool nvmlAvailable: false

    property var moduleRefCounts: ({})
    property var enabledModules: []
    property var gpuPciIds: []
    property var gpuPciIdRefCounts: ({})
    property int processLimit: 20
    property string processSort: "cpu"
    property bool noCpu: false

    property string cpuCursor: ""
    property string procCursor: ""
    property int cpuSampleCount: 0
    property int processSampleCount: 0

    property real cpuUsage: 0
    property real cpuFrequency: 0
    property real cpuTemperature: 0
    property int cpuCores: 1
    property string cpuModel: ""
    property var perCoreCpuUsage: []

    property real memoryUsage: 0
    property real totalMemoryMB: 0
    property real usedMemoryMB: 0
    property real freeMemoryMB: 0
    property real availableMemoryMB: 0
    property int totalMemoryKB: 0
    property int usedMemoryKB: 0
    property int totalSwapKB: 0
    property int usedSwapKB: 0

    property real networkRxRate: 0
    property real networkTxRate: 0
    property var lastNetworkStats: null
    property var networkInterfaces: []

    property real diskReadRate: 0
    property real diskWriteRate: 0
    property var lastDiskStats: null
    property var diskMounts: []
    property var diskDevices: []

    property var processes: []
    property var allProcesses: []
    property string currentSort: "cpu"
    property var availableGpus: []

    property string kernelVersion: ""
    property string distribution: ""
    property string hostname: ""
    property string architecture: ""
    property string loadAverage: ""
    property int processCount: 0
    property int threadCount: 0
    property string bootTime: ""
    property string motherboard: ""
    property string biosVersion: ""

    property int historySize: 60
    property var cpuHistory: []
    property var memoryHistory: []
    property var networkHistory: ({
                                      "rx": [],
                                      "tx": []
                                  })
    property var diskHistory: ({
                                   "read": [],
                                   "write": []
                               })

    function addRef(modules = null) {
        refCount++
        let modulesChanged = false

        if (modules) {
            const modulesToAdd = Array.isArray(modules) ? modules : [modules]
            for (const module of modulesToAdd) {
                const currentCount = moduleRefCounts[module] || 0
                moduleRefCounts[module] = currentCount + 1

                if (enabledModules.indexOf(module) === -1) {
                    enabledModules.push(module)
                    modulesChanged = true
                }
            }
        }

        if (modulesChanged || refCount === 1) {
            enabledModules = enabledModules.slice()
            moduleRefCounts = Object.assign({}, moduleRefCounts)
            updateAllStats()
        } else if (gpuPciIds.length > 0 && refCount > 0) {
            updateAllStats()
        }
    }

    function removeRef(modules = null) {
        refCount = Math.max(0, refCount - 1)
        let modulesChanged = false

        if (modules) {
            const modulesToRemove = Array.isArray(modules) ? modules : [modules]
            for (const module of modulesToRemove) {
                const currentCount = moduleRefCounts[module] || 0
                if (currentCount > 1) {
                    moduleRefCounts[module] = currentCount - 1
                } else if (currentCount === 1) {
                    delete moduleRefCounts[module]
                    const index = enabledModules.indexOf(module)
                    if (index > -1) {
                        enabledModules.splice(index, 1)
                        modulesChanged = true
                    }
                }
            }
        }

                if (modulesChanged) {
                    enabledModules = enabledModules.slice()
                    moduleRefCounts = Object.assign({}, moduleRefCounts)

            if (!enabledModules.includes("cpu")) {
                cpuCursor = ""
                cpuSampleCount = 0
            }
            if (!enabledModules.includes("processes")) {
                procCursor = ""
                processSampleCount = 0
            }
        }
    }

    function setGpuPciIds(pciIds) {
        gpuPciIds = Array.isArray(pciIds) ? pciIds : []
    }

    function addGpuPciId(pciId) {
        const currentCount = gpuPciIdRefCounts[pciId] || 0
        gpuPciIdRefCounts[pciId] = currentCount + 1

        if (!gpuPciIds.includes(pciId)) {
            gpuPciIds = gpuPciIds.concat([pciId])
        }

        gpuPciIdRefCounts = Object.assign({}, gpuPciIdRefCounts)
    }

    function removeGpuPciId(pciId) {
        const currentCount = gpuPciIdRefCounts[pciId] || 0
        if (currentCount > 1) {
            gpuPciIdRefCounts[pciId] = currentCount - 1
        } else if (currentCount === 1) {
            delete gpuPciIdRefCounts[pciId]
            const index = gpuPciIds.indexOf(pciId)
            if (index > -1) {
                gpuPciIds = gpuPciIds.slice()
                gpuPciIds.splice(index, 1)
            }

            if (availableGpus && availableGpus.length > 0) {
                const updatedGpus = availableGpus.slice()
                for (var i = 0; i < updatedGpus.length; i++) {
                    if (updatedGpus[i].pciId === pciId) {
                        updatedGpus[i] = Object.assign({}, updatedGpus[i], {
                                                           "temperature": 0
                                                       })
                    }
                }
                availableGpus = updatedGpus
            }

        }

        gpuPciIdRefCounts = Object.assign({}, gpuPciIdRefCounts)
    }

    function setProcessOptions(limit = 20, sort = "cpu", disableCpu = false) {
        processLimit = limit
        processSort = sort
        noCpu = disableCpu
    }

    function updateAllStats() {
        if (dgopAvailable && refCount > 0 && enabledModules.length > 0) {
            isUpdating = true
            dgopProcess.running = true
        } else {
            isUpdating = false
        }
    }
    
    

    function initializeGpuMetadata() {
        if (!dgopAvailable)
            return
        gpuInitProcess.running = true
    }

    function initializeGpuMetadataWithNVML() {
        if (!nvmlAvailable)
            return
        nvmlGpuProcess.running = true
    }

    function initializeGpuMetadataWithIntel() {
        // Initialize Intel GPU monitoring
        // This ensures Intel GPUs are detected even if dgop doesn't detect them
        intelGpuProcess.running = true
    }

    function buildDgopCommand() {
        const cmd = ["dgop", "meta", "--json"]

        if (enabledModules.length === 0) {
            return []
        }

        const finalModules = []
        for (const module of enabledModules) {
            if (module === "gpu" && gpuPciIds.length > 0) {
                finalModules.push("gpu-temp")
            } else if (module !== "gpu") {
                finalModules.push(module)
            }
        }

        if (gpuPciIds.length > 0 && finalModules.indexOf("gpu-temp") === -1) {
            finalModules.push("gpu-temp")
        }

        if (enabledModules.indexOf("all") !== -1) {
            cmd.push("--modules", "all")
        } else if (finalModules.length > 0) {
            const moduleList = finalModules.join(",")
            cmd.push("--modules", moduleList)
        } else {
            return []
        }

        if ((enabledModules.includes("cpu") || enabledModules.includes("all")) && cpuCursor) {
            cmd.push("--cpu-cursor", cpuCursor)
        }
        if ((enabledModules.includes("processes") || enabledModules.includes("all")) && procCursor) {
            cmd.push("--proc-cursor", procCursor)
        }

        if (gpuPciIds.length > 0) {
            cmd.push("--gpu-pci-ids", gpuPciIds.join(","))
        }

        if (enabledModules.indexOf("processes") !== -1 || enabledModules.indexOf("all") !== -1) {
            cmd.push("--limit", "100")
            cmd.push("--sort", "cpu")
            if (noCpu) {
                cmd.push("--no-cpu")
            }
        }

        return cmd
    }

    function parseData(data) {
        if (data.cpu) {
            const cpu = data.cpu
            cpuSampleCount++

            cpuUsage = cpu.usage || 0
            cpuFrequency = cpu.frequency || 0
            cpuTemperature = cpu.temperature || 0
            cpuCores = cpu.count || 1
            cpuModel = cpu.model || ""
            perCoreCpuUsage = cpu.coreUsage || []
            addToHistory(cpuHistory, cpuUsage)

            if (cpu.cursor) {
                cpuCursor = cpu.cursor
            }
        }

        if (data.memory) {
            const mem = data.memory
            const totalKB = mem.total || 0
            const availableKB = mem.available || 0
            const freeKB = mem.free || 0

            totalMemoryMB = totalKB / 1024
            availableMemoryMB = availableKB / 1024
            freeMemoryMB = freeKB / 1024
            usedMemoryMB = totalMemoryMB - availableMemoryMB
            memoryUsage = totalKB > 0 ? ((totalKB - availableKB) / totalKB) * 100 : 0

            totalMemoryKB = totalKB
            usedMemoryKB = totalKB - availableKB
            totalSwapKB = mem.swaptotal || 0
            usedSwapKB = (mem.swaptotal || 0) - (mem.swapfree || 0)

            addToHistory(memoryHistory, memoryUsage)
        }

        if (data.network && Array.isArray(data.network)) {
            networkInterfaces = data.network

            let totalRx = 0
            let totalTx = 0
            for (const iface of data.network) {
                totalRx += iface.rx || 0
                totalTx += iface.tx || 0
            }

            if (lastNetworkStats) {
                const timeDiff = updateInterval / 1000
                const rxDiff = totalRx - lastNetworkStats.rx
                const txDiff = totalTx - lastNetworkStats.tx
                networkRxRate = Math.max(0, rxDiff / timeDiff)
                networkTxRate = Math.max(0, txDiff / timeDiff)
                addToHistory(networkHistory.rx, networkRxRate / 1024)
                addToHistory(networkHistory.tx, networkTxRate / 1024)
            }
            lastNetworkStats = {
                "rx": totalRx,
                "tx": totalTx
            }
        }

        if (data.disk && Array.isArray(data.disk)) {
            diskDevices = data.disk

            let totalRead = 0
            let totalWrite = 0
            for (const disk of data.disk) {
                totalRead += (disk.read || 0) * 512
                totalWrite += (disk.write || 0) * 512
            }

            if (lastDiskStats) {
                const timeDiff = updateInterval / 1000
                const readDiff = totalRead - lastDiskStats.read
                const writeDiff = totalWrite - lastDiskStats.write
                diskReadRate = Math.max(0, readDiff / timeDiff)
                diskWriteRate = Math.max(0, writeDiff / timeDiff)
                addToHistory(diskHistory.read, diskReadRate / (1024 * 1024))
                addToHistory(diskHistory.write, diskWriteRate / (1024 * 1024))
            }
            lastDiskStats = {
                "read": totalRead,
                "write": totalWrite
            }
        }

        if (data.diskmounts) {
            diskMounts = data.diskmounts || []
        }

        if (data.processes && Array.isArray(data.processes)) {
            const newProcesses = []
            processSampleCount++

            for (const proc of data.processes) {
                const cpuUsage = processSampleCount >= 2 ? (proc.cpu || 0) : 0

                newProcesses.push({
                                      "pid": proc.pid || 0,
                                      "ppid": proc.ppid || 0,
                                      "cpu": cpuUsage,
                                      "memoryPercent": proc.memoryPercent || proc.pssPercent || 0,
                                      "memoryKB": proc.memoryKB || proc.pssKB || 0,
                                      "command": proc.command || "",
                                      "fullCommand": proc.fullCommand || "",
                                      "displayName": (proc.command && proc.command.length > 15) ? proc.command.substring(0, 15) + "..." : (proc.command || "")
                                  })
            }
            allProcesses = newProcesses
            applySorting()

            if (data.cursor) {
                procCursor = data.cursor
            }
        }

        const gpuData = (data.gpu && data.gpu.gpus) || data.gpus
        if (gpuData && Array.isArray(gpuData)) {
            if (gpuPciIds.length > 0 && availableGpus && availableGpus.length > 0) {
                const updatedGpus = availableGpus.slice()
                for (var i = 0; i < updatedGpus.length; i++) {
                    const existingGpu = updatedGpus[i]
                    const tempGpu = gpuData.find(g => g.pciId === existingGpu.pciId)
                    if (tempGpu && gpuPciIds.includes(existingGpu.pciId)) {
                        updatedGpus[i] = Object.assign({}, existingGpu, {
                                                           "temperature": tempGpu.temperature || 0
                                                       })
                    }
                }
                availableGpus = updatedGpus
            } else {
                const gpuList = []
                for (const gpu of gpuData) {
                    let displayName = gpu.displayName || gpu.name || "Unknown GPU"
                    let fullName = gpu.fullName || gpu.name || "Unknown GPU"

                    gpuList.push({
                                     "driver": gpu.driver || "",
                                     "vendor": gpu.vendor || "",
                                     "displayName": displayName,
                                     "fullName": fullName,
                                     "pciId": gpu.pciId || "",
                                     "temperature": gpu.temperature || 0
                                 })
                }
                availableGpus = gpuList
            }
        }

        if (data.system) {
            const sys = data.system
            loadAverage = sys.loadavg || ""
            processCount = sys.processes || 0
            threadCount = sys.threads || 0
            bootTime = sys.boottime || ""
        }

        if (data.hardware) {
            const hw = data.hardware
            hostname = hw.hostname || ""
            kernelVersion = hw.kernel || ""
            distribution = hw.distro || ""
            architecture = hw.arch || ""
            motherboard = (hw.bios && hw.bios.motherboard) || ""
            biosVersion = (hw.bios && hw.bios.version) || ""
        }

        isUpdating = false
    }

    function addToHistory(array, value) {
        array.push(value)
        if (array.length > historySize) {
            array.shift()
        }
    }

    function getProcessIcon(command) {
        const cmd = command.toLowerCase()
        if (cmd.includes("firefox") || cmd.includes("chrome") || cmd.includes("browser") || cmd.includes("chromium")) {
            return "web"
        }
        if (cmd.includes("code") || cmd.includes("editor") || cmd.includes("vim")) {
            return "code"
        }
        if (cmd.includes("terminal") || cmd.includes("bash") || cmd.includes("zsh")) {
            return "terminal"
        }
        if (cmd.includes("music") || cmd.includes("audio") || cmd.includes("spotify")) {
            return "music_note"
        }
        if (cmd.includes("video") || cmd.includes("vlc") || cmd.includes("mpv")) {
            return "play_circle"
        }
        if (cmd.includes("systemd") || cmd.includes("elogind") || cmd.includes("kernel") || cmd.includes("kthread") || cmd.includes("kworker")) {
            return "settings"
        }
        return "memory"
    }

    function formatCpuUsage(cpu) {
        return (cpu || 0).toFixed(1) + "%"
    }

    function formatMemoryUsage(memoryKB) {
        const mem = memoryKB || 0
        if (mem < 1024) {
            return mem.toFixed(0) + " KB"
        } else if (mem < 1024 * 1024) {
            return (mem / 1024).toFixed(1) + " MB"
        } else {
            return (mem / (1024 * 1024)).toFixed(1) + " GB"
        }
    }

    function formatSystemMemory(memoryKB) {
        const mem = memoryKB || 0
        if (mem === 0) {
            return "--"
        }
        if (mem < 1024 * 1024) {
            return (mem / 1024).toFixed(0) + " MB"
        } else {
            return (mem / (1024 * 1024)).toFixed(1) + " GB"
        }
    }

    function killProcess(pid) {
        if (pid > 0) {
            Quickshell.execDetached("kill", [pid.toString()])
        }
    }

    function setSortBy(newSortBy) {
        if (newSortBy !== currentSort) {
            currentSort = newSortBy
            applySorting()
        }
    }

    function applySorting() {
        if (!allProcesses || allProcesses.length === 0) {
            return
        }

        const sorted = allProcesses.slice()
        sorted.sort((a, b) => {
                        let valueA, valueB

                        switch (currentSort) {
                            case "cpu":
                            valueA = a.cpu || 0
                            valueB = b.cpu || 0
                            return valueB - valueA
                            case "memory":
                            valueA = a.memoryKB || 0
                            valueB = b.memoryKB || 0
                            return valueB - valueA
                            case "name":
                            valueA = (a.command || "").toLowerCase()
                            valueB = (b.command || "").toLowerCase()
                            return valueA.localeCompare(valueB)
                            case "pid":
                            valueA = a.pid || 0
                            valueB = b.pid || 0
                            return valueA - valueB
                            default:
                            return 0
                        }
                    })

        processes = sorted.slice(0, processLimit)
    }

    Timer {
        id: updateTimer
        interval: root.updateInterval
        running: root.dgopAvailable && root.refCount > 0 && root.enabledModules.length > 0
        repeat: true
        triggeredOnStart: true
        onTriggered: root.updateAllStats()
    }

    Timer {
        id: nvmlUpdateTimer
        interval: 2000
        running: root.nvmlAvailable && root.refCount > 0 && root.enabledModules.includes("gpu")
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (availableGpus && availableGpus.length > 0) {
                nvmlGpuProcess.running = true
            }
        }
    }

    Timer {
        id: intelUpdateTimer
        interval: 2000
        running: root.refCount > 0 && root.enabledModules.includes("gpu")
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            // Run Intel GPU process to detect and monitor Intel GPUs
            // This runs unconditionally to ensure Intel GPUs are detected
            // even if dgop doesn't detect them
            intelGpuProcess.running = true
        }
    }

    Process {
        id: dgopProcess
        command: root.buildDgopCommand()
        running: false
        onCommandChanged: {
            if (running) {
                Qt.callLater(() => {
                    if (dgopProcess.running) {
                        dgopProcess.running = false
                    }
                })
            }
        }
        onExited: exitCode => {
            if (exitCode !== 0) {
                isUpdating = false
                if (typeof LoggingService !== 'undefined') {
                    LoggingService.warn("DgopService", "dgop process exited with error", { exitCode: exitCode })
                }
            }
        }
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim()) {
                    try {
                        const data = JSON.parse(text.trim())
                        parseData(data)
                        isUpdating = false
                    } catch (e) {
                        isUpdating = false
                        if (typeof LoggingService !== 'undefined') {
                            LoggingService.error("DgopService", "Failed to parse dgop output", { error: e.message, outputLength: text.length })
                        }
                    }
                } else {
                    isUpdating = false
                }
            }
        }
    }

    Process {
        id: gpuInitProcess
        command: ["dgop", "gpu", "--json"]
        running: false
        onExited: exitCode => {
            if (exitCode !== 0) {
                if (typeof LoggingService !== 'undefined') {
                    LoggingService.warn("DgopService", "GPU init process exited with error", { exitCode: exitCode })
                }
            }
        }
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim()) {
                    try {
                        const data = JSON.parse(text.trim())
                        parseData(data)
                    } catch (e) {
                        if (typeof LoggingService !== 'undefined') {
                            LoggingService.error("DgopService", "Failed to parse GPU init output", { error: e.message })
                        }
                    }
                }
            }
        }
    }

    Process {
        id: dgopCheckProcess
        command: ["which", "dgop"]
        running: false
        onExited: exitCode => {
            dgopAvailable = (exitCode === 0)
            if (dgopAvailable) {
                initializeGpuMetadata()
                if (SessionData.enabledGpuPciIds && SessionData.enabledGpuPciIds.length > 0) {
                    for (const pciId of SessionData.enabledGpuPciIds) {
                        addGpuPciId(pciId)
                    }
                    if (refCount > 0 && enabledModules.length > 0) {
                        updateAllStats()
                    }
                }
            }
        }
    }

    readonly property string configDir: Paths.strip(StandardPaths.writableLocation(StandardPaths.ConfigLocation))
    readonly property string nvmlPythonPath: "python3"
    readonly property string nvmlScriptPath: configDir + "/quickshell/scripts/nvidia_gpu_temp.py"
    readonly property string amdScriptPath: configDir + "/quickshell/scripts/amd_gpu_temp.py"
    readonly property string intelScriptPath: configDir + "/quickshell/scripts/intel_gpu_temp.py"

    Process {
        id: nvmlCheckProcess
        command: [nvmlPythonPath, "-c", "import pynvml; print('NVML available')"]
        running: false
        onExited: exitCode => {
            nvmlAvailable = (exitCode === 0)
            if (nvmlAvailable) {
                if (!dgopAvailable) {
                    initializeGpuMetadataWithNVML()
                }
            } else {
                // Even if NVML is not available, try Intel GPU monitoring
                if (!dgopAvailable) {
                    initializeGpuMetadataWithIntel()
                }
            }
        }
    }

    Process {
        id: nvmlGpuProcess
        command: [nvmlPythonPath, nvmlScriptPath]
        running: false
        onExited: exitCode => {
            if (exitCode !== 0) {
            }
        }
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim()) {
                    try {
                        const data = JSON.parse(text.trim())
                        if (data.gpus && Array.isArray(data.gpus)) {
                            if (availableGpus && availableGpus.length > 0) {
                                const updatedGpus = availableGpus.slice()
                                for (var i = 0; i < updatedGpus.length; i++) {
                                    const existingGpu = updatedGpus[i]
                                    const nvmlGpu = data.gpus.find(g => g.pciId === existingGpu.pciId)
                                    if (nvmlGpu) {
                                        updatedGpus[i] = Object.assign({}, existingGpu, {
                                            "temperature": nvmlGpu.temperature || 0
                                        })
                                    }
                                }
                                availableGpus = updatedGpus
                            } else {
                                const gpuList = []
                                for (const gpu of data.gpus) {
                                    gpuList.push({
                                        "driver": gpu.driver || "nvidia",
                                        "vendor": gpu.vendor || "NVIDIA",
                                        "displayName": gpu.displayName || gpu.name || "Unknown GPU",
                                        "fullName": gpu.fullName || gpu.name || "Unknown GPU",
                                        "pciId": gpu.pciId || "",
                                        "temperature": gpu.temperature || 0
                                    })
                                }
                                availableGpus = gpuList
                                
                                for (const gpu of data.gpus) {
                                    if (gpu.pciId) {
                                        addGpuPciId(gpu.pciId)
                                    }
                                }
                            }
                        } else if (data.error) {
                        }
                    } catch (e) {
                    }
                }
            }
        }
    }

    Process {
        id: intelGpuProcess
        command: [nvmlPythonPath, intelScriptPath]
        running: false
        onExited: exitCode => {
            if (exitCode !== 0) {
            }
        }
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim()) {
                    try {
                        const data = JSON.parse(text.trim())
                        if (data.gpus && Array.isArray(data.gpus)) {
                            if (availableGpus && availableGpus.length > 0) {
                                const updatedGpus = availableGpus.slice()
                                for (const intelGpu of data.gpus) {
                                    let found = false
                                    for (let i = 0; i < updatedGpus.length; i++) {
                                        const existingGpu = updatedGpus[i]
                                        if (existingGpu.pciId === intelGpu.pciId ||
                                            (existingGpu.vendor === "Intel" && intelGpu.vendor === "Intel")) {
                                            updatedGpus[i] = Object.assign({}, existingGpu, {
                                                "temperature": intelGpu.temperature || existingGpu.temperature || 0,
                                                "memoryUsed": intelGpu.memoryUsed || existingGpu.memoryUsed || 0,
                                                "memoryTotal": intelGpu.memoryTotal || existingGpu.memoryTotal || 0,
                                                "memoryUsedMB": intelGpu.memoryUsedMB || existingGpu.memoryUsedMB || 0,
                                                "memoryTotalMB": intelGpu.memoryTotalMB || existingGpu.memoryTotalMB || 0
                                            })
                                            found = true
                                            break
                                        }
                                    }
                                    if (!found) {
                                        updatedGpus.push({
                                            "driver": intelGpu.driver || "i915",
                                            "vendor": intelGpu.vendor || "Intel",
                                            "displayName": intelGpu.displayName || intelGpu.name || "Intel GPU",
                                            "fullName": intelGpu.fullName || intelGpu.name || "Intel GPU",
                                            "pciId": intelGpu.pciId || "",
                                            "temperature": intelGpu.temperature || 0,
                                            "memoryUsed": intelGpu.memoryUsed || 0,
                                            "memoryTotal": intelGpu.memoryTotal || 0,
                                            "memoryUsedMB": intelGpu.memoryUsedMB || 0,
                                            "memoryTotalMB": intelGpu.memoryTotalMB || 0
                                        })
                                    }
                                }
                                availableGpus = updatedGpus
                            } else {
                                const gpuList = []
                                for (const gpu of data.gpus) {
                                    gpuList.push({
                                        "driver": gpu.driver || "i915",
                                        "vendor": gpu.vendor || "Intel",
                                        "displayName": gpu.displayName || gpu.name || "Intel GPU",
                                        "fullName": gpu.fullName || gpu.name || "Intel GPU",
                                        "pciId": gpu.pciId || "",
                                        "temperature": gpu.temperature || 0,
                                        "memoryUsed": gpu.memoryUsed || 0,
                                        "memoryTotal": gpu.memoryTotal || 0,
                                        "memoryUsedMB": gpu.memoryUsedMB || 0,
                                        "memoryTotalMB": gpu.memoryTotalMB || 0
                                    })
                                }
                                availableGpus = gpuList
                                
                                for (const gpu of data.gpus) {
                                    if (gpu.pciId) {
                                        addGpuPciId(gpu.pciId)
                                    }
                                }
                            }
                        }
                    } catch (e) {
                    }
                }
            }
        }
    }

    Process {
        id: osReleaseProcess
        command: ["cat", "/etc/os-release"]
        running: false
        onExited: exitCode => {
            if (exitCode !== 0) {
            }
        }
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim()) {
                    try {
                        const lines = text.trim().split('\n')
                        let prettyName = ""
                        let name = ""

                        for (const line of lines) {
                            const trimmedLine = line.trim()
                            if (trimmedLine.startsWith('PRETTY_NAME=')) {
                                prettyName = trimmedLine.substring(12).replace(/^["']|["']$/g, '')
                            } else if (trimmedLine.startsWith('NAME=')) {
                                name = trimmedLine.substring(5).replace(/^["']|["']$/g, '')
                            }
                        }

                        const distroName = prettyName || name || "Linux"
                        distribution = distroName
                    } catch (e) {
                        distribution = "Linux"
                    }
                }
            }
        }
    }


    Component.onCompleted: {
        dgopCheckProcess.running = true
        nvmlCheckProcess.running = true
        osReleaseProcess.running = true
    }

    Component.onDestruction: {
        if (updateTimer.running) {
            updateTimer.stop()
        }
        if (nvmlUpdateTimer.running) {
            nvmlUpdateTimer.stop()
        }
        if (intelUpdateTimer.running) {
            intelUpdateTimer.stop()
        }
        if (dgopProcess.running) {
            dgopProcess.running = false
        }
        if (gpuInitProcess.running) {
            gpuInitProcess.running = false
        }
        if (nvmlGpuProcess.running) {
            nvmlGpuProcess.running = false
        }
        if (intelGpuProcess.running) {
            intelGpuProcess.running = false
        }
    }
}
