#!/bin/bash
#
# Configure Brave to run on X11 via flags file.
#

set -euo pipefail

mkdir -p ~/.config

cat > ~/.config/brave-flags.conf << 'EOF'
--enable-features=UseOzonePlatform
--ozone-platform=x11
EOF

echo "Brave X11 flags written to ~/.config/brave-flags.conf"
