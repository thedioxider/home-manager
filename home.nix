{ lib, pkgs, ... }: {
  imports = [
    ./neovim.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    packages = with pkgs; [
      kitty
      chezmoi
      kdePackages.filelight
      telegram-desktop
      spotify
    ];

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
