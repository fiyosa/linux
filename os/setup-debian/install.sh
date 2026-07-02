#!/bin/bash
set -e

# ============================================================================
# Script: Debian/Ubuntu Setup
# Description: Auto-install development tools & yazi file manager
# ============================================================================

# ----------------------------------------------------------------------------
# Setup: Working directory for downloads
# All download artifacts go to ~/TEMP_INSTALL for inspection if an error occurs.
# ----------------------------------------------------------------------------
INSTALL_TMP="$HOME/TEMP_INSTALL"
mkdir -p "$INSTALL_TMP"

# ----------------------------------------------------------------------------
# Feature 1: OS Detection
# Validates that the host is Debian-based (Debian, Ubuntu, Mint, etc.)
# ----------------------------------------------------------------------------
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "debian" ] && echo "$ID_LIKE" | grep -qv "debian"; then
        echo "Error: This script only supports Debian and Debian-based distributions."
        exit 1
    fi
    echo "Detected: $PRETTY_NAME"
else
    echo "Error: /etc/os-release not found. Not a Debian-based system."
    exit 1
fi

# ----------------------------------------------------------------------------
# Feature 2: System Update
# Refreshes the apt package index.
# ----------------------------------------------------------------------------
sudo apt update

# ----------------------------------------------------------------------------
# Feature 3: Install Prerequisites
# Installs curl and unzip required by later steps.
# ----------------------------------------------------------------------------
sudo apt install -y curl unzip htop bzip2

# ----------------------------------------------------------------------------
# Feature 4: Install Yazi (File Manager)
# Downloads the latest yazi release for the host architecture.
# ----------------------------------------------------------------------------
YAZI_ARCH="$(uname -m)"
case "$YAZI_ARCH" in
    x86_64)  YAZI_ASSET="yazi-x86_64-unknown-linux-musl.zip" ;;
    aarch64) YAZI_ASSET="yazi-aarch64-unknown-linux-musl.zip" ;;
    *)
        echo "Error: Unsupported architecture: $YAZI_ARCH"
        exit 1
        ;;
esac

curl -Lo "$INSTALL_TMP/yazi.zip" "https://github.com/sxyazi/yazi/releases/latest/download/$YAZI_ASSET"
unzip -q "$INSTALL_TMP/yazi.zip" -d "$INSTALL_TMP/yazi-temp"
sudo mv "$INSTALL_TMP/yazi-temp/"*"/{ya,yazi}" /usr/local/bin
yazi --version
# NOTE: artifacts left in $INSTALL_TMP for manual inspection if needed.

# ----------------------------------------------------------------------------
# Feature 5: Configure y() Shell Function
# Appends the yazi wrapper to ~/.bashrc (idempotent: skips if already added).
# ----------------------------------------------------------------------------
BASHRC="$HOME/.bashrc"
YAZI_FUNC_MARKER="# >>> yazi wrapper function >>>"
if ! grep -qF "$YAZI_FUNC_MARKER" "$BASHRC" 2>/dev/null; then
    cat >> "$BASHRC" <<'EOF'

# >>> yazi wrapper function >>>
function y() {
    local tmp cwd
    tmp=$(mktemp -t "yazi-cwd.XXXXXX") || return 1
    yazi "$@" --cwd-file="$tmp"
    if cwd=$(cat -- "$tmp" 2>/dev/null) && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
        cd -- "$cwd" || echo "Failed to change directory" >&2
    fi
    rm -f -- "$tmp"
}
# <<< yazi wrapper function <<<
EOF
    echo "y() function added to $BASHRC"
else
    echo "y() function already present in $BASHRC"
fi

# ----------------------------------------------------------------------------
# Feature 6: Yazi Config (yazi.toml)
# Creates ~/.config/yazi/yazi.toml with default settings.
# ----------------------------------------------------------------------------
YAZI_CONFIG_DIR="$HOME/.config/yazi"
mkdir -p "$YAZI_CONFIG_DIR"
YAZI_TOML="$YAZI_CONFIG_DIR/yazi.toml"
if [ ! -f "$YAZI_TOML" ]; then
    cat > "$YAZI_TOML" <<'EOF'
[mgr]
show_hidden = true
EOF
    echo "yazi config created at $YAZI_TOML"
else
    echo "yazi config already exists at $YAZI_TOML"
fi

# ----------------------------------------------------------------------------
# Feature 7: Install Starship (Shell Prompt)
# Downloads starship for the host architecture and installs default config.
# ----------------------------------------------------------------------------
STARSHIP_ARCH="$(uname -m)"
case "$STARSHIP_ARCH" in
    x86_64)  STARSHIP_ASSET="starship-x86_64-unknown-linux-musl.tar.gz" ;;
    aarch64) STARSHIP_ASSET="starship-aarch64-unknown-linux-musl.tar.gz" ;;
    *)
        echo "Error: Unsupported architecture: $STARSHIP_ARCH"
        exit 1
        ;;
esac

curl -LO --output-dir "$INSTALL_TMP" "https://github.com/starship/starship/releases/latest/download/$STARSHIP_ASSET"
tar xzf "$INSTALL_TMP/$STARSHIP_ASSET" -C "$INSTALL_TMP"
sudo mv "$INSTALL_TMP/starship" /usr/local/bin/
sudo chmod +x /usr/local/bin/starship
starship --version
# NOTE: artifacts left in $INSTALL_TMP for manual inspection if needed.

