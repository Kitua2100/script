# Universal VPN Auto-Installer

## 🚀 Universal Compatibility for All Ubuntu and Debian Versions

This VPN auto-installer has been updated to work with **ALL** Ubuntu and Debian versions, not just Ubuntu 20.04+ and Debian 10+.

## ✅ Supported Operating Systems

### Ubuntu
- ✅ Ubuntu 16.04 LTS (Xenial)
- ✅ Ubuntu 18.04 LTS (Bionic)
- ✅ Ubuntu 20.04 LTS (Focal)
- ✅ Ubuntu 22.04 LTS (Jammy)
- ✅ Ubuntu 24.04 LTS (Noble)
- ✅ Ubuntu 24.10 (Mantic)
- ✅ All future Ubuntu versions

### Debian
- ✅ Debian 8 (Jessie)
- ✅ Debian 9 (Stretch)
- ✅ Debian 10 (Buster)
- ✅ Debian 11 (Bullseye)
- ✅ Debian 12 (Bookworm)
- ✅ Debian 13 (Trixie)
- ✅ All future Debian versions

## 🔧 What's New in Universal Version

### 1. **Smart OS Detection**
- Automatically detects your OS and version
- Adapts installation process accordingly
- No manual configuration needed

### 2. **Universal Package Manager Support**
- Works with both `apt` (newer versions) and `apt-get` (older versions)
- Automatic fallback mechanisms
- Handles package name differences across versions

### 3. **Version-Specific Dependencies**
- **HAProxy**: Automatically installs correct version for your OS
  - Ubuntu 20.04+: HAProxy 2.0+
  - Ubuntu 16.04-19.10: HAProxy 1.8+
  - Debian 11+: HAProxy 2.4+
  - Debian 8-10: HAProxy 1.8+

### 4. **Enhanced Error Handling**
- Better error messages
- Automatic retry mechanisms
- Graceful fallbacks for missing packages

## 📦 Installation Methods

### Method 1: Universal Compatibility Fix (Recommended)
```bash
# Run the compatibility fix first
bash compatibility-fix.sh

# Then run the main installer
bash genz.sh
```

### Method 2: Direct Universal Installation
```bash
# Use the universal wrapper
vpn-universal-install
```

### Method 3: Traditional Installation (Updated)
```bash
# The main script now has universal compatibility built-in
bash genz.sh
```

## 🛠️ Files Overview

| File | Purpose | Compatibility |
|------|---------|---------------|
| `genz.sh` | Main VPN installer | ✅ Universal (Updated) |
| `kyt.sh` | Telegram bot installer | ✅ Universal (Updated) |
| `compatibility-fix.sh` | Universal compatibility setup | ✅ All versions |
| `update.sh` | Script updater | ✅ Universal (Updated) |
| `install-universal.sh` | Alternative universal installer | ✅ All versions |

## 🔄 Update Process

### Automatic Updates
```bash
# Run the universal update script
bash update.sh
```

### Manual Updates
```bash
# Update specific components
bash compatibility-fix.sh
```

## 🐛 Troubleshooting

### Common Issues and Solutions

#### 1. Package Installation Errors
```bash
# If you get package errors, run:
bash compatibility-fix.sh
```

#### 2. HAProxy Version Conflicts
The script automatically handles this, but if you encounter issues:
```bash
# Remove existing HAProxy
apt remove haproxy
# Run compatibility fix
bash compatibility-fix.sh
```

#### 3. Python/Pip Issues
```bash
# Install Python with fallback
apt install python3 python3-pip || apt install python3 python-pip
```

#### 4. Systemd Service Issues
```bash
# Reload systemd
systemctl daemon-reload
# Restart services
systemctl restart xray
```

## 📋 System Requirements

### Minimum Requirements
- **OS**: Ubuntu 16.04+ or Debian 8+
- **Architecture**: x86_64 (64-bit)
- **RAM**: 512MB minimum (1GB recommended)
- **Storage**: 10GB free space
- **Network**: Internet connection

### Recommended Requirements
- **OS**: Ubuntu 20.04+ or Debian 11+
- **RAM**: 2GB+
- **Storage**: 20GB+ free space
- **CPU**: 2+ cores

## 🔒 Security Features

- Automatic SSL certificate generation
- Firewall configuration
- Secure default settings
- Regular security updates

## 📞 Support

### Getting Help
- **Telegram**: https://t.me/franciskitua 
- **WhatsApp**: wa.me/+254717640862
- **Email**: FRANCISKITUA2100@GMAIL.COM 

### Before Asking for Help
1. Check this README
2. Run `bash compatibility-fix.sh`
3. Check system logs: `journalctl -u xray`
4. Verify OS compatibility

## 🎯 Quick Start

### Method 1: Git Clone (Recommended)
```bash
# 1. Download the scripts
git clone https://github.com/Kitua2100/script.git
cd script

# 2. Run compatibility fix
bash compatibility-fix.sh

# 3. Install VPN
bash genz.sh

# 4. Install Telegram bot (optional)
bash kyt.sh
```

### Method 2: Direct Installation (One-Line Command)
```bash
apt install -y && apt update -y && apt upgrade -y && wget -q https://raw.githubusercontent.com/Kitua2100/script/main/genz.sh && chmod +x genz.sh && ./genz.sh
```

### Method 3: Universal Installation (Best Compatibility)
```bash
apt install -y && apt update -y && apt upgrade -y && wget -q https://raw.githubusercontent.com/Kitua2100/script/main/compatibility-fix.sh && chmod +x compatibility-fix.sh && ./compatibility-fix.sh && wget -q https://raw.githubusercontent.com/Kitua2100/script/main/genz.sh && chmod +x genz.sh && ./genz.sh
```

### Method 4: Telegram Bot Installation
```bash
wget -q https://raw.githubusercontent.com/Kitua2100/script/main/kyt.sh && chmod +x kyt.sh && ./kyt.sh
```

### Method 5: Update Script
```bash
wget -q https://raw.githubusercontent.com/Kitua2100/script/main/update.sh && chmod +x update.sh && ./update.sh
```

## 📝 Changelog

### Version 2.0 (Universal)
- ✅ Added support for all Ubuntu versions (16.04+)
- ✅ Added support for all Debian versions (8+)
- ✅ Universal package manager support
- ✅ Smart OS detection and adaptation
- ✅ Enhanced error handling
- ✅ Automatic dependency resolution
- ✅ Version-specific HAProxy installation
- ✅ Improved systemd service management

### Version 1.0 (Original)
- Basic VPN installation
- Ubuntu 20.04+ and Debian 10+ only

## 🤝 Contributing

Feel free to contribute to make this script even better:
1. Test on different OS versions
2. Report bugs and issues
3. Suggest improvements
4. Submit pull requests

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Made with ❤️ by FRANCIS**
