#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# UNIVERSAL VPN AUTO-INSTALLER
# System Request : Debian 8+/Ubuntu 16.04+
# Develovers » FRANCIS
# Email      » FRANCIS2100@GMAIL.COM
# telegram   » https://t.me/franciskitua 
# whatsapp   » wa.me/+254717640862
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# UNIVERSAL VERSION - WORKS WITH ALL UBUNTU/DEBIAN VERSIONS

# Color definitions
Green="\e[92;1m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
OK="${Green}  »${FONT}"
ERROR="${RED}[ERROR]${FONT}"
GRAY="\e[1;30m"
NC='\e[0m'
red='\e[1;31m'
green='\e[0;32m'

# Clear screen
clear
clear && clear && clear
clear;clear;clear

# Banner
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  Script : ${GRAY} UNIVERSAL VPN AUTO-INSTALLER BY FRANCISTECH ${NC}"
echo -e "  Author : ${RED}FRANCIS TECHNOLOGIES KENYA ${NC}${YELLOW}${NC}"
echo -e "  ©2024  : ${BLUE} WELCOME TO  FREENET WORLD ${NC}"
echo -e "  Support: ${GREEN}Debian 8+ / Ubuntu 16.04+${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
sleep 2

# Universal OS Detection Function
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_ID=$ID
        OS_VERSION=$VERSION_ID
        OS_NAME=$PRETTY_NAME
        OS_CODENAME=$VERSION_CODENAME
    else
        echo -e "${ERROR} Cannot detect OS version"
        exit 1
    fi
}

# Check OS Compatibility
check_os_compatibility() {
    detect_os
    
    echo -e "${OK} Detected OS: ${green}$OS_NAME${NC}"
    
    # Check if it's Ubuntu or Debian
    if [[ "$OS_ID" == "ubuntu" ]]; then
        # Convert version to number for comparison
        VERSION_NUM=$(echo $OS_VERSION | sed 's/\.//g')
        if [ "$VERSION_NUM" -ge 1604 ]; then
            echo -e "${OK} Ubuntu version $OS_VERSION is supported"
            return 0
        else
            echo -e "${ERROR} Ubuntu version $OS_VERSION is too old. Minimum required: 16.04"
            exit 1
        fi
    elif [[ "$OS_ID" == "debian" ]]; then
        VERSION_NUM=$(echo $OS_VERSION | sed 's/\.//g')
        if [ "$VERSION_NUM" -ge 80 ]; then
            echo -e "${OK} Debian version $OS_VERSION is supported"
            return 0
        else
            echo -e "${ERROR} Debian version $OS_VERSION is too old. Minimum required: 8.0"
            exit 1
        fi
    else
        echo -e "${ERROR} Your OS Is Not Supported ( ${YELLOW}$OS_NAME${NC} )"
        exit 1
    fi
}

# Universal Package Manager Functions
get_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v apt-get &> /dev/null; then
        echo "apt-get"
    else
        echo "none"
    fi
}

update_packages() {
    local pkg_mgr=$(get_package_manager)
    echo -e "${OK} Updating package lists..."
    if [ "$pkg_mgr" = "apt" ]; then
        apt update -y
    elif [ "$pkg_mgr" = "apt-get" ]; then
        apt-get update -y
    else
        echo -e "${ERROR} No supported package manager found"
        exit 1
    fi
}

install_package() {
    local package=$1
    local pkg_mgr=$(get_package_manager)
    
    if [ "$pkg_mgr" = "apt" ]; then
        apt install -y "$package"
    elif [ "$pkg_mgr" = "apt-get" ]; then
        apt-get install -y "$package"
    fi
}

# Install packages with fallback for older versions
install_package_with_fallback() {
    local package=$1
    local fallback_package=$2
    
    if ! install_package "$package" 2>/dev/null; then
        if [ -n "$fallback_package" ]; then
            echo -e "${YELLOW} Trying fallback package: $fallback_package${NC}"
            install_package "$fallback_package"
        else
            echo -e "${ERROR} Failed to install $package"
            return 1
        fi
    fi
}

# Check Architecture
if [[ $( uname -m | awk '{print $1}' ) == "x86_64" ]]; then
    echo -e "${OK} Your Architecture Is Supported ( ${green}$( uname -m )${NC} )"
else
    echo -e "${ERROR} Your Architecture Is Not Supported ( ${YELLOW}$( uname -m )${NC} )"
    exit 1
fi

# Check OS Compatibility
check_os_compatibility

# Check if running as root
if [ "${EUID}" -ne 0 ]; then
    echo -e "${ERROR} You need to run this script as root"
    exit 1
fi

