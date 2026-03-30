{
  pkgs,
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

  programs.waybar = {
    enable = true;
    package = pkgs.unstable.waybar;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };

  home.packages = with pkgs; [ lm_sensors ];
}
