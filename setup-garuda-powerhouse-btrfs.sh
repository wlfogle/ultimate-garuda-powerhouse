#!/bin/bash
# 🚀 Ultimate Garuda Powerhouse Setup Script - Btrfs Optimized
# Installs Media Stack, AI/ML Tools, and Virtualization with Btrfs optimizations
# Designed for Garuda Linux with Btrfs filesystem

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
BTRFS_ROOT="/dev/nvme0n1p2"  # Main Btrfs partition
BTRFS_MOUNT="/"

# Find project root from your repositories
PROJECT_ROOT_CANDIDATES=(
    "/home/lou/Github_Repos/github/ultimate-garuda-powerhouse"
    "/home/lou/Github_Repos/ultimate-garuda-powerhouse" 
    "/home/lou/ultimate-garuda-powerhouse"
    "/home/lou/repos/ultimate-garuda-powerhouse"
    "$HOME/ultimate-garuda-powerhouse"
)

PROJECT_ROOT=""
for candidate in "${PROJECT_ROOT_CANDIDATES[@]}"; do
    if [[ -d "$candidate" ]]; then
        PROJECT_ROOT="$candidate"
        break
    fi
done

# If no project found, use a default location
if [[ -z "$PROJECT_ROOT" ]]; then
    PROJECT_ROOT="$HOME/ultimate-garuda-powerhouse-btrfs"
    mkdir -p "$PROJECT_ROOT"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }

print_banner() {
    echo -e "${PURPLE}"
    echo "🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
    echo "🚀                                               🚀"
    echo "🚀      ULTIMATE GARUDA POWERHOUSE - BTRFS       🚀"
    echo "🚀       Complete Self-Hosting & Media Stack     🚀"
    echo "🚀                                               🚀"
    echo "🚀  📦 Media Services   🤖 AI/ML Tools           🚀"
    echo "🚀  💾 Btrfs Snapshots  🖥️  Virtualization       🚀"
    echo "🚀  🌐 Web Dashboards   🛡️  Digital Fortress     🚀"
    echo "🚀                                               🚀"
    echo "🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
    echo -e "${NC}"
}

check_user() {
    if [[ $EUID -eq 0 ]]; then
        error "Do not run this script as root! Run as your regular user with sudo privileges."
        exit 1
    fi
}

check_existing_systems() {
    log "Checking existing systems and integrations..."
    
    # Check Digital Fortress
    if command -v digital-fortress >/dev/null 2>&1; then
        success "Digital Fortress detected - VPN integration available"
        info "Current Digital Fortress status:"
        digital-fortress status 2>/dev/null | head -5
    else
        warn "Digital Fortress not found - VPN features will be limited"
        info "Install Digital Fortress first for complete privacy protection"
    fi
    
    # Check WireGuard
    if systemctl is-active --quiet wg-quick@wg0 2>/dev/null; then
        success "WireGuard VPN is active"
        info "VPN Interface: $(ip link show | grep -E 'wg[0-9]+' | head -1 | awk -F': ' '{print $2}' || echo 'None')"
    else
        info "WireGuard VPN not currently active"
    fi
    
    # Check system tray widget
    if pgrep -f "wireguard-tray-widget" >/dev/null; then
        success "Digital Fortress system tray widget is running"
    else
        info "System tray widget not running (will be started automatically)"
    fi
}

check_btrfs() {
    log "Checking Btrfs filesystem..."
    
    if ! command -v btrfs >/dev/null 2>&1; then
        error "Btrfs tools not found. Installing btrfs-progs..."
        sudo pacman -S --needed --noconfirm btrfs-progs
    fi
    
    # Check if main filesystem is Btrfs
    if ! mount | grep -q "type btrfs"; then
        error "Btrfs filesystem not detected. This script is optimized for Btrfs."
        exit 1
    fi
    
    success "Btrfs filesystem detected and ready"
    
    # Show current Btrfs subvolumes
    info "Current Btrfs subvolumes:"
    sudo btrfs subvolume list / | head -10
}

