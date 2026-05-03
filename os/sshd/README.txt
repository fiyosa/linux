# Setup login vps from login-password to .ppk

ssh-keygen -t ed25519 -C "my-vps"

# =============================================================================

vim /etc/ssh/sshd_config

# latest line
"PermitRootLogin no" => "PermitRootLogin prohibit-password"

"#PasswordAuthentication yes" => "PasswordAuthentication no"
"#PubkeyAuthentication yes" => "PubkeyAuthentication yes"
"#StrictModes yes" => "StrictModes yes"

# =============================================================================

# open cmd on windows

pscp -P 2222 -i C:\Users\fys\Documents\vps\vps-shopee\id_ed25519.ppk root@47.250.191.108:/etc/ssh/sshd_config C:\Users\fys\Desktop\sshd_config