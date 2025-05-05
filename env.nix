{ lib, pkgs, ... }: {
### Programs & Environment
  home.packages = with pkgs; [
      kitty
      chezmoi
      kdePackages.filelight
      telegram-desktop
      spotify
  ];
}
