{
  config,
  pkgs,
  globLink,
  ...
}:
{
  programs = {
    home-manager.enable = true;
    yazi = {
      enable = true;
      package = pkgs.unstable.yazi;
      shellWrapperName = "yy";
    };
    firefox.enable = true;
    vscode = {
      enable = true;
      # package = pkgs.vscodium;
    };
    tealdeer.enable = true;
    pandoc.enable = true;
    claude-code = {
      enable = true;
      package = pkgs.unstable.claude-code;
    };
  };

  xdg.configFile.eww = {
    source = globLink config "config/eww";
  };

  xdg.configFile.kitty = {
    source = globLink config "config/kitty";
    recursive = true;
  };
}
