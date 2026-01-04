{ config, lib, pkgs, ... }: {
  # programs.eww = {
  #   enable = true;
  #   configDir = ./config/eww;
  # };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "wayland-session@Hyprland.target";
    };
  };

  xdg.configFile.waybar = {
    source = config.lib.file.mkOutOfStoreSymlink ./config/waybar;
    recursive = true;
  };

  home.packages = with pkgs; [ lm_sensors ];
}
