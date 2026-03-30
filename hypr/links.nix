{
  config,
  globLink,
  ...
}:
{
  xdg.configFile = {
    "hypr/land" = {
      source = globLink config "config/hypr/land";
      recursive = true;
    };
    "hypr/hypridle.conf".source = globLink config "config/hypr/hypridle.conf";
    "hypr/hyprlock.conf".source = globLink config "config/hypr/hyprlock.conf";

    quickshell = {
      source = globLink config "config/quickshell";
      recursive = true;
    };
    waybar = {
      source = globLink config "config/waybar";
      recursive = true;
    };
  };
}
