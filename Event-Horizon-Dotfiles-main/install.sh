#!/bin/bash

# ============================================
# Event Horizon - Universal Installation Script
# ============================================
# Auto-detects your Linux distribution and installs all dependencies
# Handles package checks, fallbacks for compilation failures, and font installation
# Supports: Arch Linux, Fedora, Ubuntu/Debian/PikaOS
# ============================================

set -e  # Exit on error

# ============================================
# Configuration & Colors
# ============================================

# Colors for beautiful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Progress indicators
CHECKMARK="${GREEN}✓${NC}"
CROSS="${RED}✗${NC}"
ARROW="${BLUE}→${NC}"
WARNING="${YELLOW}⚠${NC}"
INFO="${CYAN}ℹ${NC}"

# ============================================
# Utility Functions
# ============================================

# Copy config directories with backup
copy_config_with_backup() {
    local source_dir="$1"
    local dest_dir="$2"
    local backup_suffix="${3:-.bak}"

    # Create config directory if it doesn't exist
    mkdir -p ~/.config

    if [ -d "$dest_dir" ]; then
        local backup_dir="${dest_dir}${backup_suffix}"
        if [ ! -d "$backup_dir" ]; then
            print_info "Backing up existing $dest_dir to $backup_dir"
            mv "$dest_dir" "$backup_dir"
        else
            print_info "Backup $backup_dir already exists, skipping backup"
        fi
    fi

    print_info "Copying $source_dir to $dest_dir"
    cp -r "$source_dir" "$dest_dir"

    if [ $? -eq 0 ]; then
        print_success "Successfully installed config to $dest_dir"
    else
        print_error "Failed to copy config files"
        return 1
    fi
}

# Ask for user confirmation
ask_confirmation() {
    local message="$1"
    local default="${2:-n}"

    echo -e "${YELLOW}$message${NC}"
    if [ "$default" = "y" ]; then
        echo -n "(Y/n): "
    else
        echo -n "(y/N): "
    fi

    read -r response
    case "${response:-$default}" in
        [Yy]|[Yy][Ee][Ss])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Print formatted messages
print_header() {
    echo -e "\n${PURPLE}════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  $1${NC}"
    echo -e "${PURPLE}════════════════════════════════════════════════════════════════════════════════${NC}"
}

print_section() {
    echo -e "\n${BLUE}┌─────────────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│${NC} ${WHITE}$1${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────────────────────┘${NC}"
}

print_success() {
    echo -e "${CHECKMARK} $1"
}

print_error() {
    echo -e "${CROSS} $1"
}

print_warning() {
    echo -e "${WARNING} $1"
}

print_info() {
    echo -e "${INFO} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Check if package is installed (generic)
package_installed() {
    case "$DISTRO" in
        "arch")
            pacman -Qi "$1" &>/dev/null
            ;;
        "fedora")
            rpm -q "$1" &>/dev/null
            ;;
        "ubuntu"|"debian")
            dpkg -l "$1" 2>/dev/null | grep -q "^ii"
            ;;
        *)
            return 1
            ;;
    esac
}

# Run command with sudo if needed
run_privileged() {
    if [ "$EUID" -eq 0 ]; then
        "$@"
    else
        sudo "$@"
    fi
}

# ============================================
# Distribution Detection
# ============================================

detect_distro() {
    print_header "🔍 Detecting Linux Distribution"

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            "arch"|"manjaro"|"endeavouros"|"cachyos"|"xerolinux")
                DISTRO="arch"
                DISTRO_NAME="Arch Linux"
                PACKAGE_MANAGER="pacman"
                ;;
            "fedora"|"nobara")
                DISTRO="fedora"
                DISTRO_NAME="Fedora"
                PACKAGE_MANAGER="dnf"
                ;;
            "ubuntu"|"zorin"|"pop"|"elementary"|"linuxmint")
                DISTRO="ubuntu"
                DISTRO_NAME="Ubuntu"
                PACKAGE_MANAGER="apt"
                ;;
            "debian"|"pika")
                DISTRO="debian"
                DISTRO_NAME="Debian/PikaOS"
                PACKAGE_MANAGER="apt"
                ;;
            *)
                print_error "Unsupported distribution: $ID"
                echo -e "${YELLOW}Supported distributions: Arch Linux, Fedora, Ubuntu, Debian/PikaOS${NC}"
                exit 1
                ;;
        esac
    else
        print_error "Cannot detect distribution (/etc/os-release not found)"
        exit 1
    fi

    print_success "Detected: $DISTRO_NAME ($DISTRO)"
}

