#!/bin/bash

# Ultimate Garuda Powerhouse System Status
# Shows current system performance and optimization status

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Header
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                Ultimate Garuda Powerhouse                   ║"
echo "║                    System Status Report                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# System Overview
echo -e "${CYAN}=== System Overview ===${NC}"
echo -e "${BLUE}Hostname:${NC} $(hostname)"
echo -e "${BLUE}Kernel:${NC} $(uname -r)"
echo -e "${BLUE}Uptime:${NC} $(uptime -p)"
echo -e "${BLUE}Load Average:${NC} $(uptime | awk -F'load average:' '{print $2}')"
echo

# CPU Status
echo -e "${CYAN}=== CPU Status ===${NC}"
echo -e "${BLUE}CPU Model:${NC} $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
echo -e "${BLUE}CPU Cores:${NC} $(nproc)"
echo -e "${BLUE}CPU Governor:${NC} $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'Unknown')"
echo -e "${BLUE}Current Frequency:${NC} $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null | awk '{print $1/1000 "MHz"}' || echo 'Unknown')"

# Check if performance governor is active
if [ "$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'unknown')" = "performance" ]; then
    echo -e "${GREEN}✓ CPU Performance Mode: ACTIVE${NC}"
else
    echo -e "${YELLOW}⚠ CPU Performance Mode: INACTIVE${NC}"
fi
echo

# Memory Status
echo -e "${CYAN}=== Memory Status ===${NC}"
free -h | while read line; do
    if [[ $line == *"Mem:"* ]]; then
        total=$(echo $line | awk '{print $2}')
        used=$(echo $line | awk '{print $3}')
        available=$(echo $line | awk '{print $7}')
        echo -e "${BLUE}Total Memory:${NC} $total"
        echo -e "${BLUE}Used Memory:${NC} $used"
        echo -e "${BLUE}Available Memory:${NC} $available"
    fi
done

# Check swap usage
swap_usage=$(free | grep Swap | awk '{if ($2 > 0) print ($3/$2)*100; else print 0}' | cut -d. -f1)
if [ "$swap_usage" -le 10 ]; then
    echo -e "${GREEN}✓ Swap Usage: ${swap_usage}% (Good)${NC}"
else
    echo -e "${YELLOW}⚠ Swap Usage: ${swap_usage}% (High)${NC}"
fi
echo

# Storage Status
echo -e "${CYAN}=== Storage Status ===${NC}"
df -h | grep -E "(nvme|sda|sdb)" | head -5 | while read line; do
    device=$(echo $line | awk '{print $1}')
    size=$(echo $line | awk '{print $2}')
    used=$(echo $line | awk '{print $3}')
    avail=$(echo $line | awk '{print $4}')
    percent=$(echo $line | awk '{print $5}')
    mount=$(echo $line | awk '{print $6}')
    echo -e "${BLUE}$device:${NC} $size total, $used used, $avail available ($percent) - $mount"
done

# I/O Scheduler Status
echo -e "${BLUE}I/O Schedulers:${NC}"
for device in /sys/block/nvme*/queue/scheduler; do
    if [[ -f "$device" ]]; then
        device_name=$(basename $(dirname $(dirname $device)))
        scheduler=$(cat $device | grep -o '\[.*\]' | tr -d '[]')
        if [ "$scheduler" = "bfq" ]; then
            echo -e "${GREEN}✓ $device_name: $scheduler (Optimized)${NC}"
        else
            echo -e "${YELLOW}⚠ $device_name: $scheduler${NC}"
        fi
    fi
done
echo

# Network Status
echo -e "${CYAN}=== Network Status ===${NC}"
ip addr show | grep -E "^[0-9]+:" | while read line; do
    interface=$(echo $line | awk -F': ' '{print $2}' | cut -d'@' -f1)
    if [ "$interface" != "lo" ]; then
        state=$(ip link show $interface | grep -o "state [A-Z]*" | awk '{print $2}')
        if [ "$state" = "UP" ]; then
            ip_addr=$(ip addr show $interface | grep -o "inet [0-9.]*" | awk '{print $2}' || echo "No IP")
            echo -e "${GREEN}✓ $interface: $state ($ip_addr)${NC}"
        else
            echo -e "${YELLOW}⚠ $interface: $state${NC}"
        fi
    fi
done
echo

# Kernel Optimizations Status
echo -e "${CYAN}=== Kernel Optimizations Status ===${NC}"
if [ -f "/etc/sysctl.d/99-garuda-powerhouse.conf" ]; then
    echo -e "${GREEN}✓ Garuda Powerhouse optimizations: ACTIVE${NC}"
    echo -e "${BLUE}Swappiness:${NC} $(sysctl vm.swappiness | cut -d'=' -f2 | xargs)"
    echo -e "${BLUE}TCP Congestion Control:${NC} $(sysctl net.ipv4.tcp_congestion_control | cut -d'=' -f2 | xargs)"
    echo -e "${BLUE}File Max:${NC} $(sysctl fs.file-max | cut -d'=' -f2 | xargs)"
