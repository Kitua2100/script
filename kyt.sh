#!/bin/bash

# Detect OS and version
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    else
        echo "Error: Cannot detect OS version"
        exit 1
    fi
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root"
        exit 1
    fi
}

# Update package manager based on OS
update_package_manager() {
    echo "Updating package manager..."
    if command -v apt-get &> /dev/null; then
        apt-get update
    elif command -v apt &> /dev/null; then
        apt update
    else
        echo "Error: No supported package manager found"
        exit 1
    fi
}

# Install packages with fallback
install_packages() {
    local packages=("python3" "python3-pip" "git" "wget" "unzip")
    local pkg_manager=""
    
    # Determine package manager
    if command -v apt-get &> /dev/null; then
        pkg_manager="apt-get install -y"
    elif command -v apt &> /dev/null; then
        pkg_manager="apt install -y"
    else
        echo "Error: No supported package manager found"
        exit 1
    fi
    
    echo "Installing required packages..."
    for package in "${packages[@]}"; do
        echo "Installing $package..."
        if ! $pkg_manager "$package"; then
            echo "Warning: Failed to install $package, trying alternative method..."
            # Try alternative package names for older versions
            case $package in
                "python3-pip")
                    if ! $pkg_manager "python3-pip" 2>/dev/null; then
                        $pkg_manager "python-pip" 2>/dev/null || echo "Warning: Could not install pip"
                    fi
                    ;;
                *)
                    echo "Warning: Could not install $package"
                    ;;
            esac
        fi
    done
}

# Upgrade system packages
upgrade_system() {
    echo "Upgrading system packages..."
    if command -v apt-get &> /dev/null; then
        apt-get upgrade -y
    elif command -v apt &> /dev/null; then
        apt upgrade -y
    fi
}

# Check if required files exist
check_required_files() {
    local required_files=("/etc/xray/dns" "/etc/slowdns/server.pub" "/etc/xray/domain")
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            echo "Error: Required file $file not found"
            echo "Please ensure Xray and SlowDNS are properly configured first"
            exit 1
        fi
    done
}

# Main execution
main() {
    echo "Starting KYT Bot installation..."
    echo "Detecting OS..."
    detect_os
    echo "OS: $OS $VER"
    
    check_root
    check_required_files
    
    # Read configuration files
    NS=$(cat /etc/xray/dns 2>/dev/null || echo "")
    PUB=$(cat /etc/slowdns/server.pub 2>/dev/null || echo "")
    domain=$(cat /etc/xray/domain 2>/dev/null || echo "")
    
    if [ -z "$NS" ] || [ -z "$PUB" ] || [ -z "$domain" ]; then
        echo "Error: Could not read required configuration files"
        exit 1
    fi
    
    # Color definitions
    grenbo="\e[92;1m"
    NC='\e[0m'
    
    # System preparation
    update_package_manager
    upgrade_system
    install_packages
    
    # Create working directory
    mkdir -p /usr/bin/kyt
    
    # Download and setup bot
    echo "Downloading bot files..."
    cd /usr/bin
    if ! wget -q https://raw.githubusercontent.com/Kitua2100/script/main/ubuntu/bot.zip; then
        echo "Error: Failed to download bot.zip"
        exit 1
    fi
    
    if ! unzip -q bot.zip; then
        echo "Error: Failed to extract bot.zip"
        exit 1
    fi
    
    mv bot/* /usr/bin/ 2>/dev/null || true
    chmod +x /usr/bin/*
    rm -rf bot.zip bot/
    
    clear
    
    # Download KYT files
    echo "Downloading KYT files..."
    if ! wget -q https://raw.githubusercontent.com/Kitua2100/script/main/ubuntu/kyt.zip; then
        echo "Error: Failed to download kyt.zip"
        exit 1
    fi
    
    if ! unzip -q kyt.zip; then
        echo "Error: Failed to extract kyt.zip"
        exit 1
    fi
    
    # Install Python requirements
    if [ -f "kyt/requirements.txt" ]; then
        echo "Installing Python requirements..."
        pip3 install -r kyt/requirements.txt || pip3 install --user -r kyt/requirements.txt
    fi
    
    # Configuration input
    echo ""
    echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e " \e[1;97;101m          ADD BOT PANEL          \e[0m"
    echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "${grenbo}Tutorial Creat Bot and ID Telegram${NC}"
    echo -e "${grenbo}[*] Creat Bot and Token Bot : @BotFather${NC}"
    echo -e "${grenbo}[*] Info Id Telegram : @MissRose_bot , perintah /info${NC}"
    echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    
    read -e -p "[*] Input your Bot Token : " bottoken
    read -e -p "[*] Input Your Id Telegram :" admin
    
    # Validate inputs
    if [ -z "$bottoken" ] || [ -z "$admin" ]; then
        echo "Error: Bot token and admin ID are required"
        exit 1
    fi
    
    # Create configuration file
    cat > /usr/bin/kyt/var.txt << EOF
BOT_TOKEN="$bottoken"
ADMIN="$admin"
DOMAIN="$domain"
PUB="$PUB"
HOST="$NS"
EOF
    
    clear
    
    # Create systemd service
    cat > /etc/systemd/system/kyt.service << END
[Unit]
Description=Simple kyt - @kyt
After=network.target

[Service]
WorkingDirectory=/usr/bin
ExecStart=/usr/bin/python3 -m kyt
Restart=always
RestartSec=10
User=root
Group=root

[Install]
WantedBy=multi-user.target
END
    
    # Reload systemd and start service
    systemctl daemon-reload
    systemctl enable kyt
    systemctl start kyt
    
    # Wait a moment for service to start
    sleep 3
    
    # Check service status
    if systemctl is-active --quiet kyt; then
        echo "KYT service started successfully"
    else
        echo "Warning: KYT service may not have started properly"
        systemctl status kyt --no-pager -l
    fi
    
    cd /root
    rm -rf kyt.sh
    
    echo "Done"
    echo "Your Data Bot"
    echo -e "==============================="
    echo "Token Bot         : $bottoken"
    echo "Admin          : $admin"
    echo "Domain        : $domain"
    echo "Pub            : $PUB"
    echo "Host           : $NS"
    echo -e "==============================="
    echo "Setting done"
    clear
    
    echo " Installations complete, type /menu on your bot"
}

# Run main function
main "$@"
