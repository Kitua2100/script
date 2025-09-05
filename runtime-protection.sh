#!/bin/bash
# FRANCIS Runtime Protection System
# Real-time Anti-Tampering Protection

# Protection Functions
anti_debug() {
    # Detect debugging attempts
    if [[ "${BASH_ARGV[0]}" == *"debug"* ]] || [[ "$-" == *"x"* ]]; then
        echo "🚫 Debug mode detected - Access denied"
        exit 1
    fi
    
    # Check for common debugging tools
    if pgrep -f "strace\|ltrace\|gdb\|objdump" > /dev/null; then
        echo "🚫 Debugging tools detected"
        exit 1
    fi
    
    # Remove debug environment variables
    unset BASH_XTRACEFD BASH_XTRACE DEBUG FRANCIS_DEBUG
    set +x
}

check_integrity() {
    # Verify script hasn't been modified
    local script_path="$0"
    local expected_hash="REPLACE_WITH_ACTUAL_HASH"
    local current_hash=$(sha256sum "$script_path" | cut -d' ' -f1)
    
    if [[ "$current_hash" != "$expected_hash" ]]; then
        echo "🚫 Script integrity check failed"
        # Send alert about tampering
        curl -s "https://api.telegram.org/botYOUR_TOKEN/sendMessage" \
            -d "chat_id=YOUR_CHAT_ID" \
            -d "text=🚨 Script tampering detected!" > /dev/null 2>&1
        exit 1
    fi
}

hardware_fingerprint() {
    # Generate unique hardware ID
    local hwid=$(
        {
            dmidecode -s system-uuid 2>/dev/null || echo "unknown"
            cat /proc/cpuinfo | grep "model name" | head -1 | cut -d: -f2 || echo "unknown"
            ip route get 8.8.8.8 | grep -oP 'src \K[^ ]+' 2>/dev/null || echo "unknown"
        } | md5sum | cut -d' ' -f1
    )
    echo "$hwid"
}

validate_access() {
    local current_ip=$(curl -s ipv4.icanhazip.com 2>/dev/null || echo "unknown")
    local hwid=$(hardware_fingerprint)
    local timestamp=$(date +%s)
    
    # Check against your authorization server
    local auth_check=$(curl -s "https://raw.githubusercontent.com/Kitua2100/script/main/keygen" | grep "$current_ip")
    
    if [[ -z "$auth_check" ]]; then
        echo "🚫 UNAUTHORIZED ACCESS"
        echo "IP: $current_ip"
        echo "Hardware ID: $hwid"
        echo "Contact: +254717640862"
        
        # Log attempt
        echo "$(date): Unauthorized access from $current_ip (HWID: $hwid)" >> /var/log/francis-security.log
        
        exit 1
    fi
    
    # Check expiration (if you want time-limited access)
    local expiry_date="2025-12-31"
    local expiry_timestamp=$(date -d "$expiry_date" +%s)
    
    if [[ $timestamp -gt $expiry_timestamp ]]; then
        echo "🚫 LICENSE EXPIRED"
        echo "Contact: +254717640862 for renewal"
        exit 1
    fi
}

# Protection Wrapper Function
protect_execution() {
    # Clear terminal for security
    clear
    
    # Run all protection checks
    anti_debug
    validate_access
    check_integrity
    
    # Set secure environment
    export HISTFILE=/dev/null
    export HISTSIZE=0
    export HISTFILESIZE=0
    
    # Disable core dumps
    ulimit -c 0
    
    # Set restrictive umask
    umask 077
}

# Usage: Source this file at the beginning of your scripts
# Example: source /path/to/runtime-protection.sh && protect_execution