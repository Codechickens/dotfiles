pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool isElogind: false
    property bool hibernateSupported: false
    property bool hasPowerProfiles: false
    property bool usingPowerProfilesCtl: false
    property bool usingTunedAdm: false
    
    property string powerButtonAction: "poweroff"
    property string sleepButtonAction: "suspend"
    property string hibernateButtonAction: "hibernate"
    
    property bool lidSwitchAvailable: false
    property string lidCloseAction: "suspend"
    property string lidCloseExternalPowerAction: "suspend"
    
    property int idleSleepTimeout: 0
    property int idleSleepTimeoutOnBattery: 0
    property int idleHibernateTimeout: 0
    property int idleHibernateTimeoutOnBattery: 0
    
    property int screenDimTimeout: 600
    property int screenDimTimeoutOnBattery: 300
    property int screenOffTimeout: 1200
    property int screenOffTimeoutOnBattery: 600
    
    property int lowBatteryThreshold: 20
    property int criticalBatteryThreshold: 5
    property string lowBatteryAction: "suspend"
    property string criticalBatteryAction: "hibernate"
    
    property string powerProfile: "balanced"
    property var availableProfiles: []
    
    property bool wakeOnLAN: false
    
    property bool usbAutosuspend: true
    
    property bool isLoading: false
    property string lastError: ""

    function refreshStatus() {
        if (statusProcess.running) return
        statusProcess.running = true
    }

    function setPowerButtonAction(action) {
        if (!action || action.length === 0) return
        const cmd = isElogind ? "elogind" : "loginctl"
        setPowerButtonProcess.command = [cmd, "set-property", "HandlePowerKey", action]
        setPowerButtonProcess.running = true
    }

    function setSleepButtonAction(action) {
        if (!action || action.length === 0) return
        const cmd = isElogind ? "elogind" : "loginctl"
        setSleepButtonProcess.command = [cmd, "set-property", "HandleSleepKey", action]
        setSleepButtonProcess.running = true
    }

    function setHibernateButtonAction(action) {
        if (!action || action.length === 0) return
        const cmd = isElogind ? "elogind" : "loginctl"
        setHibernateButtonProcess.command = [cmd, "set-property", "HandleHibernateKey", action]
        setHibernateButtonProcess.running = true
    }

    function setLidCloseAction(action) {
        if (!action || action.length === 0) return
        const cmd = isElogind ? "elogind" : "loginctl"
        setLidCloseProcess.command = [cmd, "set-property", "HandleLidSwitch", action]
        setLidCloseProcess.running = true
    }

    function setLidCloseExternalPowerAction(action) {
        if (!action || action.length === 0) return
        const cmd = isElogind ? "elogind" : "loginctl"
        setLidCloseExternalPowerProcess.command = [cmd, "set-property", "HandleLidSwitchExternalPower", action]
        setLidCloseExternalPowerProcess.running = true
    }

    function setIdleSleepTimeout(timeout) {
        if (timeout <= 0) {
            const cmd = isElogind ? "elogind" : "loginctl"
            setIdleSleepProcess.command = [cmd, "set-property", "IdleAction", "ignore"]
        } else {
            const cmd = isElogind ? "elogind" : "loginctl"
            setIdleSleepProcess.command = [cmd, "set-property", "IdleAction", "suspend", "IdleActionUSec", (timeout * 1000000).toString()]
        }
        setIdleSleepProcess.running = true
    }

    function setIdleHibernateTimeout(timeout) {
        if (timeout <= 0) {
            const cmd = isElogind ? "elogind" : "loginctl"
            setIdleHibernateProcess.command = [cmd, "set-property", "IdleAction", "ignore"]
        } else {
            const cmd = isElogind ? "elogind" : "loginctl"
            setIdleHibernateProcess.command = [cmd, "set-property", "IdleAction", "hibernate", "IdleActionUSec", (timeout * 1000000).toString()]
        }
        setIdleHibernateProcess.running = true
    }

    function setScreenDimTimeout(timeout) {
        setScreenDimProcess.command = ["xset", "dpms", timeout > 0 ? timeout.toString() : "0"]
        setScreenDimProcess.running = true
    }

    function setScreenOffTimeout(timeout) {
        setScreenOffProcess.command = ["xset", "dpms", "0", timeout > 0 ? timeout.toString() : "0"]
        setScreenOffProcess.running = true
    }

    function setPowerProfile(profile) {
        if (!hasPowerProfiles) return
        if (usingPowerProfilesCtl) {
            setPowerProfileProcess.command = ["powerprofilesctl", "set", profile]
        } else if (usingTunedAdm) {
            var tunedProfile = mapTunedProfile(profile)
            if (!tunedProfile) return
            setPowerProfileProcess.command = ["tuned-adm", "profile", tunedProfile]
        } else {
            return
        }
        setPowerProfileProcess.running = true
    }

    function setWakeOnLAN(enabled) {
        root.wakeOnLAN = enabled
    }

    Component.onCompleted: {
        detectElogindProcess.running = true
        detectHibernateProcess.running = true
        detectPowerProfilesProcess.running = true
        refreshStatus()
    }

    Process {
        id: detectElogindProcess
        running: false
        command: ["sh", "-c", "ps -eo comm= | grep -E '^(elogind|elogind-daemon)$'"]
        
        onExited: exitCode => {
            root.isElogind = (exitCode === 0)
        }
    }

    Process {
        id: detectHibernateProcess
        running: false
        command: ["grep", "-q", "disk", "/sys/power/state"]
        
        onExited: exitCode => {
            root.hibernateSupported = (exitCode === 0)
        }
    }

    Process {
        id: detectPowerProfilesProcess
        running: false
        command: ["which", "powerprofilesctl"]
        
        onExited: exitCode => {
            root.usingPowerProfilesCtl = (exitCode === 0)
            if (root.usingPowerProfilesCtl) {
                root.usingTunedAdm = false
                root.hasPowerProfiles = true
                listPowerProfilesProcess.running = true
            } else {
                detectTunedAdmProcess.running = true
            }
        }
    }

    Process {
        id: listPowerProfilesProcess
        running: false
        command: ["powerprofilesctl", "list"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split('\n').filter(line => line.trim().length > 0)
                const profiles = []
                for (let line of lines) {
                    if (line.includes('*')) {
                        const match = line.match(/\*\s+(\S+)/)
                        if (match) {
                            root.powerProfile = match[1]
                        }
                    }
                    const match = line.match(/^\s*(\S+):/)
                    if (match) {
                        profiles.push(match[1])
                    }
                }
                root.availableProfiles = profiles
            }
        }
    }

    Process {
        id: detectTunedAdmProcess
        running: false
        command: ["which", "tuned-adm"]

        onExited: exitCode => {
            root.usingTunedAdm = (exitCode === 0)
            root.usingPowerProfilesCtl = false
            root.hasPowerProfiles = root.usingTunedAdm
            if (root.usingTunedAdm) {
                listTunedProfilesProcess.running = true
            }
        }
    }

    Process {
        id: listTunedProfilesProcess
        running: false
        command: ["tuned-adm", "list"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split('\n').map(line => line.trim()).filter(line => line.length > 0)
                const profiles = []
                let activeProfile = ""

                for (let line of lines) {
                    if (line.toLowerCase().startsWith("current active profile")) {
                        const parts = line.split(":")
                        activeProfile = (parts.length > 1 ? parts[parts.length - 1] : "").trim()
                        continue
                    }
                    if (line.startsWith("*")) {
                        const name = line.replace("*", "").trim()
                        if (name) {
                            profiles.push(name)
                            activeProfile = activeProfile || name
                        }
                    } else if (line.startsWith("-")) {
                        const name = line.replace("-", "").trim()
                        if (name) {
                            profiles.push(name)
                        }
                    }
                }

                root.availableProfiles = profiles
                if (activeProfile) {
                    root.powerProfile = activeProfile
                }
            }
        }
    }

    function mapTunedProfile(profile) {
        if (!profile) return ""
        if (root.availableProfiles.includes(profile)) return profile

        if (profile === "power-saver") {
            if (root.availableProfiles.includes("powersave")) return "powersave"
        }
        if (profile === "performance") {
            if (root.availableProfiles.includes("performance")) return "performance"
            if (root.availableProfiles.includes("throughput-performance")) return "throughput-performance"
            if (root.availableProfiles.includes("latency-performance")) return "latency-performance"
        }
        if (profile === "balanced") {
            if (root.availableProfiles.includes("balanced")) return "balanced"
        }

        return root.availableProfiles.length > 0 ? root.availableProfiles[0] : ""
    }

    Process {
        id: statusProcess
        running: false
        command: []
    }
}
