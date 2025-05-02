{ lib, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      kdePackages.filelight
      telegram-desktop
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
