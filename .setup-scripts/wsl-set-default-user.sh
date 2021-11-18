#!/usr/bin/env bash
# This script sets the current user as default user when starting a new wsl shell.
echo "Current user is: $USER"
_USER=$USER
if [[ "$EUID" -ne 0 ]]; then
    ## Update wsl.conf with default user
    echo "Writing wsl.conf..."
    echo "[user]" | sudo tee -a /etc/wsl.conf
    echo "default=$_USER" | sudo tee -a /etc/wsl.conf
    echo ""
    echo "Don't forget to restart the distro: 'wsl -t <distro>'"
else
    echo "Root is already the default user."
fi