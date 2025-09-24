#!/bin/bash
# Ultimate Garuda Powerhouse - Unified System Installer
# Installs system components including ZFS, Calamares, and media stack

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Installation components
INSTALL_ZFS="${INSTALL_ZFS:-true}"
INSTALL_CALAMARES="${INSTALL_CALAMARES:-true}"
INSTALL_MEDIA_STACK="${INSTALL_MEDIA_STACK:-true}"
INSTALL_AI_ML="${INSTALL_AI_ML:-false}"
MEDIA_STACK_TYPE="${MEDIA_STACK_TYPE:-native}"  # native, universal, or basic

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Install Ultimate Garuda Powerhouse system components

OPTIONS:
    --zfs                   Install ZFS support (default: true)
    --no-zfs                Skip ZFS installation
    --calamares             Install Calamares with ZFS integration (default: true)
    --no-calamares          Skip Calamares installation
    --media-stack TYPE      Install media stack: native, universal, basic, or none (default: native)
    --ai-ml                 Install AI/ML components (default: false)
    -h, --help             Show this help message

EXAMPLES:
    # Full installation
    $0

    # Install only media stack (basic)
    $0 --no-zfs --no-calamares --media-stack basic

    # Install everything including AI/ML
    $0 --ai-ml

    # Minimal installation (no media stack)
    $0 --media-stack none
EOF
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root"
        error "Please run with sudo: sudo $0"
        exit 1
    fi
}

install_zfs() {
    if [[ "$INSTALL_ZFS" != "true" ]]; then
        log "Skipping ZFS installation"
        return 0
    fi

    log "Installing ZFS support..."
    
    local zfs_script="$PROJECT_ROOT/installer/zfs/zfs-installation.sh"
    
    if [[ ! -f "$zfs_script" ]]; then
        error "ZFS installation script not found: $zfs_script"
        return 1
    fi
    
    cd "$(dirname "$zfs_script")"
    bash "$(basename "$zfs_script")"
    
    success "ZFS installation completed"
}

install_calamares() {
    if [[ "$INSTALL_CALAMARES" != "true" ]]; then
        log "Skipping Calamares installation"
        return 0
    fi

    log "Installing Calamares with ZFS integration..."
    
    local build_script="$PROJECT_ROOT/installer/calamares/build-complete.sh"
    
    if [[ ! -f "$build_script" ]]; then
        error "Calamares build script not found: $build_script"
        return 1
    fi
    
    cd "$(dirname "$build_script")"
    bash "$(basename "$build_script")"
    
    success "Calamares installation completed"
}

install_media_stack() {
    if [[ "$MEDIA_STACK_TYPE" == "none" ]]; then
        log "Skipping media stack installation"
        return 0
    fi

    log "Installing media stack (type: $MEDIA_STACK_TYPE)..."
    
    local scripts_dir="$PROJECT_ROOT/media-stack/scripts"
    
    if [[ ! -d "$scripts_dir" ]]; then
        error "Media stack scripts directory not found: $scripts_dir"
        return 1
    fi
    
    cd "$scripts_dir"
    
    case "$MEDIA_STACK_TYPE" in
        "native")
            if [[ -f "install-native-media-stack.sh" ]]; then
                bash install-native-media-stack.sh
            else
                error "Native media stack installer not found"
                return 1
            fi
            ;;
        "universal")
            if [[ -f "universal-media-stack.sh" ]]; then
                bash universal-media-stack.sh
            else
                error "Universal media stack installer not found"
                return 1
            fi
            ;;
        "basic")
            if [[ -f "install-media-stack.sh" ]]; then
                bash install-media-stack.sh
            else
                error "Basic media stack installer not found"
                return 1
            fi
            ;;
        *)
            error "Unknown media stack type: $MEDIA_STACK_TYPE"
            return 1
            ;;
    esac
    
    success "Media stack installation completed"
}

install_ai_ml() {
    if [[ "$INSTALL_AI_ML" != "true" ]]; then
        log "Skipping AI/ML installation"
        return 0
    fi

    log "Installing AI/ML components..."
    
    local ai_script="$PROJECT_ROOT/ai-ml/ollama-integration.sh"
    
    if [[ ! -f "$ai_script" ]]; then
        warn "AI/ML integration script not found: $ai_script"
        return 0
    fi
    
    cd "$(dirname "$ai_script")"
    bash "$(basename "$ai_script")"
    
    success "AI/ML installation completed"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --zfs)
            INSTALL_ZFS="true"
            shift
            ;;
        --no-zfs)
            INSTALL_ZFS="false"
            shift
            ;;
        --calamares)
            INSTALL_CALAMARES="true"
            shift
            ;;
        --no-calamares)
            INSTALL_CALAMARES="false"
            shift
            ;;
        --media-stack)
            MEDIA_STACK_TYPE="$2"
            shift 2
            ;;
        --ai-ml)
            INSTALL_AI_ML="true"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validate media stack type
case "$MEDIA_STACK_TYPE" in
    "native"|"universal"|"basic"|"none")
        ;;
    *)
        error "Invalid media stack type: $MEDIA_STACK_TYPE"
        error "Valid types: native, universal, basic, none"
        exit 1
        ;;
esac

# Main execution
log "Starting Ultimate Garuda Powerhouse system installation"
log "Components to install:"
log "  - ZFS: $INSTALL_ZFS"
log "  - Calamares: $INSTALL_CALAMARES" 
log "  - Media Stack: $MEDIA_STACK_TYPE"
log "  - AI/ML: $INSTALL_AI_ML"

check_root

# Install components in order
install_zfs
install_calamares
install_media_stack
install_ai_ml

success "System installation completed successfully!"
log "Please check the logs above for any warnings or additional configuration steps."