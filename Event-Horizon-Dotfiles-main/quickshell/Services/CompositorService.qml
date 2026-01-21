pragma Singleton

pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Singleton {
    id: root

    property bool isHyprland: false
    property bool isNiri: false
    property string compositor: "unknown"

    readonly property string hyprlandSignature: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")
    readonly property string niriSocket: Quickshell.env("NIRI_SOCKET")
    readonly property bool useHyprlandFocusGrab: isHyprland && Quickshell.env("DMS_HYPRLAND_EXCLUSIVE_FOCUS") !== "1"

    property bool useNiriSorting: isNiri && NiriService

    property var sortedToplevels: {
        if (!ToplevelManager.toplevels || !ToplevelManager.toplevels.values) {
            return []
        }

        if (useNiriSorting) {
            return NiriService.sortToplevels(ToplevelManager.toplevels.values)
        }

        if (isHyprland) {
            const hyprlandToplevels = Array.from(Hyprland.toplevels.values)

            const sortedHyprland = hyprlandToplevels.sort((a, b) => {
                                                              if (a.monitor && b.monitor) {
                                                                  const monitorCompare = a.monitor.name.localeCompare(b.monitor.name)
                                                                  if (monitorCompare !== 0) {
                                                                      return monitorCompare
                                                                  }
                                                              }

                                                              if (a.workspace && b.workspace) {
                                                                  const workspaceCompare = a.workspace.id - b.workspace.id
                                                                  if (workspaceCompare !== 0) {
                                                                      return workspaceCompare
                                                                  }
                                                              }

                                                              if (a.lastIpcObject && b.lastIpcObject && a.lastIpcObject.at && b.lastIpcObject.at) {
                                                                  const aX = a.lastIpcObject.at[0]
                                                                  const bX = b.lastIpcObject.at[0]
                                                                  const aY = a.lastIpcObject.at[1]
                                                                  const bY = b.lastIpcObject.at[1]

                                                                  const xCompare = aX - bX
                                                                  if (Math.abs(xCompare) > 10) {
                                                                      return xCompare
                                                                  }
                                                                  return aY - bY
                                                              }

                                                              if (a.lastIpcObject && !b.lastIpcObject) {
                                                                  return -1
                                                              }
                                                              if (!a.lastIpcObject && b.lastIpcObject) {
                                                                  return 1
                                                              }

                                                              if (a.title && b.title) {
                                                                  return a.title.localeCompare(b.title)
                                                              }

                                                              return 0
                                                          })

            return sortedHyprland.map(hyprToplevel => hyprToplevel.wayland).filter(wayland => wayland !== null)
        }

        return ToplevelManager.toplevels.values
    }

    Component.onCompleted: {
        detectCompositor()
    }

    function filterCurrentWorkspace(toplevels, screen) {
        if (useNiriSorting) {
            return NiriService.filterCurrentWorkspace(toplevels, screen)
        }
        if (isHyprland) {
            return filterHyprlandCurrentWorkspace(toplevels, screen)
        }
        return toplevels
    }

    function filterHyprlandCurrentWorkspace(toplevels, screenName) {
        if (!toplevels || toplevels.length === 0 || !Hyprland.toplevels) {
            return toplevels
        }

        let currentWorkspaceId = null
        const hyprlandToplevels = Array.from(Hyprland.toplevels.values)

        for (const hyprToplevel of hyprlandToplevels) {
            if (hyprToplevel.monitor && hyprToplevel.monitor.name === screenName && hyprToplevel.workspace) {
                if (hyprToplevel.activated) {
                    currentWorkspaceId = hyprToplevel.workspace.id
                    break
                }
                if (currentWorkspaceId === null) {
                    currentWorkspaceId = hyprToplevel.workspace.id
                }
            }
        }

        if (currentWorkspaceId === null && Hyprland.workspaces) {
            const workspaces = Array.from(Hyprland.workspaces.values)
            for (const workspace of workspaces) {
                if (workspace.monitor && workspace.monitor === screenName) {
                    if (Hyprland.focusedWorkspace && workspace.id === Hyprland.focusedWorkspace.id) {
                        currentWorkspaceId = workspace.id
                        break
                    }
                    if (currentWorkspaceId === null) {
                        currentWorkspaceId = workspace.id
                    }
                }
            }
        }

        if (currentWorkspaceId === null) {
            return toplevels
        }

        return toplevels.filter(toplevel => {
                                    for (const hyprToplevel of hyprlandToplevels) {
                                        if (hyprToplevel.wayland === toplevel) {
                                            return hyprToplevel.workspace && hyprToplevel.workspace.id === currentWorkspaceId
                                        }
                                    }
                                    return false
                                })
    }

    function detectCompositor() {
        if (hyprlandSignature && hyprlandSignature.length > 0) {
            isHyprland = true
            isNiri = false
            compositor = "hyprland"
            return
        }

        if (niriSocket && niriSocket.length > 0) {
            niriSocketCheck.running = true
        } else {
            isHyprland = false
            isNiri = false
            compositor = "unknown"
        }
    }

    function powerOffMonitors() {
        if (isNiri) {
            return NiriService.powerOffMonitors()
        }
        if (isHyprland) {
            return Hyprland.dispatch("dpms off")
        }
    }

    function powerOnMonitors() {
        if (isNiri) {
            return NiriService.powerOnMonitors()
        }
        if (isHyprland) {
            return Hyprland.dispatch("dpms on")
        }
    }

    function applyBlurSettings(blurSize, blurPasses) {
        if (!isHyprland) {
            return false
        }

        try {
            if (blurSize === 0) {
                hyprKeyword1.command = ["hyprctl", "keyword", "blur:enabled", "false"]
                hyprKeyword1.startDetached()
            } else {
                hyprKeyword1.command = ["hyprctl", "keyword", "blur:enabled", "true"]
                hyprKeyword1.startDetached()
                hyprKeyword2.command = ["hyprctl", "keyword", "blur:size", String(blurSize)]
                hyprKeyword2.startDetached()
                hyprKeyword3.command = ["hyprctl", "keyword", "blur:passes", String(blurPasses)]
                hyprKeyword3.startDetached()
                hyprKeyword4.command = ["hyprctl", "keyword", "blur:new_optimizations", "true"]
                hyprKeyword4.startDetached()
                hyprKeyword5.command = ["hyprctl", "keyword", "blur:ignore_opacity", "false"]
                hyprKeyword5.startDetached()
                hyprKeyword6.command = ["hyprctl", "keyword", "blur:xray", "false"]
                hyprKeyword6.startDetached()
                hyprKeyword7.command = ["hyprctl", "keyword", "blur:special", "false"]
                hyprKeyword7.startDetached()
            }
            return true
        } catch (error) {
            return false
        }
    }

    function applyHyprlandInputSetting(key, value) {
        if (!isHyprland) {
            return false
        }

        try {
            var safeValue = String(value).replace(/[\\/&]/g, "\\$&")
            var cmd = "sed -i 's/^" + key + " = .*$/"+ key + " = " + safeValue + "/' /home/matt/.config/hypr/hyprland/input.conf && hyprctl reload"
            inputUpdateProcess.command = ["sh", "-c", cmd]
            inputUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyHyprlandInputDeviceRotation(deviceName, rotation) {
        if (!isHyprland) {
            return false
        }

        try {
            var safeName = String(deviceName).replace(/\\/g, "\\\\").replace(/"/g, "\\\"")
            var safeRotation = String(rotation).replace(/[\\/&]/g, "\\$&")
            var cmd = "DEVICE_NAME=\"" + safeName + "\" ROTATION=\"" + safeRotation + "\" python3 - <<'PY'\n"
                + "import os\n"
                + "path = '/home/matt/.config/hypr/hyprland/input.conf'\n"
                + "device = os.environ.get('DEVICE_NAME', '')\n"
                + "rotation = os.environ.get('ROTATION', '0')\n"
                + "if not device:\n"
                + "    raise SystemExit(0)\n"
                + "if not os.path.exists(path):\n"
                + "    raise SystemExit(0)\n"
                + "with open(path, 'r', encoding='utf-8') as f:\n"
                + "    lines = f.read().splitlines()\n"
                + "start = end = None\n"
                + "depth = 0\n"
                + "for i, line in enumerate(lines):\n"
                + "    stripped = line.strip()\n"
                + "    if stripped.startswith('input') and stripped.endswith('{'):\n"
                + "        start = i\n"
                + "        depth = 1\n"
                + "        for j in range(i + 1, len(lines)):\n"
                + "            s = lines[j].strip()\n"
                + "            depth += s.count('{')\n"
                + "            depth -= s.count('}')\n"
                + "            if depth == 0:\n"
                + "                end = j\n"
                + "                break\n"
                + "        break\n"
                + "if start is None or end is None:\n"
                + "    raise SystemExit(0)\n"
                + "device_header = f'device:{device}'\n"
                + "dev_start = dev_end = None\n"
                + "depth = 0\n"
                + "for i in range(start + 1, end):\n"
                + "    if lines[i].strip().startswith(device_header) and lines[i].strip().endswith('{'):\n"
                + "        dev_start = i\n"
                + "        depth = 1\n"
                + "        for j in range(i + 1, end + 1):\n"
                + "            s = lines[j].strip()\n"
                + "            depth += s.count('{')\n"
                + "            depth -= s.count('}')\n"
                + "            if depth == 0:\n"
                + "                dev_end = j\n"
                + "                break\n"
                + "        break\n"
                + "if dev_start is None:\n"
                + "    block = [\n"
                + "        f'    device:{device} {{',\n"
                + "        f'        rotation = {rotation}',\n"
                + "        '    }'\n"
                + "    ]\n"
                + "    lines[end:end] = block\n"
                + "else:\n"
                + "    replaced = False\n"
                + "    for i in range(dev_start + 1, dev_end):\n"
                + "        if lines[i].strip().startswith('rotation'):\n"
                + "            lines[i] = '        rotation = ' + str(rotation)\n"
                + "            replaced = True\n"
                + "            break\n"
                + "    if not replaced:\n"
                + "        lines.insert(dev_end, '        rotation = ' + str(rotation))\n"
                + "with open(path, 'w', encoding='utf-8') as f:\n"
                + "    f.write('\\n'.join(lines) + '\\n')\n"
                + "PY\n"
                + "hyprctl reload"
            inputUpdateProcess.command = ["sh", "-c", cmd]
            inputUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyHyprlandCursorSetting(key, value) {
        if (!isHyprland) {
            return false
        }

        try {
            var safeValue = String(value).replace(/[\\/&]/g, "\\$&")
            var cmd = "sed -i 's/^" + key + " = .*$/"+ key + " = " + safeValue + "/' /home/matt/.config/hypr/hyprland/cursor.conf && hyprctl reload"
            cursorUpdateProcess.command = ["sh", "-c", cmd]
            cursorUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function updateBlurConfigSize(size) {
        if (!isHyprland) {
            return false
        }

        try {
            if (size === 0) {
                var cmd = "sed -i 's/enabled = true/enabled = false/' /home/matt/.config/hypr/hyprland/decoration.conf"
                blurConfigUpdateProcess1.command = ["sh", "-c", cmd]
                blurConfigUpdateProcess1.startDetached()
            } else {
                var cmd = "sed -i 's/enabled = false/enabled = true/; s/size = [0-9]\\+/size = " + size + "/' /home/matt/.config/hypr/hyprland/decoration.conf"
                blurConfigUpdateProcess1.command = ["sh", "-c", cmd]
                blurConfigUpdateProcess1.startDetached()

                // Also ensure other blur settings are set for comprehensive control
                var cmd2 = "sed -i 's/new_optimizations = false/new_optimizations = true/; s/ignore_opacity = true/ignore_opacity = false/; s/xray = true/xray = false/; s/special = true/special = false/' /home/matt/.config/hypr/hyprland/decoration.conf"
                blurConfigUpdateProcess2.command = ["sh", "-c", cmd2]
                blurConfigUpdateProcess2.startDetached()
            }
            return true
        } catch (error) {
            return false
        }
    }

    function updateBlurConfigPasses(passes) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/passes = [0-9]\\+/passes = " + passes + "/' /home/matt/.config/hypr/hyprland/decoration.conf"
            blurConfigUpdateProcess2.command = ["sh", "-c", cmd]
            blurConfigUpdateProcess2.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyBorderSize(size) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/border_size = [0-9]\\+/border_size = " + size + "/' /home/matt/.config/hypr/hyprland/colors.conf && hyprctl reload"
            borderUpdateProcess.command = ["sh", "-c", cmd]
            borderUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyBorderColors(hueShift, alpha) {
        if (!isHyprland) {
            return false
        }

        try {
            // Get primary color from theme
            var primaryColor = typeof Theme !== 'undefined' ? Theme.primary : Qt.rgba(0.26, 0.65, 0.96, 1.0)
            
            // Convert RGB to HSL
            var r = primaryColor.r
            var g = primaryColor.g
            var b = primaryColor.b
            var max = Math.max(r, Math.max(g, b))
            var min = Math.min(r, Math.min(g, b))
            var h, s, l = (max + min) / 2
            var d = max - min
            
            if (d !== 0) {
                s = l > 0.5 ? d / (2 - max - min) : d / (max + min)
                if (max === r) {
                    h = ((g - b) / d + (g < b ? 6 : 0)) / 6
                } else if (max === g) {
                    h = ((b - r) / d + 2) / 6
                } else {
                    h = ((r - g) / d + 4) / 6
                }
            } else {
                h = s = 0
            }
            
            // Apply hue shift (convert degrees to 0-1 range)
            h = (h + hueShift / 360.0) % 1.0
            if (h < 0) h += 1.0
            
            // Convert HSL back to RGB
            var hue2rgb = function(p, q, t) {
                if (t < 0) t += 1
                if (t > 1) t -= 1
                if (t < 1/6) return p + (q - p) * 6 * t
                if (t < 1/2) return q
                if (t < 2/3) return p + (q - p) * (2/3 - t) * 6
                return p
            }
            
            var q = l < 0.5 ? l * (1 + s) : l + s - l * s
            var p = 2 * l - q
            r = hue2rgb(p, q, h + 1/3)
            g = hue2rgb(p, q, h)
            b = hue2rgb(p, q, h - 1/3)
            
            // Blend with black background to simulate alpha
            var bgR = 0.0
            var bgG = 0.0
            var bgB = 0.0
            r = r * alpha + bgR * (1 - alpha)
            g = g * alpha + bgG * (1 - alpha)
            b = b * alpha + bgB * (1 - alpha)
            
            // Convert to hex
            var toHex = function(x) {
                var v = Math.round(Math.max(0, Math.min(255, x * 255)))
                return v.toString(16).padStart(2, '0')
            }
            var hexColor = toHex(r) + toHex(g) + toHex(b)
            
            // Update config file
            var cmd = "sed -i 's/col\\.active_border = rgb([0-9a-fA-F]\\{6\\})/col.active_border = rgb(" + hexColor + ")/' /home/matt/.config/hypr/hyprland/colors.conf && hyprctl reload"
            borderColorUpdateProcess.command = ["sh", "-c", cmd]
            borderColorUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function reloadHyprlandConfig() {
        if (!isHyprland) {
            return false
        }

        try {
            Hyprland.dispatch("reload")
            return true
        } catch (error) {
            return false
        }
    }

    Process {
        id: niriSocketCheck
        command: ["test", "-S", root.niriSocket]

        onExited: exitCode => {
            if (exitCode === 0) {
                root.isNiri = true
                root.isHyprland = false
                root.compositor = "niri"
            } else {
                root.isHyprland = false
                root.isNiri = true
                root.compositor = "niri"
            }
        }
    }

    function applyDecorationRounding(rounding) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/rounding = [0-9]\\+/rounding = " + rounding + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationRoundingPower(power) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/rounding_power = [0-9]\\+/rounding_power = " + power + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurEnabled(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/enabled = true/enabled = " + (enabled ? "true" : "false") + "/; s/enabled = false/enabled = " + (enabled ? "true" : "false") + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurXray(xray) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/xray = true/xray = " + (xray ? "true" : "false") + "/; s/xray = false/xray = " + (xray ? "true" : "false") + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurSpecial(special) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/special = true/special = " + (special ? "true" : "false") + "/; s/special = false/special = " + (special ? "true" : "false") + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurNewOptimizations(optimizations) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/new_optimizations = true/new_optimizations = " + (optimizations ? "true" : "false") + "/; s/new_optimizations = false/new_optimizations = " + (optimizations ? "true" : "false") + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurIgnoreOpacity(ignore) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/ignore_opacity = true/ignore_opacity = " + (ignore ? "true" : "false") + "/; s/ignore_opacity = false/ignore_opacity = " + (ignore ? "true" : "false") + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurSize(size) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/size = [0-9]\\+/size = " + size + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurPasses(passes) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/passes = [0-9]\\+/passes = " + passes + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurBrightness(brightness) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/brightness = [0-9.]*[0-9]*/brightness = " + brightness + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurNoise(noise) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/noise = [0-9.]*[0-9]*/noise = " + noise + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurContrast(contrast) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/contrast = [0-9.]*[0-9]*/contrast = " + contrast + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurVibrancy(vibrancy) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/vibrancy = [0-9.]*[0-9]*/vibrancy = " + vibrancy + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurVibrancyDarkness(vibrancyDarkness) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/vibrancy_darkness = [0-9.]*[0-9]*/vibrancy_darkness = " + vibrancyDarkness + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurBrightnessEnabled(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd
            if (enabled) {
                cmd = "sed -i 's/#brightness = /brightness = /' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            } else {
                cmd = "sed -i 's/brightness = /#brightness = /' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            }
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurContrastEnabled(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd
            if (enabled) {
                cmd = "sed -i 's/#contrast = /contrast = /' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            } else {
                cmd = "sed -i 's/contrast = /#contrast = /' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            }
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurPopups(popups) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/popups = true/popups = " + (popups ? "true" : "false") + "/; s/popups = false/popups = " + (popups ? "true" : "false") + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurPopupsIgnorealpha(alpha) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/popups_ignorealpha = [0-9.]*[0-9]*/popups_ignorealpha = " + alpha + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurInputMethods(inputMethods) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/input_methods = true/input_methods = " + (inputMethods ? "true" : "false") + "/; s/input_methods = false/input_methods = " + (inputMethods ? "true" : "false") + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationBlurInputMethodsIgnorealpha(alpha) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/input_methods_ignorealpha = [0-9.]*[0-9]*/input_methods_ignorealpha = " + alpha + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationShadowEnabled(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i '/shadow {/,/}/ { s/enabled = true/enabled = " + (enabled ? "true" : "false") + "/; s/enabled = false/enabled = " + (enabled ? "true" : "false") + "/; }' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationShadowIgnoreWindow(ignore) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i '/shadow {/,/}/ { s/ignore_window = true/ignore_window = " + (ignore ? "true" : "false") + "/; s/ignore_window = false/ignore_window = " + (ignore ? "true" : "false") + "/; }' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationShadowRange(range) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i '/shadow {/,/}/ { s/range = [0-9]\\+/range = " + range + "/; }' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationShadowRenderPower(power) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i '/shadow {/,/}/ { s/render_power = [0-9]\\+/render_power = " + power + "/; }' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationShadowColor(color) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i '/shadow {/,/}/ { s/color = rgba([0-9a-fA-F]\\{8\\})/color = " + color + "/; }' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationDimInactive(inactive) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/dim_inactive = true/dim_inactive = " + (inactive ? "true" : "false") + "/; s/dim_inactive = false/dim_inactive = " + (inactive ? "true" : "false") + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationDimStrength(strength) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/dim_strength = [0-9.]*[0-9]*/dim_strength = " + strength + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function applyDecorationDimSpecial(special) {
        if (!isHyprland) {
            return false
        }

        try {
            var cmd = "sed -i 's/dim_special = [0-9.]*[0-9]*/dim_special = " + special + "/' /home/matt/.config/hypr/hyprland/decoration.conf && hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function updateRenderSetting(key, value) {
        if (!isHyprland) {
            return false
        }

        try {
            var safeValue = String(value).replace(/[\\/&]/g, "\\$&")
            var cmd = "if grep -q '^" + key + " =' /home/matt/.config/hypr/hyprland/render.conf; then "
                + "sed -i 's/^" + key + " = .*$/"+ key + " = " + safeValue + "/' /home/matt/.config/hypr/hyprland/render.conf; "
                + "else sed -i '/^render {$/a\\    " + key + " = " + safeValue + "' /home/matt/.config/hypr/hyprland/render.conf; fi; "
                + "hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    function updateColorsSetting(sectionPath, key, value) {
        if (!isHyprland) {
            return false
        }

        try {
            var safeSection = String(sectionPath).replace(/[\\/&]/g, "\\$&")
            var safeKey = String(key).replace(/[\\/&]/g, "\\$&")
            var safeValue = String(value).replace(/[\\/&]/g, "\\$&")
            var cmd = "SECTION_PATH=\"" + safeSection + "\" KEY=\"" + safeKey + "\" VALUE=\"" + safeValue + "\" python3 - <<'PY'\n"
                + "import os\n"
                + "import re\n"
                + "path = '/home/matt/.config/hypr/hyprland/colors.conf'\n"
                + "section_path = os.environ.get('SECTION_PATH', '')\n"
                + "key = os.environ.get('KEY', '')\n"
                + "value = os.environ.get('VALUE', '')\n"
                + "if not key or not section_path or not os.path.exists(path):\n"
                + "    raise SystemExit(0)\n"
                + "sections = [s for s in section_path.split('/') if s]\n"
                + "with open(path, 'r', encoding='utf-8') as f:\n"
                + "    lines = f.read().splitlines()\n"
                + "def find_block(start, end, section):\n"
                + "    for i in range(start, end):\n"
                + "        stripped = lines[i].strip()\n"
                + "        if stripped.startswith(section) and stripped.endswith('{'):\n"
                + "            depth = 0\n"
                + "            for j in range(i, end):\n"
                + "                depth += lines[j].count('{')\n"
                + "                depth -= lines[j].count('}')\n"
                + "                if depth == 0:\n"
                + "                    return (i, j)\n"
                + "    return None\n"
                + "start = 0\n"
                + "end = len(lines)\n"
                + "block = None\n"
                + "for section in sections:\n"
                + "    block = find_block(start, end, section)\n"
                + "    if not block:\n"
                + "        raise SystemExit(0)\n"
                + "    start = block[0] + 1\n"
                + "    end = block[1]\n"
                + "indent = '    ' * len(sections)\n"
                + "pattern = re.compile(r'^\\s*' + re.escape(key) + r'\\s*=')\n"
                + "replaced = False\n"
                + "for i in range(start, end):\n"
                + "    if pattern.match(lines[i]):\n"
                + "        lines[i] = indent + key + ' = ' + value\n"
                + "        replaced = True\n"
                + "        break\n"
                + "if not replaced:\n"
                + "    lines.insert(end, indent + key + ' = ' + value)\n"
                + "with open(path, 'w', encoding='utf-8') as f:\n"
                + "    f.write('\\n'.join(lines) + '\\n')\n"
                + "PY\n"
                + "hyprctl reload"
            decorationUpdateProcess.command = ["sh", "-c", cmd]
            decorationUpdateProcess.startDetached()
            return true
        } catch (error) {
            return false
        }
    }

    // Render functions
    function applyRenderNewScheduling(scheduling) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateRenderSetting("new_render_scheduling", scheduling ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    function applyRenderCmFsPassthrough(passthrough) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateRenderSetting("cm_fs_passthrough", passthrough)
        } catch (error) {
            return false
        }
    }

    function applyRenderCmEnabled(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateRenderSetting("cm_enabled", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    function applyRenderSendContentType(send) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateRenderSetting("send_content_type", send ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    function applyRenderCmAutoHdr(hdr) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateRenderSetting("cm_auto_hdr", hdr ? "1" : "0")
        } catch (error) {
            return false
        }
    }

    function applyRenderDirectScanout(scanout) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateRenderSetting("direct_scanout", scanout)
        } catch (error) {
            return false
        }
    }

    function applyRenderExpandUndersizedTextures(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateRenderSetting("expand_undersized_textures", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    // Snap functions
    function applyHyprlandSnapEnabled(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("general/snap", "enabled", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    function applyHyprlandSnapWindowGap(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("general/snap", "window_gap", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandSnapMonitorGap(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("general/snap", "monitor_gap", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandSnapBorderOverlap(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("general/snap", "border_overlap", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    function applyHyprlandSnapRespectGaps(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("general/snap", "respect_gaps", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    // General functions
    function applyHyprlandGeneralGapsIn(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("general", "gaps_in", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGeneralGapsOut(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("general", "gaps_out", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGeneralGapsWorkspaces(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("general", "gaps_workspaces", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGeneralBorderSize(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("general", "border_size", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGeneralResizeOnBorder(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("general", "resize_on_border", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGeneralNoFocusFallback(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("general", "no_focus_fallback", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGeneralAllowTearing(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("general", "allow_tearing", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    // Groupbar functions
    function applyHyprlandGroupbarEnabled(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("group/groupbar", "enabled", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGroupbarColActive(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("group/groupbar", "col.active", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGroupbarColInactive(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("group/groupbar", "col.inactive", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGroupbarHeight(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("group/groupbar", "height", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGroupbarPriority(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("group/groupbar", "priority", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGroupbarRenderTitles(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("group/groupbar", "render_titles", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGroupbarFontFamily(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("group/groupbar", "font_family", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGroupbarFontSize(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("group/groupbar", "font_size", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGroupbarGradients(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("group/groupbar", "gradients", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGroupbarTextColor(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("group/groupbar", "text_color", value)
        } catch (error) {
            return false
        }
    }

    function applyHyprlandGroupbarRounding(value) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("group/groupbar", "rounding", value)
        } catch (error) {
            return false
        }
    }

    // Dwindle functions
    function applyHyprlandDwindlePreserveSplit(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("dwindle", "preserve_split", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    function applyHyprlandDwindleSmartSplit(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("dwindle", "smart_split", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    function applyHyprlandDwindleSmartResizing(enabled) {
        if (!isHyprland) {
            return false
        }

        try {
            return updateColorsSetting("dwindle", "smart_resizing", enabled ? "true" : "false")
        } catch (error) {
            return false
        }
    }

    Process { id: hyprKeyword1; command: ["true"] }
    Process { id: hyprKeyword2; command: ["true"] }
    Process { id: hyprKeyword3; command: ["true"] }
    Process { id: hyprKeyword4; command: ["true"] }
    Process { id: hyprKeyword5; command: ["true"] }
    Process { id: hyprKeyword6; command: ["true"] }
    Process { id: hyprKeyword7; command: ["true"] }
    Process { id: borderUpdateProcess; command: ["true"] }
    Process { id: borderColorUpdateProcess; command: ["true"] }
    Process { id: blurConfigUpdateProcess1; command: ["true"] }
    Process { id: blurConfigUpdateProcess2; command: ["true"] }
    Process { id: inputUpdateProcess; command: ["true"] }
    Process { id: cursorUpdateProcess; command: ["true"] }
    Process { id: decorationUpdateProcess; command: ["true"] }
}
