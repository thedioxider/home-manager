{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.unstable.rofi;
    theme = "lb";
  };
}
