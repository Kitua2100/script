#!/bin/bash
# FRANCIS VPN Menu - Protected Version
# Copyright (c) 2024 FRANCIS Technologies Kenya

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
_k="1"
_l="2"
_m="3"
_n="4"
_o="5"
_p="6"
_q="7"
_r="8"
_s="9"
_t="10"
_u="11"
_v="12"
_w="13"
_x="14"
_y="15"
_z="16"

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

# Run validation
_validate

# Obfuscated menu display
_menu() {
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

# Obfuscated menu logic
_menu_logic() {
    case $_opt in
    $_k|01)
        $_h
        # SSH menu logic here
        $_f -e "$_cSSH Menu Activated$_b"
        ;;
    $_l|02)
        $_h
        # VMESS menu logic here
        $_f -e "$_cVMESS Menu Activated$_b"
        ;;
    $_m|03)
        $_h
        # VLESS menu logic here
        $_f -e "$_cVLESS Menu Activated$_b"
        ;;
    $_n|04)
        $_h
        # TROJAN menu logic here
        $_f -e "$_cTROJAN Menu Activated$_b"
        ;;
    $_o|05)
        $_h
        # SHADOW menu logic here
        $_f -e "$_cSHADOW Menu Activated$_b"
        ;;
    $_p|06)
        $_h
        # LIMIT SPEED menu logic here
        $_f -e "$_cLIMIT SPEED Menu Activated$_b"
        ;;
    $_q|07)
        $_h
        # VPS INFO menu logic here
        $_f -e "$_cVPS INFO Menu Activated$_b"
        ;;
    $_r|08)
        $_h
        # DELL ALL EXP menu logic here
        $_f -e "$_cDELL ALL EXP Menu Activated$_b"
        ;;
    $_s|09)
        $_h
        # AUTOREBOOT menu logic here
        $_f -e "$_cAUTOREBOOT Menu Activated$_b"
        ;;
    $_t|10)
        $_h
        # INFO PORT menu logic here
        $_f -e "$_cINFO PORT Menu Activated$_b"
        ;;
    $_u|11)
        $_h
        # SPEEDTEST menu logic here
        $_f -e "$_cSPEEDTEST Menu Activated$_b"
        ;;
    $_v|12)
        $_h
        # RUNNING menu logic here
        $_f -e "$_cRUNNING Menu Activated$_b"
        ;;
    $_w|13)
        $_h
        # CLEAR LOG menu logic here
        $_f -e "$_cCLEAR LOG Menu Activated$_b"
        ;;
    $_x|14)
        $_h
        # Cek Bandiwth menu logic here
        $_f -e "$_cCek Bandiwth Menu Activated$_b"
        ;;
    $_y|15)
        $_h
        # BCKP/RSTR menu logic here
        $_f -e "$_cBCKP/RSTR Menu Activated$_b"
        ;;
    $_z|16)
        $_h
        # REBOOT menu logic here
        $_f -e "$_cREBOOT Menu Activated$_b"
        ;;
    $_j|0)
        $_f -e "$_dExiting...$_b"
        $_i $_j
        ;;
    *)
        $_f -e "$_dInvalid option$_b"
        sleep 2
        ;;
    esac
}

# Main menu loop
while true; do
    _menu
    _menu_logic
    $_f -e ""
    $_f -e " Press any key to continue..."
    $_g -n1
done 