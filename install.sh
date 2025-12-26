#!/bin/bash
set -e

echo "TuxGPT..."

if [ -f /etc/arch-release ]; then
    DISTRO="arch"
elif [ -f /etc/debian_version ]; then
    DISTRO="debian"
else
    echo "not available distro"
    exit 1
fi

echo "Distro: $DISTRO"

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

if ! command -v ollama >/dev/null 2>&1; then
    if [ "$DISTRO" = "debian" ]; then
        if ! command -v curl >/dev/null 2>&1; then
            sudo apt update
            sudo apt install -y curl
        fi
        curl -fsSL https://ollama.com/install.sh | sh
    elif [ "$DISTRO" = "arch" ]; then
        echo "sudo pacman -S ollama"
        exit 1
    fi
fi

until ollama --version &>/dev/null; do
  sleep 4
done

MODEL="llama3"
if ! ollama list | awk '{print $1}' | grep -q "^$MODEL$"; then
    echo "⬇ Downloading model $MODEL..."
    ollama pull "$MODEL"
else
    echo " Model $MODEL already installed"
fi

python3 -m venv "$PROJECT_DIR/venv"
"$PROJECT_DIR/venv/bin/pip" install --upgrade pip
"$PROJECT_DIR/venv/bin/pip" install -r "$PROJECT_DIR/requirements.txt"

mkdir -p ~/.local/bin

cat <<EOF > ~/.local/bin/tuxgpt
#!/usr/bin/env bash
PROJECT_DIR="$PROJECT_DIR"
VENV="\$PROJECT_DIR/venv/bin/python"

if [[ "\$1" == "--help" || "\$1" == "-h" ]]; then
    echo "   TuxGPT - is a terminal ia powered by Ollama "
    echo
    echo "Usage:"
    echo "  tuxgpt"
    echo "  tuxgpt --update"
    echo
    exit 0
fi

if [[ "\$1" == "--update" ]]; then
    echo "Updating TuxGPT..."
    cd "\$PROJECT_DIR" || exit 1
    git pull
    "\$VENV" -m pip install -r requirements.txt
    echo "Updated"
    exit 0
fi

exec "\$VENV" "\$PROJECT_DIR/main.py" "\$@"
EOF

chmod +x ~/.local/bin/tuxgpt

if ! echo "\$PATH" | grep -q ".local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

export PATH="$HOME/.local/bin:$PATH"
echo "finix"
