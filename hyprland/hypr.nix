{ config, pkgs, ... }: {
  xdg.configFile.hypr = {
    source = ./config/hypr;
    recursive = true;
  };

  wayland.windowManager.hyprland.settings = { source = [ "./core.conf" ]; };
}
