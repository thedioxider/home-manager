{
  lib,
  pkgs,
  username,
  homeDirectory,
  ...
}:
{
  home = {
    inherit username;
    inherit homeDirectory;
  };

  programs.nh = {
    enable = true;
    homeFlake = "/home/dio/.hm";
    osFlake = "/etc/nixos";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 3 --keep-since 7d";
    };
  };

  # targets.genericLinux.enable = true;

  home.stateVersion = "25.11";
}
