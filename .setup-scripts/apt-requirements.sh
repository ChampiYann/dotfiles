#!/usr/bin/env bash
# Update and upgrade
apt update
apt upgrade

# zsh
apt install -y zsh

# Python build requirements
apt install -y build-essential libffi-dev zlib1g-dev libssl-dev