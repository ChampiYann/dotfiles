#!/usr/bin/env bash
# Update and upgrade
dnf update && dnf upgrade

# User management
dnf install -y passwd cracklib-dicts

# zsh
dnf install -y zsh file
