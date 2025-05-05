{ lib, pkgs, ... }:
let
  neovim-nightly-flake = builtins.getFlake "github:nix-community/neovim-nightly-overlay";
  neovim-nightly = neovim-nightly-flake.packages.${pkgs.system}.default;
in
{
  home.packages = with pkgs; [
    neovim-nightly
    luajit

    # required lazyvim dependencies
    gcc git tree-sitter

    #optional lazyvim dependencies
    fd fzf ripgrep curl lazygit
    ghostscript python3
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
