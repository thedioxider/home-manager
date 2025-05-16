{ config, pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    source = [ "./land/core.conf" ];
  };

  xdg.configFile."hypr/land" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config/hypr;
    recursive = true;
  };
}
