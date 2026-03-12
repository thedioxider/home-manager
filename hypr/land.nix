{
  config,
  pkgs,
  lib,
  globLink,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    settings = {
      source = [ "./land/core.conf" ];
    };
    plugins = [
      inputs.hyprland-split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "hyprland" "gtk" ];
  };

  xdg.configFile."hypr/land" = {
    source = globLink config "config/hypr/land";
    recursive = true;
  };

  xdg.configFile."hypr/hypridle.conf" = {
    source = globLink config "config/hypr/hypridle.conf";
  };

  xdg.configFile."hypr/hyprlock.conf" = {
    source = globLink config "config/hypr/hyprlock.conf";
  };
}
