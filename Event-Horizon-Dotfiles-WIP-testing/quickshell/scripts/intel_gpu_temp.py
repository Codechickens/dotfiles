#!/usr/bin/env python3
import json
import os
import glob
import subprocess

def read_sysfs_file(path):
    try:
        with open(path, 'r') as f:
            return f.read().strip()
    except (OSError, IOError):
        return None

def get_short_intel_name(full_name):
    """Create a short display name for Intel GPUs"""
    name = full_name
    
    # Remove common prefixes
    if name.startswith('Intel(R)'):
        name = name[8:].strip()
    elif name.startswith('Intel '):
        name = name[6:].strip()
    
    # Remove common suffixes
    suffixes_to_remove = [
        'Processor Graphics',
        'Graphics',
        'UHD Graphics',
        'HD Graphics',
    ]
    for suffix in suffixes_to_remove:
        if name.endswith(suffix):
            name = name[:-len(suffix)].strip()
    
    # If too long, try to extract platform name
    if len(name) > 20:
        platforms = ['TigerLake', 'AlderLake', 'RaptorLake', 'MeteorLake', 
                     'IceLake', 'CometLake', 'KabyLake', 'SkyLake',
                     'Broadwell', 'Haswell', 'Apollo']
        for platform in platforms:
            if platform.lower() in full_name.lower():
                return 'Intel ' + platform
    
    if not name or len(name) < 3:
        return "Intel Graphics"
    
    return name

def get_intel_gpus():
    gpus = []

    drm_cards = sorted(glob.glob('/sys/class/drm/card*'))
    for card_path in drm_cards:
        card_name = os.path.basename(card_path)
        device_path = os.path.join(card_path, 'device')

        if not os.path.exists(device_path):
            continue

        vendor = read_sysfs_file(os.path.join(device_path, 'vendor'))
        device_id = read_sysfs_file(os.path.join(device_path, 'device'))

        # Intel vendor ID is 0x8086
        if vendor and vendor.lower() in ['0x8086', '8086']:
            display_name = "Intel GPU"
            try:
                pci_addr = read_sysfs_file(os.path.join(device_path, 'uevent'))
                if pci_addr:
                    for line in pci_addr.split('\n'):
                        if line.startswith('PCI_SLOT_NAME='):
                            pci_slot = line.split('=', 1)[1]
                            try:
                                lspci_output = subprocess.check_output(
                                    ['lspci', '-s', pci_slot, '-d', '8086:'],
                                    universal_newlines=True
                                ).strip()
                                if lspci_output:
                                    parts = lspci_output.split(':', 2)
                                    if len(parts) > 2:
                                        full_name = parts[2].split('[')[0].strip()
                                        display_name = full_name
                            except subprocess.CalledProcessError:
                                pass
                            break
            except:
                pass

            temperature = 0
            # Try multiple methods to get temperature
            hwmon_dirs = glob.glob(os.path.join(device_path, 'hwmon', 'hwmon*'))
            for hwmon_dir in hwmon_dirs:
                temp_files = glob.glob(os.path.join(hwmon_dir, 'temp*_input'))
                for temp_file in temp_files:
                    temp_raw = read_sysfs_file(temp_file)
                    if temp_raw and temp_raw.isdigit():
                        temp_celsius = int(temp_raw) / 1000.0
                        if temp_celsius > 0 and temp_celsius < 150:
                            temperature = max(temperature, temp_celsius)

            # Try hwmon with i915/xe in name
            if temperature == 0:
                for hwmon_dir in hwmon_dirs:
                    hwmon_name = read_sysfs_file(os.path.join(hwmon_dir, 'name'))
                    if hwmon_name and ('i915' in hwmon_name.lower() or 'xe' in hwmon_name.lower()):
                        temp_files = glob.glob(os.path.join(hwmon_dir, 'temp*_input'))
                        for temp_file in temp_files:
                            temp_raw = read_sysfs_file(temp_file)
                            if temp_raw and temp_raw.isdigit():
                                temp_celsius = int(temp_raw) / 1000.0
                                if temp_celsius > 0 and temp_celsius < 150:
                                    temperature = max(temperature, temp_celsius)

            memory_used = 0
            memory_total = 0

            # Try to get VRAM info for Intel dGPUs (like Intel Arc)
            vram_used = read_sysfs_file(os.path.join(device_path, 'mem_info_vram_used'))
            vram_total = read_sysfs_file(os.path.join(device_path, 'mem_info_vram_total'))

            if vram_used and vram_used.isdigit():
                memory_used = int(vram_used)

            if vram_total and vram_total.isdigit():
                memory_total = int(vram_total)

            # If no dedicated VRAM, try gtt memory
            if memory_total == 0:
                gtt_used = read_sysfs_file(os.path.join(device_path, 'mem_info_gtt_used'))
                gtt_total = read_sysfs_file(os.path.join(device_path, 'mem_info_gtt_total'))

                if gtt_used and gtt_used.isdigit():
                    memory_used = int(gtt_used)

                if gtt_total and gtt_total.isdigit():
                    memory_total = int(gtt_total)

            memory_used_mb = memory_used // (1024 * 1024) if memory_used > 0 else 0
            memory_total_mb = memory_total // (1024 * 1024) if memory_total > 0 else 0

            pci_id = ""
            try:
                pci_id = f"{vendor}:{device_id}"
            except:
                pci_id = card_name

            # Determine driver type
            driver = "i915"
            if "arc" in display_name.lower() or "xe" in display_name.lower():
                driver = "xe"

            short_name = get_short_intel_name(display_name)

            gpu_info = {
                "index": len(gpus),
                "name": short_name,
                "displayName": short_name,
                "fullName": display_name,
                "pciId": pci_id,
                "temperature": temperature,
                "memoryUsed": memory_used,
                "memoryTotal": memory_total,
                "memoryUsedMB": memory_used_mb,
                "memoryTotalMB": memory_total_mb,
                "vendor": "Intel",
                "driver": driver
            }

            gpus.append(gpu_info)

    return {"gpus": gpus}

if __name__ == "__main__":
    print(json.dumps(get_intel_gpus()))
