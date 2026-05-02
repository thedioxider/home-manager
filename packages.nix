{ pkgs, ... }:
{
  # nixpkgs.config.cudaSupport = true;

  home.packages =
    (with pkgs; [
      python3
      kitty
      trash-cli
      playerctl
      wl-clipboard
      hyprshot
      chezmoi
      kdePackages.filelight
      spotify
      thunderbird
      bitwarden-desktop
      bitwarden-menu
      blender
      texliveMedium
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
      zoom-us
      kdePackages.gwenview
      fd
      fzf
      ripgrep
      lazygit
      gdu
      bottom
      gh
      chromium
    ])
    ++ (with pkgs.unstable; [
      telegram-desktop
      obsidian
      android-studio
    ]);
}
