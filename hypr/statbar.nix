{
  config,
  pkgs,
  globLink,
  ...
}:
{
  programs.quickshell = {
    enable = true;
    package = pkgs.unstable.quickshell;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };

  xdg.configFile.quickshell = {
    source = globLink config "config/quickshell";
    recursive = true;
  };

  programs.waybar = {
    enable = true;
    package = pkgs.unstable.waybar;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };

  xdg.configFile.waybar = {
    source = globLink config "config/waybar";
    recursive = true;
  };

  home.packages = with pkgs; [ lm_sensors ];
}
