#!/bin/bash

# Generate PNG icons for FVWM from desktop files
# This script extracts icon names from .desktop files and converts them to PNG

set -e

ICON_DIR="../icons"
ICON_SIZE=24

# Load shared application lists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/fvwm-applications-list.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if ImageMagick is installed
if ! command -v convert >/dev/null 2>&1; then
    print_error "ImageMagick is not installed. Please install it first."
    exit 1
fi

print_status "Generating FVWM menu icons from desktop files..."

# Create icons directory if it doesn't exist
mkdir -p "$ICON_DIR"

# Function to find and convert icon
generate_icon() {
    local desktop_file="$1"
    local output_name="$2"
    
    if [ ! -f "$desktop_file" ]; then
        print_error "Desktop file not found: $desktop_file"
        return 1
    fi
    
    # Extract icon name from desktop file
    local icon_name=$(grep "^Icon=" "$desktop_file" | head -1 | cut -d= -f2)
    
    if [ -z "$icon_name" ]; then
        print_error "No icon found in $desktop_file"
        return 1
    fi
    
    print_status "Looking for icon: $icon_name"
    
    # Try to find the icon file
    local icon_file=""
    
    # Search in common icon locations
    for size in ${ICON_SIZE} 48 64 128 256 scalable; do
        for theme in hicolor Papirus gnome Adwaita oxygen breeze; do
            for ext in svg png xpm; do
                local search_paths=(
                    "/usr/share/icons/$theme/${size}x${size}/apps/$icon_name.$ext"
                    "/usr/share/icons/$theme/$size/apps/$icon_name.$ext"
                    "/usr/share/icons/$theme/scalable/apps/$icon_name.$ext"
                    "/usr/share/pixmaps/$icon_name.$ext"
                    "/usr/share/pixmaps/$icon_name"
                )
                
                for path in "${search_paths[@]}"; do
                    if [ -f "$path" ]; then
                        icon_file="$path"
                        break 4
                    fi
                done
            done
        done
    done
    
    if [ -z "$icon_file" ]; then
        print_error "Icon file not found for: $icon_name"
        return 1
    fi
    
    print_status "Found icon: $icon_file"
    
    # Convert to PNG if needed
    local output_file="$ICON_DIR/$output_name.png"
    
    if [[ "$icon_file" == *.png ]] && [ $(identify -format "%w" "$icon_file") -eq $ICON_SIZE ]; then
        # Already a PNG of correct size, just copy
        cp "$icon_file" "$output_file"
        print_success "Copied: $output_name.png"
    else
        # Convert to PNG
        convert "$icon_file" -resize ${ICON_SIZE}x${ICON_SIZE} "$output_file" 2>/dev/null
        if [ $? -eq 0 ]; then
            print_success "Generated: $output_name.png"
        else
            print_error "Failed to convert: $icon_name"
            return 1
        fi
    fi
    
    # Remove white backgrounds for specific icons
    if [[ "$output_name" == "keepassxc" ]] || [[ "$output_name" == "thunderbird" ]]; then
        magick "$output_file" -fuzz 10% -transparent white "$output_file" 2>/dev/null
        print_status "Made background transparent for: $output_name"
    fi
}

# Generate icons for all apps from the list
print_status "Generating icons for core applications..."

# Function to try multiple desktop file locations
find_and_generate() {
    local app_name="$1"
    local output_name="$2"
    
    # Common desktop file patterns
    local patterns=(
        "/usr/share/applications/$app_name.desktop"
        "/usr/share/applications/*$app_name*.desktop"
        "/usr/local/share/applications/$app_name.desktop"
        "$HOME/.local/share/applications/$app_name.desktop"
    )
    
    for pattern in "${patterns[@]}"; do
        for file in $pattern; do
            if [ -f "$file" ]; then
                generate_icon "$file" "$output_name" && return 0
            fi
        done
    done
    
    print_error "No desktop file found for: $app_name"
    return 1
}

# Generate icons for core apps
for app in "${FVWM_CORE_APPS[@]}"; do
    case "$app" in
        "gnome-terminal")
            find_and_generate "org.gnome.Terminal" "terminal" || find_and_generate "gnome-terminal" "terminal" || true
            ;;
        "pcmanfm-qt")
            find_and_generate "pcmanfm-qt" "file-manager" || true
            ;;
        "keepassxc")
            find_and_generate "org.keepassxc.KeePassXC" "keepassxc" || true
            ;;
        "thunderbird")
            find_and_generate "thunderbird" "thunderbird" || true
            ;;
        "rofi")
            find_and_generate "rofi" "rofi" || true
            ;;
        "xterm")
            find_and_generate "xterm" "xterm" || true
            ;;
    esac
done

print_status "Generating icons for additional applications..."

# Brave Browser
find_and_generate "brave-browser" "brave" || true

# Visual Studio Code
find_and_generate "code" "vscode" || true

print_status "Generating icons for system tray applications..."

generate_icon "/usr/share/applications/nm-connection-editor.desktop" "network" || true
generate_icon "/usr/share/applications/xfce4-power-manager-settings.desktop" "power" || true
generate_icon "/usr/share/applications/blueman-manager.desktop" "bluetooth" || true

print_success "Icon generation complete!"
print_status "Generated icons are in: $ICON_DIR"
