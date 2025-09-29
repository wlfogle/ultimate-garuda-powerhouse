#!/bin/bash

# Ultimate Garuda Powerhouse System Optimization Script
# Optimizes performance, security, and functionality

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging setup
LOG_FILE="/tmp/system-optimization-$(date +%Y%m%d-%H%M%S).log"

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

# Check if running as root for system-level changes
check_root() {
    if [[ $EUID -eq 0 ]]; then
        warn "Running as root - system-level optimizations will be applied"
        return 0
    else
        warn "Not running as root - some optimizations will be skipped"
        return 1
    fi
}

# Backup current configuration
backup_configs() {
    log "Creating configuration backups..."
    local backup_dir="/tmp/garuda-powerhouse-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup system files if root
    if check_root; then
        cp /etc/sysctl.conf "$backup_dir/" 2>/dev/null || true
        cp -r /etc/systemd/system "$backup_dir/systemd-system" 2>/dev/null || true
        echo "$backup_dir" > /tmp/last-backup-location
        log "System configs backed up to: $backup_dir"
    fi
}

# System updates
update_system() {
    log "Updating system packages..."
    if check_root; then
        pacman -Syu --noconfirm
        log "System packages updated successfully"
    else
        warn "Skipping system update - requires root access"
    fi
}

# CPU Performance Optimization
optimize_cpu() {
    log "Optimizing CPU performance..."
    
    if check_root; then
        # Set CPU governor to performance
        echo "performance" > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null || warn "Could not set CPU governor"
        
        # Enable turbo boost
        echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo 2>/dev/null || warn "Could not enable turbo boost"
        
        # Create systemd service for persistent CPU settings
        cat > /etc/systemd/system/cpu-performance.service << 'EOF'
[Unit]
Description=Set CPU Performance Mode
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo performance > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
ExecStart=/bin/bash -c 'echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
        systemctl enable cpu-performance.service
        systemctl start cpu-performance.service
        
        log "CPU performance optimization applied"
    else
        warn "Skipping CPU optimization - requires root access"
    fi
}

# Storage I/O Optimization
optimize_storage() {
    log "Optimizing storage performance..."
    
    if check_root; then
        # Set I/O scheduler to BFQ for better mixed workload performance
        for device in /sys/block/nvme*/queue/scheduler; do
            if [[ -f "$device" ]]; then
                echo "bfq" > "$device" 2>/dev/null || warn "Could not set BFQ scheduler for $(basename $(dirname $(dirname $device)))"
            fi
        done
        
        # Create udev rule for persistent I/O scheduler
        cat > /etc/udev/rules.d/60-ioscheduler.rules << 'EOF'
# Set BFQ scheduler for NVMe devices
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="bfq"
EOF
        
        # Optimize mount options for performance
        if ! grep -q "noatime" /etc/fstab 2>/dev/null; then
            info "Consider adding 'noatime' mount option to /etc/fstab for better I/O performance"
        fi
        
        log "Storage optimization applied"
    else
        warn "Skipping storage optimization - requires root access"
    fi
}

# Memory and Kernel Parameter Optimization  
optimize_memory() {
    log "Optimizing memory and kernel parameters..."
    
    if check_root; then
        # Create optimized sysctl configuration
        cat > /etc/sysctl.d/99-garuda-powerhouse.conf << 'EOF'
# Garuda Powerhouse System Optimizations

# Memory Management
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_background_ratio=5
vm.dirty_ratio=10
vm.dirty_writeback_centisecs=1500
vm.dirty_expire_centisecs=3000

# Network Performance
net.core.rmem_default=262144
net.core.rmem_max=16777216
net.core.wmem_default=262144
net.core.wmem_max=16777216
net.core.netdev_max_backlog=5000
net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_timestamps=1
net.ipv4.tcp_sack=1
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 16384 16777216
net.ipv4.udp_rmem_min=8192
net.ipv4.udp_wmem_min=8192

# Kernel Performance
kernel.sched_autogroup_enabled=0
kernel.sched_migration_cost_ns=5000000
kernel.numa_balancing=0

# File System
fs.file-max=2097152
fs.inotify.max_user_watches=524288
EOF
        
        # Apply the settings
        sysctl -p /etc/sysctl.d/99-garuda-powerhouse.conf
        
        log "Memory and kernel optimization applied"
    else
        warn "Skipping memory optimization - requires root access" 
    fi
}

