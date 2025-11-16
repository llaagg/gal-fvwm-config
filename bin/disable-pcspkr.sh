#!/bin/bash

# Disable PC Speaker (pcspkr) module
# Run this script once to permanently disable the PC speaker

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

print_status "Disabling PC Speaker (pcspkr) module..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   print_status "Run as normal user - it will prompt for sudo when needed"
   exit 1
fi

# Create blacklist file
BLACKLIST_FILE="/etc/modprobe.d/blacklist-pcspkr.conf"

# Check if blacklist already exists
if [ -f "$BLACKLIST_FILE" ]; then
    if grep -q "blacklist pcspkr" "$BLACKLIST_FILE"; then
        print_success "pcspkr module is already blacklisted"
    else
        print_status "Adding pcspkr blacklist to existing file..."
        echo "blacklist pcspkr" | sudo tee -a "$BLACKLIST_FILE" >/dev/null
        print_success "pcspkr blacklist added"
    fi
else
    print_status "Creating pcspkr blacklist file..."
    echo "blacklist pcspkr" | sudo tee "$BLACKLIST_FILE" >/dev/null
    print_success "pcspkr blacklist file created"
fi

# Try to unload the module if it's currently loaded
if lsmod | grep -q pcspkr; then
    print_status "Unloading pcspkr module..."
    sudo modprobe -r pcspkr 2>/dev/null && print_success "pcspkr module unloaded" || print_warning "Could not unload pcspkr module (may be in use)"
else
    print_success "pcspkr module is not currently loaded"
fi

# Also disable via sysctl if available
if [ -f /proc/sys/kernel/printk ]; then
    print_status "Configuring console bell settings..."
    echo 'kernel.printk_ratelimit = 0' | sudo tee /etc/sysctl.d/99-disable-pcspkr.conf >/dev/null 2>&1 || true
fi

# For user session - disable terminal bell
print_status "Disabling terminal bell for current user..."
if command -v setterm >/dev/null 2>&1; then
    setterm -blength 0 2>/dev/null || true
fi

# Add to user's shell configuration
for rcfile in ~/.bashrc ~/.zshrc; do
    if [ -f "$rcfile" ]; then
        if ! grep -q "setterm -blength 0" "$rcfile"; then
            echo "" >> "$rcfile"
            echo "# Disable terminal bell" >> "$rcfile"
            echo "setterm -blength 0 2>/dev/null || true" >> "$rcfile"
            print_status "Added bell disable to $rcfile"
        fi
    fi
done

print_success "PC Speaker disable configuration completed!"
print_status "============================================="
print_status "What was done:"
print_status "- Created/updated $BLACKLIST_FILE"
print_status "- Attempted to unload pcspkr module"
print_status "- Added sysctl configuration"
print_status "- Configured terminal bell disable"
print_status ""
print_warning "Reboot required for full effect"
print_status "Or run: sudo modprobe -r pcspkr (if not in use)"
print_status ""
print_status "To verify:"
print_status "- Check blacklist: cat $BLACKLIST_FILE"
print_status "- Check if loaded: lsmod | grep pcspkr"
print_status "- Test: speaker-test (should be silent)"