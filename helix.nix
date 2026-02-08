{
  config,
  lib,
  pkgs,
  globLink,
  ...
}:
{
  xdg.configFile."helix/config.toml".source = globLink config "config/helix/config.toml";
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [ ];
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt;
      }
    ];
  };
}
