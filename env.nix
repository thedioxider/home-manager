{ lib, pkgs, ... }: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
      "vscode"
      "obsidian"
      "blender"
      "cuda_cudart"
      "cuda_nvcc"
      "cuda_cccl"
      "android-studio-stable"
      "steam"
      "steam-unwrapped"
      "aseprite"
    ];

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
    adwaita-icon-theme
    inkscape
    vlc
    rpi-imager
    nmap
    amneziawg-go
    amneziawg-tools
    android-studio
    steam
    aseprite
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
    nix-your-shell.enable = true;
    nix-your-shell.enableFishIntegration = true;
  };

  services.flatpak = {
    enable = true;
    packages = [ "app.zen_browser.zen" ];
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
  };
  services.syncthing = {
    enable = true;
    tray.enable = true;
  };
}
