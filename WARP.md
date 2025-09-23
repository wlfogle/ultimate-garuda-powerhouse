# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Repository overview
- This is a monorepo that aggregates three upstream projects as Git subtrees (see README.md):
  - ai-powerhouse-setup/ — ISO build profiles and scripts, self-hosting media stack, and virtualization tooling
  - calamares-zfs-integration/ — Calamares 3.3.14 ZFS enhancements and packaging for Garuda Linux
  - garuda-media-stack/ — Standalone media stack (mirrors the self-hosting stack under ai-powerhouse-setup)
- Subproject-specific WARP.md files exist in:
  - calamares-zfs-integration/WARP.md
  - garuda-media-stack/WARP.md
  - ai-powerhouse-setup/.../airootfs/.../self-hosting/WARP.md (and ai-powerhouse-setup/self-hosting/WARP.md)
  Prefer those when operating inside their respective subtrees; this root file focuses on cross-repo tasks and entry points.

Common commands by area

ISO build (Garuda AI Powerhouse)
- Standard archiso-based flow (non-root):
  ```bash path=null start=null
  # From repo root
  bash ai-powerhouse-setup/iso-build/build-ai-powerhouse-iso.sh
  # Optional: override work/output locations
  WORK_DIR=/fast/tmp OUTPUT_DIR=/fast/out \
    bash ai-powerhouse-setup/iso-build/build-ai-powerhouse-iso.sh
  ```
- Alternative custom profile flow (root; clones garuda-tools and uses buildiso):
  ```bash path=null start=null
  sudo bash ai-powerhouse-setup/installation/build-custom-iso.sh
  ```
- Profile metadata lives in ai-powerhouse-setup/iso-build/archiso-method/profiledef.sh.

Virtualization tooling (MobaLiveCD-style runner)
- Location: ai-powerhouse-setup/virtualization/
- Targets:
  ```bash path=null start=null
  # Verify deps (Python 3, QEMU, GTK)
  make -C ai-powerhouse-setup/virtualization check

  # Run and basic tests
  make -C ai-powerhouse-setup/virtualization run
  make -C ai-powerhouse-setup/virtualization test

  # Install system-wide or for current user
  sudo make -C ai-powerhouse-setup/virtualization install
  make -C ai-powerhouse-setup/virtualization install-user

  # USB helpers
  make -C ai-powerhouse-setup/virtualization list-usb
  make -C ai-powerhouse-setup/virtualization create-usb

  # Clean artifacts
  make -C ai-powerhouse-setup/virtualization clean
  ```

Calamares ZFS integration
- One-shot automated build (installs deps, integrates modules, builds Calamares, then builds the Garuda package):
  ```bash path=null start=null
  # From repo root
  bash calamares-zfs-integration/build-complete.sh
  ```
- Manual development snippets:
  ```bash path=null start=null
  # Validate module syntax and configs
  python3 -m py_compile calamares-zfs-integration/modules/zfspostcfg/main.py
  python3 -c "import yaml; yaml.safe_load(open('calamares-zfs-integration/modules/zfspostcfg/zfspostcfg.conf'))"
  python3 -c "import yaml; yaml.safe_load(open('calamares-zfs-integration/modules/zfs.conf'))"

  # Configure, build, and test Calamares (after extracting source per project docs)
  cmake -S calamares-zfs-integration/calamares-3.3.14 -B calamares-zfs-integration/calamares-3.3.14/build \
    -DCMAKE_BUILD_TYPE=Release -DWITH_QT6=ON -DCMAKE_INSTALL_PREFIX=/usr
  make -C calamares-zfs-integration/calamares-3.3.14/build -j"$(nproc)"

  # Build the Garuda package
  (cd calamares-zfs-integration/garuda-package/garuda-calamares-zfs && makepkg -si)

  # Run Calamares in debug (after build/install)
  sudo calamares -d
  ```

Media stack (self-hosting)
- The same stack exists under ai-powerhouse-setup/self-hosting/ and garuda-media-stack/.
- Core install/run commands:
  ```bash path=null start=null
  # Native install (all services)
  (cd ai-powerhouse-setup/self-hosting && sudo ./install-native-media-stack.sh)

  # Basic native install (without Ghost Mode/WireGuard)
  (cd ai-powerhouse-setup/self-hosting && sudo ./install-media-stack.sh)

  # Universal (container) install
  (cd ai-powerhouse-setup/self-hosting && ./universal-media-stack.sh)

  # Health check and service helpers
  (cd ai-powerhouse-setup/self-hosting && ./scripts/health-check-enhanced.sh)
  (cd ai-powerhouse-setup/self-hosting && ./ghost-control.sh status)
  (cd ai-powerhouse-setup/self-hosting && ./scripts/wireguard-client-manager.sh)
  ```

Running a single test or check
- Virtualization: run the Makefile test target
  ```bash path=null start=null
  make -C ai-powerhouse-setup/virtualization test
  ```
- Calamares ZFS: validate just the Python module (fast syntax check)
  ```bash path=null start=null
  python3 -m py_compile calamares-zfs-integration/modules/zfspostcfg/main.py
  ```
- Media stack: quick health verification
  ```bash path=null start=null
  (cd ai-powerhouse-setup/self-hosting && ./scripts/health-check-enhanced.sh)
  ```

Architecture notes (big picture)
- ISO build pipeline (ai-powerhouse-setup):
  - archiso-method/ defines an ArchISO profile (profiledef.sh plus packages.x86_64 and airootfs overlay).
  - build-ai-powerhouse-iso.sh drives mkarchiso end-to-end with configurable WORK_DIR and OUTPUT_DIR.
  - installation/build-custom-iso.sh provides an alternative flow that clones garuda-tools ISO profiles, overlays AI Powerhouse assets into /etc/skel inside the image, and invokes buildiso; it also adds AI/ML, ZFS, and media stack packages.
- Self-hosting media stack:
  - install-native-media-stack.sh, install-media-stack.sh, and universal-media-stack.sh orchestrate service install and configuration for Jellyfin, Sonarr/Radarr/Lidarr/Readarr, qBittorrent, Jackett, Audiobookshelf, Calibre-web, Jellyseerr, Pulsarr, and Ghost Mode/WireGuard (ESSENTIAL/CRITICAL).
  - scripts/ contains operational utilities (health checks, WireGuard setup/management, service runners) used across workflows.
- Calamares ZFS integration:
  - Adds a Python module (zfspostcfg) that runs post ZFS dataset creation but before initramfs generation. It enables critical ZFS systemd services, configures mkinitcpio for ZFS, and finalizes mountpoints/cache.
  - Packaging lives under calamares-zfs-integration/garuda-package with a PKGBUILD to produce garuda-calamares-zfs; build-complete.sh automates dependency install, integration, build, and packaging.

Conventions and pointers
- This monorepo preserves upstream structure intentionally; prefer making changes inside the relevant subproject to keep responsibilities clear.
- When operating inside a subtree, defer to that subtree’s WARP.md for specifics. This root file is the index for where to perform tasks and how to kick off common workflows.
