#!/bin/bash

# COMPREHENSIVE CONFIG BACKUP SCRIPT
# Backs up ALL service configurations with dynamic paths
# Run this after any configuration changes!

# Dynamic path configuration
USER_NAME="${USER:-$(whoami)}"
USER_HOME="${HOME:-$(eval echo ~$USER_NAME)}"
BACKUP_ROOT="${BACKUP_ROOT:-/mnt/media/config}"
CONFIG_ROOT="${CONFIG_ROOT:-$USER_HOME/.config}"

echo "🔄 BACKING UP ALL CONFIGURATIONS TO $BACKUP_ROOT..."

# Create all config directories
sudo mkdir -p "$BACKUP_ROOT"/{radarr,sonarr,lidarr,readarr,jellyfin,jackett,qbittorrent,jellyseerr,calibre,pulsarr,audiobookshelf,bazarr,prowlarr,wireguard,ghost-mode}

# Backup *arr services
echo "📁 Backing up *arr services..."
sudo cp -r /var/lib/radarr/* "$BACKUP_ROOT"/radarr/ 2>/dev/null || echo "Radarr: using existing config"
sudo cp -r /var/lib/sonarr/* "$BACKUP_ROOT"/sonarr/ 2>/dev/null || echo "Sonarr: using existing config"
sudo cp -r /var/lib/lidarr/* "$BACKUP_ROOT"/lidarr/ 2>/dev/null || echo "Lidarr: using existing config"
sudo cp -r /var/lib/readarr/* "$BACKUP_ROOT"/readarr/ 2>/dev/null || echo "Readarr: using existing config"

# Backup Jellyfin
echo "🎬 Backing up Jellyfin..."
sudo cp -r /var/lib/jellyfin/* "$BACKUP_ROOT"/jellyfin/ 2>/dev/null || echo "Jellyfin: using existing config"

# Backup Jackett
echo "🔍 Backing up Jackett..."
sudo cp -r "$CONFIG_ROOT"/Jackett/* "$BACKUP_ROOT"/jackett/ 2>/dev/null || echo "Jackett: using existing config"

# Backup qBittorrent
echo "⬇️ Backing up qBittorrent..."
sudo cp -r "$CONFIG_ROOT"/qBittorrent/* "$BACKUP_ROOT"/qbittorrent/ 2>/dev/null || echo "qBittorrent: using existing config"

# Backup Jellyseerr
echo "🔍 Backing up Jellyseerr..."
sudo cp -r /root/.config/jellyseerr/* "$BACKUP_ROOT"/jellyseerr/ 2>/dev/null || echo "Jellyseerr: will create new config"
sudo cp -r "$CONFIG_ROOT"/jellyseerr/* "$BACKUP_ROOT"/jellyseerr/ 2>/dev/null || echo "Jellyseerr: user config not found"

# Backup Calibre
echo "📚 Backing up Calibre..."
sudo cp -r "$USER_HOME"/.calibre/* "$BACKUP_ROOT"/calibre/ 2>/dev/null || echo "Calibre: will create new config"

# Backup WireGuard
echo "🛡️ Backing up WireGuard..."
sudo cp -r /etc/wireguard/* "$BACKUP_ROOT"/wireguard/ 2>/dev/null || echo "WireGuard: will create new config"

# Backup Ghost Mode configs
echo "🥷 Backing up Ghost Mode..."
cp -r ghost-mode-* "$BACKUP_ROOT"/ghost-mode/ 2>/dev/null || echo "Ghost Mode: using existing config"

# Fix permissions
echo "🔐 Fixing permissions..."
# Use current user's UID:GID instead of hardcoded values
USER_UID=$(id -u "$USER_NAME")
USER_GID=$(id -g "$USER_NAME")
sudo chown -R "$USER_UID:$USER_GID" "$BACKUP_ROOT"/
sudo chmod -R 755 "$BACKUP_ROOT"/

# Create service startup script
START_SCRIPT_DIR="${START_SCRIPT_DIR:-$USER_HOME/github/garuda-media-stack}"
mkdir -p "$START_SCRIPT_DIR"
cat > "$START_SCRIPT_DIR"/start-with-configs.sh << 'EOF'
#!/bin/bash
# START ALL SERVICES WITH PERSISTENT CONFIGS
echo "🚀 Starting all services with persistent configs..."

# Start with config directories
/usr/bin/jellyfin --datadir /mnt/media/config/jellyfin --configdir /mnt/media/config/jellyfin &
/usr/lib/radarr/bin/Radarr -nobrowser -data=/mnt/media/config/radarr &
/usr/lib/sonarr/bin/Sonarr -nobrowser -data=/mnt/media/config/sonarr &
/usr/lib/lidarr/bin/Lidarr -nobrowser -data=/mnt/media/config/lidarr &
/usr/local/bin/Readarr -nobrowser -data=/mnt/media/config/readarr &
qbittorrent-nox --webui-port=5080 --profile=/mnt/media/config/qbittorrent &

echo "✅ All services started with persistent configs!"
EOF

chmod +x "$START_SCRIPT_DIR"/start-with-configs.sh

echo "✅ ALL CONFIGURATIONS BACKED UP TO $BACKUP_ROOT!"
echo "📁 Config directories created for all services"
echo "🔧 Use $START_SCRIPT_DIR/start-with-configs.sh to start with persistent configs"
echo "💾 Run this script after ANY configuration changes!"
