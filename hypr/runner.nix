{
  pkgs,
  lib,
  config,
  ...
}:
let
  # --- Style config: change these to pick your look ---
  # Reference: https://github.com/adi1090x/rofi/blob/master/files/
  launcherType = "type-1"; # type-1..7 (5/6/7: image-based)
  launcherStyle = "style-6"; # style-1..15 for type-1/2, fewer for others
  launcherPath = "${config.xdg.configHome}/rofi/launchers/${launcherType}/${launcherStyle}.rasi";
  menuType = "type-1"; # type-1..5 (4/5: image-based)
  menuStyle = "style-3"; # style-1..3
  menuPath = "${config.xdg.configHome}/rofi/applets/${menuType}/${menuStyle}.rasi";

  # --- adi1090x source ---
  adi1090x = pkgs.runCommandLocal "adi1090x-rofi" { } ''
    cp -r ${
      pkgs.fetchFromGitHub {
        owner = "adi1090x";
        repo = "rofi";
        rev = "b0bfe927531e365f009d01810c26878c003f7cb8";
        hash = "sha256-pM183MHOMuKJyLgthozM1MRsmhBM25VQgWc7CmLL2HI=";
      }
    }/files $out
    chmod -R u+w $out
    chmod +x $out/applets/bin/*.sh
    chmod +x $out/launchers/type-*/*.sh
    chmod +x $out/powermenu/type-*/*.sh
    printf 'type="${config.xdg.configHome}/rofi/applets/${menuType}"\nstyle="${menuStyle}.rasi"\n' \
      > $out/applets/shared/theme.bash
  '';

  # --- Clipboard picker ---
  rofi-clipboard = pkgs.writeShellScriptBin "rofi-clipboard" ''
    cliphist list | rofi -dmenu -p " Clipboard" | cliphist decode | wl-copy
  '';

  # --- Hub entries: add/remove lines to extend the menu ---
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
      | rofi -dmenu -p "" \
          -theme "${menuPath}")
    case "$choice" in
      ${lib.concatMapStrings (e: ''
        "${e.title}") ${e.cmd} ;;
      '') hubEntries}
    esac
  '';
in
{
  programs.rofi = {
    enable = true;
    theme = "${launcherPath}";
  };

  home.packages = [
    rofi-hub
    rofi-clipboard
    pkgs.cliphist
    pkgs.rofimoji
    pkgs.rofi-bluetooth
    pkgs.networkmanager_dmenu
  ];

  xdg.configFile = {
    "rofi/applets".source = "${adi1090x}/applets";
    "rofi/launchers".source = "${adi1090x}/launchers";
    "rofi/powermenu".source = "${adi1090x}/powermenu";
    "rofi/colors".source = "${adi1090x}/colors";
  };

  services.cliphist.enable = true;
}
