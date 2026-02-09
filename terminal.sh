#!/run/current-system/sw/bin/bash

hostname=$(hostname)

if [ "$hostname" = "lenovo" ]; then
    konsole
elif [ "$hostname" = "dell" ]; then
    kitty
else
    exit 1
fi
