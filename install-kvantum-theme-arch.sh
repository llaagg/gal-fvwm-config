#!/bin/bash

# Kvantum Theme Installation and Configuration Script for Arch Linux
# This script installs all necessary packages and configures themes for a consistent desktop experience

set -e  # Exit on any error

# Colors for output RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' BLUE='\033[0;34m' NC='\033[0m' # No Color

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

print_status "Starting Kvantum theme installation and configuration for Arch Linux..."

# Update package database
print_status "Updating package database..."
sudo pacman -Sy

# Install Kvantum and Qt-related packages
print_status "Installing Kvantum theme engine and Qt packages..." KVANTUM_PACKAGES=(
    "kvantum"                        # Kvantum theme engine for Qt5/Qt6
    "qt5ct"                          # Qt5 configuration tool
    "qt6ct"                          # Qt6 configuration tool
    "qt5-wayland"                    # Qt5 Wayland support
    "qt6-wayland"                    # Qt6 Wayland support
    "qgnomeplatform-qt5"             # Qt5 GNOME platform theme
    "qgnomeplatform-qt6"             # Qt6 GNOME platform theme
    "adwaita-qt5"                    # Adwaita theme for Qt5
    "adwaita-qt6"                    # Adwaita theme for Qt6
)

for package in "${KVANTUM_PACKAGES[@]}"; do
    if pacman -Q "$package" &>/dev/null; then
        print_success "$package is already installed"
    else
        print_status "Installing $package..."
        sudo pacman -S --noconfirm "$package" || print_warning "Failed to install $package"
    fi
done

# Install GTK theme packages and tools
print_status "Installing GTK theme packages and configuration tools..." GTK_PACKAGES=(
    "gtk-engine-murrine"             # Murrine GTK theme engine
    "gnome-themes-extra"             # Additional GNOME themes
    "arc-gtk-theme"                  # Arc theme for GTK
    "papirus-icon-theme"             # Papirus icon theme
    "adwaita-icon-theme"             # Default GNOME icon theme
    "hicolor-icon-theme"             # HiColor icon theme
    "breeze-icons"                   # KDE Breeze icon theme
    "numix-icon-theme-git"           # Numix icon theme (AUR)
    "lxappearance"                   # GTK theme configurator
    "dconf-editor"                   # Advanced configuration editor
    "gsettings-desktop-schemas"      # Desktop schemas for gsettings
    "ttf-dejavu"                     # DejaVu fonts family
    "ttf-liberation"                 # Liberation fonts (metric-compatible with Windows fonts)
    "noto-fonts"                     # Google Noto fonts
    "fontconfig"                     # Font configuration library
    "ttf-ubuntu-font-family"         # Ubuntu font family
    "ttf-roboto"                     # Roboto font family
    "ttf-opensans"                   # Open Sans font family
    "rofi"                           # Application launcher (for FVWM harmony)
    "xfce4-power-manager"            # Power manager (already in FVWM start)
    "volumeicon"                     # Volume control (already in FVWM start)
    "blueman"                        # Bluetooth manager (already in FVWM start)
    "network-manager-applet"         # Network manager applet (nm-applet in FVWM)
)

for package in "${GTK_PACKAGES[@]}"; do
    if pacman -Q "$package" &>/dev/null; then
        print_success "$package is already installed"
    else
        print_status "Installing $package..."
        # Skip AUR packages with a warning
        if [[ "$package" == *"-git" ]] || [[ "$package" == *"-bin" ]]; then
            print_warning "Skipping AUR package $package (requires AUR helper like yay or paru)"
        else
            sudo pacman -S --noconfirm "$package" || print_warning "Failed to install $package (might not be available in official repos)"
        fi
    fi
done

# Install additional icon themes
print_status "Installing additional icon themes..." ICON_PACKAGES=(
    "elementary-icon-theme"          # Elementary icon theme  
    "oxygen-icons"                   # KDE Oxygen icon theme
)

