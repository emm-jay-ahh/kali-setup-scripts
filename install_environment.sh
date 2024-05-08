#!/bin/bash

# Define installation directory and GitHub repo
INSTALL_DIR="$HOME/Scripts"
REPO_URL="https://github.com/emm-jay-ahh/kali_setup_scripts.git"

# Install git if not installed
if ! command -v git &>/dev/null; then
    echo "Git is not installed. Installing now..."
    sudo apt-get update && sudo apt-get install git
fi

# Clone the repository or update if it already exists
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"  # Ensure the directory exists
    git clone "$REPO_URL" "$HOME/kali_setup_scripts" # Clone to a temporary directory
    cp -r "$HOME/kali_setup_scripts/Scripts/"* "$INSTALL_DIR" # Copy only the Scripts folder
    rm -rf "$HOME/kali_setup_scripts"  # Clean up temporary directory
else
    echo "Updating existing scripts"
    # Pull and update approach
    git clone "$REPO_URL" "$HOME/kali_setup_scripts" # Clone to a temporary directory
    cp -r "$HOME/kali_setup_scripts/Scripts/"* "$INSTALL_DIR" # Update scripts
    rm -rf "$HOME/kali_setup_scripts"  # Clean up temporary directory
fi

# Make scripts executable
chmod +x "$INSTALL_DIR/set_ip.sh"
chmod +x "$INSTALL_DIR/set_ip_completion.sh" # Adjust if Zsh completion script is different

# Update .zshrc to include new functions and source completion script
echo "Updating Zsh profile..."
# Check and add myipexport function if not exists
if ! grep -Fxq "myipexport()" "$HOME/.zshrc"; then
    cat <<EOF >> "$HOME/.zshrc"

# Function to export IP
myipexport() {
    output=\$("$INSTALL_DIR/set_ip.sh" "\$1" 2>&1)
    exit_status=\$?
    if [ \$exit_status -ne 0 ]; then
        echo "Error: \$output"
    else
        eval "\$output"
        echo "Net Adaptor: \$1"
        echo "IP Address: \$MYIP"
    fi
}
EOF
fi

# Check and source the IP address completion script if not already sourced
if ! grep -Fxq "source \"$INSTALL_DIR/set_ip_completion.sh\"" "$HOME/.zshrc"; then
    echo "source \"$INSTALL_DIR/set_ip_completion.sh\"" >> "$HOME/.zshrc"
fi

# Apply changes
source "$HOME/.zshrc"

echo "Setup completed successfully."