# ============================================
# Package Installation Functions
# ============================================

install_packages() {
    local packages=("$@")
    local to_install=()

    print_info "Checking packages..."

    for package in "${packages[@]}"; do
        if package_installed "$package"; then
            print_success "Already installed: $package"
        else
            print_info "Will install: $package"
            to_install+=("$package")
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        print_info "Installing ${#to_install[@]} packages..."
        case "$DISTRO" in
            "arch")
                run_privileged pacman -S --needed --noconfirm "${to_install[@]}"
                ;;
            "fedora")
                run_privileged dnf install -y "${to_install[@]}"
                ;;
            "ubuntu")
                run_privileged apt update
                run_privileged apt install -y "${to_install[@]}"
                ;;
        esac
        print_success "Installed ${#to_install[@]} packages"
    else
        print_success "All packages already installed"
    fi
}

# ============================================
# Special Package Handlers
# ============================================

setup_arch_aur() {
    print_section "Setting up AUR (Arch Linux)"

    if ! command_exists yay; then
        print_info "Installing yay AUR helper..."
        run_privileged pacman -S --needed --noconfirm git base-devel
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
        cd ~
        print_success "yay installed"
    else
        print_success "yay already installed"
    fi
}

setup_fedora_repos() {
    print_section "Setting up Fedora repositories"
    print_info "This step requires sudo permissions to enable RPM Fusion and COPR repositories"

    print_info "Enabling RPM Fusion repositories..."
    run_privileged dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    run_privileged dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

    print_info "Enabling COPR repositories..."
    run_privileged dnf copr enable -y lionheartp/Hyprland
    run_privileged dnf copr enable -y errornointernet/quickshell

    print_info "Updating package cache..."
    run_privileged dnf makecache
    print_success "Fedora repositories configured successfully"
}

install_aur_packages() {
    local packages=("$@")
    local to_install=()

    print_info "Checking AUR packages..."

    for package in "${packages[@]}"; do
        if package_installed "$package"; then
            print_success "Already installed: $package"
        else
            print_info "Will install: $package"
            to_install+=("$package")
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        print_info "Installing ${#to_install[@]} AUR packages..."
        yay -S --needed --noconfirm "${to_install[@]}"
        print_success "Installed ${#to_install[@]} AUR packages"
    else
        print_success "All AUR packages already installed"
    fi
}

# ============================================
# Build Functions with Fallbacks
# ============================================

build_matugen() {
    print_section "Installing matugen (color scheme generator)"

    if command_exists matugen; then
        print_success "matugen already installed"
        return
    fi

    print_info "Attempting to install matugen via cargo..."

    # Ensure Rust is installed
    if ! command_exists cargo; then
        print_info "Installing Rust..."
        case "$DISTRO" in
            "arch")
                install_packages rust
                ;;
            "fedora")
                install_packages rust cargo
                ;;
            "ubuntu")
                install_packages rustc cargo
                ;;
        esac
    fi

    # Try to install via cargo
    if cargo install matugen 2>/dev/null; then
        print_success "matugen installed via cargo"
    else
        print_warning "Cargo installation failed, trying build from source..."
        cd /tmp
        if git clone https://github.com/InioX/matugen.git 2>/dev/null; then
            cd matugen
            if cargo build --release 2>/dev/null; then
                run_privileged cp target/release/matugen /usr/local/bin/
                print_success "matugen built and installed from source"
            else
                print_error "Failed to build matugen from source"
                print_warning "Continuing without matugen - some features may not work"
            fi
            cd ..
            rm -rf matugen
        else
            print_error "Failed to clone matugen repository"
            print_warning "Continuing without matugen - some features may not work"
        fi
        cd ~
    fi
}

build_dgop() {
    print_section "Installing dgop (GPU optimization tool)"

    if command_exists dgop; then
        print_success "dgop already installed"
        return
    fi

    print_info "Building dgop from source..."

    # Ensure Go is installed
    if ! command_exists go; then
        print_info "Installing Go..."
        case "$DISTRO" in
            "arch")
                install_packages go
                ;;
            "fedora")
                install_packages golang
                ;;
            "ubuntu")
                install_packages golang-go
                ;;
        esac
    fi

    cd /tmp
    if git clone https://github.com/AvengeMedia/dgop.git 2>/dev/null; then
        cd dgop
        if make 2>/dev/null && run_privileged make install 2>/dev/null; then
            print_success "dgop built and installed"
        else
            print_error "Failed to build dgop"
            print_warning "Continuing without dgop - GPU optimization features may not work"
        fi
        cd ..
        rm -rf dgop
    else
        print_error "Failed to clone dgop repository"
        print_warning "Continuing without dgop - GPU optimization features may not work"
    fi
    cd ~
}