for package in "${ICON_PACKAGES[@]}"; do
    if pacman -Q "$package" &>/dev/null; then
        print_success "$package is already installed"
    else
        print_status "Installing $package..."
        sudo pacman -S --noconfirm "$package" || print_warning "Failed to install $package (might not be available)"
    fi
done

# Install additional common fonts that might be missing
print_status "Installing additional common fonts..." ADDITIONAL_FONTS=(
    "ttf-liberation"                 # Liberation fonts (already in main list but checking again)
    "ttf-droid"                      # Droid fonts
    "gnu-free-fonts"                 # GNU FreeFont family
)

for package in "${ADDITIONAL_FONTS[@]}"; do
    if pacman -Q "$package" &>/dev/null; then
        print_success "$package is already installed"
    else
        print_status "Installing $package..."
        sudo pacman -S --noconfirm "$package" 2>/dev/null || print_warning "Failed to install $package (might not be available)"
    fi
done

# Configuration functions
configure_qt() {
    print_status "Configuring Qt applications to use Kvantum..."
    
    # Create Qt5 configuration directory
    mkdir -p "$HOME/.config/qt5ct"
    
    # Create Qt5 configuration file (harmonized with FVWM fonts)
    cat > "$HOME/.config/qt5ct/qt5ct.conf"<< 'EOF' [Appearance] color_scheme_path=
custom_palette=false icon_theme=Papirus standard_dialogs=default style=kvantum [Fonts] fixed="DejaVu Sans Mono,8,-1,5,75,0,0,0,0,0" general="Sans,8,-1,5,75,0,0,0,0,0" [Interface] activate_item_on_single_click=1 buttonbox_layout=0 cursor_flash_time=1000 dialog_buttons_have_icons=1 double_click_interval=400 gui_effects=@Invalid() keyboard_scheme=2 menus_have_icons=true show_shortcuts_in_context_menus=true stylesheets=@Invalid() toolbutton_style=4 underline_shortcut=1 wheel_scroll_lines=3 [SettingsWindow] geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\x2\x80\0\0\x1\x90\0\0\x5\x7f\0\0\x4\x37\0\0\x2\x80\0\0\x1\x90\0\0\x5\x7f\0\0\x4\x37\0\0\0\0\0\0\0\0\a\x80\0\0\x2\x80\0\0\x1\x90\0\0\x5\x7f\0\0\x4\x37) [Troubleshooting] force_raster_widgets=1 ignored_applications=@Invalid()
EOF

    # Create Qt6 configuration directory
    mkdir -p "$HOME/.config/qt6ct"
    
    # Create Qt6 configuration file (harmonized with FVWM fonts)
    cat > "$HOME/.config/qt6ct/qt6ct.conf" << 'EOF' [Appearance] color_scheme_path=
