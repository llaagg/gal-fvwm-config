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
- **Alt + F1** or **Menu Key**: Open the root menu (MenuFvwmRoot).
- **Alt + Tab**: Open the window list.

## Desktop Switching
- **Ctrl + F1**: Switch to Desktop 0 0.
- **Ctrl + F2**: Switch to Desktop 0 1.
- **Ctrl + F3**: Switch to Desktop 0 2.
- **Ctrl + F4**: Switch to Desktop 0 3.

## Launchers
- **Super_R (Right Windows Key)**: Launch the terminal.
- **Alt + Space**: Launch dmenu (run command).
- **Super_L + Space**: Launch Rofi (application launcher).

## Window Management
- **Ctrl + Alt + Up Arrow**: Shuffle window up.
- **Ctrl + Alt + Down Arrow**: Shuffle window down.
- **Ctrl + Alt + Left Arrow**: Shuffle window left.
- **Ctrl + Alt + Right Arrow**: Shuffle window right.
- **Ctrl + Alt + Shift + Up Arrow**: Grow window up.
- **Ctrl + Alt + Shift + Down Arrow**: Grow window down.
- **Ctrl + Alt + Shift + Left Arrow**: Grow window left.
- **Ctrl + Alt + Shift + Right Arrow**: Grow window right.

Note: These shortcuts apply to window contexts (W, T, S, F) as defined in the configuration.
