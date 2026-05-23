{ pkgs, ... }:
{
  # nixpkgs.config.cudaSupport = true;

  home.packages =
    (with pkgs.stable; [
      python3
      kitty
      trash-cli
      playerctl
      wl-clipboard
      hyprshot
      kdePackages.filelight
      thunderbird
      bitwarden-desktop
      bitwarden-menu
      blender
      texliveMedium
      findutils.locate
      bluez
      blueman
      arduino-ide
      obs-studio
      adwaita-icon-theme
      inkscape
      vlc
      rpi-imager
      nmap
      aseprite
      scooter
      picocom
      rshell
      jetbrains.idea-oss
      bc
      xxd
      hexedit
      marktext
      gtk3
      gsettings-desktop-schemas
      libnotify
      kdePackages.gwenview
      fd
      fzf
      ripgrep
      lazygit
      gdu
      bottom
      gh
      chromium
      qdirstat
      deno
    ])
    ++ (with pkgs; [
      telegram-desktop
      obsidian
      android-studio
    ]);
}
