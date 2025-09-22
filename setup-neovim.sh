#!/usr/bin/env bash
set -e

echo "=== Updating system and installing essential packages ==="
sudo apt update
sudo apt install -y git curl build-essential cmake ninja-build nodejs npm python3 python3-pip python3-venv python3-dev lua5.4 unzip php-cli g++ wget xclip xsel wl-clipboard
# ==========================
# Neovim
# ==========================
if ! command -v nvim &> /dev/null; then
    echo "=== Installing Neovim ==="
    sudo apt install -y neovim
else
    echo "Neovim already installed"
fi

# ==========================
# Python virtual environment for Neovim
# ==========================
VENV_DIR="$HOME/.venv/nvim"
if [ ! -d "$VENV_DIR" ]; then
    echo "=== Creating Python virtual environment at $VENV_DIR ==="
    python3 -m venv "$VENV_DIR"
fi

echo "=== Activating virtual environment and installing Python packages ==="
source "$VENV_DIR/bin/activate"
pip install --upgrade pip
pip install pynvim ipython
deactivate

# Set python3_host_prog for Neovim
mkdir -p "$HOME/.config/nvim"
echo "vim.g.python3_host_prog = '$VENV_DIR/bin/python'" > "$HOME/.config/nvim/init.lua.tmp"

# ==========================
# Go
# ==========================
GO_VERSION="1.21.7"
GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
if [ ! -d "/usr/local/go" ]; then
    echo "=== Installing Go ${GO_VERSION} ==="
    wget "https://go.dev/dl/${GO_TAR}"
    sudo tar -C /usr/local -xzf "${GO_TAR}"
    rm "${GO_TAR}"
fi
export PATH=$PATH:/usr/local/go/bin
echo "Installing gopls..."
go install golang.org/x/tools/gopls@latest

# ==========================
# Node.js global packages (LSPs)
# ==========================
echo "=== Installing Node.js global packages ==="
npm install -g pyright typescript typescript-language-server @volar/server vscode-langservers-extracted bash-language-server intelephense

# ==========================
# Lua language server
# ==========================
LUA_LS_DIR="$HOME/lua-language-server"
if [ ! -d "$LUA_LS_DIR" ]; then
    echo "=== Installing Lua Language Server ==="
    git clone https://github.com/LuaLS/lua-language-server.git "$LUA_LS_DIR"
    cd "$LUA_LS_DIR"
    ./make.sh
    cd -
fi

# ==========================
# Copy init.lua from script location to Neovim config
# ==========================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
if [ -f "$SCRIPT_DIR/init.lua" ]; then
    echo "=== Copying init.lua to ~/.config/nvim/init.lua ==="
    cp "$SCRIPT_DIR/init.lua" "$HOME/.config/nvim/init.lua"
    echo "init.lua copied successfully"
else
    echo "Warning: init.lua not found next to the script"
fi

echo "=== Setup complete ==="
echo "Open Neovim and run :Lazy install to install plugins"

