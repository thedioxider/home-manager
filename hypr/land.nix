{
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    settings = {
      source = [ "./land/core.conf" ];
    };
    plugins = [
      inputs.hyprland-split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

}
