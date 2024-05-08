#!/usr/bin/env zsh

# Define the installation directory explicitly
INSTALL_DIR="$HOME/Scripts"

# Ensure the installation directory exists
mkdir -p "$INSTALL_DIR" || {
    echo "Failed to create installation directory: $INSTALL_DIR"
    exit 1
}

# Assuming you are running this script from the directory where it resides
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/Scripts"

# Copy all completion scripts to the installation directory
echo "Copying completion scripts to $INSTALL_DIR..."
for file in "$SCRIPT_DIR/_*" ; do
    if [ -f "$file" ]; then
        cp "$file" "$INSTALL_DIR" || {
            echo "Failed to copy file: $file"
            exit 1
        }
        echo "Copied $(basename $file) to $INSTALL_DIR"
    else
        echo "No completion scripts found in $SCRIPT_DIR."
        exit 1
    fi
done

# Make sure scripts are executable
echo "Setting executable permissions for completion scripts..."
chmod +x "$INSTALL_DIR"/_*

# Update .zshrc to include new functions and source completion scripts
echo "Updating Zsh profile..."
# Setup Zsh completions if not already done
if ! grep -Fxq "autoload -Uz compinit && compinit" "$HOME/.zshrc"; then
    echo "fpath+=($INSTALL_DIR)" >> "$HOME/.zshrc"
    echo "autoload -Uz compinit && compinit" >> "$HOME/.zshrc"
fi

# Apply changes
source "$HOME/.zshrc" || {
    echo "Failed to source $HOME/.zshrc. Setup may not be complete."
    exit 1
}

echo "Setup completed successfully."
