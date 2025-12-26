#!/bin/bash

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



if ! command -v ollama &> /dev/null; then
    echo "not Ollama"
    if [ "$DISTRO" = "arch" ]; then
        echo "sudo pacman -S ollama"
    else
        echo "curl -fsSL https://ollama.com/install.sh | sh"
    fi
    exit 1
fi

python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

mkdir -p ~/.local/bin
cp tuxgpt ~/.local/bin/
chmod +x ~/.local/bin/tuxgpt

echo "finix"
echo "tuxgpt"
