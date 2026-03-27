{
  description = "Home Manager configuration of Diomentia";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-sweep.url = "github:jzbor/nix-sweep";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      # doesn't work on unstable
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    hyprland.url = "github:hyprwm/Hyprland/v0.54.2";
    hyprland-split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces/v0.54.2";
      inputs.hyprland.follows = "hyprland";
    };
    secrets-dir = {
      url = "path:/home/dio/.secrets";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
            ### Add latest stable channel support
            stable = import inputs.nixpkgs-stable {
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

            ### Fish configs
            ./fish.nix

            ### Dependencies for correct work of neovim distro
            ./neovim.nix

            ### Helix and languages
            ./helix.nix

            ### Hyprland
            ./hypr

            ### Secrets
            ./secrets.nix

            ### Other
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            inputs.nix-sweep.homeModules.default
            inputs.hyprland.homeManagerModules.default
            inputs.sops-nix.homeManagerModules.sops
          ];

          extraSpecialArgs = {
            inherit inputs;
          }
          // args;
        };
    };
}
