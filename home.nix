{ lib, pkgs, ... }: {
  imports = [
    ### Programs & Environment
    ./env.nix

    ### Dependencies for correct work of neovim distro
    ./neovim.nix

    ### Hyprland
    ./hyprland
  ];

  home = {
    username = "dio";
    homeDirectory = "/home/dio";
  };

  # services.home-manager.autoExpire
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    persistent = true;
    options = "--delete-older-than 30d";
  };

  home.stateVersion = "25.11";
}
