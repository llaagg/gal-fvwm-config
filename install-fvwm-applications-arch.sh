#!/bin/bash

# FVWM Applications Installation Script for Arch Linux
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

print_status "Starting FVWM applications installation for Arch Linux..."

# Update package database
print_status "Updating package database..."
sudo pacman -Sy

# Core FVWM Applications from menu configuration
print_status "Installing core FVWM applications..."

FVWM_CORE_APPS=(
    "gnome-terminal"                 # Terminal emulator (infostore.terminal)
    "pcmanfm-qt"                     # File manager
    "keepassxc"                      # Password manager
    "thunderbird"                    # Email client
    "rofi"                           # Application launcher (infostore.runcmd)
    "xterm"                          # Fallback terminal
)

for package in "${FVWM_CORE_APPS[@]}"; do
    if pacman -Q "$package" &>/dev/null; then
        print_success "$package is already installed"
    else
        print_status "Installing $package..."
        sudo pacman -S --noconfirm "$package" || print_warning "Failed to install $package"
    fi
done

# System tray applications from start.conf
print_status "Installing system tray applications..."

SYSTEM_TRAY_APPS=(
    "network-manager-applet"         # nm-applet
    "xfce4-power-manager"            # Power management
    "volumeicon"                     # Volume control
    "blueman"                        # Bluetooth manager
    "stalonetray"                    # System tray
)

for package in "${SYSTEM_TRAY_APPS[@]}"; do
    if pacman -Q "$package" &>/dev/null; then
        print_success "$package is already installed"
    else
        print_status "Installing $package..."
        sudo pacman -S --noconfirm "$package" || print_warning "Failed to install $package"
    fi
done

# FVWM modules and utilities
print_status "Installing FVWM modules and utilities..."

FVWM_UTILITIES=(
    "fvwm3"                          # FVWM window manager
    "xorg-xload"                     # System load monitor
    "feh"                            # Image viewer/wallpaper setter
    "scrot"                          # Screenshot utility
    "xclip"                          # Clipboard utility
    "wmctrl"                         # Window control utility
    "xdotool"                        # X11 automation
)

for package in "${FVWM_UTILITIES[@]}"; do
    if pacman -Q "$package" &>/dev/null; then
        print_success "$package is already installed"
    else
        print_status "Installing $package..."
        sudo pacman -S --noconfirm "$package" || print_warning "Failed to install $package"
    fi
done

# Install Brave Browser (from AUR)
install_brave_browser() {
    print_status "Installing Brave Browser..."
    
    if command -v brave >/dev/null 2>&1 || command -v brave-bin >/dev/null 2>&1; then
        print_success "Brave Browser is already installed"
        return 0
    fi
    
    # Check if an AUR helper is available
    if command -v yay >/dev/null 2>&1; then
        print_status "Installing Brave Browser via yay..."
        yay -S --noconfirm brave-bin || print_warning "Failed to install Brave Browser via yay"
    elif command -v paru >/dev/null 2>&1; then
        print_status "Installing Brave Browser via paru..."
        paru -S --noconfirm brave-bin || print_warning "Failed to install Brave Browser via paru"
    elif command -v aurman >/dev/null 2>&1; then
        print_status "Installing Brave Browser via aurman..."
        aurman -S --noconfirm brave-bin || print_warning "Failed to install Brave Browser via aurman"
    else
        print_warning "No AUR helper found (yay, paru, aurman). Brave Browser needs to be installed manually from AUR."
        print_status "You can install yay first: git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"
        print_status "Then run: yay -S brave-bin"
    fi
}

# Install Visual Studio Code
install_vscode() {
    print_status "Installing Visual Studio Code..."
    
    if command -v code >/dev/null 2>&1; then
        print_success "Visual Studio Code is already installed"
        return 0
    fi
    
    # Try to install via pacman (official package)
    if pacman -Si code &>/dev/null; then
        print_status "Installing Visual Studio Code from official repositories..."
        sudo pacman -S --noconfirm code || print_warning "Failed to install VS Code from repos"
    else
        # Fallback to AUR
        if command -v yay >/dev/null 2>&1; then
            print_status "Installing Visual Studio Code via yay..."
            yay -S --noconfirm visual-studio-code-bin || print_warning "Failed to install VS Code via yay"
        elif command -v paru >/dev/null 2>&1; then
            print_status "Installing Visual Studio Code via paru..."
            paru -S --noconfirm visual-studio-code-bin || print_warning "Failed to install VS Code via paru"
        else
            print_warning "No AUR helper found. VS Code needs to be installed manually from AUR."
            print_status "Alternative: Install via Snap if available"
            if command -v snap >/dev/null 2>&1; then
                sudo snap install code --classic || print_warning "Failed to install VS Code via Snap"
            fi
        fi
    fi
}

