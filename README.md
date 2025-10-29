# FVWM Configuration

This directory contains the configuration files for FVWM (F Virtual Window Manager), a lightweight and highly customizable window manager for X11.

## Files

- **bindings.conf**: Defines key and mouse bindings for various actions, such as desktop navigation, window management, and launching applications.
- **functions.conf**: Contains custom functions for FVWM, including startup routines, background settings, and event handlers.

## Usage

- Place these files in your `~/.fvwm/` directory.
- Restart FVWM or reload the configuration to apply changes.
- Customize bindings and functions as needed for your workflow.

For more information, refer to the [FVWM documentation](https://www.fvwm.org/).

# FVWM Key Shortcuts

This document lists the key shortcuts configured in FVWM, based on `bindings.conf`.

## Menu and Navigation
- **Super_L (Left Windows Key)** or **Menu Key**: Open the root menu (MenuFvwmRoot).
- **Alt + Tab**: Open the window list.
- **Super + Tab**: Switch to next desktop page (2x2 grid).

## Launchers
- **Alt + Space**: Launch application runner (Rofi).

## Window Management
- **Ctrl + Alt + Up Arrow**: Shuffle window up.
- **Ctrl + Alt + Down Arrow**: Shuffle window down.
- **Ctrl + Alt + Left Arrow**: Shuffle window left.
- **Ctrl + Alt + Right Arrow**: Shuffle window right.
- **Ctrl + Alt + Shift + Up Arrow**: Grow window up.
- **Ctrl + Alt + Shift + Down Arrow**: Grow window down.
- **Ctrl + Alt + Shift + Left Arrow**: Grow window left.
- **Ctrl + Alt + Shift + Right Arrow**: Grow window right.

## Mouse Bindings

### Window Title Bar
- **Left Click**: Raise and move window, double-click to maximize.
- **Right Click**: Open window operations menu.
- **Mouse Wheel Up**: Window shade on.
- **Mouse Wheel Down**: Window shade off.

### Window Borders
- **Left Click**: Raise and resize window.

### Root Window (Desktop)
- **Left Click**: Open root menu.
- **Middle Click**: Open window list.
- **Right Click**: Open extended window operations menu.

### Window Buttons
- **Button 1 (Minimize)**: Iconify window.
- **Button 2 (Maximize)**: Maximize window (single click), maximize vertical/horizontal (middle/right click).
- **Button 4 (Close)**: Close window (single click), destroy window (double click).

### Icons
- **Left Click**: Raise and move iconified window.
- **Right Click**: Open icon operations menu.

Note: These shortcuts apply to window contexts (W=Window, T=Title, S=Sides, F=Frame) as defined in the configuration. 
