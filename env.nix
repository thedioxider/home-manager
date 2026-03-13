{ pkgs, ... }:
{
  home.sessionVariables = {
    EDITOR = "hx";
  };

  xdg = {
    enable = true;

    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = [
        "hyprland"
        "gtk"
      ];
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };

    mime.enable = true;
  };
}
