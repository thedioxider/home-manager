{
  config,
  pkgs,
  globLink,
  ...
}:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "wayland-session@Hyprland.target";
    };
  };

  xdg.configFile.waybar = {
    source = globLink config "config/waybar";
    recursive = true;
  };

  home.packages = with pkgs; [ lm_sensors ];
}
