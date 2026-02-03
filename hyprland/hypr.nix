{ config, pkgs, lib, globLink, ... }: {
  wayland.windowManager.hyprland.settings = {
    source = [ "./land/core.conf" ];
  };

  xdg.configFile."hypr/land" = {
    source = globLink config "hyprland/config/hypr";
    recursive = true;
  };
}