# Network Optimization
optimize_network() {
    log "Optimizing network configuration..."
    
    if check_root; then
        # Install network performance tools if not present
        pacman -S --needed --noconfirm iperf3 ethtool 2>/dev/null || warn "Could not install network tools"
        
        # Optimize network interface settings
        for iface in $(ip link show | grep -E "^[0-9]+" | awk -F': ' '{print $2}' | grep -v lo); do
            if [[ -d "/sys/class/net/$iface" ]]; then
                # Increase network buffer sizes if supported
                ethtool -G "$iface" rx 4096 tx 4096 2>/dev/null || true
                # Enable offload features if supported  
                ethtool -K "$iface" gso on gro on tso on 2>/dev/null || true
            fi
        done
        
        log "Network optimization applied"
    else
        warn "Skipping network optimization - requires root access"
    fi
}

# Install Performance Monitoring Tools
install_monitoring_tools() {
    log "Installing performance monitoring tools..."
    
    if check_root; then
        pacman -S --needed --noconfirm \
            htop \
            iotop \
            nethogs \
            ncdu \
            tree \
            lsof \
            strace \
            perf \
            sysstat \
            smartmontools \
            hdparm \
            nvme-cli 2>/dev/null || warn "Some monitoring tools could not be installed"
        
        # Enable system monitoring services
        systemctl enable --now sysstat || warn "Could not enable sysstat"
        
        log "Monitoring tools installed"
    else
        warn "Skipping monitoring tools installation - requires root access"
    fi
}

# Optimize for AI/ML workloads
optimize_ai_ml() {
    log "Optimizing for AI/ML workloads..."
    
    if check_root; then
        # Install AI/ML performance libraries
        pacman -S --needed --noconfirm \
            python-numpy \
            python-scipy \
            python-matplotlib \
            python-pandas \
            python-scikit-learn \
            python-tensorflow \
            python-pytorch \
            cuda \
            opencl-headers \
            rocm-core 2>/dev/null || warn "Some AI/ML packages could not be installed"
        
        # Set up GPU acceleration if available
        if lspci | grep -i nvidia >/dev/null 2>&1; then
            pacman -S --needed --noconfirm nvidia nvidia-utils nvidia-settings || warn "NVIDIA drivers installation failed"
            log "NVIDIA GPU support configured"
        fi
        
        if lspci | grep -i amd >/dev/null 2>&1; then
            pacman -S --needed --noconfirm amdgpu-pro-installer || warn "AMD GPU drivers installation failed"
            log "AMD GPU support configured"
        fi
        
        log "AI/ML optimization applied"
    else
        warn "Skipping AI/ML optimization - requires root access"
    fi
}

# Security Hardening
apply_security_hardening() {
    log "Applying security hardening..."
    
    if check_root; then
        # Configure firewall
        pacman -S --needed --noconfirm ufw || warn "Could not install ufw"
        ufw --force enable
        ufw default deny incoming
        ufw default allow outgoing
        
        # Allow essential services
        ufw allow ssh
        ufw allow 8096/tcp  # Jellyfin
        ufw allow 9091/tcp  # qBittorrent
        ufw allow 8080/tcp  # General web services
        
        # Secure kernel parameters
        cat >> /etc/sysctl.d/99-garuda-powerhouse.conf << 'EOF'

# Security Hardening
net.ipv4.conf.default.rp_filter=1
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.all.accept_redirects=0
net.ipv6.conf.all.accept_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.all.accept_source_route=0
net.ipv6.conf.all.accept_source_route=0
net.ipv4.conf.all.log_martians=1
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.icmp_ignore_bogus_error_responses=1
kernel.dmesg_restrict=1
kernel.kptr_restrict=1
EOF
        
        sysctl -p /etc/sysctl.d/99-garuda-powerhouse.conf
        
        log "Security hardening applied"
    else
        warn "Skipping security hardening - requires root access"
    fi
}

