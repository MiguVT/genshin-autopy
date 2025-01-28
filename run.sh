#!/bin/bash

# Determine system architecture
ARCH=$(uname -m)

# Prompt to install Python if not installed
if ! command -v python3 &> /dev/null; then
    echo "Python is not installed."
    read -p "Would you like to install Python? (Y/N): " installPython
    if [[ "$installPython" =~ ^[Yy]$ ]]; then
        echo "Installing Python for architecture: $ARCH..."
        if [[ "$ARCH" == "x86_64" ]]; then
            sudo apt update && sudo apt install -y python3 python3-venv python3-pip
        elif [[ "$ARCH" == "arm64" ]]; then
            sudo apt update && sudo apt install -y python3 python3-venv python3-pip
        elif [[ "$ARCH" == "armv7l" ]]; then
            sudo apt update && sudo apt install -y python3 python3-venv python3-pip
        else
            echo "Unsupported architecture. Please install Python manually."
            exit 1
        fi
        echo "Python successfully installed."
    else
        echo "Python installation skipped. Please install Python manually."
        exit 1
    fi
fi

# Check if pip exists
if ! command -v pip3 &> /dev/null; then
    echo "Pip is not installed. Installing pip..."
    python3 -m ensurepip --default-pip
    python3 -m pip install --upgrade pip
    echo "Pip successfully installed."
fi

# Prompt to install virtualenv if venv is not available
if ! python3 -m venv --help &> /dev/null; then
    echo "The venv module is not available."
    read -p "Would you like to install virtualenv? (Y/N): " installVenv
    if [[ "$installVenv" =~ ^[Yy]$ ]]; then
        echo "Installing virtualenv..."
        python3 -m pip install virtualenv
        echo "Virtualenv installed."
    else
        echo "Virtualenv installation skipped. Please install it manually if required."
        exit 1
    fi
fi

# Check if the virtual environment already exists
if [[ -d "venv_genshin-autopy" ]]; then
    echo "The virtual environment venv_genshin-autopy already exists."
else
    echo "Creating the virtual environment venv_genshin-autopy..."
    python3 -m venv venv_genshin-autopy
    echo "Virtual environment created."
fi

# Activate the virtual environment
source venv_genshin-autopy/bin/activate

# Check if requirements.txt exists
if [[ ! -f "requirements.txt" ]]; then
    echo "requirements.txt is missing. Please ensure it is in the current directory."
    deactivate
    exit 1
fi

# Install requirements
pip install -r requirements.txt
if [[ $? -eq 0 ]]; then
    echo "All requirements from requirements.txt have been successfully installed."
else
    echo "An error occurred while installing packages from requirements.txt."
    deactivate
    exit 1
fi

# Execute the main Python script
if [[ -f "__main__.py" ]]; then
    echo "Running the main Python script..."
    python __main__.py
else
    echo "__main__.py is missing. Please ensure it is in the current directory."
fi

# Deactivate the virtual environment
deactivate
