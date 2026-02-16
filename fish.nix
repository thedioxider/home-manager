{ ... }:
{
  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    shellAliases = {
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      plz = "sudo";
      fm = "yazi";
      ew = "trash put";
    };
  };
}
