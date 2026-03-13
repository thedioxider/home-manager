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
      shellWrapperName = "yy";
    };
    firefox.enable = true;
    vscode = {
      enable = true;
      # package = pkgs.vscodium;
    };
    tealdeer.enable = true;
    pandoc.enable = true;
    eww.enable = true;
    claude-code = {
      enable = true;
    };
  };

  # TODO: customize GTK/Qt theming
  # TODO: customize cursor theme with home.pointerCursor (needs a theme with both hyprcursor and xcursor formats)
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  xdg.configFile.eww = {
    source = globLink config "config/eww";
  };

  xdg.configFile.kitty = {
    source = globLink config "config/kitty";
    recursive = true;
  };
}