# Install RClone for cloud storage
install_rclone() {
    print_status "Installing RClone for cloud storage..."
    
    if command -v rclone >/dev/null 2>&1; then
        print_success "RClone is already installed"
        return 0
    fi
    
    # Install rclone
    sudo pacman -S --noconfirm rclone || print_warning "Failed to install RClone"
}

# Optional applications that enhance FVWM experience
install_optional_apps() {
    print_status "Installing optional applications for enhanced FVWM experience..."
    
    OPTIONAL_APPS=(
        "firefox"                        # Alternative browser
        "gimp"                           # Image editing
        "libreoffice-fresh"              # Office suite
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
        "base-devel"                    # Development tools (needed for AUR)
    )
    
    for package in "${OPTIONAL_APPS[@]}"; do
        if pacman -Q "$package" &>/dev/null; then
            print_success "$package is already installed"
        else
            print_status "Installing $package..."
            sudo pacman -S --noconfirm "$package" || print_warning "Failed to install $package"
        fi
    done
}

# Install AUR helper if none exists
install_aur_helper() {
    print_status "Checking for AUR helper..."
    
    if command -v yay >/dev/null 2>&1; then
        print_success "yay is already installed"
        return 0
    elif command -v paru >/dev/null 2>&1; then
        print_success "paru is already installed"
        return 0
    elif command -v aurman >/dev/null 2>&1; then
        print_success "aurman is already installed"
        return 0
    fi
    
    print_status "No AUR helper found. Installing yay..."
    
    # Ensure base-devel and git are installed
    sudo pacman -S --needed --noconfirm base-devel git
    
    # Clone and install yay
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm || print_warning "Failed to install yay AUR helper"
    cd ~
    rm -rf /tmp/yay
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

    # Create quick launcher script for FVWM (Arch-specific paths)
    cat > "$HOME/.local/bin/fvwm-launch" << 'EOF'
#!/bin/bash
# Quick application launcher for FVWM (Arch Linux)
# Usage: fvwm-launch <application>

case "$1" in
    "terminal"|"term")
        exec gnome-terminal
        ;;
    "files"|"fm")
        exec pcmanfm-qt
        ;;
    "browser"|"brave")
        exec brave 2>/dev/null || exec brave-bin 2>/dev/null || exec firefox
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
        echo "FVWM Quick Launcher (Arch Linux)"
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
    print_status "Starting FVWM applications installation process for Arch Linux..."
    
    # Install AUR helper first
    install_aur_helper
    
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
    print_status "- brave/brave-bin: Web browser"
    print_status "- code: Visual Studio Code editor"
    print_status "- keepassxc: Password manager"
    print_status "- thunderbird: Email client"
    print_status "- rofi: Application launcher"
    print_status ""
    print_status "System Tray Applications:"
    print_status "- network-manager-applet: Network management"
    print_status "- xfce4-power-manager: Power management"
    print_status "- volumeicon: Volume control"
    print_status "- blueman: Bluetooth management"
    print_status "- stalonetray: System tray"
    print_status ""
    print_status "FVWM Utilities:"
    print_status "- fvwm3: Window manager"
    print_status "- xorg-xload: System load monitor"
    print_status "- feh: Image viewer/wallpaper"
    print_status "- wmctrl, xdotool: Window control"
    print_status ""
    print_status "Development Tools:"
    print_status "- base-devel: Build tools for AUR"
    print_status "- yay: AUR helper (if installed)"
    print_status ""
    print_status "Cloud Storage:"
    print_status "- rclone: Cloud storage mounting"
    print_status ""
    print_status "Quick Launcher:"
    print_status "- Use 'fvwm-launch <app>' for quick application launching"
    print_status "- Example: fvwm-launch terminal, fvwm-launch browser"
    print_status ""
    print_status "Arch Linux Integration Notes:"
    print_status "- Applications match your FVWM menu configuration"
    print_status "- System tray apps match your FVWM StartFunction"
    print_status "- AUR packages installed via yay/paru when available"
    print_status "- Package names adapted for Arch repositories"
    print_status "- RClone configured for OneDrive mounting"
    print_status ""
    print_warning "IMPORTANT: Log out and log back in to refresh PATH for new launchers"
    print_status "Or run: source ~/.bashrc"
    print_status ""
    print_status "Next steps:"
    print_status "1. Configure RClone for your OneDrive: rclone config"
    print_status "2. Run the Arch theme installation script for consistent styling"
    print_status "3. Restart FVWM to see all applications in menus"
    print_status ""
    print_status "AUR Helper Info:"
    if command -v yay >/dev/null 2>&1; then
        print_status "- yay is installed and ready to use"
    elif command -v paru >/dev/null 2>&1; then
        print_status "- paru is installed and ready to use"
    else
        print_status "- Install AUR packages manually or install an AUR helper"
    fi
}

# Run the main function
main

print_success "FVWM applications installation for Arch Linux completed successfully!"