# Ultimate Garuda Powerhouse

**Complete AI-Powered Linux Distribution** - A unified repository combining ISO building, system installation, ZFS integration, and media stack deployment in one cohesive package.

## 🚀 Quick Start

### Build ISO & Install Everything
```bash
# Complete setup (requires root for system installation)
sudo ./scripts/setup-all.sh
```

### Build ISO Only
```bash
# Build ArchISO profile
./scripts/build-iso.sh

# Build Garuda profile
./scripts/build-iso.sh --profile garuda
```

### Install System Components Only
```bash
# Full system installation (requires root)
sudo ./scripts/install-system.sh

# Install only media stack
sudo ./scripts/install-system.sh --no-zfs --no-calamares --media-stack universal
```

## 📁 Repository Structure

```
/
├── scripts/                    # 🎯 Main entry points
│   ├── build-iso.sh           # Unified ISO builder
│   ├── install-system.sh      # System installer  
│   └── setup-all.sh          # Complete setup
├── iso/                       # 💿 ISO building components
│   ├── archiso-profile/       # ArchISO profile
│   ├── garuda-profile/        # Garuda profile
│   └── virtualization/        # VM testing tools
├── installer/                 # 🔧 System installation
│   ├── calamares/            # Calamares ZFS integration
│   └── zfs/                  # ZFS setup scripts
├── media-stack/              # 📺 Media server components
│   ├── scripts/              # Service management
│   ├── api/                  # REST API
│   ├── dashboard/            # Web dashboard
│   └── mobile-app/           # Mobile app
├── ai-ml/                    # 🤖 AI/ML components
└── docs/                     # 📚 Documentation
```

## 🛠️ Available Commands

### ISO Building
```bash
# Standard ArchISO build
./scripts/build-iso.sh

# Garuda profile with custom paths  
./scripts/build-iso.sh -p garuda -w /fast/tmp -o /fast/out

# Verbose build
./scripts/build-iso.sh -v
```

### System Installation
```bash
# Full installation
sudo ./scripts/install-system.sh

# Custom media stack type
sudo ./scripts/install-system.sh --media-stack universal

# Include AI/ML components
sudo ./scripts/install-system.sh --ai-ml

# Minimal installation
sudo ./scripts/install-system.sh --media-stack none
```

### Complete Setup
```bash
# Everything with ArchISO and native media stack
sudo ./scripts/setup-all.sh

# Garuda ISO only
./scripts/setup-all.sh --iso-profile garuda --no-install-system

# System only (no ISO build)
sudo ./scripts/setup-all.sh --no-build-iso --media-stack universal

# Everything including AI/ML
sudo ./scripts/setup-all.sh --ai-ml
```

## 🎯 Use Cases

### 1. ISO Creation
Perfect for creating custom Linux distributions with:
- **ArchISO Profile**: Standard Arch Linux base with AI/ML tools
- **Garuda Profile**: Garuda Linux base with custom enhancements
- Built-in virtualization testing tools

### 2. System Deployment
Comprehensive system installation including:
- **ZFS Integration**: Advanced filesystem with Calamares installer support
- **Media Stack**: Complete self-hosting solution (Jellyfin, *arr stack, qBittorrent)
- **AI/ML Tools**: Ollama integration and machine learning frameworks

### 3. Development & Testing
- **VM Testing**: MobaLiveCD-style ISO runner with QEMU integration
- **USB Creation**: Automated bootable USB creation tools
- **Health Monitoring**: Built-in service monitoring and management

## 🔧 Component Details

### Media Stack Options
- **Native**: Full native installation with all services
- **Universal**: Container-based deployment for portability
- **Basic**: Essential services only (no Ghost Mode/WireGuard)
- **None**: Skip media stack installation

### ZFS Integration
- Custom Calamares module for post-ZFS configuration
- Automatic systemd service enablement
- mkinitcpio integration for ZFS boot support
- Mountpoint and cache optimization

### AI/ML Components
- Ollama integration for local LLMs
- Machine learning framework support
- GPU acceleration configuration (when available)

## 📋 Requirements

### For ISO Building
- `archiso` package
- `git`
- Sufficient disk space (10GB+ recommended)

### For System Installation
- Root privileges (`sudo`)
- Internet connection
- Target system with adequate resources

### For Media Stack
- Docker (for universal installation)
- Adequate storage for media files
- Network connectivity for remote access

## 🚀 Quick Examples

### Create a Custom ISO
```bash
# Build ArchISO with custom output directory
WORK_DIR=/fast/tmp OUTPUT_DIR=/custom/output ./scripts/build-iso.sh
```

### Test in VM
```bash
# Test the built ISO
make -C iso/virtualization run
```

### Deploy Media Stack Only
```bash
# Install just the media services
sudo ./scripts/install-system.sh --no-zfs --no-calamares --media-stack native
```

### Full AI-Powered Setup
```bash
# Everything including AI/ML
sudo ./scripts/setup-all.sh --ai-ml
```

## 🔍 Testing & Verification

### Virtualization Testing
```bash
# Check dependencies
make -C iso/virtualization check

# Run and test
make -C iso/virtualization run
make -C iso/virtualization test
```

### Service Health Checks
```bash
# Media stack status
media-stack/scripts/ultimate-status.sh

# Enhanced health check  
media-stack/scripts/health-check-enhanced.sh
```

### Calamares ZFS Validation
```bash
# Validate Python module
python3 -m py_compile installer/calamares/modules/zfspostcfg/main.py

# Test configuration files
python3 -c "import yaml; yaml.safe_load(open('installer/calamares/modules/zfspostcfg/zfspostcfg.conf'))"
```

## 🆘 Troubleshooting

### Common Issues
1. **Permission Denied**: Use `sudo` for system installation commands
2. **Missing Dependencies**: Run dependency checks first (`make -C iso/virtualization check`)
3. **Disk Space**: Ensure adequate space for ISO building (10GB+)

### Debug Mode
Most scripts support verbose output:
```bash
./scripts/build-iso.sh --verbose
sudo ./scripts/install-system.sh  # Already includes detailed logging
```

## 🤝 Contributing

This repository combines functionality from three upstream projects:
- [ai-powerhouse-setup](https://github.com/wlfogle/ai-powerhouse-setup)
- [calamares-zfs-integration](https://github.com/wlfogle/calamares-zfs-integration)  
- [garuda-media-stack](https://github.com/wlfogle/garuda-media-stack)

When contributing, please ensure changes maintain compatibility with all three integrated systems.

## 📄 License

This project combines multiple upstream licenses. See individual component directories for specific license information.

---

**Ultimate Garuda Powerhouse** - *One repository, complete Linux distribution solution* 🚀