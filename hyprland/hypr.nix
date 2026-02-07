{ config, pkgs, lib, globLink, inputs, ... }: {
  wayland.windowManager.hyprland = {
    systemd.enable = false;
    settings = { source = [ "./land/core.conf" ]; };
    plugins = [
      inputs.hyprland-split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  xdg.configFile."hypr/land" = {
    source = globLink config "hyprland/config/hypr";
    recursive = true;
  };
}
