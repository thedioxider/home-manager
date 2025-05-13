{ lib, pkgs, ... }: {
  ### Programs & Environment
  home.packages = with pkgs; [
    kitty
    trashy
    wl-clipboard
    hyprshot
    chezmoi
    kdePackages.filelight
    telegram-desktop
    spotify
    thunderbird
    bitwarden-desktop
    bitwarden-menu
    vscode
    blender
    obsidian
  ];

  programs = {
    yazi.enable = true;
    firefox.enable = true;
    tealdeer.enable = true;
  };
}
