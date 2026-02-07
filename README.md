> Proudly sponsored by Claude.

# NixOS Configuration

Multi-machine NixOS configuration using flakes.

## Machines

- **dell**: Main machine (EFI + Btrfs + Windows dual boot)
- **lenovo**: Secondary machine (BIOS + ext4 + 16GB swap)

## Structure
```
.
├── flake.nix                 # Main flake configuration
├── flake.lock                # Locked inputs
├── stylix.nix                # Stylix theming
├── wallpaper.png             # Desktop wallpaper
├── computors/
│   ├── 1/                    # Dell configuration
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── 2/                    # Lenovo configuration
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── shared.nix            # Common settings
│   ├── desktop.nix           # Desktop environment
│   └── gaming.nix            # Gaming packages
└── home/
    ├── home.nix              # Home Manager config
    ├── niri.kdl              # Niri window manager config
    └── quickshell/           # Quickshell configs (auto-synced)
```

## Building

On the Dell machine:
```bash
sudo nixos-rebuild switch --flake .#dell
```

On the Lenovo machine:
```bash
sudo nixos-rebuild switch --flake .#lenovo
```

Or use the helper script:
```bash
./rebuild.sh
```

## Quickshell Config

Quickshell configurations are stored in `home/quickshell/` and automatically synced to `~/.config/quickshell` on both machines.

To update quickshell configs:
1. Edit files in `home/quickshell/`
2. Commit changes to git
3. Pull on other machine
4. Run `./rebuild.sh`

## Initial Setup on New Machine
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./rebuild.sh
```

## Updating
```bash
cd ~/dotfiles
nix flake update  # Update all inputs
./rebuild.sh
```
```

## 4. Add .gitignore

Create `.gitignore`:
```
result
*.swp
*.swo
*~
.DS_Store
