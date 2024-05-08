#!/bin/bash

# Define installation directory and GitHub repo
INSTALL_DIR="$HOME/Scripts"
REPO_URL="https://github.com/emm-jay-ahh/kali-setup-scripts.git"

# Install git if not installed
if ! command -v git &>/dev/null; then
    echo "Git is not installed. Installing now..."
    sudo apt-get update && sudo apt-get install git
fi

# Clone the repository
if [ ! -d "$INSTALL_DIR" ]; then
    git clone "$REPO_URL" "$INSTALL_DIR"
else
    echo "Update existing repository"
    git -C "$INSTALL_DIR" pull
fi

# Make scripts executable
chmod 700 "$INSTALL_DIR/set_ip.sh"
chmod 700 "$INSTALL_DIR/set_ip_completion.sh" # Adapt if Zsh completion

# Update .zshrc to include new functions and source completion script
echo "Updating Zsh profile..."
if ! grep -q 'myipexport()' "$HOME/.zshrc"; then
    cat <<EOF >> "$HOME/.zshrc"

# Function to export IP
source "$INSTALL_DIR/set_ip.sh"
source "$INSTALL_DIR/set_ip_completion.sh"
EOF
fi

# Apply changes
source "$HOME/.zshrc"

echo "Setup completed successfully."
