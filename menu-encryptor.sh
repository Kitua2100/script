#!/bin/bash
# FRANCIS Menu Encryptor
# Encrypts menu files to prevent editing

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

echo -e "${BLUE}=== FRANCIS Menu Encryptor ===${NC}"
echo -e "${YELLOW}This tool encrypts menu files to prevent unauthorized editing${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root${NC}"
    exit 1
fi

# Function to encrypt a file
encrypt_file() {
    local input_file="$1"
    local output_file="$2"
    
    if [ ! -f "$input_file" ]; then
        echo -e "${RED}File not found: $input_file${NC}"
        return 1
    fi
    
    # Create encrypted version
    cat > "$output_file" << 'EOF'
#!/bin/bash
# FRANCIS ENCRYPTED MENU - UNEDITABLE
# Copyright (c) 2024 FRANCIS Technologies Kenya

# Anti-tampering protection
if [[ "${BASH_ARGV[0]}" == *"debug"* ]] || [[ "$-" == *"x"* ]]; then
    echo "Debugging detected - exiting"
    exit 1
fi

# Remote validation
_validate() {
    local _ip=$(curl -s ipv4.icanhazip.com)
    local _auth=$(curl -s https://your-domain.com/auth.txt)
    if ! echo "$_auth" | grep -q "$_ip"; then
        echo -e "\033[1;31mPERMISSION DENIED\033[0m"
        echo -e "\033[1;32mContact: +254717640862\033[0m"
        sleep 5
        reboot
        exit 1
    fi
}

# File integrity check
_check_integrity() {
    local _hash=$(sha256sum "$0" | awk '{print $1}')
    local _expected="your_expected_hash_here"
    if [[ "$_hash" != "$_expected" ]]; then
        echo -e "\033[1;31mFile integrity check failed\033[0m"
        exit 1
    fi
}

# Run protection checks
_validate
_check_integrity

# Encrypted menu data
_menu_data="
EOF

    # Add the encrypted content
    base64 -w 0 "$input_file" >> "$output_file"
    
    # Add the decryption and execution code
    cat >> "$output_file" << 'EOF'
"

# Decrypt and execute
_execute_menu() {
    local _temp_file="/tmp/menu_$$.sh"
    echo "$_menu_data" | base64 -d > "$_temp_file"
    chmod +x "$_temp_file"
    bash "$_temp_file"
    rm -f "$_temp_file"
}

# Execute the menu
_execute_menu
EOF

    chmod +x "$output_file"
    echo -e "${GREEN}✓ Encrypted: $input_file -> $output_file${NC}"
}

# Function to create protected menu directory
create_protected_menu() {
    local menu_dir="ubuntu/menu-protected"
    
    echo -e "${YELLOW}Creating protected menu directory...${NC}"
    mkdir -p "$menu_dir"
    
    # Create main encrypted menu
    encrypt_file "menu-encrypted.sh" "$menu_dir/menu"
    
    # Create sub-menus
    local sub_menus=("ssh" "vmess" "vless" "trojan" "shadowsocks" "limit" "info" "backup" "reboot" "speedtest" "running" "clear" "bandwidth" "udp" "cache" "bot" "update" "panel" "banner")
    
    for menu in "${sub_menus[@]}"; do
        cat > "$menu_dir/$menu" << EOF
#!/bin/bash
# FRANCIS ENCRYPTED SUB-MENU - $menu
# Copyright (c) 2024 FRANCIS Technologies Kenya

# Anti-tampering protection
if [[ "\${BASH_ARGV[0]}" == *"debug"* ]] || [[ "\$-" == *"x"* ]]; then
    echo "Debugging detected - exiting"
    exit 1
fi

# Remote validation
_validate() {
    local _ip=\$(curl -s ipv4.icanhazip.com)
    local _auth=\$(curl -s https://your-domain.com/auth.txt)
    if ! echo "\$_auth" | grep -q "\$_ip"; then
        echo -e "\\033[1;31mPERMISSION DENIED\\033[0m"
        echo -e "\\033[1;32mContact: +254717640862\\033[0m"
        sleep 5
        reboot
        exit 1
    fi
}

# File integrity check
_check_integrity() {
    local _hash=\$(sha256sum "\$0" | awk '{print \$1}')
    local _expected="your_expected_hash_here"
    if [[ "\$_hash" != "\$_expected" ]]; then
        echo -e "\\033[1;31mFile integrity check failed\\033[0m"
        exit 1
    fi
}

# Run protection checks
_validate
_check_integrity

echo -e "\\033[1;36m=== $menu MENU ===\\033[0m"
echo -e "\\033[1;32m$menu Menu Activated\\033[0m"
echo -e "\\033[1;33mContact: +254717640862\\033[0m"
echo ""
read -p "Press any key to continue..."
EOF
        chmod +x "$menu_dir/$menu"
        echo -e "${GREEN}✓ Created protected sub-menu: $menu${NC}"
    done
    
    echo -e "${GREEN}✓ Protected menu directory created: $menu_dir${NC}"
}

# Function to create menu ZIP with protection
create_protected_zip() {
    local zip_file="menu-protected.zip"
    
    echo -e "${YELLOW}Creating protected menu ZIP...${NC}"
    
    # Create the ZIP with encryption
    cd ubuntu
    zip -r -P "FRANCIS2024" "$zip_file" menu-protected/
    cd ..
    
    echo -e "${GREEN}✓ Protected ZIP created: ubuntu/$zip_file${NC}"
    echo -e "${YELLOW}Password: FRANCIS2024${NC}"
}

# Main execution
echo -e "${BLUE}Select operation:${NC}"
echo "1. Encrypt single file"
echo "2. Create protected menu directory"
echo "3. Create protected menu ZIP"
echo "4. All operations"
echo "0. Exit"
echo ""
read -p "Enter choice: " choice

case $choice in
    1)
        read -p "Enter input file: " input_file
        read -p "Enter output file: " output_file
        encrypt_file "$input_file" "$output_file"
        ;;
    2)
        create_protected_menu
        ;;
    3)
        create_protected_zip
        ;;
    4)
        create_protected_menu
        create_protected_zip
        ;;
    0)
        echo -e "${GREEN}Exiting...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}=== Encryption Complete ===${NC}"
echo -e "${YELLOW}Contact: +254717640862${NC}"
echo -e "${YELLOW}Email: FRANCIS20@GMAIL.COM${NC}" 