{ pkgs, inputs, ... }:
{
  imports = [
    ./links.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.buildPlatform.system}.default;
    xwayland.enable = true;
    systemd.enableXdgAutostart = true;

    configType = "lua";
    extraConfig = ''
      hl.plugin.load("${
        inputs.hyprland-split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.default
      }/lib/libsplit-monitor-workspaces.so")
      local root = debug.getinfo(1, "S").source:match("@(.*/)")
      package.path = package.path .. ";" .. root .. "land/?.lua"
      require("core")
    '';
  };

  home.packages = with pkgs; [
    hyprland-qtutils
    hyprland-protocols
    hyprshutdown

    # file managers
    yazi
    nemo-with-extensions

    lm_sensors
  ];

  services.hyprpolkitagent.enable = true;
  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
  programs.rofi = {
    enable = true;
    theme = "lb";
  };
  programs.quickshell = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = [ "hyprland-session.target" ];
    };
  };
}
