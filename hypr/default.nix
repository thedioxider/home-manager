{ pkgs, inputs, ... }:
{
  imports = [
    ./land.nix
    ./runner.nix
    ./statbar.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.buildPlatform.system}.default;
    xwayland.enable = true;
    systemd.enableXdgAutostart = true;
  };

  home.packages = with pkgs.unstable; [
    hyprland-qtutils
    hyprland-protocols

    # file managers
    yazi
    pkgs.nemo-with-extensions
  ];

  services.hyprpolkitagent.enable = true;
  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
}