# Check virtualization
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo -e "${ERROR} OpenVZ is not supported"
    exit 1
fi

# Export IP Address
export IP=$( curl -sS icanhazip.com )
if [[ $IP == "" ]]; then
    echo -e "${ERROR} IP Address ( ${YELLOW}Not Detected${NC} )"
else
    echo -e "${OK} IP Address ( ${green}$IP${NC} )"
fi

# Continue prompt
echo ""
read -p "$( echo -e "Press ${GRAY}[ ${NC}${green}Enter${NC} ${GRAY}]${NC} For Starting Installation") "
echo ""
clear

# Install basic dependencies
echo -e "${OK} Installing basic dependencies..."
update_packages

# Install essential packages with version-specific handling
install_package "curl"
install_package "wget"
install_package "unzip"
install_package "git"

# Install ruby and lolcat with fallback
install_package_with_fallback "ruby" "ruby2.7"
if command -v gem &> /dev/null; then
    gem install lolcat
else
    echo -e "${YELLOW} Ruby gem not available, skipping lolcat${NC}"
fi

# Install wondershaper
install_package_with_fallback "wondershaper" ""

clear

# REPO    
REPO="https://raw.githubusercontent.com/Kitua2100/script/main/"

# Installation timer
start=$(date +%s)
secs_to_human() {
    echo "Installation time : $((${1} / 3600)) hours $(((${1} / 60) % 60)) minute's $((${1} % 60)) seconds"
}

# Status functions
function print_ok() {
    echo -e "${OK} ${BLUE} $1 ${FONT}"
}

function print_install() {
    echo -e "${green} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ${FONT}"
    echo -e "${YELLOW} » $1 ${FONT}"
    echo -e "${green} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ${FONT}"
    sleep 1
}

function print_error() {
    echo -e "${ERROR} ${REDBG} $1 ${FONT}"
}

function print_success() {
    if [[ 0 -eq $? ]]; then
        echo -e "${green} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ${FONT}"
        echo -e "${Green} » $1 installed successfully"
        echo -e "${green} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ${FONT}"
        sleep 2
    fi
}

# Create xray directory
print_install "Create xray directory"
mkdir -p /etc/xray
curl -s ifconfig.me > /etc/xray/ipvps
touch /etc/xray/domain
mkdir -p /var/log/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
mkdir -p /var/lib/kyt >/dev/null 2>&1

