{ pkgs, ... }:
{
  services = {
    flatpak = {
      enable = true;
      packages = [
        "app.zen_browser.zen"
        "org.onlyoffice.desktopeditors"
      ];
      update.auto = {
        enable = true;
        onCalendar = "daily";
      };
    };
    syncthing = {
      enable = true;
      tray.enable = true;
    };
    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      acceleration = "cuda";
    };
  };
}
