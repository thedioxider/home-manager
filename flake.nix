{
  description = "Home Manager configuration of Diomentia";

  inputs = {
    nixos-config.url = "path:/etc/nixos";
    nixpkgs.follows = "nixos-config/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.dio = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules =
          [ ./home.nix inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

        extraSpecialArgs = inputs;
      };
    };
}
