#!/bin/bash

# ============================================
# Event Horizon - Universal Installation Script
# ============================================
# Auto-detects your Linux distribution and installs all dependencies
# Handles package checks, fallbacks for compilation failures, and font installation
# Supports: Arch Linux, Fedora, Ubuntu/Debian/PikaOS
# ============================================

# Run in bash regardless of which shell invokes this script
if [ -z "$BASH_VERSION" ]; then
    exec bash "$0" "$@"
fi

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

    # Resolve source to absolute path
    local abs_source
    abs_source=$(realpath "$source_dir" 2>/dev/null) || abs_source="$source_dir"

    # Determine the final destination (source folder name inside dest_dir)
    local source_name=$(basename "$source_dir")
    local final_dest="${dest_dir}/${source_name}"

    if [ -d "$final_dest" ]; then
        local backup_dir="${final_dest}${backup_suffix}"
        if [ ! -d "$backup_dir" ]; then
            print_info "Backing up existing $final_dest to $backup_dir"
            mv "$final_dest" "$backup_dir"
        else
            print_info "Backup $backup_dir already exists, skipping backup"
        fi
    fi

    print_info "Copying $abs_source to $final_dest"
    cp -r "$abs_source" "$final_dest"

    if [ $? -eq 0 ]; then
        print_success "Successfully installed config to $final_dest"
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
        "debian")
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

    # Initialize CachyOS flag
    CACHYOS=false

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            "cachyos")
                DISTRO="arch"
                DISTRO_NAME="CachyOS"
                PACKAGE_MANAGER="pacman"
                CACHYOS=true
                ;;
            "arch"|"manjaro"|"endeavouros"|"xerolinux")
                DISTRO="arch"
                DISTRO_NAME="Arch Linux"
                PACKAGE_MANAGER="pacman"
                ;;
            "fedora"|"nobara")
                DISTRO="fedora"
                DISTRO_NAME="Fedora"
                PACKAGE_MANAGER="dnf"
                ;;
            "debian"|"pika")
                DISTRO="debian"
                DISTRO_NAME="Debian/PikaOS"
                PACKAGE_MANAGER="apt"
                ;;
            "ubuntu"|"zorin"|"pop"|"elementary"|"linuxmint")
                print_error "Your distribution ($ID) is not supported by this installer or Hyprland"
                echo -e "${YELLOW}Please migrate to PikaOS instead, which is built from Debian and can fully meet your needs${NC}"
                echo -e "${CYAN}PikaOS provides a better experience with superior performance, gaming optimizations, and full Hyprland support.${NC}"
                echo -e "${BLUE}Learn more: https://wiki.pika-os.com/en/home${NC}"
                echo -e "${WHITE}Installation instructions and ISOs are available on the PikaOS website.${NC}"
                exit 1
                ;;
            *)
                print_error "Unsupported distribution: $ID"
                echo -e "${YELLOW}Supported distributions: Arch Linux, Fedora, Debian/PikaOS${NC}"
                echo -e "${CYAN}For Ubuntu-based distributions, we recommend switching to PikaOS for the best Hyprland experience.${NC}"
                echo -e "${BLUE}Learn more about PikaOS: https://wiki.pika-os.com/en/home${NC}"
                exit 1
                ;;
        esac
    else
        print_error "Cannot detect distribution (/etc/os-release not found)"
        exit 1
    fi

    print_success "Detected: $DISTRO_NAME ($DISTRO)"

    if [ "$CACHYOS" = true ]; then
        print_info "CachyOS detected - will check CachyOS repo for matugen and dgop"
    fi
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
            "debian")
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

# Check if package is available in CachyOS repo
check_cachyos_repo() {
    local package="$1"
    # CachyOS repo packages can be checked via pacman
    pacman -Ss "^${package}$" 2>/dev/null | grep -q "cachyos" && return 0
    return 1
}