# Create performance monitoring script
create_monitoring_script() {
    log "Creating performance monitoring script..."
    
    cat > /mnt/home/lou/ultimate-garuda-powerhouse/scripts/monitor-performance.sh << 'EOF'
#!/bin/bash

# Garuda Powerhouse Performance Monitor
# Shows real-time system performance metrics

clear
echo "=== Garuda Powerhouse Performance Monitor ==="
echo "Press Ctrl+C to exit"
echo

while true; do
    clear
    echo -e "\033[1;32m=== Garuda Powerhouse Performance Monitor ===\033[0m"
    echo
    
    # System load and uptime
    echo -e "\033[1;34m--- System Overview ---\033[0m"
    uptime
    echo
    
    # CPU information
    echo -e "\033[1;34m--- CPU Usage ---\033[0m"
    top -bn1 | grep "Cpu(s)" | awk '{print $2 $3 $4 $5 $6 $7 $8}'
    cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null && echo " governor" || echo "Governor: Unknown"
    echo
    
    # Memory usage
    echo -e "\033[1;34m--- Memory Usage ---\033[0m"
    free -h
    echo
    
    # Storage usage
    echo -e "\033[1;34m--- Storage Usage ---\033[0m"
    df -h | grep -E "(nvme|sda|sdb)" | head -5
    echo
    
    # Network activity
    echo -e "\033[1;34m--- Network Activity ---\033[0m"
    cat /proc/net/dev | grep -E "(wlp|enp|eth)" | head -2 | awk '{print $1 " RX: " $2/1024/1024 "MB TX: " $10/1024/1024 "MB"}'
    echo
    
    # Top processes
    echo -e "\033[1;34m--- Top Processes ---\033[0m"
    ps aux --sort=-%cpu | head -6
    echo
    
    sleep 3
done
EOF
    
    chmod +x /mnt/home/lou/ultimate-garuda-powerhouse/scripts/monitor-performance.sh
    log "Performance monitoring script created"
}

# Create system maintenance script
create_maintenance_script() {
    log "Creating system maintenance script..."
    
    cat > /mnt/home/lou/ultimate-garuda-powerhouse/scripts/maintain-system.sh << 'EOF'
#!/bin/bash

# Garuda Powerhouse System Maintenance Script
# Performs regular system maintenance tasks

set -euo pipefail

echo "=== Garuda Powerhouse System Maintenance ==="
echo

# Update package databases
echo "Updating package databases..."
sudo pacman -Sy

# Clean package cache
echo "Cleaning package cache..."
sudo pacman -Sc --noconfirm

# Clean system logs
echo "Cleaning system logs..."
sudo journalctl --vacuum-time=7d

# Check disk usage
echo "Checking disk usage..."
df -h | grep -E "(nvme|sda|sdb)"

# Update locate database
echo "Updating locate database..."
sudo updatedb &

# Check for failed services
echo "Checking for failed services..."
systemctl --failed | head -10

# Clean temporary files
echo "Cleaning temporary files..."
sudo find /tmp -type f -atime +7 -delete 2>/dev/null || true
sudo find /var/tmp -type f -atime +7 -delete 2>/dev/null || true

# Memory and cache cleanup
echo "Cleaning memory caches..."
sync
echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

echo
echo "System maintenance completed!"
echo "System status:"
uptime
free -h | head -2
df -h / | tail -1
EOF
    
    chmod +x /mnt/home/lou/ultimate-garuda-powerhouse/scripts/maintain-system.sh
    log "System maintenance script created"
}

