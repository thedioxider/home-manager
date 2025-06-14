{ lib, pkgs, ... }:
let nix-flatpak = builtins.getFlake "github:gmodena/nix-flatpak";
in {
  imports = [ nix-flatpak.homeManagerModules.nix-flatpak ];

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
    findutils.locate
    bluez
    blueman
    arduino-ide
    bottles
    obs-studio
    inkscape
  ];

  programs = {
    home-manager.enable = true;
    yazi.enable = true;
    firefox.enable = true;
    vscode = {
      enable = true;
      # package = pkgs.vscodium;
    };
    tealdeer.enable = true;
    pandoc.enable = true;
  };

  services.flatpak.enable = true;
  services.flatpak.packages = [ "app.zen_browser.zen" ];
  services.syncthing = {
    enable = true;
    tray.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
      "vscode"
      "obsidian"
      "blender"
      "cuda_cudart"
      "cuda_nvcc"
      "cuda_cccl"
    ];
}