# Install matugen and dgop from CachyOS repo if available
install_cachyos_cached_packages() {
    if [ "$CACHYOS" = false ]; then
        return 1
    fi

    local installed_any=false
    local packages_to_install=()

    # Check and install matugen from CachyOS repo
    if check_cachyos_repo "matugen"; then
        if ! package_installed "matugen"; then
            print_info "matugen available in CachyOS repo, installing..."
            packages_to_install+=("matugen")
        else
            print_success "matugen already installed"
        fi
        installed_any=true
    fi

    # Check and install dgop from CachyOS repo
    if check_cachyos_repo "dgop"; then
        if ! package_installed "dgop"; then
            print_info "dgop available in CachyOS repo, installing..."
            packages_to_install+=("dgop")
        else
            print_success "dgop already installed"
        fi
        installed_any=true
    fi

    # Install any packages found
    if [ ${#packages_to_install[@]} -gt 0 ]; then
        run_privileged pacman -S --needed --noconfirm "${packages_to_install[@]}"
        print_success "Installed CachyOS repo packages: ${packages_to_install[*]}"
    fi

    return 0
}

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

    # Skip if CachyOS and we want to avoid compiling
    if [ "$CACHYOS" = true ]; then
        print_warning "matugen not found, but CachyOS repo should have it"
        print_info "Try: sudo pacman -S matugen"
        return 1
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
            "debian")
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

    # Skip if CachyOS and we want to avoid compiling
    if [ "$CACHYOS" = true ]; then
        print_warning "dgop not found, but CachyOS repo should have it"
        print_info "Try: sudo pacman -S dgop"
        return 1
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
            "debian")
                install_packages golang-go make
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

    # First ensure pip is installed via package manager
    if ! command_exists pip3 && ! command_exists pip; then
        print_info "Installing pip..."
        case "$DISTRO" in
            "arch")
                run_privileged pacman -S --needed --noconfirm python-pip
                ;;
            "fedora")
                run_privileged dnf install -y python3-pip
                ;;
            "debian")
                run_privileged apt install -y python3-pip
                ;;
        esac
        # Refresh shell hash table so pip3 is found immediately
        hash -r
    fi

    print_info "Installing pynvml..."
    if python3 -c "import pynvml" 2>/dev/null; then
        print_success "pynvml already installed"
    else
        case "$DISTRO" in
            "debian")
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
    if [ ! -d "./hypr" ] || [ ! -d "./quickshell" ]; then
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
        "debian")
            run_privileged apt update && run_privileged apt upgrade -y
            ;;
    esac
    print_success "System updated"

    # Define package lists by distro
    case "$DISTRO" in
        "arch")
            # Official packages
            OFFICIAL_PACKAGES=(
                hyprland quickshell brightnessctl cliphist fuzzel gedit grim
                mission-center nautilus nwg-look pavucontrol polkit polkit-gnome
                mate-polkit ptyxis qt6ct slurp swappy tesseract wl-clipboard
                xdg-desktop-portal-hyprland yad qt6-5compat xorg-xhost jq matugen
            )

            install_packages "${OFFICIAL_PACKAGES[@]}"

            # CachyOS has matugen and dgop in their repo, check first
            if [ "$CACHYOS" = true ]; then
                install_cachyos_cached_packages
            fi

            # AUR packages (excluding matugen/dgop for CachyOS since they're in repo)
            setup_arch_aur
            AUR_PACKAGES=(
                anyrun python-pynvml wlogout
            )
            # Add dgop to AUR only if not CachyOS (matugen is in stock Arch repos)
            if [ "$CACHYOS" = false ]; then
                AUR_PACKAGES+=("dgop")
            fi
            install_aur_packages "${AUR_PACKAGES[@]}"
            ;;

        "fedora")
            FEDORA_PACKAGES=(
                hyprland hyprpicker swww xdg-desktop-portal-hyprland
                gnome-keyring brightnessctl cliphist fuzzel gedit
                gnome-disks gnome-system-monitor gnome-text-editor grim nautilus
                nwg-look pavucontrol polkit mate-polkit ptyxis qt6ct slurp
                swappy tesseract wl-clipboard wlogout yad quickshell
                qt5-qtgraphicaleffects qt6-qt5compat python3-pyqt6 btop gedit nwg-look quickshell jq
            )

            install_packages "${FEDORA_PACKAGES[@]}"
            ;;


        "debian")
            # PikaOS/Debian uses similar packages to Ubuntu
            DEBIAN_PACKAGES=(
                hyprland xdg-desktop-portal-hyprland gnome-keyring brightnessctl cliphist
                fuzzel gedit gnome-system-monitor gnome-text-editor
                grim nautilus nwg-look pavucontrol mate-polkit-bin ptyxis qt6ct
                slurp swappy tesseract-ocr wl-clipboard wlogout yad qtbase5-dev
                qt6-base-dev python3-pyqt6 python3 python3-dev libcurl4-openssl-dev
                fuse libfuse2t64 btop lm-sensors golang-go make python3-pip quickshell
                qml6-module-qtquick-controls qml6-module-qtcore qml6-module-qtquick-effects
                qml6-module-qt5compat-graphicaleffects qml6-module-qt-labs-folderlistmodel
                qml6-module-qt-labs-platform matugen dgop jq
            )

            install_packages "${DEBIAN_PACKAGES[@]}"
            ;;
    esac

    # Python dependencies
    install_python_deps

    # Build tools that may fail (with fallbacks)
    # Skip if CachyOS and packages were installed from repo
    if [ "$CACHYOS" = true ]; then
        if command_exists matugen && command_exists dgop; then
            print_success "matugen and dgop installed from CachyOS repo, skipping build"
        else
            # Only build if not already installed
            command_exists matugen || build_matugen
            command_exists dgop || build_dgop
        fi
    else
        build_matugen
        build_dgop
    fi

    # Post-installation
    print_section "Post-Installation Setup"
    print_info "Setting up user directories..."
    xdg-user-dirs-update 2>/dev/null || print_warning "xdg-user-dirs-update failed (non-critical)"

    # Copy configuration files
    print_info "Installing configuration files..."

    copy_config_with_backup "./hypr" ~/.config
    copy_config_with_backup "./quickshell" ~/.config

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
