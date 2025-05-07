{ lib, pkgs, ... }: {
  imports = [
    ### Programs & Environment
    ./env.nix

    ### Dependencies for correct work of neovim distro
    ./neovim.nix

    ### Hyprland
    # ./hyprland.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "dio";
    homeDirectory = "/home/dio";

    stateVersion = "24.11";
  };

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    persistent = true;
    options = "--delete-older-than 30d";
  };
}