optimize_btrfs() {
    log "Optimizing Btrfs for media and container workloads..."
    
    # Create media subvolumes for better management
    sudo mkdir -p /media/{downloads,movies,tv,music,books}
    
    # Create container data subvolumes
    sudo mkdir -p /var/lib/{docker,containers,media-stack}
    
    # Set Btrfs mount options for performance
    info "Current mount options:"
    mount | grep btrfs | head -3
    
    # Enable compression for media directories (compress=zstd:1 for better performance)
    info "Setting up Btrfs compression for media directories..."
    sudo btrfs property set /media compression zstd:1 2>/dev/null || warn "Compression setting may require remount"
    
    # Create snapshot directory structure
    sudo mkdir -p /snapshots/{media-stack,containers,system}
    
    success "Btrfs optimizations applied"
}

create_btrfs_snapshots() {
    log "Creating pre-installation Btrfs snapshots..."
    
    # Create system snapshot before major changes
    local snapshot_name="pre-powerhouse-$(date +%Y%m%d_%H%M%S)"
    
    if sudo btrfs subvolume snapshot / "/snapshots/system/$snapshot_name" 2>/dev/null; then
        success "System snapshot created: $snapshot_name"
        echo "$snapshot_name" > "/tmp/garuda-powerhouse-snapshot"
    else
        warn "Could not create system snapshot (may not be supported)"
    fi
    
    # Create media directories snapshot point for future use
    sudo mkdir -p "/snapshots/media-stack"
    
    info "Snapshots ready for rollback if needed"
}

install_base_packages() {
    log "Installing base packages for Garuda media powerhouse..."
    
    # Update system first
    sudo pacman -Syu --noconfirm
    
    # Core media stack packages optimized for Btrfs
    # Note: WireGuard and VPN tools already installed via Digital Fortress
    sudo pacman -S --needed --noconfirm \
        jellyfin-server \
        jellyfin-web \
        qbittorrent-nox \
        docker \
        docker-compose \
        podman \
        buildah \
        python-pip \
        python-docker \
        git \
        curl \
        wget \
        unzip \
        nginx \
        redis \
        postgresql \
        mariadb \
        btrfs-progs \
        compsize \
        snapper
    
    # Install media tools
    sudo pacman -S --needed --noconfirm \
        ffmpeg \
        yt-dlp \
        mediainfo \
        imagemagick \
        ghostscript
        
    # Install development tools
    sudo pacman -S --needed --noconfirm \
        nodejs \
        npm \
        python-virtualenv \
        python-pipenv \
        rustup \
        go
    
    # Enable services
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo systemctl enable redis
    sudo systemctl enable postgresql
    
    # Add user to groups  
    sudo usermod -aG docker $USER
    sudo usermod -aG wheel $USER
    
    # Verify Digital Fortress is available
    if command -v digital-fortress >/dev/null 2>&1; then
        success "Digital Fortress integration available"
    else
        warn "Digital Fortress not found - VPN features may be limited"
    fi
    
    success "Base packages installed successfully"
}

setup_docker_btrfs() {
    log "Optimizing Docker for Btrfs filesystem..."
    
    # Create Docker daemon configuration for Btrfs
    sudo mkdir -p /etc/docker
    
    cat << 'EOF' | sudo tee /etc/docker/daemon.json
{
    "storage-driver": "btrfs",
    "storage-opts": [
        "btrfs.min_space=1G"
    ],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "data-root": "/var/lib/docker",
    "exec-opts": ["native.cgroupdriver=systemd"],
    "live-restore": true,
    "userland-proxy": false,
    "experimental": false,
    "features": {
        "buildkit": true
    }
}
EOF
    
    # Restart Docker with new configuration
    sudo systemctl restart docker
    
    # Verify Docker is using Btrfs
    if docker info | grep -q "Storage Driver: btrfs"; then
        success "Docker configured to use Btrfs storage driver"
    else
        warn "Docker may not be using Btrfs storage driver"
    fi
}

