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
    echo "✔ Model $MODEL already installed"
fi

python3 -m venv venv
./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt

mkdir -p ~/.local/bin

cat <<EOF > ~/.local/bin/tuxgpt
#!/usr/bin/env bash
$(pwd)/venv/bin/python $(pwd)/main.py "\$@"
EOF

chmod +x ~/.local/bin/tuxgpt

if ! echo "\$PATH" | grep -q ".local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

echo "finix"