# Append starship init to ~/.bashrc (idempotent).
STARSHIP_INIT_MARKER="# >>> starship init >>>"
if ! grep -qF "$STARSHIP_INIT_MARKER" "$BASHRC" 2>/dev/null; then
    cat >> "$BASHRC" <<EOF

# >>> starship init >>>
export STARSHIP_HOST="\$(hostname -I | awk '{print \$1}')"
eval "\$(starship init bash)"
# <<< starship init <<<
EOF
    echo "starship init added to $BASHRC"
else
    echo "starship init already present in $BASHRC"
fi

# Create starship config directory and default config.
STARSHIP_CONFIG_DIR="$HOME/.config"
mkdir -p "$STARSHIP_CONFIG_DIR"
STARSHIP_TOML="$STARSHIP_CONFIG_DIR/starship.toml"
if [ ! -f "$STARSHIP_TOML" ]; then
    cat > "$STARSHIP_TOML" <<'EOF'
format = """
[┌──╲](bold green)$username[@](bold green)$env_var[\\)─\\[](bold green)$directory[╲]](bold green)$git_branch$git_status
[└─](bold green)$character"""

[character]
success_symbol = "[\\$](bold green)"
error_symbol = "[\\$](bold green)"
format = "$symbol "

[username]
show_always = true
format = "[$user](bold cyan)"

[env_var]
variable = "STARSHIP_HOST"
default = "localhost"
format = "[$env_value](bold 208)"

[directory]
format = "[$path](bold yellow)"
truncation_length = 0
truncate_to_repo = false

[git_branch]
format = "[-\\(](bold green)[$branch](bold blue)"

[git_status]
format = "[$all_status](bold blue)[\\)](bold green)"
conflicted = "|MERGE"
modified = "|*"
staged = "|*"
untracked = ""
deleted = ""
renamed = ""
stashed = ""
ahead = ""
behind = ""
diverged = ""
EOF
    echo "starship config created at $STARSHIP_TOML"
else
    echo "starship config already exists at $STARSHIP_TOML"
fi

# ----------------------------------------------------------------------------
# Feature 8: Install Btop (System Monitor)
# Downloads the latest btop release for the host architecture.
# ----------------------------------------------------------------------------
BTOP_ARCH="$(uname -m)"
case "$BTOP_ARCH" in
    x86_64)  BTOP_ASSET="btop-x86_64-linux-musl.tbz" ;;
    aarch64) BTOP_ASSET="btop-aarch64-linux-musl.tbz" ;;
    *)
        echo "Error: Unsupported architecture: $BTOP_ARCH"
        exit 1
        ;;
esac

curl -LO --output-dir "$INSTALL_TMP" "https://github.com/aristocratos/btop/releases/latest/download/$BTOP_ASSET"
tar xf "$INSTALL_TMP/$BTOP_ASSET" -C "$INSTALL_TMP"
sudo mv "$INSTALL_TMP/btop/bin/btop" /usr/local/bin/
echo "btop installed: $(btop --version)"
# NOTE: extracted btop directory will be removed at end of script with $INSTALL_TMP cleanup.

# ----------------------------------------------------------------------------
# Feature 9: Vim Configuration
# Installs vim (if missing) and writes ~/.vimrc with default settings.
# ----------------------------------------------------------------------------
sudo apt install -y vim

VIMRC="$HOME/.vimrc"
if [ ! -f "$VIMRC" ]; then
    cat > "$VIMRC" <<'EOF'
syntax on            " enable syntax highlighting
set tabstop=2        " tab width displayed as 2 spaces
set shiftwidth=2     " indentation width for >> and <<
set expandtab        " convert tabs to spaces
set autoindent       " auto-indent new lines
set hlsearch         " highlight all matches of last search
set ignorecase       " case-insensitive search by default
set smartcase        " case-sensitive only if uppercase is present
set mouse=a          " enable mouse in all modes
set noswapfile       " do not create .swp recovery files
set wrap             " wrap long lines visually
set number           " show absolute line numbers
set relativenumber   " show relative line numbers
EOF
    echo "vim config created at $VIMRC"
else
    echo "vim config already exists at $VIMRC"
fi

# ----------------------------------------------------------------------------
# Feature 10: Shell Aliases
# Appends common aliases to ~/.bashrc (idempotent: skips if already added).
# ----------------------------------------------------------------------------
ALIASES_MARKER="# >>> shell aliases >>>"
if ! grep -qF "$ALIASES_MARKER" "$BASHRC" 2>/dev/null; then
    cat >> "$BASHRC" <<'EOF'

# >>> shell aliases >>>
alias ll="ls -al"
alias c="clear"
# <<< shell aliases <<<
EOF
    echo "shell aliases added to $BASHRC"
else
    echo "shell aliases already present in $BASHRC"
fi

# ----------------------------------------------------------------------------
# Feature 11: Reload Shell Config
# Sources ~/.bashrc so y() and starship are available in the current shell.
# ----------------------------------------------------------------------------
source "$BASHRC"
echo "Done."
rm -rf "$INSTALL_TMP"
echo "Cleaned up: $INSTALL_TMP"
