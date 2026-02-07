{ lib, pkgs, inputs, ... }: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    (builtins.elem (lib.getName pkg) ([
      "android-studio"
      "spotify"
      "vscode"
      "obsidian"
      "blender"
      "android-studio-stable"
      "steam"
      "steam-unwrapped"
      "aseprite"
    ] ++ [ "cuda-merged" "libnvjitlink" "libnpp" "cudnn" ]))
    || (builtins.match "^(cuda_[a-z_]+)|(libcu[a-z]+)$" (lib.getName pkg))
    != null;

  # nixpkgs.config.cudaSupport = true;

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
    blender
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
    inputs.nix-sweep.packages.${pkgs.stdenv.hostPlatform.system}.default
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
