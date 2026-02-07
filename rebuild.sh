#!/bin/bash

# Detect hostname
HOSTNAME=$(cat /etc/hostname)

echo "Building NixOS configuration for: $HOSTNAME"

case $HOSTNAME in
  "dell")
    sudo nixos-rebuild switch --flake .#dell
    ;;
  "lenovo")
    sudo nixos-rebuild switch --flake .#lenovo
    ;;
  *)
    echo "Unknown hostname: $HOSTNAME"
    echo ""
    echo "Available configurations:"
    echo "  sudo nixos-rebuild switch --flake .#dell"
    echo "  sudo nixos-rebuild switch --flake .#lenovo"
    exit 1
    ;;
esac
