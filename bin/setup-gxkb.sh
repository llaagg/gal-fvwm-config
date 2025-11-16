#!/bin/bash
#
# Setup gxkb configuration for Polish and US keyboard layouts
#

# Create config directory if it doesn't exist
mkdir -p ~/.config/gxkb

# Create gxkb configuration file
cat > ~/.config/gxkb/gxkb.cfg << 'EOF'
[xkb config]
group_policy=2
default_group=0
never_modify_config=true
model=pc105
layouts=pl,us
variants=,
toggle_option=grp:alt_shift_toggle
compose_key_position=
EOF

echo "✓ gxkb configuration created at ~/.config/gxkb/gxkb.cfg"
echo "✓ Layouts: pl,us"
echo "✓ Toggle: Alt+Shift"
echo ""
echo "Restart gxkb or log out/in for changes to take effect."
