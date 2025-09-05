#!/bin/bash
# FRANCIS Advanced Script Protector
# Multi-Layer Protection System

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${PURPLE}╔══════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║      FRANCIS ADVANCED PROTECTOR      ║${NC}"
echo -e "${PURPLE}║        Multi-Layer Security          ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════╝${NC}"
echo ""

# Check root access
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ Please run as root${NC}"
    exit 1
fi

# Protection Configuration
PROTECT_DIR="ubuntu/menu"
BACKUP_DIR="/root/.francis_backup"
ENCRYPTED_DIR="/usr/local/francis_protected"
SERVER_URL="https://raw.githubusercontent.com/Kitua2100/script/main"
TELEGRAM_BOT_TOKEN="YOUR_BOT_TOKEN"
TELEGRAM_CHAT_ID="YOUR_CHAT_ID"

# Functions
send_alert() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d text="🚨 SECURITY ALERT: $message" \
        -d parse_mode="HTML" > /dev/null 2>&1
}

get_hardware_id() {
    # Generate unique hardware fingerprint
    {
        dmidecode -s system-uuid 2>/dev/null
        cat /proc/cpuinfo | grep "model name" | head -1
        ip route get 8.8.8.8 | grep -oP 'src \K[^ ]+'
    } | md5sum | cut -d' ' -f1
}

validate_license() {
    local hwid=$(get_hardware_id)
    local current_ip=$(curl -s ipv4.icanhazip.com)
    
    # Check against your license server
    local auth_response=$(curl -s "${SERVER_URL}/keygen" | grep "$current_ip")
    
    if [[ -z "$auth_response" ]]; then
        echo -e "${RED}❌ UNAUTHORIZED ACCESS DETECTED${NC}"
        echo -e "${YELLOW}IP: $current_ip${NC}"
        echo -e "${YELLOW}Hardware ID: $hwid${NC}"
        echo -e "${CYAN}Contact: +254717640862${NC}"
        send_alert "Unauthorized access attempt from IP: $current_ip, HWID: $hwid"
        exit 1
    fi
}

create_encrypted_wrapper() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    local wrapper_path="/usr/local/bin/$script_name"
    
    cat > "$wrapper_path" << EOF
#!/bin/bash
# FRANCIS Protected Wrapper - $script_name
# Anti-tampering protection enabled

# Check for debugging
if [[ "\${BASH_ARGV[0]}" == *"debug"* ]] || [[ "\$-" == *"x"* ]]; then
    echo "🚫 Debugging detected"
    exit 1
fi

# Validate environment
if [[ -f /tmp/.francis_debug ]] || [[ -n "\$FRANCIS_DEBUG" ]]; then
    rm -f /tmp/.francis_debug
    echo "🚫 Debug mode disabled"
    exit 1
fi

# Runtime validation
$(declare -f validate_license)
$(declare -f get_hardware_id)
$(declare -f send_alert)

# Configuration
TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"
SERVER_URL="$SERVER_URL"

# Validate before execution
validate_license

# Execute encrypted payload
ENCRYPTED_PAYLOAD="\$(cat << 'PAYLOAD_END'
$(gzip -c "$script_path" | base64 -w0)
PAYLOAD_END
)"

# Decode and execute
echo "\$ENCRYPTED_PAYLOAD" | base64 -d | gunzip | bash
EOF
    
    chmod +x "$wrapper_path"
    echo -e "${GREEN}✓ Created protected wrapper: $wrapper_path${NC}"
}

obfuscate_directory() {
    echo -e "${BLUE}🔒 Obfuscating directory: $PROTECT_DIR${NC}"
    
    # Create backup
    mkdir -p "$BACKUP_DIR"
    cp -r "$PROTECT_DIR" "$BACKUP_DIR/"
    
    # Create encrypted storage
    mkdir -p "$ENCRYPTED_DIR"
    
    # Process each file
    find "$PROTECT_DIR" -type f -name "*" | while read file; do
        if [[ -f "$file" ]]; then
            relative_path=$(echo "$file" | sed "s|^$PROTECT_DIR/||")
            encrypted_file="$ENCRYPTED_DIR/$(echo "$relative_path" | md5sum | cut -d' ' -f1).enc"
            
            # Multi-layer encryption
            gzip -c "$file" | base64 -w0 | openssl enc -aes-256-cbc -salt -k "FRANCIS2024" > "$encrypted_file"
            
            # Create wrapper
            create_encrypted_wrapper "$file"
            
            echo -e "${GREEN}✓ Encrypted: $relative_path${NC}"
        fi
    done
    
    # Hide original directory
    mv "$PROTECT_DIR" "${PROTECT_DIR}.hidden"
    mkdir -p "$PROTECT_DIR"
    
    # Create decoy files
    for i in {1..5}; do
        echo "# Decoy file $i" > "$PROTECT_DIR/decoy$i"
    done
}

create_protection_service() {
    cat > /etc/systemd/system/francis-guard.service << EOF
[Unit]
Description=FRANCIS Protection Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/francis-guard
Restart=always
RestartSec=30
User=root

[Install]
WantedBy=multi-user.target
EOF

    cat > /usr/local/bin/francis-guard << 'EOF'
#!/bin/bash
# FRANCIS Guard Service

while true; do
    # Check for tampering
    if [[ -f /tmp/.francis_debug ]] || [[ -n "$FRANCIS_DEBUG" ]]; then
        echo "🚫 Debug mode detected - cleaning"
        unset FRANCIS_DEBUG
        rm -f /tmp/.francis_debug
    fi
    
    # Check for unauthorized modifications
    if [[ ! -d "/usr/local/francis_protected" ]]; then
        echo "🚨 Protection directory missing!"
        # Send alert and restore
    fi
    
    sleep 60
done
EOF
    
    chmod +x /usr/local/bin/francis-guard
    systemctl enable francis-guard
    systemctl start francis-guard
    
    echo -e "${GREEN}✓ Protection service installed${NC}"
}

# Main execution
main() {
    echo -e "${CYAN}Choose protection level:${NC}"
    echo -e "${YELLOW}1) Basic Obfuscation${NC}"
    echo -e "${YELLOW}2) Advanced Encryption${NC}"
    echo -e "${YELLOW}3) Military Grade (Recommended)${NC}"
    echo -e "${YELLOW}4) Custom Configuration${NC}"
    echo ""
    read -p "Enter choice [1-4]: " choice
    
    case $choice in
        1)
            echo -e "${BLUE}🔒 Applying basic obfuscation...${NC}"
            obfuscate_directory
            ;;
        2)
            echo -e "${BLUE}🔒 Applying advanced encryption...${NC}"
            obfuscate_directory
            create_protection_service
            ;;
        3)
            echo -e "${BLUE}🔒 Applying military grade protection...${NC}"
            obfuscate_directory
            create_protection_service
            # Add additional layers here
            ;;
        4)
            echo -e "${BLUE}🔧 Custom configuration mode...${NC}"
            # Custom options
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}✅ Protection applied successfully!${NC}"
    echo -e "${CYAN}📱 Configure Telegram alerts: Edit TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID${NC}"
    echo -e "${YELLOW}⚠️  Keep backup safe: $BACKUP_DIR${NC}"
}

# Run main function
main "$@"