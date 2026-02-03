{ lib, pkgs, username, homeDirectory, ... }: {
  home = {
    inherit username;
    inherit homeDirectory;
  };

  services.nix-sweep = {
    enable = true;
    interval = "weekly";
    removeOlder = "7d";
    keepMin = 5;
    keepMax = 30;
  };

  home.stateVersion = "25.11";
}
