{ config, lib, pkgs, globLink, ... }: {
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
    source = globLink config "hyprland/config/waybar";
    recursive = true;
  };

  home.packages = with pkgs; [ lm_sensors ];
}
