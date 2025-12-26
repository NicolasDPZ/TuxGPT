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

echo "comand tuxgpt..."
mkdir -p ~/.local/bin

cat <<EOF > ~/.local/bin/tuxgpt
#!/bin/bash
source "\$HOME/TuxGPT/venv/bin/activate"
python "\$HOME/TuxGPT/main.py"
EOF

chmod +x ~/.local/bin/tuxgpt

echo " finix "
echo " tuxgpt "
