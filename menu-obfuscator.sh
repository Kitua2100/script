#!/bin/bash
# FRANCIS Menu Obfuscator
# Specifically for protecting ubuntu/menu directory

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
NC='\033[0m'

echo -e "${PURPLE}╔══════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║        MENU OBFUSCATOR v2.0          ║${NC}"
echo -e "${PURPLE}║    Ubuntu/Menu Protection System     ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════╝${NC}"

# Configuration
MENU_DIR="ubuntu/menu"
PROTECTED_DIR="/usr/local/francis_menus"
BACKUP_DIR="/root/.francis_menu_backup"
DECOY_DIR="ubuntu/menu_fake"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ Must run as root${NC}"
    exit 1
fi

# Create directories
mkdir -p "$PROTECTED_DIR" "$BACKUP_DIR" "$DECOY_DIR"

obfuscate_menu_files() {
    echo -e "${BLUE}🔒 Obfuscating menu files...${NC}"
    
    # Backup original files
    echo -e "${YELLOW}📁 Creating backup...${NC}"
    cp -r "$MENU_DIR" "$BACKUP_DIR/"
    
    # Process each menu file
    find "$MENU_DIR" -type f | while read file; do
        if [[ -f "$file" ]]; then
            local filename=$(basename "$file")
            local obfuscated_name=$(echo "$filename" | md5sum | cut -d' ' -f1)
            local protected_file="$PROTECTED_DIR/$obfuscated_name.enc"
            
            echo -e "${GREEN}🔐 Processing: $filename${NC}"
            
            # Multi-layer obfuscation
            {
                echo "#!/bin/bash"
                echo "# FRANCIS Protected Menu - $filename"
                echo "# Unauthorized access prohibited"
                echo ""
                echo "# Runtime protection"
                echo "source /usr/local/bin/runtime-protection.sh 2>/dev/null && protect_execution"
                echo ""
                echo "# Decode and execute protected payload"
                echo "PAYLOAD=\$(cat << 'END_PAYLOAD'"
                gzip -c "$file" | base64 -w0 | sed 's/./&\n/g' | shuf | tr -d '\n'
                echo ""
                echo "END_PAYLOAD"
                echo ")"
                echo ""
                echo "# Decode payload"
                echo "echo \"\$PAYLOAD\" | tr -d '\\n' | base64 -d | gunzip | bash"
            } > "$protected_file"
            
            chmod +x "$protected_file"
            
            # Create symlink with original name
            ln -sf "$protected_file" "/usr/local/bin/$filename"
            
            echo -e "${GREEN}✓ Protected: $filename -> $obfuscated_name.enc${NC}"
        fi
    done
}

create_decoy_files() {
    echo -e "${BLUE}🎭 Creating decoy files...${NC}"
    
    # Create fake menu files
    for i in {1..10}; do
        cat > "$DECOY_DIR/menu$i" << EOF
#!/bin/bash
# Fake menu file $i
echo "This is a decoy file"
echo "Real files are protected"
echo "Contact: +254717640862"
exit 1
EOF
        chmod +x "$DECOY_DIR/menu$i"
    done
    
    # Replace original directory with decoys
    rm -rf "$MENU_DIR"
    mv "$DECOY_DIR" "$MENU_DIR"
    
    echo -e "${GREEN}✓ Decoy files created${NC}"
}

setup_access_wrapper() {
    echo -e "${BLUE}🔧 Setting up access wrapper...${NC}"
    
    cat > /usr/local/bin/francis-menu << 'EOF'
#!/bin/bash
# FRANCIS Menu Access Wrapper

# Protection checks
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "FRANCIS Protected Menu System"
    echo "Usage: francis-menu [menu-name]"
    echo "Contact: +254717640862"
    exit 0
fi

# Validate access
source /usr/local/bin/runtime-protection.sh 2>/dev/null || {
    echo "🚫 Protection system not found"
    exit 1
}

protect_execution

# Menu selection
if [[ -z "$1" ]]; then
    echo "Available menus:"
    ls /usr/local/francis_menus/ | sed 's/\.enc$//' | nl
    echo ""
    read -p "Select menu number: " choice
    menu_file=$(ls /usr/local/francis_menus/ | sed 's/\.enc$//' | sed -n "${choice}p")
else
    menu_file="$1"
fi

# Execute protected menu
protected_path="/usr/local/francis_menus/${menu_file}.enc"
if [[ -f "$protected_path" ]]; then
    bash "$protected_path"
else
    echo "🚫 Menu not found: $menu_file"
    exit 1
fi
EOF
    
    chmod +x /usr/local/bin/francis-menu
    echo -e "${GREEN}✓ Access wrapper created${NC}"
}

