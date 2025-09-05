#!/bin/bash
# Universal Update Script for VPN Installation
# Compatible with all Ubuntu and Debian versions

# Detect OS and set package manager
if command -v apt &> /dev/null; then
    PKG_MGR="apt"
elif command -v apt-get &> /dev/null; then
    PKG_MGR="apt-get"
else
    echo "Error: No supported package manager found"
    exit 1
fi

# Universal package installation function
install_pkg() {
    local pkg=$1
    if [ "$PKG_MGR" = "apt" ]; then
        apt install -y "$pkg"
    elif [ "$PKG_MGR" = "apt-get" ]; then
        apt-get install -y "$pkg"
    fi
}

# Update package lists
update_pkgs() {
    if [ "$PKG_MGR" = "apt" ]; then
        apt update -y
    elif [ "$PKG_MGR" = "apt-get" ]; then
        apt-get update -y
    fi
}

# Get date from server
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`

# Color definitions
red() { echo -e "\\033[32;1m${*}\\033[0m"; }

clear

# Progress bar function
fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}

# Update function
res1() {
    # Install required packages for update
    install_pkg "wget"
    install_pkg "unzip"
    
    # Download and install menu
    wget https://raw.githubusercontent.com/Kitua2100/script/main/ubuntu/menu.zip
    unzip menu.zip
    chmod +x menu/*
    mv menu/* /usr/local/sbin
    rm -rf menu
    rm -rf menu.zip
    rm -rf update.sh
}

# Install netfilter-persistent if not present
if ! command -v netfilter-persistent &> /dev/null; then
    echo "Installing netfilter-persistent..."
    install_pkg "netfilter-persistent"
fi

clear

echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " \e[1;97;101m          UPDATED SCRIPT POWERED BY FRANCIS     \e[0m"
echo -e " \e[1;97;101m          UNIVERSAL VERSION - ALL UBUNTU/DEBIAN      \e[0m"
echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e "  \033[1;91m update script service\033[1;37m"
fun_bar 'res1'
echo -e "\033[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press [ Enter ] to back on menu"
menu

###########- COLOR CODE -##############