configure_vpn_media_integration() {
    log "Configuring media stack for VPN integration..."
    
    # Create VPN-aware Docker network
    if docker network ls | grep -q vpn-media; then
        info "VPN media network already exists"
    else
        docker network create --driver bridge vpn-media || warn "Could not create VPN media network"
    fi
    
    # Configure routing for media services through VPN when needed
    if command -v digital-fortress >/dev/null 2>&1; then
        info "Setting up media services to work with Digital Fortress"
        # Create a script to ensure media services can work with VPN
        cat << 'EOF' > "$HOME/media-stack/scripts/vpn-media-helper.sh"
#!/bin/bash
# Helper script to ensure media services work properly with VPN

# Check if VPN is active and adjust container networking accordingly
if systemctl is-active --quiet wg-quick@wg0; then
    echo "VPN active - using VPN-aware configuration"
    export DOCKER_NETWORK="vpn-media"
else
    echo "VPN inactive - using bridge networking"
    export DOCKER_NETWORK="bridge"
fi

# Export variables for docker-compose
export VPN_ACTIVE=$(systemctl is-active --quiet wg-quick@wg0 && echo "true" || echo "false")
EOF
        chmod +x "$HOME/media-stack/scripts/vpn-media-helper.sh"
    fi
    
    success "VPN-media integration configured"
}

install_media_stack() {
    log "Installing comprehensive media stack..."
    
    # Configure VPN integration first
    configure_vpn_media_integration
    
    # Create media stack directory structure
    mkdir -p "$HOME/media-stack"/{config,data,compose,scripts}
    
    # Create Docker Compose file for media stack
    cat << 'EOF' > "$HOME/media-stack/compose/media-stack.yml"
version: '3.8'

services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    user: 1000:1000
    network_mode: host
    volumes:
      - /home/lou/media-stack/config/jellyfin:/config
      - /home/lou/media-stack/data/cache:/cache
      - /media:/media:ro
    restart: unless-stopped
    environment:
      - JELLYFIN_PublishedServerUrl=http://localhost:8096
    
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
      - WEBUI_PORT=8080
    volumes:
      - /home/lou/media-stack/config/qbittorrent:/config
      - /media/downloads:/downloads
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
    
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - /home/lou/media-stack/config/sonarr:/config
      - /media/tv:/tv
      - /media/downloads:/downloads
    ports:
      - 8989:8989
    restart: unless-stopped
    
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - /home/lou/media-stack/config/radarr:/config
      - /media/movies:/movies
      - /media/downloads:/downloads
    ports:
      - 7878:7878
    restart: unless-stopped
    
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - /home/lou/media-stack/config/prowlarr:/config
    ports:
      - 9696:9696
    restart: unless-stopped
    
  bazarr:
    image: lscr.io/linuxserver/bazarr:latest
    container_name: bazarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - /home/lou/media-stack/config/bazarr:/config
      - /media/movies:/movies
      - /media/tv:/tv
    ports:
      - 6767:6767
    restart: unless-stopped
EOF
    
    success "Media stack Docker Compose created"
}

install_ai_ml_stack() {
    log "Installing AI/ML stack with Ollama..."
    
    # Install Ollama
    curl -fsSL https://ollama.ai/install.sh | sh
    
    # Start Ollama service
    sudo systemctl enable ollama
    sudo systemctl start ollama
    
    # Create AI/ML workspace
    mkdir -p "$HOME/ai-ml"/{models,projects,notebooks}
    
    # Install Python AI/ML packages
    pip3 install --user \
        ollama \
        openai \
        langchain \
        jupyter \
        numpy \
        pandas \
        scikit-learn \
        tensorflow \
        torch \
        transformers
    
    # Create Ollama Docker Compose for GUI management
    cat << 'EOF' > "$HOME/ai-ml/ollama-webui.yml"
version: '3.8'

services:
  ollama-webui:
    image: ghcr.io/ollama-webui/ollama-webui:main
    container_name: ollama-webui
    ports:
      - "3000:8080"
    environment:
      - OLLAMA_API_BASE_URL=http://host.docker.internal:11434/api
    volumes:
      - /home/lou/ai-ml/webui:/app/backend/data
    restart: unless-stopped
    extra_hosts:
      - "host.docker.internal:host-gateway"
EOF
    
    success "AI/ML stack with Ollama installed"
}

