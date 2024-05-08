#!/bin/bash

# Check if repository directory was provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_cloned_repo>"
    exit 1
fi

REPO_DIR="$1/Scripts"  # Scripts directory within the cloned repo
INSTALL_DIR="$HOME/Scripts"

# Ensure the installation directory exists
mkdir -p "$INSTALL_DIR"

# Copy scripts to the installation directory
echo "Copying scripts to $INSTALL_DIR..."
if [ -f "$REPO_DIR/set_ip.sh" ]; then
    cp "$REPO_DIR/set_ip.sh" "$INSTALL_DIR/set_ip.sh"
else
    echo "Error: set_ip.sh does not exist in $REPO_DIR."
fi

if [ -f "$REPO_DIR/set_ip_completion.sh" ]; then
    cp "$REPO_DIR/set_ip_completion.sh" "$INSTALL_DIR/set_ip_completion.sh"
else
    echo "Error: set_ip_completion.sh does not exist in $REPO_DIR."
fi

# Make sure scripts are executable
echo "Setting executable permissions for scripts..."
chmod +x "$INSTALL_DIR/set_ip.sh"
chmod +x "$INSTALL_DIR/set_ip_completion.sh"

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