# Create system benchmark script
create_benchmark_script() {
    log "Creating system benchmark script..."
    
    cat > /mnt/home/lou/ultimate-garuda-powerhouse/scripts/benchmark-system.sh << 'EOF'
#!/bin/bash

# Garuda Powerhouse System Benchmark Script
# Tests system performance across multiple metrics

set -euo pipefail

echo "=== Garuda Powerhouse System Benchmark ==="
echo

# CPU benchmark
echo "--- CPU Benchmark ---"
echo "Running CPU stress test (30 seconds)..."
time (
    for i in {1..4}; do
        nohup bash -c 'for ((j=0; j<100000; j++)); do ((k=j*j)); done' &
    done
    wait
) 2>&1 | grep real

# Memory benchmark  
echo
echo "--- Memory Benchmark ---"
echo "Testing memory speed..."
if command -v sysbench >/dev/null 2>&1; then
    sysbench memory --memory-block-size=1M --memory-total-size=10G run | grep -E "(total time|events per second)"
else
    echo "sysbench not available - installing..."
    sudo pacman -S --needed --noconfirm sysbench || echo "Could not install sysbench"
fi

# Storage benchmark
echo
echo "--- Storage Benchmark ---"
echo "Testing storage performance..."
dd if=/dev/zero of=/tmp/benchmark_test bs=1M count=1000 conv=fdatasync 2>&1 | grep -E "(copied|MB/s)"
rm -f /tmp/benchmark_test

# Network benchmark (internal)
echo
echo "--- Network Benchmark ---"
echo "Testing network interface speed..."
iperf3 -s -p 5201 -D 2>/dev/null || echo "iperf3 server already running or not available"
sleep 2
iperf3 -c 127.0.0.1 -p 5201 -t 10 2>/dev/null | grep -E "(sender|receiver)" || echo "Network benchmark failed"
pkill iperf3 2>/dev/null || true

# System information summary
echo
echo "--- System Information Summary ---"
echo "CPU: $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
echo "Memory: $(free -h | grep Mem | awk '{print $2}')"
echo "Storage: $(df -h / | tail -1 | awk '{print $2 " total, " $4 " available"}')"
echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
echo "CPU Governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'Unknown')"

echo
echo "Benchmark completed!"
EOF
    
    chmod +x /mnt/home/lou/ultimate-garuda-powerhouse/scripts/benchmark-system.sh
    log "System benchmark script created"
}

# Main optimization function
main() {
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                Ultimate Garuda Powerhouse                   ║"
    echo "║                 System Optimization Script                  ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log "Starting system optimization..."
    log "Log file: $LOG_FILE"
    
    # Run all optimization functions
    backup_configs
    update_system
    optimize_cpu
    optimize_storage  
    optimize_memory
    optimize_network
    install_monitoring_tools
    optimize_ai_ml
    apply_security_hardening
    create_monitoring_script
    create_maintenance_script
    create_benchmark_script
    
    echo
    log "System optimization completed successfully!"
    info "Log file saved to: $LOG_FILE"
    info "New scripts created in: /mnt/home/lou/ultimate-garuda-powerhouse/scripts/"
    echo
    echo -e "${GREEN}Available new commands:${NC}"
    echo -e "  ${BLUE}./scripts/monitor-performance.sh${NC}  - Real-time performance monitoring"
    echo -e "  ${BLUE}./scripts/maintain-system.sh${NC}      - Regular system maintenance"
    echo -e "  ${BLUE}./scripts/benchmark-system.sh${NC}     - System performance benchmark"
    echo
    echo -e "${YELLOW}Recommended next steps:${NC}"
    echo -e "  1. Reboot system to apply all kernel optimizations"
    echo -e "  2. Run ./scripts/benchmark-system.sh to test performance"
    echo -e "  3. Set up media stack with ./scripts/install-system.sh"
    echo -e "  4. Monitor with ./scripts/monitor-performance.sh"
    echo
}

# Run main function
main "$@"
EOF