#!/usr/bin/env bash
# Update and upgrade
dnf update && dnf upgrade

# User management
dnf install -y passwd cracklib-dicts

# zsh
dnf install -y zsh
dnf install -y file # needed for zinit extract
dnf install -y findutils # needed for fzf
dnf install -y wget # needed for code

## TODO
# Missing chsh
# 
