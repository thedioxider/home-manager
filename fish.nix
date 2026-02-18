{ pkgs, ... }:
{
  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    package = pkgs.stable.fish;
    shellAliases = {
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      plz = "sudo";
      fm = "yazi";
      ew = "trash-put";
    };
    shellInit = ''
      fish_config theme choose "Old School"
    '';
  };
}
