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

  home.packages = with pkgs; [
    neovim-nightly
    # luajit
    # cargo

    # required lazyvim dependencies
    # gcc
    # git
    # tree-sitter

    #optional lazyvim dependencies
    fd
    fzf
    ripgrep
    curl
    lazygit
    # ghostscript
    # python3
  ];
}
