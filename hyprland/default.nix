{ lib, pkgs, ... }: {
  imports = [
    ./hypr.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

    # use USWM instead
    systemd.enable = false;
  };

  home.packages = with pkgs; [
    hyprland-qtutils
    hyprland-protocols

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
}