install_virtualization() {
    log "Installing virtualization tools..."
    
    # Install QEMU and virtualization packages
    sudo pacman -S --needed --noconfirm \
        qemu-full \
        virt-manager \
        libvirt \
        bridge-utils \
        dnsmasq \
        openbsd-netcat \
        ebtables \
        iptables \
        libguestfs
    
    # Enable and start libvirt
    sudo systemctl enable libvirtd
    sudo systemctl start libvirtd
    
    # Add user to libvirt group
    sudo usermod -aG libvirt $USER
    sudo usermod -aG kvm $USER
    
    # Configure libvirt for user access
    echo 'unix_sock_group = "libvirt"' | sudo tee -a /etc/libvirt/libvirtd.conf
    echo 'unix_sock_ro_perms = "0777"' | sudo tee -a /etc/libvirt/libvirtd.conf
    echo 'unix_sock_rw_perms = "0770"' | sudo tee -a /etc/libvirt/libvirtd.conf
    
    success "Virtualization tools installed successfully"
}

setup_monitoring() {
    log "Setting up system monitoring..."
    
    # Install monitoring tools
    sudo pacman -S --needed --noconfirm \
        htop \
        btop \
        iotop \
        nethogs \
        ncdu \
        lm_sensors
    
    # Create monitoring compose file
    cat << 'EOF' > "$HOME/media-stack/compose/monitoring.yml"
version: '3.8'

services:
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3001:3000"
    volumes:
      - /home/lou/media-stack/config/grafana:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    restart: unless-stopped
    
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - /home/lou/media-stack/config/prometheus:/etc/prometheus
    restart: unless-stopped
    
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    restart: unless-stopped
EOF
    
    success "Monitoring stack configured"
}

setup_web_dashboard() {
    log "Setting up web dashboard..."
    
    # Create dashboard directory
    mkdir -p "$HOME/media-stack/dashboard"
    
    # Create main dashboard HTML
    cat << 'EOF' > "$HOME/media-stack/dashboard/index.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🚀 Garuda Powerhouse Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff; min-height: 100vh; padding: 20px;
        }
        .container { max-width: 1200px; margin: 0 auto; }
        h1 { text-align: center; margin-bottom: 30px; font-size: 2.5rem; }
        .grid { 
            display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px; margin-bottom: 30px;
        }
        .card {
            background: rgba(255,255,255,0.1); border-radius: 15px; padding: 25px;
            backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.2);
            transition: transform 0.3s ease;
        }
        .card:hover { transform: translateY(-5px); }
        .card h3 { margin-bottom: 15px; color: #fff; }
        .service-link {
            display: block; color: #fff; text-decoration: none; padding: 10px;
            background: rgba(255,255,255,0.1); border-radius: 8px; margin: 5px 0;
            transition: background 0.3s ease;
        }
        .service-link:hover { background: rgba(255,255,255,0.2); }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Garuda Powerhouse Dashboard</h1>
        
        <div class="grid">
            <div class="card">
                <h3>📺 Media Services</h3>
                <a href="http://localhost:8096" class="service-link" target="_blank">🎬 Jellyfin Media Server</a>
                <a href="http://localhost:8080" class="service-link" target="_blank">📥 qBittorrent</a>
                <a href="http://localhost:8989" class="service-link" target="_blank">📺 Sonarr (TV Shows)</a>
                <a href="http://localhost:7878" class="service-link" target="_blank">🎬 Radarr (Movies)</a>
                <a href="http://localhost:9696" class="service-link" target="_blank">🔍 Prowlarr (Indexers)</a>
                <a href="http://localhost:6767" class="service-link" target="_blank">💬 Bazarr (Subtitles)</a>
            </div>
            
            <div class="card">
                <h3>🤖 AI/ML Services</h3>
                <a href="http://localhost:11434" class="service-link" target="_blank">🧠 Ollama API</a>
                <a href="http://localhost:3000" class="service-link" target="_blank">💬 Ollama WebUI</a>
                <a href="http://localhost:8888" class="service-link" target="_blank">📊 Jupyter Notebooks</a>
            </div>
            
            <div class="card">
                <h3>📊 Monitoring</h3>
                <a href="http://localhost:3001" class="service-link" target="_blank">📈 Grafana</a>
                <a href="http://localhost:9090" class="service-link" target="_blank">📊 Prometheus</a>
                <a href="http://localhost:9100/metrics" class="service-link" target="_blank">🖥️ Node Exporter</a>
            </div>
            
            <div class="card">
                <h3>🏰 Digital Fortress</h3>
                <a href="javascript:void(0)" onclick="checkDigitalFortress()" class="service-link">🛡️ VPN Status</a>
                <a href="javascript:void(0)" onclick="toggleDigitalFortress()" class="service-link">🏰 Toggle Fortress</a>
                <a href="https://browserleaks.com" class="service-link" target="_blank">🔍 Test Anonymity</a>
            </div>
        </div>
        
        <div class="card">
            <h3>💾 Btrfs Filesystem Status</h3>
            <div id="btrfs-info">Loading filesystem information...</div>
        </div>
    </div>

    <script>
        function checkDigitalFortress() {
            alert('Check system tray for Digital Fortress status or run: digital-fortress status');
        }
        
        function toggleDigitalFortress() {
            alert('Use system tray widget or run: digital-fortress toggle');
        }
        
        // Load Btrfs info (would require backend API in real implementation)
        document.getElementById('btrfs-info').innerHTML = 'Use: <code>btrfs fi show</code> and <code>btrfs fi df /</code> in terminal';
    </script>
</body>
</html>
EOF
    
    # Create simple nginx config for dashboard
    cat << 'EOF' > "$HOME/media-stack/dashboard/nginx.conf"
server {
    listen 8600;
    server_name localhost;
    root /home/lou/media-stack/dashboard;
    index index.html;
    
    location / {
        try_files $uri $uri/ =404;
    }
}
EOF
    
    success "Web dashboard created at http://localhost:8600"
}

