{ lib, pkgs, ... }:
{
  imports = [
    ./hypr.nix
    ./runner.nix
    ./statbar.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    # use USWM instead
    systemd.enable = false;
  };

  home.packages = with pkgs; [
    hyprland-qtutils
    hyprland-protocols

    # terminal
    kitty

    # file managers
    yazi
    kdePackages.dolphin
  ];

  services.hyprpolkitagent.enable = true;
}
