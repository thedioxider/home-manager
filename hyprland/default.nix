{ lib, pkgs, ... }: {
  imports = [ ./hypr.nix ./runner.nix ./statbar.nix ];

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

    # file manager
    yazi
  ];

  services.hyprpolkitagent.enable = true;
}
