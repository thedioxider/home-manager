{ pkgs, ... }:
{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shellAliases = {
    rm = "rm -i";
    cp = "cp -i";
    mv = "mv -i";
    plz = "sudo";
    fm = "yazi";
    ew = "trash-put";
    e = "nvim";
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

    terminal-exec = {
      enable = true;
      settings = {
        default = [ "kitty.desktop" ];
      };
    };
  };
}
