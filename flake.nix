{
  description = "Home Manager configuration of Diomentia";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/v0.54.2";
    hyprland-split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces/v0.54.2";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      allowUnfreePredicate = import ./unfree.nix nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config = {
          inherit allowUnfreePredicate;
          permittedInsecurePackages = [
            "openclaw-2026.3.12"
          ];
        };
        overlays = [
          (self: super: {
            ### Add unstable channel support
            unstable = import inputs.nixpkgs-unstable {
              inherit (self.stdenv.hostPlatform) system;
              config = { inherit allowUnfreePredicate; };
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
