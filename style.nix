{ pkgs, ... }:
{
  # TODO: customize GTK/Qt theming
  # TODO: customize cursor theme with home.pointerCursor (needs a theme with both hyprcursor and xcursor formats)

  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.bookmarks = [
      "file:///home/dio/Documents"
      "file:///home/dio/Downloads"
      "file:///home/dio/Music"
      "file:///home/dio/Pictures"
      "file:///home/dio/Videos"
    ];
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze-dark";
  };
}
