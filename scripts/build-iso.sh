#!/bin/bash
# Ultimate Garuda Powerhouse - Unified ISO Builder
# Combines functionality from ai-powerhouse-setup and garuda profiles

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Default values
PROFILE_TYPE="archiso"  # archiso or garuda
WORK_DIR="${WORK_DIR:-/tmp/archiso-tmp}"
OUTPUT_DIR="${OUTPUT_DIR:-$PROJECT_ROOT/output}"
VERBOSE="${VERBOSE:-false}"

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

Build Ultimate Garuda Powerhouse ISO

OPTIONS:
    -p, --profile TYPE      Profile type: archiso or garuda (default: archiso)
    -w, --work DIR          Working directory (default: /tmp/archiso-tmp)
    -o, --output DIR        Output directory (default: ./output)
    -v, --verbose           Enable verbose output
    -h, --help             Show this help message

EXAMPLES:
    # Build standard ArchISO profile
    $0

    # Build Garuda profile with custom paths
    $0 -p garuda -w /fast/tmp -o /fast/out

    # Verbose build
    $0 -v
EOF
}

check_dependencies() {
    local deps=("archiso" "git" "sudo")
    local missing=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing+=("$dep")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing dependencies: ${missing[*]}"
        error "Please install missing packages and try again"
        exit 1
    fi
}

build_archiso_profile() {
    log "Building ArchISO profile..."
    
    local profile_dir="$PROJECT_ROOT/iso/archiso-profile"
    
    if [[ ! -d "$profile_dir" ]]; then
        error "ArchISO profile directory not found: $profile_dir"
        exit 1
    fi
    
    # Clean previous builds
    [[ -d "$WORK_DIR" ]] && sudo rm -rf "$WORK_DIR"
    mkdir -p "$OUTPUT_DIR"
    
    log "Using profile: $profile_dir"
    log "Work directory: $WORK_DIR"
    log "Output directory: $OUTPUT_DIR"
    
    # Run mkarchiso
    if [[ "$VERBOSE" == "true" ]]; then
        sudo mkarchiso -v -w "$WORK_DIR" -o "$OUTPUT_DIR" "$profile_dir"
    else
        sudo mkarchiso -w "$WORK_DIR" -o "$OUTPUT_DIR" "$profile_dir"
    fi
    
    success "ArchISO build completed!"
}

build_garuda_profile() {
    log "Building Garuda profile..."
    
    local build_script="$PROJECT_ROOT/iso/garuda-profile/build-custom-iso.sh"
    
    if [[ ! -f "$build_script" ]]; then
        error "Garuda build script not found: $build_script"
        exit 1
    fi
    
    log "Executing Garuda build script..."
    cd "$PROJECT_ROOT/iso/garuda-profile"
    
    if [[ "$VERBOSE" == "true" ]]; then
        VERBOSE=1 sudo bash build-custom-iso.sh
    else
        sudo bash build-custom-iso.sh
    fi
    
    success "Garuda profile build completed!"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--profile)
            PROFILE_TYPE="$2"
            shift 2
            ;;
        -w|--work)
            WORK_DIR="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE="true"
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

# Validate profile type
if [[ "$PROFILE_TYPE" != "archiso" && "$PROFILE_TYPE" != "garuda" ]]; then
    error "Invalid profile type: $PROFILE_TYPE. Must be 'archiso' or 'garuda'"
    exit 1
fi

# Main execution
log "Starting Ultimate Garuda Powerhouse ISO build"
log "Profile type: $PROFILE_TYPE"

check_dependencies

case "$PROFILE_TYPE" in
    "archiso")
        build_archiso_profile
        ;;
    "garuda")
        build_garuda_profile
        ;;
esac

log "Build process completed successfully!"