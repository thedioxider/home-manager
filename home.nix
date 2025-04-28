{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
    ];

    username = "dio";
    homeDirectory = "/home/dio";

    stateVersion = "24.11";
  };
}
