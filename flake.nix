{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
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

  outputs = {nixpkgs, home-manager, catppuccin, niri, ...} @ inputs: {
    nixosConfigurations.sys1 = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        catppuccin.nixosModules.catppuccin
        ./systems/1/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit inputs; self = inputs.self; };
          home-manager.sharedModules = [ catppuccin.homeModules.catppuccin ];
          home-manager.users.demi = ./home/home.nix;
        }
      ];
    };
    nixosConfigurations.sys2 = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
	catppuccin.nixosModules.catppuccin
	./systems/2/configuration.nix
	home-manager.nixosModules.home-manager
	{
	  home-manager.extraSpecialArgs = { inherit inputs; self = inputs.self; };
	  home-manager.sharedModules = [ catppuccin.homeModules.catppuccin ];
	  home-manager.users.demi = ./home/home.nix;
	}
      ];
    };
  };
}
