#!/bin/bash
# podman-root-verify.sh

echo "=== Podman Root Mode Verification ==="
echo ""

# 1. Check user is in podman group
echo "[CHECK] User group :"
groups $USER
echo ""

# 2. Check socket permission
echo "[CHECK] Socket permission :"
ls -la /run/podman/podman.sock
echo ""

# 3. Check DOCKER_HOST
echo "[CHECK] DOCKER_HOST :"
source ~/.bashrc && echo $DOCKER_HOST
echo ""

# 4. Check podman root socket status
echo "[CHECK] Podman root socket status :"
sudo systemctl status podman.socket --no-pager -l
echo ""

# 5. Check podman user socket status
echo "[CHECK] Podman user socket status :"
systemctl --user status podman.socket --no-pager -l 2>/dev/null || echo "User socket not running"
echo ""

# 6. Test podman without sudo
echo "[CHECK] Podman ps (without sudo) :"
podman ps
echo ""

echo "=== Verification Done ==="