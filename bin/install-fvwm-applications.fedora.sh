#!/bin/bash

# FVWM Applications Installation Script for Fedora Linux
# This script installs applications referenced in the FVWM configuration.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be run as root"
    exit 1
fi

if ! command -v dnf >/dev/null 2>&1; then
    print_error "dnf was not found. This script is for Fedora Linux."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/fvwm-applications-list.sh"

install_package() {
    local package="$1"

    if rpm -q "$package" >/dev/null 2>&1; then
        print_success "$package is already installed"
    else
        print_status "Installing $package..."
        sudo dnf install -y "$package" || print_warning "Failed to install $package"
    fi
}

install_packages() {
    local package

    for package in "$@"; do
        install_package "$package"
    done
}

install_brave_browser() {
    if command -v brave-browser >/dev/null 2>&1; then
        print_success "Brave Browser is already installed"
        return 0
    fi

    print_status "Adding the Brave Browser repository..."
    sudo dnf config-manager addrepo \
        --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo \
        || print_warning "Could not add the Brave Browser repository"
    install_package brave-browser
}

install_vscode() {
    if command -v code >/dev/null 2>&1; then
        print_success "Visual Studio Code is already installed"
        return 0
    fi

    print_status "Adding the Visual Studio Code repository..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo dnf config-manager addrepo \
        https://packages.microsoft.com/yumrepos/vscode/config.repo \
        || print_warning "Could not add the Visual Studio Code repository"
    install_package code
}

install_rclone() {
    if command -v rclone >/dev/null 2>&1; then
        print_success "RClone is already installed"
    else
        install_package rclone
    fi
}

create_fvwm_launchers() {
    print_status "Creating FVWM application launchers..."
    mkdir -p "$HOME/.local/share/applications" "$HOME/.local/bin"

    cat > "$HOME/.local/share/applications/fvwm-terminal.desktop" <<'EOF'
[Desktop Entry]
Name=FVWM Terminal
Comment=Terminal with FVWM theme
Keywords=shell;prompt;command;commandline;
Exec=gnome-terminal
Icon=utilities-terminal
Type=Application
Categories=System;TerminalEmulator;
StartupNotify=true
EOF

    cat > "$HOME/.local/share/applications/fvwm-filemanager.desktop" <<'EOF'
[Desktop Entry]
Name=FVWM File Manager
Comment=File manager with FVWM theme
Keywords=folder;manager;explore;disk;filesystem;
Exec=pcmanfm-qt
Icon=folder
Type=Application
Categories=System;FileManager;
StartupNotify=true
EOF

    cat > "$HOME/.local/bin/fvwm-launch" <<'EOF'
#!/bin/bash

case "$1" in
    terminal|term) exec gnome-terminal ;;
    files|fm) exec pcmanfm-qt ;;
    browser|brave) exec brave-browser 2>/dev/null || exec firefox ;;
    code|editor) exec code ;;
    mail|email) exec thunderbird ;;
    password|keepass) exec keepassxc ;;
    run|rofi) exec rofi -show drun ;;
    *)
        echo "Usage: fvwm-launch {terminal|files|browser|code|mail|password|run}"
        exit 1
        ;;
esac
EOF
    chmod +x "$HOME/.local/bin/fvwm-launch"

    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi

    print_success "FVWM application launchers created"
}

print_status "Updating Fedora package metadata..."
sudo dnf makecache

print_status "Installing core FVWM applications..."
install_packages "${FVWM_CORE_APPS[@]}"

print_status "Installing system tray applications..."
SYSTEM_TRAY_APPS=("${SYSTEM_TRAY_APPS_COMMON[@]}" "${SYSTEM_TRAY_APPS_FEDORA[@]}")
install_packages "${SYSTEM_TRAY_APPS[@]}"

print_status "Installing FVWM modules and utilities..."
FVWM_UTILITIES=("${FVWM_UTILITIES_COMMON[@]}" "${FVWM_UTILITIES_FEDORA[@]}")
install_packages "${FVWM_UTILITIES[@]}"

print_status "Installing optional applications..."
OPTIONAL_APPS=(firefox gimp libreoffice vlc gkrellm htop tree curl wget git vim nano)
install_packages "${OPTIONAL_APPS[@]}"

install_brave_browser
install_vscode
install_rclone
create_fvwm_launchers

print_success "FVWM applications installation for Fedora Linux completed"
print_status "Run 'rclone config' to configure cloud storage, then restart FVWM."
print_warning "Log out and back in, or run 'source ~/.bashrc', to refresh PATH."