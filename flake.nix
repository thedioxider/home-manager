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
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.53.3";
      # does not work on unstable yet
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    hyprland-split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
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
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (self: super: {
            stable = import inputs.nixpkgs-stable {
              inherit (self.stdenv.hostPlatform) system;
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

            ### Programs & Environment
            ./env.nix

            ### Fish configs
            ./fish.nix

            ### Dependencies for correct work of neovim distro
            ./neovim.nix

            ### Helix and languages
            ./helix.nix

            ### Hyprland
            ./hyprland

            ### Other
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            inputs.nix-sweep.homeModules.default
            inputs.hyprland.homeManagerModules.default
          ];

          extraSpecialArgs = {
            inherit inputs;
          }
          // args;
        };
    };
}
