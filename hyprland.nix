{ lib, pkgs, ... }: {
  imports = [];

  home.packages = with pkgs; [
    # terminal
    kitty

    # other
  ];


  # statusbar
  # programs.waybar.enable = true;

  # launcher
  # programs.rofi.enable = true;

  # notification manager
  # services.dunst.enable = true;

  # file manager
  # programs.yazi.enable = true;

  # lock screen
  # programs.hyprlock.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

    systemd.enable = true;
  };
}
