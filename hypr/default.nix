{ pkgs, inputs, ... }:
let
  hyprcapture = pkgs.callPackage ./hyprcapture { inherit inputs pkgs; };
  graceful-hyprshutdown = pkgs.writeShellApplication {
    name = "graceful-hyprshutdown";
    runtimeInputs = with pkgs; [ hyprshutdown ];
    text = ''
      if [ -z "''${GRACEFUL_HS_DETACHED:-}" ]; then
        GRACEFUL_HS_DETACHED=1 exec setsid -f "$0" "$@" </dev/null >/dev/null 2>&1
      fi

      post_cmd=""
      args=()
      while [ $# -gt 0 ]; do
        case "$1" in
          -p | --post-cmd)
            post_cmd="$2"
            shift 2
            ;;
          *)
            args+=("$1")
            shift
            ;;
        esac
      done

      marker=$(mktemp -t hyprshutdown-XXXXXX.done)
      rm -f "$marker"
      hyprshutdown --no-fork --post-cmd "touch $marker; $post_cmd" "''${args[@]}"
      sleep 0.5
      [ -e "$marker" ] && exit 0
      systemctl --user start quickshell.service awww.service
    '';
  };
in
{
  imports = [
    ./links.nix
    ./runner.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.buildPlatform.system}.default;
    xwayland.enable = true;
    systemd.enableXdgAutostart = true;

    configType = "lua";
    extraConfig = ''
      require("monitors")

      hl.plugin.load("${
        inputs.hyprland-split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.default
      }/lib/libsplit-monitor-workspaces.so")
      hl.plugin.load("${hyprcapture}/lib/libhyprcapture.so")
      hl.config({ plugin = { hyprcapture = { helper = "${hyprcapture}/bin/hyprcapture-ui" } } })

      local root = debug.getinfo(1, "S").source:match("@(.*/)")
      package.path = package.path .. ";" .. root .. "land/?.lua"
      require("core")
    '';
  };

  home.packages = [
    hyprcapture
    graceful-hyprshutdown
  ]
  ++ (with pkgs; [
    gpu-screen-recorder
    hyprland-qtutils
    hyprland-protocols

    waypaper

    # file managers
    yazi
    nemo-with-extensions

    lm_sensors
  ]);

  services.hyprpolkitagent.enable = true;
  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
  programs.quickshell = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };
  programs.waybar = {
    enable = false;
    # systemd = {
    #   enable = true;
    #   targets = [ "hyprland-session.target" ];
    # };
  };
  services.awww.enable = true;
}
