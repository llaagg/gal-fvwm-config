#!/bin/bash

# Shared application lists for FVWM installation scripts
# This file is sourced by both Arch and Debian installation scripts

# Core FVWM Applications from menu configuration
FVWM_CORE_APPS=(
    "gnome-terminal"                 # Terminal emulator (infostore.terminal)
    "pcmanfm-qt"                     # File manager
    "keepassxc"                      # Password manager
    "thunderbird"                    # Email client
    "rofi"                           # Application launcher (infostore.runcmd)
    "xterm"                          # Fallback terminal
)

# System tray applications from start.conf
# Note: Some packages have different names on different distributions
# Use SYSTEM_TRAY_APPS_ARCH or SYSTEM_TRAY_APPS_DEBIAN in respective scripts
SYSTEM_TRAY_APPS_COMMON=(
    "xfce4-power-manager"            # Power management
    "blueman"                        # Bluetooth manager
    "stalonetray"                    # System tray
    "gxkb"                           # Keyboard layout indicator
)

# Arch-specific system tray packages
SYSTEM_TRAY_APPS_ARCH=(
    "network-manager-applet"         # nm-applet
    "volumeicon"                     # Volume control
    "pasystray"                      # PulseAudio system tray
)

# Debian-specific system tray packages
SYSTEM_TRAY_APPS_DEBIAN=(
    "network-manager-gnome"          # nm-applet
    "volumeicon-alsa"                # Volume control
)

# FVWM modules and utilities
# Note: Some packages have different names on different distributions
FVWM_UTILITIES_COMMON=(
    "fvwm3"                          # FVWM window manager
    "feh"                            # Image viewer/wallpaper setter
    "scrot"                          # Screenshot utility
    "xclip"                          # Clipboard utility
    "wmctrl"                         # Window control utility
    "xdotool"                        # X11 automation
    "imagemagick"                    # Image conversion tools (for icon generation)
)

# Arch-specific utilities
FVWM_UTILITIES_ARCH=(
    "xorg-xload"                     # System load monitor
    "python-xdg"                     # Required for fvwm3-menu-desktop (XDG menu generation)
)

# Debian-specific utilities
FVWM_UTILITIES_DEBIAN=(
    "xload"                          # System load monitor
)