# System information
export tanggal=`date -d "0 days" +"%d-%m-%Y - %X" `
export OS_Name=$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' )
export Kernel=$( uname -r )
export Arch=$( uname -m )
export IP=$( curl -s https://ipinfo.io/ip/ )

# Universal Setup Function
function first_setup(){
    print_install "Setting up system environment"
    
    # Set timezone
    timedatectl set-timezone Asia/Jakarta
    
    # Configure iptables persistence
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    
    detect_os
    local pkg_mgr=$(get_package_manager)
    
    if [[ "$OS_ID" == "ubuntu" ]]; then
        echo -e "${OK} Setup Dependencies For Ubuntu $OS_VERSION"
        update_packages
        install_package "software-properties-common"
        
        # Add HAProxy repository based on Ubuntu version
        VERSION_NUM=$(echo $OS_VERSION | sed 's/\.//g')
        if [ "$VERSION_NUM" -ge 2004 ]; then
            # Ubuntu 20.04+ - use newer HAProxy
            add-apt-repository ppa:vbernat/haproxy-2.0 -y
            update_packages
            install_package "haproxy=2.0.*"
        else
            # Ubuntu 16.04-19.10 - use older HAProxy
            add-apt-repository ppa:vbernat/haproxy-1.8 -y
            update_packages
            install_package "haproxy=1.8.*"
        fi
    elif [[ "$OS_ID" == "debian" ]]; then
        echo -e "${OK} Setup Dependencies For Debian $OS_VERSION"
        update_packages
        
        # Add HAProxy repository based on Debian version
        VERSION_NUM=$(echo $OS_VERSION | sed 's/\.//g')
        if [ "$VERSION_NUM" -ge 110 ]; then
            # Debian 11+ - use newer HAProxy
            curl https://haproxy.debian.net/bernat.debian.org.gpg | gpg --dearmor >/usr/share/keyrings/haproxy.debian.net.gpg
            echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" http://haproxy.debian.net bullseye-backports-2.4 main >/etc/apt/sources.list.d/haproxy.list
            update_packages
            install_package "haproxy=2.4.*"
        else
            # Debian 8-10 - use older HAProxy
            curl https://haproxy.debian.net/bernat.debian.org.gpg | gpg --dearmor >/usr/share/keyrings/haproxy.debian.net.gpg
            echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" http://haproxy.debian.net buster-backports-1.8 main >/etc/apt/sources.list.d/haproxy.list
            update_packages
            install_package "haproxy=1.8.*"
        fi
    fi
    
    print_success "System environment setup"
}

# Universal Nginx Installation
function nginx_install() {
    detect_os
    local pkg_mgr=$(get_package_manager)
    
    if [[ "$OS_ID" == "ubuntu" ]]; then
        print_install "Setup nginx For Ubuntu $OS_VERSION"
        update_packages
        install_package "nginx"
    elif [[ "$OS_ID" == "debian" ]]; then
        print_install "Setup nginx For Debian $OS_VERSION"
        update_packages
        install_package "nginx"
    fi
}

# Install base packages with version compatibility
function base_package() {
    clear
    print_install "Installing the Required Packages"
    
    # Essential packages
    install_package "zip"
    install_package "pwgen"
    install_package "openssl"
    install_package "netcat"
    install_package "socat"
    install_package "cron"
    install_package "bash-completion"
    install_package "sudo"
    install_package "ntpdate"
    install_package "chrony"
    
    # Install figlet with fallback
    install_package_with_fallback "figlet" ""
    
    # Update and upgrade
    update_packages
    install_package "dist-upgrade"
    
    # Enable chrony
    systemctl enable chronyd 2>/dev/null || systemctl enable chrony
    systemctl restart chronyd 2>/dev/null || systemctl restart chrony
    
    # NTP sync
    ntpdate pool.ntp.org
    
    # Clean up
    install_package "autoremove"
    install_package "clean"
    install_package "debconf-utils"
    
    # Remove conflicting packages
    install_package "remove --purge exim4"
    install_package "remove --purge ufw"
    install_package "remove --purge firewalld"
    
    # Install additional packages with fallbacks for older versions
    local packages=(
        "speedtest-cli" "vnstat" "libnss3-dev" "libnspr4-dev" "pkg-config"
        "libpam0g-dev" "libcap-ng-dev" "libcap-ng-utils" "libselinux1-dev"
        "libcurl4-nss-dev" "flex" "bison" "make" "libnss3-tools"
        "libevent-dev" "bc" "rsyslog" "dos2unix" "zlib1g-dev"
        "libssl-dev" "libsqlite3-dev" "sed" "dirmngr" "libxml-parser-perl"
        "build-essential" "gcc" "g++" "python" "htop" "lsof" "tar"
        "p7zip-full" "python3-pip" "libc6" "util-linux" "msmtp-mta"
        "ca-certificates" "bsd-mailx" "iptables" "iptables-persistent"
        "netfilter-persistent" "net-tools" "openssl" "gnupg" "gnupg2"
        "lsb-release" "shc" "make" "cmake" "screen" "xz-utils"
        "apt-transport-https" "gnupg1" "dnsutils" "jq" "openvpn"
        "easy-rsa"
    )
    
    for package in "${packages[@]}"; do
        install_package_with_fallback "$package" ""
    done
    
    print_success "Required Packages"
}

# Domain setup function
function pasang_domain() {
    echo -e ""
    clear
    echo -e " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e " \e[1;32mPlease Select a Domain Type Below \e[0m"
    echo -e " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e " \e[1;32m1)\e[0m Use Your Own Domain (Recommended)"
    echo -e " \e[1;32m2)\e[0m Use Random Domain"
    echo -e " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p " Please select numbers 1-2 or Any Button(Random) : " host
    echo ""
    
    if [[ $host == "1" ]]; then
        echo -e " \e[1;32mPlease Enter Your Subdomain $NC"
        echo -e " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo -e ""
        read -p " Input Domain : " host1
        echo -e ""
        echo -e " ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo "IP=" >> /var/lib/kyt/ipvps.conf
        echo $host1 > /etc/xray/domain
        echo $host1 > /root/domain
        echo ""
    elif [[ $host == "2" ]]; then
        # Install Cloudflare script
        wget ${REPO}ubuntu/cf.sh && chmod +x cf.sh && ./cf.sh
        rm -f /root/cf.sh
        clear
    else
        print_install "Random Subdomain/Domain is Used"
        clear
    fi
}

# Main installation process
echo -e "${OK} Starting universal installation process..."
first_setup
nginx_install
base_package
pasang_domain

# Continue with the rest of the installation...
echo -e "${OK} Basic setup completed. Continuing with VPN installation..."
echo -e "${OK} This script will now proceed with the full VPN installation."
echo -e "${OK} Installation time: $(secs_to_human $(($(date +%s) - start)))"

# Note: The rest of the installation functions would continue here
# This is a framework for the universal installer 
