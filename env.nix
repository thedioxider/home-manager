{ lib, pkgs, ... }: {
  ### Programs & Environment
  home.packages = with pkgs; [
    kitty
    wl-clipboard
    chezmoi
    kdePackages.filelight
    telegram-desktop
    spotify
    thunderbird
  ];

  programs = {
    yazi                .enable = true;
    firefox             .enable = true;
  };
}