custom_palette=false icon_theme=Papirus standard_dialogs=default style=kvantum [Fonts] fixed="DejaVu Sans Mono,8,-1,5,75,0,0,0,0,0" general="Sans,8,-1,5,75,0,0,0,0,0" [Interface] activate_item_on_single_click=1 buttonbox_layout=0 cursor_flash_time=1000 dialog_buttons_have_icons=1 double_click_interval=400 gui_effects=@Invalid() keyboard_scheme=2 menus_have_icons=true show_shortcuts_in_context_menus=true stylesheets=@Invalid() toolbutton_style=4 underline_shortcut=1 wheel_scroll_lines=3 [SettingsWindow] geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\x2\x80\0\0\x1\x90\0\0\x5\x7f\0\0\x4\x37\0\0\x2\x80\0\0\x1\x90\0\0\x5\x7f\0\0\x4\x37\0\0\0\0\0\0\0\0\a\x80\0\0\x2\x80\0\0\x1\x90\0\0\x5\x7f\0\0\x4\x37) [Troubleshooting] force_raster_widgets=1 ignored_applications=@Invalid()
EOF

    # Create Kvantum configuration directory
    mkdir -p "$HOME/.config/Kvantum"
    
    # Create Kvantum configuration file (harmonized with FVWM Art-Deco blue theme)
    cat > "$HOME/.config/Kvantum/kvantum.kvconfig" << 'EOF' [General] theme=KvArcDark [%General] author=Tsu Jan comment=A dark theme harmonized with FVWM Art-Deco blue theme x11drag=menubar_and_primary_toolbar alt_mnemonic=true animate_states=true blurring=true buttonsize=+0 click_behavior=0 composite=true contrast=1.00 dialog_button_layout=0 drag_from_buttons=false fill_rubberband=false group_toolbar_buttons=false groupbox_top_label=true hide_combo_checkboxes=false inline_spin_indicators=false joined_inactive_tabs=false layout_margin=4 layout_spacing=3 left_tabs=true merge_menubar_with_toolbar=true mirror_doc_tabs=false no_window_pattern=false opaque=kaffeine,kmplayer,subtitlecomposer,kdenlive,vlc,smplayer,smplayer2,avidemux,avidemux2_qt4,avidemux2_qt5,avidemux2,VirtualBox,VirtualBoxVM,trojita,dragon,digikam popup_blurring=true reduce_menu_opacity=0 reduce_window_opacity=0 remove_extra_frames=false scroll_min_extent=36 scrollable_menu=false scrollbar_in_view=false slider_handle_length=16 slider_handle_width=16 slider_width=4 spin_button_width=16 submenu_overlap=0 textless_progressbar=false thick_separators=false toolbar_icon_size=16 toolbar_interior_spacing=2 tooltip_delay=-1 tree_branch_line=true vertical_spin_indicators=false
EOF

    print_success "Qt configuration completed"
}

