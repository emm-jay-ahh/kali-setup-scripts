#!/bin/bash

# Define the installation directory explicitly
INSTALL_DIR="$HOME/Scripts"

# Ensure the installation directory exists
mkdir -p "$INSTALL_DIR"

# Make sure scripts are executable
echo "Setting executable permissions for scripts..."
chmod +x "$INSTALL_DIR/set_ip.sh"
chmod +x "$INSTALL_DIR/set_ip_completion.sh"  # Adjust if Zsh completion script is different

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
