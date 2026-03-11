{ lib, pkgs, ... }:
{
  imports = [
    ./land.nix
    ./runner.nix
    ./statbar.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enableXdgAutostart = true;
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
  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
}
