#!/bin/bash
# 🚀 Quick Launcher for Garuda Powerhouse with Digital Fortress
# This script starts everything in the right order

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log() { echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"; }
success() { echo -e "${GREEN}✅${NC} $1"; }
warn() { echo -e "${YELLOW}⚠️${NC} $1"; }
error() { echo -e "${RED}❌${NC} $1"; }

print_banner() {
    echo -e "${PURPLE}"
    echo "🚀🚀🚀 GARUDA POWERHOUSE LAUNCHER 🚀🚀🚀"
    echo -e "${NC}"
}

check_prerequisites() {
    log "Checking prerequisites..."
    
    local missing=()
    
    # Check Digital Fortress
    if ! command -v digital-fortress >/dev/null 2>&1; then
        missing+=("Digital Fortress")
    fi
    
    # Check Docker
    if ! command -v docker >/dev/null 2>&1; then
        missing+=("Docker")
    fi
    
    # Check media stack
    if [[ ! -d "$HOME/media-stack" ]]; then
        missing+=("Media Stack (run setup script first)")
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing prerequisites: ${missing[*]}"
        echo
        echo "To install everything, run:"
        echo "  /home/lou/scripts/setup-garuda-powerhouse-btrfs.sh"
        exit 1
    fi
    
    success "All prerequisites available"
}

start_services() {
    log "Starting Garuda Powerhouse services..."
    
    # 1. Start Digital Fortress first
    log "🏰 Starting Digital Fortress protection..."
    if digital-fortress activate; then
        success "Digital Fortress activated"
    else
        warn "Digital Fortress activation had issues - continuing anyway"
    fi
    
    # Wait for VPN to stabilize
    sleep 3
    
    # 2. Start media services
    if [[ -f "$HOME/media-stack/scripts/start-all.sh" ]]; then
        log "🎬 Starting media stack..."
        bash "$HOME/media-stack/scripts/start-all.sh"
    else
        warn "Media stack start script not found"
    fi
    
    success "All services started!"
}

show_status() {
    echo
    log "📊 Service Status:"
    
    # Digital Fortress
    echo -e "${BLUE}🏰 Digital Fortress:${NC}"
    if command -v digital-fortress >/dev/null 2>&1; then
        digital-fortress status | head -8
    else
        echo "   Not available"
    fi
    
    echo
    # Docker containers
    echo -e "${BLUE}🐳 Docker Containers:${NC}"
    if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -v "^NAMES" | head -10; then
        :
    else
        echo "   No containers running"
    fi
    
    echo
    echo -e "${BLUE}🌐 Service URLs:${NC}"
    echo "   📊 Main Dashboard: http://localhost:8600"
    echo "   🎬 Jellyfin: http://localhost:8096" 
    echo "   📥 qBittorrent: http://localhost:8080"
    echo "   🤖 Ollama: http://localhost:3000"
    echo "   📈 Grafana: http://localhost:3001"
}

stop_services() {
    log "Stopping all services..."
    
    # Stop containers
    if command -v docker >/dev/null 2>&1; then
        docker stop $(docker ps -q) 2>/dev/null || true
    fi
    
    # Stop nginx
    sudo pkill -f nginx 2>/dev/null || true
    
    # Deactivate Digital Fortress
    if command -v digital-fortress >/dev/null 2>&1; then
        digital-fortress deactivate 2>/dev/null || true
    fi
    
    success "All services stopped"
}

# Main function
main() {
    case "${1:-start}" in
        "start")
            print_banner
            check_prerequisites
            start_services
            show_status
            ;;
        "stop")
            print_banner
            stop_services
            ;;
        "status")
            print_banner
            show_status
            ;;
        "restart")
            print_banner
            stop_services
            sleep 2
            check_prerequisites
            start_services
            show_status
            ;;
        "help"|"-h"|"--help")
            print_banner
            echo "Usage: $0 [start|stop|status|restart|help]"
            echo
            echo "Commands:"
            echo "  start    - Start all services (default)"
            echo "  stop     - Stop all services"
            echo "  status   - Show status of all services"
            echo "  restart  - Stop and start all services"
            echo "  help     - Show this help message"
            echo
            echo "Services included:"
            echo "  🏰 Digital Fortress (VPN + anonymity)"
            echo "  🎬 Jellyfin Media Server"
            echo "  📥 qBittorrent"
            echo "  🤖 Ollama AI"
            echo "  📊 Monitoring stack"
            echo "  🌐 Web dashboard"
            ;;
        *)
            error "Unknown command: $1"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
}

main "$@"