# TODO: modifiable way to fetch the live configs from github
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  neovim-nightly = inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.file.".nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nvim";

  home.packages = [
    neovim-nightly
  ];
}
