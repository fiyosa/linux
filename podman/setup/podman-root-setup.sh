#!/bin/bash
# podman-root-setup.sh

echo "=== Setup Podman Root Mode ==="

# 1. Create podman group if not exists
if ! getent group podman > /dev/null; then
    sudo groupadd podman
    echo "[OK] Podman group created"
else
    echo "[SKIP] Podman group already exists"
fi

# 2. Add current user to podman group
sudo usermod -aG podman $USER
echo "[OK] User $USER added to podman group"

# 3. Set socket permission
sudo chown root:podman /run/podman/podman.sock
sudo chmod 660 /run/podman/podman.sock
echo "[OK] Socket permission set"

# 4. Create tmpfiles.d config to persist after reboot
echo "z /run/podman/podman.sock 660 root podman -" | sudo tee /etc/tmpfiles.d/podman.conf > /dev/null
sudo systemd-tmpfiles --create /etc/tmpfiles.d/podman.conf
echo "[OK] Reboot persistent config created"

# 5. Add DOCKER_HOST to bashrc if not exists
if ! grep -q "DOCKER_HOST" ~/.bashrc; then
    echo 'export DOCKER_HOST=unix:///run/podman/podman.sock' >> ~/.bashrc
    echo "[OK] DOCKER_HOST added to .bashrc"
else
    echo "[SKIP] DOCKER_HOST already exists in .bashrc"
fi

# 6. Disable podman user socket
systemctl --user stop podman.socket 2>/dev/null
systemctl --user disable podman.socket 2>/dev/null
echo "[OK] Podman user socket disabled"

# 7. Enable and start podman root socket
sudo systemctl enable --now podman.socket
echo "[OK] Podman root socket enabled"

# 8. Add docker.io to unqualified search registries if not exists
REGISTRY_CONF="/etc/containers/registries.conf"
if ! grep -q "unqualified-search-registries" $REGISTRY_CONF; then
    echo 'unqualified-search-registries = ["docker.io"]' | sudo tee -a $REGISTRY_CONF > /dev/null
    echo "[OK] docker.io added to unqualified search registries"
else
    echo "[SKIP] unqualified-search-registries already exists in $REGISTRY_CONF"
fi

echo ""
echo "=== Done ==="
echo "Please logout and login again to activate podman group"