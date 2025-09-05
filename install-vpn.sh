#!/bin/bash
# VPN Installation Wrapper - Handles all compatibility issues automatically

echo "=== VPN Installation Wrapper ==="
echo "This script will automatically install VPN with universal compatibility"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Function to download and fix line endings
download_and_fix() {
    local url=$1
    local filename=$2
    echo "Downloading $filename..."
    wget -q "$url" -O "$filename"
    if [ -f "$filename" ]; then
        # Fix line endings
        sed -i 's/\r$//' "$filename"
        chmod +x "$filename"
        echo "✅ $filename downloaded and fixed"
        return 0
    else
        echo "❌ Failed to download $filename"
        return 1
    fi
}

# Update system
echo "Step 1: Updating system packages..."
apt update -y && apt upgrade -y

# Download and run compatibility fix
echo "Step 2: Setting up universal compatibility..."
if download_and_fix "https://raw.githubusercontent.com/Kitua2100/script/main/compatibility-fix.sh" "compatibility-fix.sh"; then
    ./compatibility-fix.sh
else
    echo "⚠️  Compatibility fix failed, continuing with main installation..."
fi

# Download and run main installer
echo "Step 3: Installing VPN..."
if download_and_fix "https://raw.githubusercontent.com/Kitua2100/script/main/genz.sh" "genz.sh"; then
    ./genz.sh
else
    echo "❌ Failed to download main installer"
    exit 1
fi

echo ""
echo "=== Installation Complete ==="
echo "Your VPN should now be installed and running!" 