#!/bin/bash
# FRANCIS ENCRYPTED MENU - UNEDITABLE VERSION
# Copyright (c) 2024 FRANCIS Technologies Kenya

# Anti-tampering protection
if [[ "${BASH_ARGV[0]}" == *"debug"* ]] || [[ "$-" == *"x"* ]]; then
    echo "Debugging detected - exiting"
    exit 1
fi

# Obfuscated variables
_a="\033[1;36m"
_b="\033[0m"
_c="\033[1;32m"
_d="\033[1;31m"
_e="\033[1;33m"
_f="echo"
_g="read"
_h="clear"
_i="exit"
_j="0"

# Remote validation
_validate() {
    local _ip=$(curl -s ipv4.icanhazip.com)
    local _auth=$(curl -s https://your-domain.com/auth.txt)
    if ! echo "$_auth" | grep -q "$_ip"; then
        $_f -e "$_dPERMISSION DENIED$_b"
        $_f -e "$_cContact: +254717640862$_b"
        sleep 5
        reboot
        $_i $_j
    fi
}

# File integrity check
_check_integrity() {
    local _hash=$(sha256sum "$0" | awk '{print $1}')
    local _expected="your_expected_hash_here"
    if [[ "$_hash" != "$_expected" ]]; then
        $_f -e "$_dFile integrity check failed$_b"
        $_i $_j
    fi
}

# Run protection checks
_validate
_check_integrity

# Encrypted menu data (base64 encoded)
_menu_data="W1tNRU5VX0RBVEFdXQ=="

# Decrypt and display menu
_decrypt_menu() {
    local _decoded=$(echo "$_menu_data" | base64 -d)
    $_f -e "$_decoded"
}

# Main menu function
_main_menu() {
    $_h
    $_f -e "$_a╭══════════════════════════════════════════════════════════╮$_b"
    $_f -e "$_a│$_b$_c                    PREMIUM AUTOSCRIPT BY FRANCIS TECH                    $_b$_a│$_b"
    $_f -e "$_a│$_b$_e                         Contact: +254717640862                          $_b$_a│$_b"
    $_f -e "$_a╰══════════════════════════════════════════════════════════╯$_b"
    $_f -e "$_a╭══════════════════════════════════════════════════════════╮$_b"
    $_f -e "$_a│$_b [$_c01$_b] SSH MENU     │ [$_c08$_b] DELL ALL EXP │ [$_c15$_b] BCKP/RSTR   $_b$_a│$_b"
    $_f -e "$_a│$_b [$_c02$_b] VMESS MENU   │ [$_c09$_b] AUTOREBOOT   │ [$_c16$_b] REBOOT      $_b$_a│$_b"
    $_f -e "$_a│$_b [$_c03$_b] VLESS MENU   │ [$_c10$_b] INFO PORT    │ [$_c17$_b] RESTART     $_b$_a│$_b"
    $_f -e "$_a│$_b [$_c04$_b] TROJAN MENU  │ [$_c11$_b] SPEEDTEST    │ [$_c18$_b] DOMAIN      $_b$_a│$_b"
    $_f -e "$_a│$_b [$_c05$_b] SHADOW MENU  │ [$_c12$_b] RUNNING      │ [$_c19$_b] CERT SSL    $_b$_a│$_b"
    $_f -e "$_a│$_b [$_c06$_b] LIMIT SPEED  │ [$_c13$_b] CLEAR LOG    │ [$_c20$_b] INS. UDP    $_b$_a│$_b"
    $_f -e "$_a│$_b [$_c07$_b] VPS INFO     │ [$_c14$_b] Cek Bandiwth │ [$_c21$_b] CLEAR CACHE $_b$_a│$_b"
    $_f -e "$_a│$_b [$_c22$_b] BOT NOTIF    │ [$_c23$_b] UPDATE SCRIPT│ [$_c24$_b] BOT PANEL   $_b$_a│$_b"
    $_f -e "$_a│$_b                                                          $_b$_a│$_b"
    $_f -e "$_a│$_b [$_c25$_b] CHANGE BANNER <<<                                   $_b$_a│$_b"
    $_f -e "$_a│$_b [$_c0$_b] BACK TO EXIT MENU <<<                                $_b$_a│$_b"
    $_f -e "$_a╰══════════════════════════════════════════════════════════╯$_b"
    $_f -e "$_a╭══════════════════════════════════════════════════════════╮$_b"
    $_f -e "$_a│$_b Version       = V3.0.1"
    $_f -e "$_a│$_b User          = FRANCIS"
    $_f -e "$_a│$_b Script Status = (Active)"
    $_f -e "$_a│$_b Expiry script = 2025-10-25 56 Days"
    $_f -e "$_a╰══════════════════════════════════════════════════════════╯$_b"
    $_f -e ""
    $_f -e " Select menu : "
    $_g -p "" _opt
}

# Menu logic with protection
_menu_logic() {
    case $_opt in
    01|1)
        $_h
        $_f -e "$_cSSH Menu Activated$_b"
        ;;
    02|2)
        $_h
        $_f -e "$_cVMESS Menu Activated$_b"
        ;;
    03|3)
        $_h
        $_f -e "$_cVLESS Menu Activated$_b"
        ;;
    04|4)
        $_h
        $_f -e "$_cTROJAN Menu Activated$_b"
        ;;
    05|5)
        $_h
        $_f -e "$_cSHADOW Menu Activated$_b"
        ;;
    06|6)
        $_h
        $_f -e "$_cLIMIT SPEED Menu Activated$_b"
        ;;
    07|7)
        $_h
        $_f -e "$_cVPS INFO Menu Activated$_b"
        ;;
    08|8)
        $_h
        $_f -e "$_cDELL ALL EXP Menu Activated$_b"
        ;;
    09|9)
        $_h
        $_f -e "$_cAUTOREBOOT Menu Activated$_b"
        ;;
    10)
        $_h
        $_f -e "$_cINFO PORT Menu Activated$_b"
        ;;
    11)
        $_h
        $_f -e "$_cSPEEDTEST Menu Activated$_b"
        ;;
    12)
        $_h
        $_f -e "$_cRUNNING Menu Activated$_b"
        ;;
    13)
        $_h
        $_f -e "$_cCLEAR LOG Menu Activated$_b"
        ;;
    14)
        $_h
        $_f -e "$_cCek Bandiwth Menu Activated$_b"
        ;;
    15)
        $_h
        $_f -e "$_cBCKP/RSTR Menu Activated$_b"
        ;;
    16)
        $_h
        $_f -e "$_cREBOOT Menu Activated$_b"
        ;;
    0)
        $_f -e "$_dExiting...$_b"
        $_i $_j
        ;;
    *)
        $_f -e "$_dInvalid option$_b"
        sleep 2
        ;;
    esac
}

# Main loop
while true; do
    _main_menu
    _menu_logic
    $_f -e ""
    $_f -e " Press any key to continue..."
    $_g -n1
done 