# ============================================
# Font Installation
# ============================================


# ============================================
# Python Dependencies
# ============================================

install_python_deps() {
    print_section "Installing Python Dependencies"

    if ! command_exists pip3 && ! command_exists pip; then
        print_info "Installing pip..."
        case "$DISTRO" in
            "arch")
                install_packages python-pip
                ;;
            "fedora")
                install_packages python3-pip
                ;;
            "ubuntu"|"debian")
                install_packages python3-pip
                ;;
        esac
    fi

    print_info "Installing pynvml..."
    if python3 -c "import pynvml" 2>/dev/null; then
        print_success "pynvml already installed"
    else
        case "$DISTRO" in
            "ubuntu"|"debian")
                pip3 install pynvml --break-system-packages 2>/dev/null || pip3 install pynvml --user
                ;;
            *)
                pip3 install pynvml --user 2>/dev/null || pip3 install pynvml
                ;;
        esac
        print_success "pynvml installed"
    fi
}

# ============================================
# Main Installation Logic
# ============================================

main() {
    print_header "🚀 DarkMatter Shell - Universal Installer"
    echo -e "${CYAN}Welcome to the DarkMatter Shell installer!${NC}"
    echo -e "${WHITE}This script will install all dependencies needed for DarkMatter.${NC}\n"

    # Verify we're in the correct directory
    if [ ! -d "hypr" ] || [ ! -d "quickshell" ]; then
        print_error "Error: This script must be run from the DarkMatter repository root directory."
        print_info "Make sure hypr/ and quickshell/ directories exist in the current location."
        exit 1
    fi

    # Detect distribution
    detect_distro

    # Ask for user confirmation
    echo
    if ! ask_confirmation "Continue with installation for $DISTRO_NAME? This will install all required dependencies and copy configuration files."; then
        echo -e "${YELLOW}Installation cancelled by user.${NC}"
        exit 0
    fi

    # Check if running as root (warn but continue)
    if [ "$EUID" -eq 0 ]; then
        print_warning "Running as root - some operations may not work correctly"
        echo -e "${YELLOW}Consider running as regular user with sudo when prompted${NC}"
    fi

    # Setup repositories for Fedora (requires sudo)
    if [ "$DISTRO" = "fedora" ]; then
        setup_fedora_repos
    fi

    # Update system
    print_section "Updating System"
    case "$DISTRO" in
        "arch")
            run_privileged pacman -Syu --noconfirm
            ;;
        "fedora")
            run_privileged dnf update -y
            ;;
        "ubuntu"|"debian")
            run_privileged apt update && run_privileged apt upgrade -y
            ;;
    esac
    print_success "System updated"

    # Define package lists by distro
    case "$DISTRO" in
        "arch")
            # Official packages
            OFFICIAL_PACKAGES=(
                brightnessctl hyprland cliphist easyeffects firefox fuzzel gedit grim
                mission-center nautilus nwg-look pavucontrol polkit polkit-gnome
                mate-polkit ptyxis qt6ct slurp swappy tesseract wl-clipboard
                xdg-desktop-portal-hyprland yad qt6-5compat xorg-xhost quickshell
            )

            install_packages "${OFFICIAL_PACKAGES[@]}"

            # AUR packages
            setup_arch_aur
            AUR_PACKAGES=(
                anyrun dgop matugen-git python-pynvml
                wlogout
            )
            install_aur_packages "${AUR_PACKAGES[@]}"
            ;;

        "fedora")
            FEDORA_PACKAGES=(
                hyprland-git hyprpicker swww xdg-desktop-portal-hyprland
                xdg-desktop-portal-wlr xdg-desktop-portal-gnome gnome-keyring
                brightnessctl cliphist easyeffects firefox fuzzel gedit
                gnome-disks gnome-system-monitor gnome-text-editor grim nautilus
                nwg-look pavucontrol polkit mate-polkit ptyxis qt6ct slurp
                swappy tesseract wl-clipboard wlogout yad quickshell-git
                rust cargo gcc gcc-c++ pkg-config openssl-devel libX11-devel
                libXcursor-devel libXrandr-devel libXi-devel mesa-libGL-devel
                fontconfig-devel freetype-devel expat-devel cairo-gobject
                cairo-gobject-devel rust-gdk4-sys+default-devel gtk4-layer-shell-devel
                qt5-qtgraphicaleffects qt6-qt5compat python3-pyqt6 python3.11
                python3.11-libs libxcrypt-compat libcurl libcurl-devel apr
                fuse-libs fuse btop lm_sensors gedit nwg-look
            )

            install_packages "${FEDORA_PACKAGES[@]}"
            ;;

        "ubuntu")
            UBUNTU_PACKAGES=(
                hyprland-git swww xdg-desktop-portal-hyprland xdg-desktop-portal-wlr
                xdg-desktop-portal-gnome gnome-keyring brightnessctl cliphist
                easyeffects firefox fuzzel gedit gnome-system-monitor gnome-text-editor
                grim nautilus nwg-look pavucontrol mate-polkit-bin ptyxis qt6ct
                slurp swappy tesseract-ocr wl-clipboard wlogout yad rustc cargo
                gcc g++ pkg-config libssl-dev libx11-dev libxcursor-dev libxrandr-dev
                libxi-dev libgl1-mesa-dev libfontconfig-dev libfreetype-dev
                libexpat1-dev curl unzip fontconfig libcairo2-dev libgtk-4-dev
                libgtk-layer-shell-dev qtbase5-dev qt6-base-dev python3-pyqt6
                python3 python3-dev libcurl4-openssl-dev fuse libfuse2t64 btop
                lm-sensors golang-go make python3-pip quickshell-git qml6-module-qtquick-controls
                qml6-module-qtcore qml6-module-qtquick-effects qml6-module-qt5compat-graphicaleffects
                qml6-module-qt-labs-folderlistmodel qml6-module-qt-labs-platform
            )

            install_packages "${UBUNTU_PACKAGES[@]}"
            ;;

        "debian")
            # PikaOS/Debian uses similar packages to Ubuntu
            DEBIAN_PACKAGES=(
                hyprland swww xdg-desktop-portal-hyprland xdg-desktop-portal-wlr
                xdg-desktop-portal-gnome gnome-keyring brightnessctl cliphist
                easyeffects firefox fuzzel gedit gnome-system-monitor gnome-text-editor
                grim nautilus nwg-look pavucontrol mate-polkit-bin ptyxis qt6ct
                slurp swappy tesseract-ocr wl-clipboard wlogout yad rustc cargo
                gcc g++ pkg-config libssl-dev libx11-dev libxcursor-dev libxrandr-dev
                libxi-dev libgl1-mesa-dev libfontconfig-dev libfreetype-dev
                libexpat1-dev curl unzip fontconfig libcairo2-dev libgtk-4-dev
                libgtk-layer-shell-dev qtbase5-dev qt6-base-dev python3-pyqt6
                python3 python3-dev libcurl4-openssl-dev fuse libfuse2t64 btop
                lm-sensors golang-go make python3-pip quickshell qml6-module-qtquick-controls
                qml6-module-qtcore qml6-module-qtquick-effects qml6-module-qt5compat-graphicaleffects
                qml6-module-qt-labs-folderlistmodel qml6-module-qt-labs-platform
            )

            install_packages "${DEBIAN_PACKAGES[@]}"
            ;;
    esac

    # Python dependencies
    install_python_deps

    # Build tools that may fail (with fallbacks)
    build_matugen
    build_dgop

    # Post-installation
    print_section "Post-Installation Setup"
    print_info "Setting up user directories..."
    xdg-user-dirs-update 2>/dev/null || print_warning "xdg-user-dirs-update failed (non-critical)"

    # Copy configuration files
    print_info "Installing configuration files..."

    copy_config_with_backup "hypr" ~/.config/hypr
    copy_config_with_backup "quickshell" ~/.config/quickshell

    # Success message
    print_header "🎉 Installation Complete!"
    echo -e "${GREEN}DarkMatter Shell has been installed successfully!${NC}"
    echo -e "${WHITE}What's been set up:${NC}"
    echo -e "  ${CHECKMARK} All required dependencies"
    echo -e "  ${CHECKMARK} Configuration files in ~/.config/hypr/ and ~/.config/quickshell/"
    echo -e "  ${CHECKMARK} Existing configs backed up with .bak extension"
    echo -e "${WHITE}Next steps:${NC}"
    echo -e "  ${ARROW} Check out the features documentation"
    echo -e "  ${ARROW} Customize your Hyprland configuration"

    if [ "$EUID" -eq 0 ]; then
        echo -e "\n${WARNING} You ran this script as root. Some user-specific configurations may need manual setup.${NC}"
    fi
}

# ============================================
# Script Entry Point
# ============================================

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
