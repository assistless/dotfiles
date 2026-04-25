#!/bin/bash

sudo nixos-rebuild switch --flake ~/dotfiles#nixos
exit_code=$?

if [ $exit_code -eq 0 ]; then
    while true; do
        read -p "Clean up? (y/n): " answer

        case "$answer" in
            y|Y|yes|YES|Yes)
                echo "Cleaning up..."
                sudo nix-collect-garbage -d
                nix-collect-garbage -d
                sudo nix store optimise
                nix store optimise
                echo "Done!"
                exit 0
                ;;
            n|N|no|NO|No)
                echo "Exiting..."
                exit 0
                ;;
            *)
                ;;
        esac
    done
else
    echo "Rebuild failed. Either its a syntax error, spelling error or it spontaneously exploded."
    exit 1
fi
