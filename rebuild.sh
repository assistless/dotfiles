#!/bin/bash

# Detect hostname
HOSTNAME=$(cat /etc/hostname)

echo "Building NixOS configuration for: $HOSTNAME"

case $HOSTNAME in
  "dell")
    sudo nixos-rebuild switch --flake ~/dotfiles#dell
    ;;
  "lenovo")
    sudo nixos-rebuild switch --flake ~/dotfiles#lenovo
    ;;
  *)
    echo "Unknown hostname: $HOSTNAME"
    exit 1
    ;;
esac
