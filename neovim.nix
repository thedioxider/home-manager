{
  config,
  pkgs,
  inputs,
  globLink,
  ...
}:
let
  neovim-nightly = inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  xdg.configFile.nvim.source = globLink config "config/nvim";

  home.file.".nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nvim";

  home.packages = [
    neovim-nightly
  ];
}
