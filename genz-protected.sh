#!/bin/bash
# FRANCIS VPN Script - Protected Version
# Copyright (c) 2024 FRANCIS Technologies Kenya
# Unauthorized use is strictly prohibited

# Anti-debugging protection
if [[ "${BASH_ARGV[0]}" == *"debug"* ]] || [[ "$-" == *"x"* ]]; then
    echo "Debugging detected - exiting"
    exit 1
fi

# Obfuscated variables
_a="\033[1;31m"
_b="\033[0m"
_c="\033[1;32m"
_d="\033[1;33m"
_e="\033[1;36m"
_f="echo"
_g="curl"
_h="wget"
_i="chmod"
_j="+x"
_k="exit"
_l="1"
_m="sleep"
_n="5"
_o="reboot"
_p="ipv4.icanhazip.com"
_q="https://your-domain.com/auth.txt"
_r="PERMISSION DENIED"
_s="Contact: +254717640862"
_t="EMMKASH20@GMAIL.COM"
_u="t.me/emmkash"
_v="wa.me/+254717640862"

# Remote validation function (obfuscated)
_validate() {
    local _ip=$($_g -s $_p)
    local _auth=$($_g -s $_q)
    if ! echo "$_auth" | grep -q "$_ip"; then
        $_f -e "$_a$_r$_b"
        $_f -e "$_c$_s$_b"
        $_f -e "$_d$_t$_b"
        $_f -e "$_e$_u$_b"
        $_f -e "$_d$_v$_b"
        $_m $_n
        $_o
        $_k $_l
    fi
}

# System validation
_check_system() {
    if [[ -f /proc/cpuinfo ]] && grep -q "hypervisor" /proc/cpuinfo; then
        $_f -e "$_aVirtualization detected - not allowed$_b"
        $_k $_l
    fi
    
    local _mem=$(free -m | grep Mem | awk '{print $2}')
    if [[ $_mem -lt 512 ]]; then
        $_f -e "$_aInsufficient memory$_b"
        $_k $_l
    fi
}

# Time-based expiration
_check_expiry() {
    local _current=$(date +%s)
    local _expiry="1735689600"  # 2025-01-01
    if [[ $_current -gt $_expiry ]]; then
        $_f -e "$_aScript expired$_b"
        $_f -e "$_c$_s$_b"
        $_k $_l
    fi
}

# File integrity check
_check_integrity() {
    local _hash=$(sha256sum "$0" | awk '{print $1}')
    local _expected="your_expected_hash_here"
    if [[ "$_hash" != "$_expected" ]]; then
        $_f -e "$_aFile integrity check failed$_b"
        $_k $_l
    fi
}

# Network validation
_check_network() {
    local _domain="your-domain.com"
    if ! ping -c 1 "$_domain" &>/dev/null; then
        $_f -e "$_aNetwork validation failed$_b"
        $_k $_l
    fi
}

# Run all protection checks
_validate
_check_system
_check_expiry
_check_integrity
_check_network

# Main script logic (obfuscated)
$_f -e "$_e=== FRANCIS VPN INSTALLER ===$_b"
$_f -e "$_cProtected Version - All Rights Reserved$_b"
$_f -e ""

# OS detection (obfuscated)
_detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        _OS_ID=$ID
        _OS_VERSION=$VERSION_ID
        $_f -e "$_cDetected: $PRETTY_NAME$_b"
    else
        $_f -e "$_aError: Cannot detect OS$_b"
        $_k $_l
    fi
}

# Package manager functions (obfuscated)
_install_pkg() {
    local _pkg=$1
    if command -v apt &> /dev/null; then
        apt install -y "$_pkg"
    elif command -v apt-get &> /dev/null; then
        apt-get install -y "$_pkg"
    fi
}

_update_pkgs() {
    if command -v apt &> /dev/null; then
        apt update -y
    elif command -v apt-get &> /dev/null; then
        apt-get update -y
    fi
}

# Main installation process
$_f -e "$_cStarting protected installation...$_b"
_detect_os

# Check root
if [ "$EUID" -ne 0 ]; then
    $_f -e "$_aPlease run as root$_b"
    $_k $_l
fi

# Update system
$_f -e "$_dUpdating system packages...$_b"
_update_pkgs

# Install dependencies
$_f -e "$_dInstalling dependencies...$_b"
_install_pkg "curl"
_install_pkg "wget"
_install_pkg "unzip"
_install_pkg "git"

# Download and run main installer
$_f -e "$_dDownloading main installer...$_b"
$_h -q https://raw.githubusercontent.com/Kitua2100/script/main/genz.sh
$_i $_j genz.sh
./genz.sh

$_f -e "$_cInstallation completed successfully!$_b"
$_f -e "$_dThank you for using EMMKASH VPN Script$_b" 
