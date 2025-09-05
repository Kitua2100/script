#!/bin/bash
# FRANCIS Security Monitor
# Monitors for unauthorized access and modifications

# Obfuscated variables
_a="\033[1;31m"
_b="\033[0m"
_c="\033[1;32m"
_d="\033[1;33m"
_e="\033[1;36m"
_f="echo"
_g="curl"
_h="wget"
_i="sha256sum"
_j="grep"
_k="diff"
_l="mail"
_m="telegram"
_n="whatsapp"

# Configuration
LOG_FILE="/var/log/emmkash-security.log"
ALERT_EMAIL="FRANCIS20@GMAIL.COM"
TELEGRAM_BOT_TOKEN="your_bot_token_here"
TELEGRAM_CHAT_ID="your_chat_id_here"

# Initialize log file
init_log() {
    if [ ! -f "$LOG_FILE" ]; then
        touch "$LOG_FILE"
        chmod 600 "$LOG_FILE"
    fi
}

# Log security event
log_event() {
    local event="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] SECURITY: $event" >> "$LOG_FILE"
}

# Send alert via email
send_email_alert() {
    local subject="$1"
    local message="$2"
    echo "$message" | mail -s "$subject" "$ALERT_EMAIL"
}

# Send alert via Telegram
send_telegram_alert() {
    local message="$1"
    local encoded_message=$(echo "$message" | sed 's/ /%20/g')
    curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage?chat_id=$TELEGRAM_CHAT_ID&text=$encoded_message" > /dev/null
}

# Check file integrity
check_file_integrity() {
    local file="$1"
    local expected_hash="$2"
    local current_hash=$($i "$file" | awk '{print $1}')
    
    if [ "$current_hash" != "$expected_hash" ]; then
        local alert_msg="File integrity check failed: $file"
        log_event "$alert_msg"
        send_email_alert "Security Alert - File Modified" "$alert_msg"
        send_telegram_alert "$alert_msg"
        return 1
    fi
    return 0
}

# Check for unauthorized IP access
check_ip_access() {
    local current_ip=$(curl -s ipv4.icanhazip.com)
    local authorized_ips=$(curl -s https://your-domain.com/auth.txt)
    
    if ! echo "$authorized_ips" | grep -q "$current_ip"; then
        local alert_msg="Unauthorized IP access detected: $current_ip"
        log_event "$alert_msg"
        send_email_alert "Security Alert - Unauthorized Access" "$alert_msg"
        send_telegram_alert "$alert_msg"
        return 1
    fi
    return 0
}

# Check for debugging attempts
check_debugging() {
    if [[ "${BASH_ARGV[0]}" == *"debug"* ]] || [[ "$-" == *"x"* ]]; then
        local alert_msg="Debugging attempt detected"
        log_event "$alert_msg"
        send_email_alert "Security Alert - Debugging Attempt" "$alert_msg"
        send_telegram_alert "$alert_msg"
        return 1
    fi
    return 0
}

# Check for virtualization
check_virtualization() {
    if [[ -f /proc/cpuinfo ]] && grep -q "hypervisor" /proc/cpuinfo; then
        local alert_msg="Virtualization detected - unauthorized environment"
        log_event "$alert_msg"
        send_email_alert "Security Alert - Virtualization Detected" "$alert_msg"
        send_telegram_alert "$alert_msg"
        return 1
    fi
    return 0
}

# Monitor system resources
check_system_resources() {
    local mem_usage=$(free | grep Mem | awk '{printf "%.2f", $3/$2 * 100.0}')
    local disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    if (( $(echo "$mem_usage > 90" | bc -l) )); then
        local alert_msg="High memory usage detected: ${mem_usage}%"
        log_event "$alert_msg"
        send_telegram_alert "$alert_msg"
    fi
    
    if [ "$disk_usage" -gt 90 ]; then
        local alert_msg="High disk usage detected: ${disk_usage}%"
        log_event "$alert_msg"
        send_telegram_alert "$alert_msg"
    fi
}

# Check for suspicious processes
check_suspicious_processes() {
    local suspicious_procs=("gdb" "strace" "ltrace" "objdump" "strings")
    
    for proc in "${suspicious_procs[@]}"; do
        if pgrep -x "$proc" > /dev/null; then
            local alert_msg="Suspicious process detected: $proc"
            log_event "$alert_msg"
            send_email_alert "Security Alert - Suspicious Process" "$alert_msg"
            send_telegram_alert "$alert_msg"
        fi
    done
}

# Monitor network connections
check_network_connections() {
    local suspicious_ports=(22 23 3389 5900)
    
    for port in "${suspicious_ports[@]}"; do
        if netstat -tuln | grep ":$port " > /dev/null; then
            local alert_msg="Suspicious port open: $port"
            log_event "$alert_msg"
            send_telegram_alert "$alert_msg"
        fi
    done
}

# Check for file modifications
check_file_modifications() {
    local protected_files=("genz.sh" "kyt.sh" "update.sh" "menu-protected.sh")
    
    for file in "${protected_files[@]}"; do
        if [ -f "$file" ]; then
            local last_modified=$(stat -c %Y "$file")
            local current_time=$(date +%s)
            local time_diff=$((current_time - last_modified))
            
            # Alert if file was modified in the last hour
            if [ $time_diff -lt 3600 ]; then
                local alert_msg="Recent file modification detected: $file"
                log_event "$alert_msg"
                send_telegram_alert "$alert_msg"
            fi
        fi
    done
}

# Main monitoring function
run_security_checks() {
    $_f -e "$_e=== FRANCIS Security Monitor ===$_b"
    
    # Initialize logging
    init_log
    
    # Run all security checks
    check_ip_access
    check_debugging
    check_virtualization
    check_system_resources
    check_suspicious_processes
    check_network_connections
    check_file_modifications
    
    $_f -e "$_cSecurity checks completed$_b"
    log_event "Security monitoring cycle completed"
}

# Continuous monitoring
continuous_monitoring() {
    while true; do
        run_security_checks
        sleep 300  # Check every 5 minutes
    done
}

# Main execution
case "$1" in
    "start")
        $_f -e "$_cStarting continuous security monitoring...$_b"
        continuous_monitoring
        ;;
    "check")
        run_security_checks
        ;;
    "log")
        if [ -f "$LOG_FILE" ]; then
            tail -50 "$LOG_FILE"
        else
            $_f -e "$_aNo log file found$_b"
        fi
        ;;
    *)
        $_f -e "$_eFRANCIS Security Monitor$_b"
        $_f -e "Usage: $0 {start|check|log}"
        $_f -e ""
        $_f -e "  start  - Start continuous monitoring"
        $_f -e "  check  - Run security checks once"
        $_f -e "  log    - Show recent security events"
        $_f -e ""
        $_f -e "Contact: +254717640862"
        $_f -e "Email: FRANCIS20@GMAIL.COM"
        ;;
esac 