install_protection_service() {
    echo -e "${BLUE}🛡️ Installing protection service...${NC}"
    
    # Copy runtime protection
    cp runtime-protection.sh /usr/local/bin/
    chmod +x /usr/local/bin/runtime-protection.sh
    
    # Create monitoring service
    cat > /etc/systemd/system/francis-menu-guard.service << EOF
[Unit]
Description=FRANCIS Menu Protection Guard
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/francis-menu-guard
Restart=always
RestartSec=30
User=root

[Install]
WantedBy=multi-user.target
EOF

    cat > /usr/local/bin/francis-menu-guard << 'EOF'
#!/bin/bash
# FRANCIS Menu Guard Service

LOG_FILE="/var/log/francis-menu-guard.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

while true; do
    # Check for tampering
    if [[ ! -d "/usr/local/francis_menus" ]]; then
        log_message "ALERT: Protected menu directory missing!"
        # Could restore from backup here
    fi
    
    # Check for unauthorized access attempts
    if [[ -f "/tmp/.francis_debug" ]]; then
        rm -f /tmp/.francis_debug
        log_message "ALERT: Debug mode attempt detected and blocked"
    fi
    
    # Monitor for unusual activity
    if ps aux | grep -E "(strace|ltrace|gdb)" | grep -v grep > /dev/null; then
        log_message "ALERT: Debugging tools detected"
    fi
    
    sleep 60
done
EOF
    
    chmod +x /usr/local/bin/francis-menu-guard
    systemctl enable francis-menu-guard
    systemctl start francis-menu-guard
    
    echo -e "${GREEN}✓ Protection service installed and started${NC}"
}

# Main execution
main() {
    echo -e "${CYAN}🔒 MENU PROTECTION OPTIONS:${NC}"
    echo ""
    echo -e "${YELLOW}1) Obfuscate menu files only${NC}"
    echo -e "${YELLOW}2) Full protection (obfuscate + decoys + monitoring)${NC}"
    echo -e "${YELLOW}3) Restore from backup${NC}"
    echo -e "${YELLOW}4) View protection status${NC}"
    echo ""
    read -p "Choose option [1-4]: " option
    
    case $option in
        1)
            obfuscate_menu_files
            setup_access_wrapper
            ;;
        2)
            obfuscate_menu_files
            create_decoy_files
            setup_access_wrapper
            install_protection_service
            ;;
        3)
            if [[ -d "$BACKUP_DIR/menu" ]]; then
                echo -e "${BLUE}🔄 Restoring from backup...${NC}"
                rm -rf "$MENU_DIR"
                cp -r "$BACKUP_DIR/menu" "$MENU_DIR"
                echo -e "${GREEN}✅ Restored successfully${NC}"
            else
                echo -e "${RED}❌ No backup found${NC}"
            fi
            ;;
        4)
            echo -e "${BLUE}📊 PROTECTION STATUS:${NC}"
            echo -e "Original menu files: $(ls -la "$BACKUP_DIR/menu" 2>/dev/null | wc -l) files"
            echo -e "Protected files: $(ls -la "$PROTECTED_DIR" 2>/dev/null | wc -l) files"
            echo -e "Service status: $(systemctl is-active francis-menu-guard 2>/dev/null || echo 'not installed')"
            ;;
        *)
            echo -e "${RED}❌ Invalid option${NC}"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}✅ Operation completed!${NC}"
    echo -e "${CYAN}📱 Access menus with: francis-menu${NC}"
    echo -e "${YELLOW}📁 Backup location: $BACKUP_DIR${NC}"
}

main "$@"