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



    if [ "$DISTRO" = "debian" ]; then
        if ! command -v curl &> /dev/null; then
            echo "installing curl..."
            sudo apt update
            sudo apt install -y curl
        fi

        echo "installing Ollama..."
        curl -fsSL https://ollama.com/install.sh | sh
    fi

    if [ "$DISTRO" = "arch" ]; then
        echo "install Ollama:"
        echo "sudo pacman -S ollama"
        exit 1
    fi
fi


if ! command -v ollama &> /dev/null; then
    echo "Installing Ollama..."
    if [ "$DISTRO" = "debian" ]; then
        curl -fsSL https://ollama.com/install.sh | sh
    elif [ "$DISTRO" = "arch" ]; then
        echo "Ollama arch"
        echo "   sudo pacman -S ollama"
        exit 1
    fi
else
    echo "Ollama installed"
fi



echo "virtual environment..."
python3 -m venv venv

echo "Python dependencies..."
./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt



echo "tuxgpt command..."

mkdir -p ~/.local/bin

cat > ~/.local/bin/tuxgpt <<EOF
#!/usr/bin/env bash
$(pwd)/venv/bin/python $(pwd)/main.py "\$@"
EOF

chmod +x ~/.local/bin/tuxgpt



if ! echo "\$PATH" | grep -q ".local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo "ℹ Added ~/.local/bin to PATH (restart terminal)"
fi

echo " finix "
echo " tuxgpt "
