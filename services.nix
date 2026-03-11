{ ... }:
{
  services = {
    flatpak = {
      enable = true;
      packages = [ "app.zen_browser.zen" ];
      update.auto = {
        enable = true;
        onCalendar = "daily";
      };
    };
    syncthing = {
      enable = true;
      tray.enable = true;
    };
  };
}
