{ lib, pkgs, inputs, ... }:
let
  neovim-nightly =
    inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  home.packages = with pkgs; [
    neovim-nightly
    luajit
    cargo

    # required lazyvim dependencies
    gcc
    git
    tree-sitter

    #optional lazyvim dependencies
    fd
    fzf
    ripgrep
    curl
    lazygit
    ghostscript
    python3
  ];

  home.sessionVariables = { EDITOR = "nvim"; };
}