configure_gtk() {
    print_status "Configuring GTK applications..."
    
    # Create GTK-3.0 configuration directory
    mkdir -p "$HOME/.config/gtk-3.0"
    
    # Create GTK-3.0 settings file (harmonized with FVWM fonts)
    cat > "$HOME/.config/gtk-3.0/settings.ini" << 'EOF' [Settings] gtk-theme-name=Arc-Dark gtk-icon-theme-name=Papirus gtk-font-name=Sans Bold 8 gtk-cursor-theme-name=Adwaita gtk-cursor-theme-size=24 gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR gtk-button-images=1 gtk-menu-images=1 gtk-enable-event-sounds=1 gtk-enable-input-feedback-sounds=0 gtk-xft-antialias=1 gtk-xft-hinting=1 gtk-xft-hintstyle=hintfull gtk-xft-rgba=rgb gtk-application-prefer-dark-theme=1 gtk-decoration-layout=menu:minimize,maximize,close gtk-primary-button-warps-slider=1 gtk-enable-animations=1 gtk-enable-primary-paste=1 gtk-recent-files-max-age=30 gtk-recent-files-enabled=1
EOF

    # Create GTK-4.0 configuration directory
    mkdir -p "$HOME/.config/gtk-4.0"
    
    # Create GTK-4.0 settings file (harmonized with FVWM fonts)
    cat > "$HOME/.config/gtk-4.0/settings.ini" << 'EOF' [Settings] gtk-theme-name=Arc-Dark gtk-icon-theme-name=Papirus gtk-font-name=Sans Bold 8 gtk-cursor-theme-name=Adwaita gtk-cursor-theme-size=24 gtk-application-prefer-dark-theme=1 gtk-decoration-layout=menu:minimize,maximize,close gtk-primary-button-warps-slider=1 gtk-enable-animations=1 gtk-enable-primary-paste=1 gtk-recent-files-max-age=30 gtk-recent-files-enabled=1
EOF

    # Create/update GTK-2.0 configuration (harmonized with FVWM fonts)
    cat > "$HOME/.gtkrc-2.0" << 'EOF'
# GTK-2.0 Configuration - Harmonized with FVWM gtk-theme-name="Arc-Dark" gtk-icon-theme-name="Papirus" gtk-font-name="Sans Bold 8" gtk-cursor-theme-name="Adwaita" gtk-cursor-theme-size=24 gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR gtk-button-images=1 gtk-menu-images=1 gtk-enable-event-sounds=1 gtk-enable-input-feedback-sounds=0 gtk-xft-antialias=1 gtk-xft-hinting=1 gtk-xft-hintstyle="hintfull" gtk-xft-rgba="rgb" gtk-application-prefer-dark-theme=1 gtk-auto-mnemonics=1

# Include Arc-Dark theme engine
include "/usr/share/themes/Arc-Dark/gtk-2.0/gtkrc"

# Widget style configurations
style "default" {
    GtkButton::default_border = { 0, 0, 0, 0 }
    GtkRange::trough_border = 0
    GtkPaned::handle_size = 6
    GtkRange::slider_width = 15
    GtkRange::stepper_size = 15
    GtkScrollbar::min_slider_length = 30
    GtkCheckButton::indicator_size = 12
    GtkMenuBar::internal-padding = 0
    GtkTreeView::expander_size = 14
    GtkTreeView::vertical-separator = 0
    GtkMenu::horizontal-padding = 0
    GtkMenu::vertical-padding = 0
}
widget_class "*" style "default"
EOF

    # Configure gsettings for GNOME applications
    if command -v gsettings >/dev/null 2>&1; then
        print_status "Configuring GNOME settings..."
        gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark' 2>/dev/null || true
        gsettings set org.gnome.desktop.interface icon-theme 'Papirus' 2>/dev/null || true
        gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita' 2>/dev/null || true
        gsettings set org.gnome.desktop.interface font-name 'Sans Bold 8' 2>/dev/null || true
        gsettings set org.gnome.desktop.interface prefer-dark-theme true 2>/dev/null || true
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
        
        # Widget and appearance settings
        gsettings set org.gnome.desktop.interface enable-animations true 2>/dev/null || true
        gsettings set org.gnome.desktop.interface toolkit-accessibility false 2>/dev/null || true
        gsettings set org.gnome.desktop.interface enable-hot-corners false 2>/dev/null || true
        gsettings set org.gnome.desktop.interface clock-show-seconds false 2>/dev/null || true
        
        # Terminal-specific settings
        gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false 2>/dev/null || true
        gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark' 2>/dev/null || true
        gsettings set org.gnome.Terminal.Legacy.Settings new-terminal-mode 'tab' 2>/dev/null || true
        
        # File chooser and GTK widget settings
        gsettings set org.gtk.Settings.FileChooser sort-directories-first true 2>/dev/null || true
        gsettings set org.gtk.Settings.FileChooser show-hidden false 2>/dev/null || true
        gsettings set org.gtk.Settings.FileChooser show-size-column true 2>/dev/null || true
        
        # Window manager settings for better integration
        gsettings set org.gnome.desktop.wm.preferences button-layout 'menu:minimize,maximize,close' 2>/dev/null || true
        gsettings set org.gnome.desktop.wm.preferences theme 'Arc-Dark' 2>/dev/null || true
    fi

    print_success "GTK configuration completed"
    
    # Create GTK CSS override for better widget styling
    mkdir -p "$HOME/.config/gtk-3.0"
    cat > "$HOME/.config/gtk-3.0/gtk.css" << 'EOF'
/* GTK-3.0 CSS overrides for better Arc-Dark theme integration */

/* Ensure dark theme is applied */
@import url("resource:///org/gtk/libgtk/theme/Adwaita/gtk-contained-dark.css");

/* Override with Arc-Dark specific styling */
window {
    background-color: #383C4A;
    color: #D3DAE3;
}

headerbar {
    background-image: linear-gradient(to bottom, #404552, #383C4A);
    border-color: #2B2E39;
    color: #D3DAE3;
}

button {
    background-image: linear-gradient(to bottom, #454954, #3C4049);
    border-color: #2B2E39;
    color: #D3DAE3;
}

entry {
    background-color: #404552;
    border-color: #2B2E39;
    color: #D3DAE3;
}

/* Terminal specific styling */
terminal-window .terminal-screen {
    background-color: #2B2E39;
    color: #D3DAE3;
}
EOF

    # Create GTK-4.0 CSS override
    mkdir -p "$HOME/.config/gtk-4.0"
    cat > "$HOME/.config/gtk-4.0/gtk.css" << 'EOF'
/* GTK-4.0 CSS overrides for better Arc-Dark theme integration */

/* Ensure dark theme is applied */
@import url("resource:///org/gtk/libgtk/theme/Default/Default-dark.css");

/* Override with Arc-Dark specific styling */
window {
    background-color: #383C4A;
    color: #D3DAE3;
}

headerbar {
    background: linear-gradient(to bottom, #404552, #383C4A);
    border-color: #2B2E39;
    color: #D3DAE3;
}

button {
    background: linear-gradient(to bottom, #454954, #3C4049);
    border-color: #2B2E39;
    color: #D3DAE3;
}

entry {
    background-color: #404552;
    border-color: #2B2E39;
    color: #D3DAE3;
}
EOF
}

set_environment_variables() {
    print_status "Setting up environment variables..."
    
    # Create or update environment variables ENV_FILE="$HOME/.profile"
    
    # Remove existing style override lines to avoid duplicates
    sed -i '/QT_STYLE_OVERRIDE/d' "$ENV_FILE" 2>/dev/null || true
    sed -i '/QT_QPA_PLATFORMTHEME/d' "$ENV_FILE" 2>/dev/null || true
    sed -i '/GTK_THEME/d' "$ENV_FILE" 2>/dev/null || true
    sed -i '/GTK_APPLICATION_PREFER_DARK_THEME/d' "$ENV_FILE" 2>/dev/null || true
    
    # Add environment variables
    cat >> "$ENV_FILE" << 'EOF'

# Qt theme configuration for Kvantum
export QT_STYLE_OVERRIDE=kvantum
export QT_QPA_PLATFORMTHEME=qt5ct

# GTK dark theme enforcement
export GTK_THEME=Arc-Dark
export GTK_APPLICATION_PREFER_DARK_THEME=1
EOF

    # Also add to .bashrc for interactive shells BASHRC_FILE="$HOME/.bashrc"
    if [ -f "$BASHRC_FILE" ]; then
        sed -i '/QT_STYLE_OVERRIDE/d' "$BASHRC_FILE" 2>/dev/null || true
        sed -i '/QT_QPA_PLATFORMTHEME/d' "$BASHRC_FILE" 2>/dev/null || true
        sed -i '/GTK_THEME/d' "$BASHRC_FILE" 2>/dev/null || true
        sed -i '/GTK_APPLICATION_PREFER_DARK_THEME/d' "$BASHRC_FILE" 2>/dev/null || true
        
        cat >> "$BASHRC_FILE" << 'EOF'

# Qt theme configuration for Kvantum (harmonized with FVWM config)
export QT_STYLE_OVERRIDE=kvantum
export QT_QPA_PLATFORMTHEME=qt5ct

# GTK dark theme enforcement
export GTK_THEME=Arc-Dark
export GTK_APPLICATION_PREFER_DARK_THEME=1
EOF
    fi

    print_success "Environment variables configured (harmonized with FVWM)"
}

configure_fonts() {
    print_status "Configuring font rendering..."
    
    # Create fontconfig directory
    mkdir -p "$HOME/.config/fontconfig"
    
    # Create fontconfig configuration for better font rendering
    cat > "$HOME/.config/fontconfig/fonts.conf" << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
<!-- Default font families -->
<alias>
<family>serif</family>
<prefer>
<family>DejaVu Serif</family>
<family>Liberation Serif</family>
<family>Noto Serif</family>
</prefer>
</alias>

<alias>
<family>sans-serif</family>
<prefer>
<family>DejaVu Sans</family>
<family>Liberation Sans</family>
<family>Noto Sans</family>
</prefer>
</alias>

<alias>
<family>monospace</family>
<prefer>
<family>DejaVu Sans Mono</family>
<family>Liberation Mono</family>
<family>Noto Sans Mono</family>
</prefer>
</alias>

<!-- Font rendering settings -->
<match target="font">
<edit name="antialias" mode="assign">
<bool>true</bool>
</edit>
<edit name="hinting" mode="assign">
<bool>true</bool>
</edit>
<edit name="hintstyle" mode="assign">
<const>hintslight</const>
</edit>
<edit name="rgba" mode="assign">
<const>rgb</const>
</edit>
<edit name="lcdfilter" mode="assign">
<const>lcddefault</const>
</edit>
</match>
</fontconfig>
EOF

    print_success "Font configuration completed"
}



restart_services() {
    print_status "Attempting to refresh theme cache and services..."
    
    # Update icon cache
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        print_status "Updating icon cache..."
        gtk-update-icon-cache -f -t ~/.icons/* 2>/dev/null || true
        gtk-update-icon-cache -f -t /usr/share/icons/* 2>/dev/null || true
    fi
    
    # Update font cache
    if command -v fc-cache >/dev/null 2>&1; then
        print_status "Updating font cache..."
        fc-cache -f -v 2>/dev/null || true
        # Also update user font cache
        fc-cache -f -v ~/.fonts 2>/dev/null || true
    fi
    
    # Rebuild fontconfig cache
    print_status "Rebuilding fontconfig cache..."
    fc-cache -r -v 2>/dev/null || true
    
    print_success "Cache updates completed"
}

# Main execution
main() {
    print_status "Starting theme configuration process..."
    
    # Run configuration functions
    configure_qt
    configure_gtk
    configure_fonts
    set_environment_variables
    restart_services
    
    print_success "Theme installation and configuration completed!"
    print_status "============================================="
    print_status "FVWM-Harmonized Configuration Summary:"
    print_status "- Kvantum theme engine installed and configured"
    print_status "- Qt5/Qt6 applications configured to use Kvantum"
    print_status "- GTK applications configured with Arc-Dark theme"
    print_status "- Icon theme set to Papirus"
    print_status "- Font rendering harmonized with FVWM (Sans Bold 8)"
    print_status "- Environment variables configured (matches FVWM config)"
    print_status "- System tray applications installed (nm-applet, volumeicon, etc.)"
    print_status "- Rofi launcher support included"
    print_status "- Global dark theme enforcement configured"
    print_status "============================================="
    print_warning "IMPORTANT: Please log out and log back in (or reboot) for all changes to take effect."
    print_status "You can also run 'source ~/.profile && source ~/.bashrc' in new terminal sessions."
    print_status ""
    print_status "FVWM Integration Notes:"
    print_status "- Your FVWM config already sets QT_STYLE_OVERRIDE=kvantum ✓"
    print_status "- Font settings harmonized with FVWM DefaultFont (Sans:Bold:size=8)"
    print_status "- Arc-Dark theme complements your Art-Deco blue colorscheme"
    print_status "- System tray applications match your FVWM StartFunction"
    print_status ""
    print_status "Global Dark Theme Enforcement:"
    print_status "- GTK_THEME and GTK_APPLICATION_PREFER_DARK_THEME environment variables set"
    print_status "- System-wide dark theme configuration applied"
    print_status "- GNOME settings configured for dark theme preference"
    print_status ""
    print_status "To customize themes further:"
    print_status "- Use 'qt5ct' or 'qt6ct' for Qt application theming"
    print_status "- Use 'lxappearance' for GTK application theming"
    print_status "- Use 'kvantummanager' to change Kvantum themes"
    print_status ""
    print_status "Available theme tools installed:"
    print_status "- qt5ct: Qt5 Configuration Tool"
    print_status "- qt6ct: Qt6 Configuration Tool"
    print_status "- lxappearance: GTK Theme Configurator"
    print_status "- kvantummanager: Kvantum Theme Manager"
    print_status ""
    print_status "Note: Some packages may require AUR (Arch User Repository)."
    print_status "Use an AUR helper like 'yay' or 'paru' to install AUR packages."
}

# Run the main function
main

print_success "Script execution completed successfully!"
