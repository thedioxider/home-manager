{
  config,
  globLink,
  ...
}:
{
  ### XDG config symlinks (globLink -> ~/.config/)
  xdg.configFile = {
    kitty = {
      source = globLink config "config/kitty";
      recursive = true;
    };
  };
}