create_management_scripts() {
    log "Creating management scripts..."
    
    # Create start script with Digital Fortress integration
    cat << 'EOF' > "$HOME/media-stack/scripts/start-all.sh"
#!/bin/bash
echo "🚀 Starting Garuda Powerhouse services..."

# Check if Digital Fortress is available and activate it
if command -v digital-fortress >/dev/null 2>&1; then
    echo "🏰 Activating Digital Fortress protection..."
    digital-fortress activate
else
    echo "⚠️  Digital Fortress not available - starting without VPN protection"
fi

# Wait a moment for VPN to establish
sleep 2

# Start media stack
echo "📺 Starting media services..."
cd /home/lou/media-stack/compose
docker-compose -f media-stack.yml up -d

# Start AI/ML services  
echo "🤖 Starting AI/ML services..."
cd /home/lou/ai-ml
docker-compose -f ollama-webui.yml up -d

# Start monitoring
echo "📊 Starting monitoring services..."
cd /home/lou/media-stack/compose
docker-compose -f monitoring.yml up -d

# Start dashboard nginx (check if already running)
echo "🌐 Starting dashboard..."
if ! pgrep -f "nginx.*8600" >/dev/null; then
    sudo nginx -c /home/lou/media-stack/dashboard/nginx.conf
fi

echo "✅ All services started!"
echo "📊 Main Dashboard: http://localhost:8600"
echo "🎬 Jellyfin: http://localhost:8096"
echo "🏰 Digital Fortress: Check system tray"
EOF
    
    # Create stop script
    cat << 'EOF' > "$HOME/media-stack/scripts/stop-all.sh"
#!/bin/bash
echo "🛑 Stopping Garuda Powerhouse services..."

# Stop containers
docker stop $(docker ps -q) 2>/dev/null || true

# Stop nginx
sudo pkill -f nginx || true

echo "✅ All services stopped!"
EOF
    
    # Create status script with Digital Fortress integration
    cat << 'EOF' > "$HOME/media-stack/scripts/status.sh"
#!/bin/bash
echo "📊 Garuda Powerhouse Status"
echo "=========================="
echo

# Digital Fortress status
if command -v digital-fortress >/dev/null 2>&1; then
    echo "🏰 Digital Fortress Status:"
    digital-fortress status 2>/dev/null || echo "   ⚠️  Digital Fortress not responding"
else
    echo "🏰 Digital Fortress: Not installed"
fi

echo
echo "🐳 Docker Containers:"
if command -v docker >/dev/null 2>&1 && docker ps >/dev/null 2>&1; then
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
    echo "   Docker not available or not running"
fi

echo
echo "💾 Btrfs Filesystem:"
df -h / | grep btrfs 2>/dev/null || echo "   Btrfs info not available"
if command -v btrfs >/dev/null 2>&1; then
    echo "   Filesystem usage:"
    btrfs fi usage / 2>/dev/null | head -5
fi

echo
echo "🌐 Network Status:"
echo "   External IP: $(curl -s --max-time 3 ifconfig.me 2>/dev/null || echo 'Unknown')"
echo "   VPN Interface: $(ip link show | grep -E 'wg[0-9]+' | head -1 | awk -F': ' '{print $2}' || echo 'None')"

echo
echo "🖥️ System Resources:"
free -h
uptime

echo
echo "📱 Service URLs:"
echo "   🎬 Jellyfin: http://localhost:8096"
echo "   📥 qBittorrent: http://localhost:8080" 
echo "   🤖 Ollama WebUI: http://localhost:3000"
echo "   📈 Grafana: http://localhost:3001"
echo "   📊 Dashboard: http://localhost:8600"
EOF
    
    chmod +x "$HOME/media-stack/scripts/"*.sh
    
    success "Management scripts created"
}

