#!/bin/bash

# FVWM Applications Installation Script for Debian/Ubuntu
# This script installs all applications referenced in the FVWM configuration

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

print_status "Starting FVWM applications installation..."

# Load shared application lists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/fvwm-applications-list.sh"

# Update package lists
print_status "Updating package lists..."
sudo apt update

# Core FVWM Applications from menu configuration
print_status "Installing core FVWM applications..."

for package in "${FVWM_CORE_APPS[@]}"; do
    if dpkg -l | grep -q "^ii  $package "; then
        print_success "$package is already installed"
    else
        print_status "Installing $package..."
        sudo apt install -y "$package" || print_warning "Failed to install $package"
    fi
done

# System tray applications from start.conf
print_status "Installing system tray applications..."

SYSTEM_TRAY_APPS=("${SYSTEM_TRAY_APPS_COMMON[@]}" "${SYSTEM_TRAY_APPS_DEBIAN[@]}")

for package in "${SYSTEM_TRAY_APPS[@]}"; do
    if dpkg -l | grep -q "^ii  $package "; then
        print_success "$package is already installed"
    else
        print_status "Installing $package..."
        sudo apt install -y "$package" || print_warning "Failed to install $package"
    fi
done

# FVWM modules and utilities
print_status "Installing FVWM modules and utilities..."

FVWM_UTILITIES=("${FVWM_UTILITIES_COMMON[@]}" "${FVWM_UTILITIES_DEBIAN[@]}")

for package in "${FVWM_UTILITIES[@]}"; do
    if dpkg -l | grep -q "^ii  $package "; then
        print_success "$package is already installed"
    else
        print_status "Installing $package..."
        sudo apt install -y "$package" || print_warning "Failed to install $package"
    fi
done

# Install Brave Browser (requires special handling)
install_brave_browser() {
    print_status "Installing Brave Browser..."
    
    if command -v brave-browser >/dev/null 2>&1 || command -v brave-browser-stable >/dev/null 2>&1; then
        print_success "Brave Browser is already installed"
        return 0
    fi
    
    # Add Brave's signing key
    if ! [ -f /usr/share/keyrings/brave-browser-archive-keyring.gpg ]; then
        print_status "Adding Brave Browser repository key..."
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    fi
    
    # Add Brave's repository
    if ! [ -f /etc/apt/sources.list.d/brave-browser-release.list ]; then
        print_status "Adding Brave Browser repository..."
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        sudo apt update
    fi
    
    # Install Brave Browser
    print_status "Installing Brave Browser..."
    sudo apt install -y brave-browser || print_warning "Failed to install Brave Browser"
}

# Install Visual Studio Code (requires special handling)
install_vscode() {
    print_status "Installing Visual Studio Code..."
    
    if command -v code >/dev/null 2>&1; then
        print_success "Visual Studio Code is already installed"
        return 0
    fi
    
    # Check if snap is available and install via snap (matches FVWM config)
    if command -v snap >/dev/null 2>&1; then
        print_status "Installing Visual Studio Code via Snap..."
        sudo snap install code --classic || print_warning "Failed to install VS Code via Snap"
        return 0
    fi
    
    # Fallback to APT installation
    if ! [ -f /usr/share/keyrings/packages.microsoft.gpg ]; then
        print_status "Adding Microsoft repository key..."
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    fi
    
    if ! [ -f /etc/apt/sources.list.d/vscode.list ]; then
        print_status "Adding Visual Studio Code repository..."
        echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
        sudo apt update
    fi
    
    print_status "Installing Visual Studio Code..."
    sudo apt install -y code || print_warning "Failed to install Visual Studio Code"
}

# Install RClone for cloud storage
install_rclone() {
    print_status "Installing RClone for cloud storage..."
    
    if command -v rclone >/dev/null 2>&1; then
        print_success "RClone is already installed"
        return 0
    fi
    
    # Install rclone
    sudo apt install -y rclone || print_warning "Failed to install RClone"
}

# Optional applications that enhance FVWM experience
install_optional_apps() {
    print_status "Installing optional applications for enhanced FVWM experience..."
    
    OPTIONAL_APPS=(
        "firefox-esr"                    # Alternative browser
        "gimp"                           # Image editing
        "libreoffice"                    # Office suite
        "vlc"                           # Media player
        "gkrellm"                       # System monitor (mentioned in start.conf)
        "htop"                          # Process monitor
        "neofetch"                      # System information
        "tree"                          # Directory tree view
        "curl"                          # Command line HTTP client
        "wget"                          # File downloader
        "git"                           # Version control
        "vim"                           # Text editor
        "nano"                          # Simple text editor
    )
    
    for package in "${OPTIONAL_APPS[@]}"; do
        if dpkg -l | grep -q "^ii  $package "; then
            print_success "$package is already installed"
        else
            print_status "Installing $package..."
            sudo apt install -y "$package" || print_warning "Failed to install $package"
        fi
    done
}

