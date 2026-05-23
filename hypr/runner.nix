{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Clipboard picker
  rofi-clipboard = pkgs.writeShellScriptBin "rofi-clipboard" ''
    cliphist list | rofi -dmenu -p " Clipboard" | cliphist decode | wl-copy
  '';

  # Hub entries: add/remove lines to extend the menu
  hubEntries = [
    {
      title = "Apps";
      cmd = "rofi-launcher";
    }
    {
      title = "Clipboard";
      cmd = "rofi-clipboard";
    }
    # { title = "WiFi"; cmd = "networkmanager_dmenu"; }
    # { title = "Bluetooth"; cmd = "rofi-bluetooth"; }
    {
      title = "Emoji";
      cmd = "rofimoji";
    }
    # { title = "Power"; cmd = "$HOME/.config/rofi/applets/bin/powermenu.sh"; }
  ];

  rofi-hub = pkgs.writeShellScriptBin "rofi-hub" ''
    choice=$(printf "${lib.concatMapStringsSep "\\n" (e: e.title) hubEntries}" \
      | rofi -dmenu -p "")
    case "$choice" in
      ${lib.concatMapStrings (e: ''
        "${e.title}") ${e.cmd} ;;
      '') hubEntries}
    esac
  '';
in
{
  home.packages = [
    pkgs.rofi
    rofi-hub
    rofi-clipboard
    pkgs.cliphist
    pkgs.rofimoji
    pkgs.rofi-bluetooth
    pkgs.networkmanager_dmenu
  ];

  services.cliphist.enable = true;
}
