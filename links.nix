{
  config,
  globLink,
  homeDirectory,
  ...
}:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  xdg.configFile = {
    kitty = {
      source = globLink config "config/kitty";
      recursive = true;
    };
    "home-manager".source = link "${homeDirectory}/.hm";
  };

  home.file = {
    ".nixos".source = link "/etc/nixos";
  };
}
