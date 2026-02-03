{
  description = "Home Manager configuration of Diomentia";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.dio = let
        args = rec {
          username = "dio";
          homeDirectory = "/home/${username}";
          globLink = config: path:
            config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.hm/${path}";
        };
      in home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ### Main configurations
          ./home.nix

          ### Programs & Environment
          ./env.nix

          ### Dependencies for correct work of neovim distro
          ./neovim.nix

          ### Hyprland
          ./hyprland

          ### Other
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
        ];

        extraSpecialArgs = { inherit inputs; } // args;
      };
    };
}
