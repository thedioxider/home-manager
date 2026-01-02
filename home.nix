{ lib, pkgs, ... }: {
  home = {
    username = "dio";
    homeDirectory = "/home/dio";
  };

  # services.home-manager.autoExpire
  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 30d";
  };

  home.stateVersion = "25.11";
}