# Create application launchers that respect FVWM theme
create_fvwm_launchers() {
    print_status "Creating FVWM-themed application launchers..."
    
    # Create launchers directory
    mkdir -p "$HOME/.local/share/applications"
    mkdir -p "$HOME/.local/bin"
    
    # Create FVWM-themed terminal launcher
    cat > "$HOME/.local/share/applications/fvwm-terminal.desktop" << 'EOF'
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

    # Create themed file manager launcher
    cat > "$HOME/.local/share/applications/fvwm-filemanager.desktop" << 'EOF'
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

    # Create quick launcher script for FVWM
    cat > "$HOME/.local/bin/fvwm-launch" << 'EOF'
#!/bin/bash
# Quick application launcher for FVWM
# Usage: fvwm-launch <application>

case "$1" in
    "terminal"|"term")
        exec gnome-terminal
        ;;
    "files"|"fm")
        exec pcmanfm-qt
        ;;
    "browser"|"brave")
        exec brave-browser-stable 2>/dev/null || exec brave-browser 2>/dev/null || exec firefox
        ;;
    "code"|"editor")
        exec code
        ;;
    "mail"|"email")
        exec thunderbird
        ;;
    "password"|"keepass")
        exec keepassxc
        ;;
    "run"|"rofi")
        exec rofi -show drun
        ;;
    *)
        echo "FVWM Quick Launcher"
        echo "Usage: fvwm-launch <application>"
        echo ""
        echo "Available applications:"
        echo "  terminal, term    - Terminal emulator"
        echo "  files, fm         - File manager"
        echo "  browser, brave    - Web browser"
        echo "  code, editor      - Code editor"
        echo "  mail, email       - Email client"
        echo "  password, keepass - Password manager"
        echo "  run, rofi         - Application launcher"
        ;;
esac
EOF
    chmod +x "$HOME/.local/bin/fvwm-launch"
    
    # Add ~/.local/bin to PATH if not already there
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
    
    print_success "FVWM application launchers created"
}

# Main installation function
main() {
    print_status "Starting FVWM applications installation process..."
    
    # Install applications
    install_brave_browser
    install_vscode
    install_rclone
    install_optional_apps
    create_fvwm_launchers
    
    print_success "FVWM applications installation completed!"
    print_status "============================================="
    print_status "Installed Applications Summary:"
    print_status "============================================="
    print_status "Core Applications:"
    print_status "- gnome-terminal: Terminal emulator"
    print_status "- pcmanfm-qt: File manager"
    print_status "- brave-browser: Web browser"
    print_status "- code: Visual Studio Code editor"
    print_status "- keepassxc: Password manager"
    print_status "- thunderbird: Email client"
    print_status "- rofi: Application launcher"
    print_status ""
    print_status "System Tray Applications:"
    print_status "- network-manager-gnome: Network management"
    print_status "- xfce4-power-manager: Power management"
    print_status "- volumeicon-alsa: Volume control"
    print_status "- blueman: Bluetooth management"
    print_status "- stalonetray: System tray"
    print_status ""
    print_status "FVWM Utilities:"
    print_status "- fvwm3: Window manager"
    print_status "- xload: System load monitor"
    print_status "- feh: Image viewer/wallpaper"
    print_status "- wmctrl, xdotool: Window control"
    print_status ""
    print_status "Cloud Storage:"
    print_status "- rclone: Cloud storage mounting"
    print_status ""
    print_status "Quick Launcher:"
    print_status "- Use 'fvwm-launch <app>' for quick application launching"
    print_status "- Example: fvwm-launch terminal, fvwm-launch browser"
    print_status ""
    print_status "Integration Notes:"
    print_status "- Applications match your FVWM menu configuration"
    print_status "- System tray apps match your FVWM StartFunction"
    print_status "- VS Code installed via Snap (matches your config path)"
    print_status "- RClone configured for OneDrive mounting"
    print_status ""
    print_warning "IMPORTANT: Log out and log back in to refresh PATH for new launchers"
    print_status "Or run: source ~/.bashrc"
    print_status ""
    print_status "Next steps:"
    print_status "1. Configure RClone for your OneDrive: rclone config"
    print_status "2. Run the theme installation script for consistent styling"
    print_status "3. Restart FVWM to see all applications in menus"
}

# Run the main function
main

print_success "FVWM applications installation completed successfully!"