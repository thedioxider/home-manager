{
  description = "Home Manager configuration of Diomentia";

  inputs = {
    home-manager.url = "home-manager/master";
    nixpkgs.follows = "home-manager/nixpkgs";
    nixpkgs-stable.url = "nixpkgs/nixos-26.05";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    hyprland.url = "github:hyprwm/Hyprland/v0.55.2";
    hyprland-split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces/v0.55.2";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      allowUnfreePredicate = import ./unfree.nix nixpkgs.lib;
      permittedInsecurePackages = [ "electron-39.8.10" ];
      pkgs = import nixpkgs {
        inherit system;
        config = {
          inherit allowUnfreePredicate;
          inherit permittedInsecurePackages;
        };
        overlays = [
          (self: super: {
            ### Add stable channel support
            stable = import nixpkgs-stable {
              inherit (self.stdenv.hostPlatform) system;
              config = {
                inherit permittedInsecurePackages;
                allowUnfreePredicate = import ./unfree.nix self.lib;
              };
            };
          })
        ];
      };
    in
    {
      homeConfigurations.dio =
        let
          args = rec {
            username = "dio";
            homeDirectory = "/home/${username}";
            globLink = config: path: config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.hm/${path}";
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ### Main configurations
            ./home.nix

            ### Environment, Packages, Programs & Services
            ./env.nix
            ./packages.nix
            ./programs.nix
            ./style.nix
            ./services.nix

            ### Symlinks
            ./links.nix

            ### Fish configs
            ./fish.nix

            ### Dependencies for correct work of neovim distro
            ./neovim.nix

            ### Helix and languages
            # ./helix.nix

            ### Hyprland
            ./hypr

            ### Other
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            inputs.hyprland.homeManagerModules.default
          ];

          extraSpecialArgs = {
            inherit inputs;
          }
          // args;
        };
    };
}
