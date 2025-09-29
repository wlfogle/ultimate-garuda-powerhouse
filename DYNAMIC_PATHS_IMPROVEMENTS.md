# Dynamic Paths Improvements

## 🔄 Overview

All hardcoded paths across the repositories have been replaced with dynamic, configurable alternatives. This makes the codebase portable, user-agnostic, and environment-flexible.

## 📋 Changes Made

### 🛠️ Core Changes

**Environment Variables**: All scripts now use environment variables with sensible defaults instead of hardcoded paths.

**User Detection**: Scripts automatically detect the current user using `${USER:-$(whoami)}` and `${HOME:-$(eval echo ~$USER_NAME)}`.

**Path Flexibility**: All key paths can be overridden via environment variables.

### 📁 Files Modified

#### 1. **Media Stack Installation Scripts**
- `ultimate-garuda-powerhouse/media-stack/scripts/install-media-stack.sh`
- `ai-powerhouse-setup/self-hosting/install-media-stack.sh`

**Dynamic Variables Added:**
```bash
USER_NAME="${USER:-$(whoami)}"
USER_HOME="${HOME:-$(eval echo ~$USER_NAME)}"
DATA_ROOT="${DATA_ROOT:-/media}"
CONFIG_ROOT="${CONFIG_ROOT:-$USER_HOME/.config}"
CACHE_ROOT="${CACHE_ROOT:-$USER_HOME/.cache}"
LOG_ROOT="${LOG_ROOT:-/var/log}"
INSTALL_ROOT="${INSTALL_ROOT:-/opt}"
```

#### 2. **Configuration Backup Script**
- `ultimate-garuda-powerhouse/media-stack/scripts/backup-all-configs.sh`

**Improvements:**
- Dynamic backup location: `BACKUP_ROOT="${BACKUP_ROOT:-/mnt/media/config}"`
- User-specific permissions using actual UID/GID instead of hardcoded `1000:1000`
- Configurable start script directory

#### 3. **Ghost Mode Control**
- `garuda-media-stack/ghost-control.sh`

**Enhancements:**
- Dynamic ghost directory: `GHOST_DIR="${GHOST_DIR:-$USER_HOME/garuda-media-stack}"`
- Automatic directory creation
- User-agnostic status file location

#### 4. **API Server**
- `ultimate-garuda-powerhouse/iso/archiso-profile/airootfs/etc/skel/ai-powerhouse-setup/self-hosting/api-server.py`

**Features:**
- Dynamic stack directory detection via `MEDIA_STACK_DIR` environment variable
- User home directory expansion using `os.path.expanduser('~')`
- Portable script path resolution

#### 5. **Container-based Stack**
- `ultimate-garuda-powerhouse/media-stack/scripts/universal-media-stack-nopriv.sh`

**Container Improvements:**
- Dynamic PUID/PGID using `$(id -u "$USER_NAME")` and `$(id -g "$USER_NAME")`
- Configurable data and config directories
- User-specific ownership

#### 6. **ISO Build Script**
- `ai-powerhouse-setup/installation/build-custom-iso.sh`

**Enhancements:**
- Dynamic setup source detection
- Configurable ISO output directory: `ISO_OUTPUT_DIR="${ISO_OUTPUT_DIR:-$DEFAULT_OUTPUT}"`

#### 7. **Ollama Code Checker**
- `ollama-code-checker/install.sh`

**Flexibility:**
- Configurable installation directory: `INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"`
- Dynamic PATH modification

## 🚀 Usage

### Environment Variable Configuration

Set any of these environment variables before running scripts to customize behavior:

```bash
# User Configuration
export USER_NAME="myuser"          # Override detected username
export USER_HOME="/home/myuser"    # Override home directory

# Media Stack Paths
export DATA_ROOT="/mnt/storage"    # Media files location
export CONFIG_ROOT="/opt/configs"  # Configuration directory
export BACKUP_ROOT="/backups"      # Backup location
export INSTALL_ROOT="/usr/local"   # Installation directory

# Container Configuration  
export DATA_DIR="/storage"         # Container data directory
export CONFIG_DIR="/configs"       # Container config directory

# Development Paths
export INSTALL_DIR="/usr/local/bin"  # Tool installation directory
export ISO_OUTPUT_DIR="/tmp/isos"    # ISO build output
```

### Multi-User Support

The scripts now work seamlessly for any user:

```bash
# As user 'john'
./install-media-stack.sh
# Creates: /home/john/.config/media-stack/

# As user 'alice' 
sudo -u alice ./install-media-stack.sh  
# Creates: /home/alice/.config/media-stack/

# With custom paths
DATA_ROOT="/mnt/shared" CONFIG_ROOT="/opt/configs" ./install-media-stack.sh
```

### Docker/Container Usage

Container scripts now use dynamic user IDs:

```bash
# Before: -e PUID=1000 -e PGID=1000
# After:  -e PUID=$(id -u "$USER_NAME") -e PGID=$(id -g "$USER_NAME")
```

## 🔧 Migration Guide

### For Existing Installations

1. **Check Current Paths**: Review your existing configuration locations
2. **Set Environment Variables**: Define any custom paths you want to maintain
3. **Re-run Scripts**: Execute updated scripts with your environment variables
4. **Verify Configuration**: Ensure services can access new paths

### Example Migration

```bash
# If you previously used /home/lou paths:
export DATA_ROOT="/media"
export CONFIG_ROOT="/home/$(whoami)/.config" 
export BACKUP_ROOT="/mnt/media/config"

# Re-run installation
./install-media-stack.sh

# Update existing services
./backup-all-configs.sh
```

## 🎯 Benefits

1. **Portability**: Scripts work on any Linux system with any user
2. **Flexibility**: All paths can be customized via environment variables
3. **Multi-User**: Multiple users can run the same scripts without conflicts
4. **Container-Ready**: Dynamic UID/GID for proper container permissions
5. **Maintainability**: No need to edit scripts for different environments

## 🧪 Testing

Test the dynamic paths with different users and configurations:

```bash
# Test with different user
sudo -u testuser bash -c 'export DATA_ROOT="/tmp/test-media" && ./install-media-stack.sh'

# Test with custom paths
DATA_ROOT="/custom/data" CONFIG_ROOT="/custom/config" ./install-media-stack.sh

# Test container permissions
USER_NAME="mediauser" ./universal-media-stack-nopriv.sh
```

## 📚 Best Practices

1. **Always use environment variables** for any paths in new scripts
2. **Provide sensible defaults** that work for most users
3. **Use `$(id -u)` and `$(id -g)`** for dynamic UID/GID in containers
4. **Test with multiple users** before deploying
5. **Document environment variables** in script headers

## 🔍 Verification Commands

Verify the changes work correctly:

```bash
# Check user detection
echo "Detected user: ${USER:-$(whoami)}"
echo "Home directory: ${HOME:-$(eval echo ~$(whoami))}"

# Check path resolution
DATA_ROOT="${DATA_ROOT:-/media}" 
echo "Data directory: $DATA_ROOT"

# Check UID/GID detection
echo "UID: $(id -u), GID: $(id -g)"
```

---

✅ **All hardcoded paths have been successfully replaced with dynamic alternatives!**

The codebase is now portable, user-agnostic, and ready for deployment in any environment.