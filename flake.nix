{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      stylix,
      ...
    }:
    let
      system = "x86_64-linux";
      overlays = [
        (final: prev: {
          hitmarker-fonts = final.callPackage ./modules/hitmarker-fonts.nix { };
        })
      ];
    in
    {
      nixosConfigurations = {
        ultimatum = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            stylix.nixosModules.stylix
            ./machines/ultimatum/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = overlays;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.demi = ./machines/ultimatum/home.nix;
            }
          ];
        };
        #       volcanic = nixpkgs.lib.nixosSystem {
        #         system = "x86_64-linux";
        #         modules = [
        #           ./machines/volcanic/root.nix
        #         ];
        #       };
      };
    };
}
