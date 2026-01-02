{
  description = "Home Manager configuration of Diomentia";

  inputs = {
    nixos-config.url = "path:/etc/nixos";
    nixpkgs.follows = "nixos-config/nixpkgs";
    home-manager.follows = "nixos-config/home-manager";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.dio = home-manager.lib.homeManagerConfiguration {
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

        extraSpecialArgs = inputs;
      };
    };
}
