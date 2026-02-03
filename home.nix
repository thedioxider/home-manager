{ lib, pkgs, username, homeDirectory, ... }: {
  home = {
    inherit username;
    inherit homeDirectory;
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
