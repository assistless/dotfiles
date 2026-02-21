#!/bin/bash
echo "Input flake name: "
read flake

sudo nixos-rebuild switch --flake ~/dotfiles/#$flake
