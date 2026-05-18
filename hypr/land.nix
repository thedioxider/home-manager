{
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    extraConfig = "# lua";
  };

  xdg.configFile."hypr/hyprland.lua".text = ''
    hl.plugin.load("${
      inputs.hyprland-split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.default
    }/lib/libsplit-monitor-workspaces.so")
    local root = debug.getinfo(1, "S").source:match("@(.*/)")
    package.path = package.path .. ";" .. root .. "land/?.lua"
    require("land/core")
  '';
}
