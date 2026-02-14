{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak/";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qml-niri = {
      url = "github:imiric/qml-niri/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
    };
    awww.url = "git+https://codeberg.org/LGFae/awww";
  };

  outputs = {nixpkgs, home-manager, stylix, nix-flatpak, niri, ...} @ inputs: {
    nixosConfigurations.dell = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        niri.nixosModules.niri
        stylix.nixosModules.stylix
        ./configuration.nix
        ./stylix.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.demi = ./home/home.nix;
        }
      ];
    };
  };
}
