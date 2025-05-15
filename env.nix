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
    (blender.override { cudaSupport = true; })
    obsidian
    texlive.combined.scheme-full
  ];

  programs = {
    yazi.enable = true;
    firefox.enable = true;
    vscode = {
      enable = true;
      # package = pkgs.vscodium;
    };
    tealdeer.enable = true;
    pandoc.enable = true;
  };
}