else
    echo -e "${YELLOW}⚠ Garuda Powerhouse optimizations: NOT APPLIED${NC}"
fi
echo

# Process Information
echo -e "${CYAN}=== Top Processes (by CPU) ===${NC}"
ps aux --sort=-%cpu | head -6 | awk 'NR==1{printf "%-10s %-6s %-6s %-8s %-s\n", "USER", "PID", "%CPU", "%MEM", "COMMAND"} NR>1{printf "%-10s %-6s %-6s %-8s %-s\n", $1, $2, $3, $4, $11}'
echo

# Service Status
echo -e "${CYAN}=== Service Status ===${NC}"
services=("sysstat" "systemd-resolved" "NetworkManager")
for service in "${services[@]}"; do
    if systemctl is-active --quiet "$service"; then
        echo -e "${GREEN}✓ $service: ACTIVE${NC}"
    else
        echo -e "${YELLOW}⚠ $service: INACTIVE${NC}"
    fi
done
echo

# Media Stack Status (if available)
echo -e "${CYAN}=== Media Stack Status ===${NC}"
media_services=("jellyfin" "sonarr" "radarr" "lidarr" "readarr" "qbittorrent-nox" "jackett" "jellyseerr")
active_services=0
for service in "${media_services[@]}"; do
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        echo -e "${GREEN}✓ $service: RUNNING${NC}"
        ((active_services++))
    fi
done

if [ $active_services -eq 0 ]; then
    echo -e "${YELLOW}No media stack services currently running${NC}"
    echo -e "${BLUE}To set up media stack: ./scripts/install-system.sh --media-stack native${NC}"
fi
echo

# Available Scripts
echo -e "${CYAN}=== Available Optimization Scripts ===${NC}"
scripts_dir="/mnt/home/lou/ultimate-garuda-powerhouse/scripts"
if [ -d "$scripts_dir" ]; then
    for script in "$scripts_dir"/*.sh; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            script_name=$(basename "$script")
            case $script_name in
                "optimize-system.sh")
                    echo -e "${BLUE}• $script_name${NC} - Complete system optimization"
                    ;;
                "monitor-performance.sh")
                    echo -e "${BLUE}• $script_name${NC} - Real-time performance monitoring"
                    ;;
                "maintain-system.sh")
                    echo -e "${BLUE}• $script_name${NC} - System maintenance and cleanup"
                    ;;
                "benchmark-system.sh")
                    echo -e "${BLUE}• $script_name${NC} - System performance benchmarking"
                    ;;
                "build-iso.sh")
                    echo -e "${BLUE}• $script_name${NC} - Build custom ISO images"
                    ;;
                "install-system.sh")
                    echo -e "${BLUE}• $script_name${NC} - Install system components"
                    ;;
                "setup-all.sh")
                    echo -e "${BLUE}• $script_name${NC} - Complete system setup"
                    ;;
                "system-status.sh")
                    echo -e "${BLUE}• $script_name${NC} - This status report"
                    ;;
                *)
                    echo -e "${BLUE}• $script_name${NC}"
                    ;;
            esac
        fi
    done
fi
echo

# System Health Summary
echo -e "${CYAN}=== System Health Summary ===${NC}"
health_score=0
total_checks=6

# Check CPU governor
if [ "$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'unknown')" = "performance" ]; then
    ((health_score++))
fi

# Check I/O scheduler
bfq_count=$(cat /sys/block/nvme*/queue/scheduler 2>/dev/null | grep -c "\[bfq\]" || echo 0)
if [ "$bfq_count" -gt 0 ]; then
    ((health_score++))
fi

# Check optimizations file
if [ -f "/etc/sysctl.d/99-garuda-powerhouse.conf" ]; then
    ((health_score++))
fi

# Check swap usage
if [ "$swap_usage" -le 10 ]; then
    ((health_score++))
fi

# Check load average (should be reasonable for a 32-core system)
load_1min=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | xargs)
if (( $(echo "$load_1min < 16" | bc -l) )); then
    ((health_score++))
fi

# Check available memory > 80%
mem_available_percent=$(free | grep Mem | awk '{print ($7/$2)*100}' | cut -d. -f1)
if [ "$mem_available_percent" -gt 80 ]; then
    ((health_score++))
fi

health_percentage=$((health_score * 100 / total_checks))

if [ "$health_percentage" -ge 80 ]; then
    echo -e "${GREEN}✓ System Health: EXCELLENT (${health_score}/${total_checks} checks passed)${NC}"
elif [ "$health_percentage" -ge 60 ]; then
    echo -e "${YELLOW}⚠ System Health: GOOD (${health_score}/${total_checks} checks passed)${NC}"
else
    echo -e "${RED}✗ System Health: NEEDS ATTENTION (${health_score}/${total_checks} checks passed)${NC}"
fi

echo
echo -e "${BLUE}Run './scripts/optimize-system.sh' to improve system performance${NC}"
echo -e "${BLUE}Run './scripts/monitor-performance.sh' for real-time monitoring${NC}"
echo -e "${BLUE}Run './scripts/benchmark-system.sh' to test system performance${NC}"
echo