finalize_installation() {
    log "Finalizing installation..."
    
    # Create post-installation snapshot
    if [[ -f "/tmp/garuda-powerhouse-snapshot" ]]; then
        local snapshot_name="post-powerhouse-$(date +%Y%m%d_%H%M%S)"
        if sudo btrfs subvolume snapshot / "/snapshots/system/$snapshot_name" 2>/dev/null; then
            success "Post-installation snapshot created: $snapshot_name"
        fi
    fi
    
    # Set up systemd user services for auto-start
    mkdir -p ~/.config/systemd/user
    
    # Create user service for media stack
    cat << 'EOF' > ~/.config/systemd/user/garuda-powerhouse.service
[Unit]
Description=Garuda Powerhouse Media Stack
After=docker.service

[Service]
Type=oneshot
ExecStart=/home/lou/media-stack/scripts/start-all.sh
RemainAfterExit=yes
ExecStop=/home/lou/media-stack/scripts/stop-all.sh

[Install]
WantedBy=default.target
EOF
    
    systemctl --user daemon-reload
    systemctl --user enable garuda-powerhouse
    
    success "Installation completed successfully!"
}

print_completion_summary() {
    echo
    success "🚀 GARUDA POWERHOUSE BTRFS INSTALLATION COMPLETE!"
    echo
    info "📊 Services Available:"
    echo "  • 🎬 Jellyfin Media Server: http://localhost:8096"
    echo "  • 📥 qBittorrent: http://localhost:8080"
    echo "  • 🤖 Ollama WebUI: http://localhost:3000"
    echo "  • 📈 Grafana: http://localhost:3001"
    echo "  • 🏰 Digital Fortress: System tray widget"
    echo "  • 📊 Main Dashboard: http://localhost:8600"
    echo
    info "🛠️  Management Commands:"
    echo "  • Start all: ~/media-stack/scripts/start-all.sh"
    echo "  • Stop all: ~/media-stack/scripts/stop-all.sh" 
    echo "  • Status: ~/media-stack/scripts/status.sh"
    echo "  • Digital Fortress: digital-fortress help"
    echo
    info "💾 Btrfs Features:"
    echo "  • Snapshots: /snapshots/system/"
    echo "  • Compression: Enabled for /media"
    echo "  • Docker: Optimized for Btrfs"
    echo
    warn "⚠️  Please log out and back in to apply group membership changes"
    warn "⚠️  Some services may need manual configuration on first run"
    echo
    success "🎉 Your Garuda Powerhouse is ready to use!"
    echo
    info "🏰 Digital Fortress Integration:"
    if command -v digital-fortress >/dev/null 2>&1; then
        echo "   ✅ Digital Fortress is integrated and ready"
        echo "   ✅ VPN protection will be activated automatically"
        echo "   ✅ System tray widget available for quick control"
        echo "   ✅ Use 'digital-fortress help' for more options"
    else
        echo "   ⚠️  Digital Fortress not found"
        echo "   ⚠️  Install Digital Fortress for VPN protection"
        echo "   ⚠️  Run: /home/lou/scripts/digital-fortress.sh setup"
    fi
}

# Main execution
main() {
    print_banner
    check_user
    check_existing_systems
    check_btrfs
    optimize_btrfs
    create_btrfs_snapshots
    install_base_packages
    setup_docker_btrfs
    install_media_stack
    install_ai_ml_stack
    install_virtualization
    setup_monitoring
    setup_web_dashboard
    create_management_scripts
    finalize_installation
    print_completion_summary
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi