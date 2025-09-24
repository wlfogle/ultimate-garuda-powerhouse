#!/bin/bash
# Ultimate Garuda Powerhouse - Complete Setup Script
# Builds ISO and installs system components in one go

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Default options
BUILD_ISO="${BUILD_ISO:-true}"
ISO_PROFILE="${ISO_PROFILE:-archiso}"
INSTALL_SYSTEM="${INSTALL_SYSTEM:-true}"
MEDIA_STACK_TYPE="${MEDIA_STACK_TYPE:-native}"
INSTALL_AI_ML="${INSTALL_AI_ML:-false}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

header() {
    echo -e "${PURPLE}=== $1 ===${NC}"
}

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Complete Ultimate Garuda Powerhouse setup - builds ISO and installs system

OPTIONS:
    --build-iso             Build ISO (default: true)
    --no-build-iso          Skip ISO building
    --iso-profile TYPE      ISO profile: archiso or garuda (default: archiso)
    --install-system        Install system components (default: true)
    --no-install-system     Skip system installation
    --media-stack TYPE      Media stack type: native, universal, basic, none (default: native)
    --ai-ml                 Include AI/ML components (default: false)
    -h, --help             Show this help message

EXAMPLES:
    # Complete setup with ArchISO and native media stack
    $0

    # Build Garuda ISO only
    $0 --iso-profile garuda --no-install-system

    # Install system only (no ISO build)
    $0 --no-build-iso --media-stack universal

    # Everything including AI/ML
    $0 --ai-ml
EOF
}

show_banner() {
    echo -e "${PURPLE}"
    cat << 'EOF'
    ╦ ╦╦ ╔╦╗╦╔╦╗╔═╗╔╦╗╔═╗  ╔═╗╔═╗╦═╗╦ ╦╔╦╗╔═╗
    ║ ║║  ║ ║║║║╠═╣ ║ ║╣   ║ ╦╠═╣╠╦╝║ ║ ║║╠═╣
    ╚═╝╩═╝╩ ╩╩ ╩╩ ╩ ╩ ╚═╝  ╚═╝╩ ╩╩╚═╚═╝═╩╝╩ ╩
    ╔═╗╔═╗╦ ╦╔═╗╦═╗╦ ╦╔═╗╦ ╦╔═╗╔═╗
    ╠═╝║ ║║║║║╣ ╠╦╝╠═╣║ ║║ ║╚═╗║╣ 
    ╩  ╚═╝╚╩╝╚═╝╩╚═╩ ╩╚═╝╚═╝╚═╝╚═╝

    Complete AI-Powered Linux Distribution
    ISO Builder + System Installer + Media Stack
EOF
    echo -e "${NC}"
    echo
}

check_prerequisites() {
    header "Checking Prerequisites"
    
    # Check if running as root when needed
    if [[ "$INSTALL_SYSTEM" == "true" ]] && [[ $EUID -ne 0 ]]; then
        error "System installation requires root privileges"
        error "Please run with sudo: sudo $0"
        exit 1
    fi
    
    # Check for required tools
    local required_tools=("git" "bash")
    local missing_tools=()
    
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        error "Missing required tools: ${missing_tools[*]}"
        exit 1
    fi
    
    success "Prerequisites check passed"
}

build_iso_step() {
    if [[ "$BUILD_ISO" != "true" ]]; then
        log "Skipping ISO build"
        return 0
    fi

    header "Building ISO"
    
    local build_script="$SCRIPT_DIR/build-iso.sh"
    
    if [[ ! -f "$build_script" ]]; then
        error "ISO build script not found: $build_script"
        exit 1
    fi
    
    log "Executing ISO build with profile: $ISO_PROFILE"
    bash "$build_script" --profile "$ISO_PROFILE" --verbose
    
    success "ISO build completed"
}

install_system_step() {
    if [[ "$INSTALL_SYSTEM" != "true" ]]; then
        log "Skipping system installation"
        return 0
    fi

    header "Installing System Components"
    
    local install_script="$SCRIPT_DIR/install-system.sh"
    
    if [[ ! -f "$install_script" ]]; then
        error "System install script not found: $install_script"
        exit 1
    fi
    
    log "Executing system installation..."
    
    # Build install command with options
    local install_cmd=("$install_script")
    
    install_cmd+=("--media-stack" "$MEDIA_STACK_TYPE")
    
    if [[ "$INSTALL_AI_ML" == "true" ]]; then
        install_cmd+=("--ai-ml")
    fi
    
    "${install_cmd[@]}"
    
    success "System installation completed"
}

show_summary() {
    header "Setup Summary"
    
    echo -e "Configuration used:"
    echo -e "  ${BLUE}Build ISO:${NC} $BUILD_ISO"
    if [[ "$BUILD_ISO" == "true" ]]; then
        echo -e "  ${BLUE}ISO Profile:${NC} $ISO_PROFILE"
    fi
    echo -e "  ${BLUE}Install System:${NC} $INSTALL_SYSTEM"
    if [[ "$INSTALL_SYSTEM" == "true" ]]; then
        echo -e "  ${BLUE}Media Stack:${NC} $MEDIA_STACK_TYPE"
        echo -e "  ${BLUE}AI/ML Components:${NC} $INSTALL_AI_ML"
    fi
    echo
    
    success "Ultimate Garuda Powerhouse setup completed successfully!"
    
    if [[ "$BUILD_ISO" == "true" ]]; then
        log "ISO files can be found in: $PROJECT_ROOT/output/"
    fi
    
    if [[ "$INSTALL_SYSTEM" == "true" ]]; then
        log "System components have been installed and configured"
        log "Check the logs above for any additional configuration steps"
    fi
    
    echo
    log "Next steps:"
    if [[ "$BUILD_ISO" == "true" ]]; then
        log "  - Test the ISO using: make -C iso/virtualization run"
        log "  - Write to USB using: make -C iso/virtualization create-usb"
    fi
    if [[ "$INSTALL_SYSTEM" == "true" ]] && [[ "$MEDIA_STACK_TYPE" != "none" ]]; then
        log "  - Check media stack status: media-stack/scripts/ultimate-status.sh"
        log "  - Access services via their respective web interfaces"
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --build-iso)
            BUILD_ISO="true"
            shift
            ;;
        --no-build-iso)
            BUILD_ISO="false"
            shift
            ;;
        --iso-profile)
            ISO_PROFILE="$2"
            shift 2
            ;;
        --install-system)
            INSTALL_SYSTEM="true"
            shift
            ;;
        --no-install-system)
            INSTALL_SYSTEM="false"
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

# Validate options
if [[ "$ISO_PROFILE" != "archiso" && "$ISO_PROFILE" != "garuda" ]]; then
    error "Invalid ISO profile: $ISO_PROFILE. Must be 'archiso' or 'garuda'"
    exit 1
fi

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
show_banner

log "Starting Ultimate Garuda Powerhouse complete setup"

check_prerequisites
build_iso_step
install_system_step
show_summary