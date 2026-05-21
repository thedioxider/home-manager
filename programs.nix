{
  pkgs,
  config,
  ...
}:
{
  programs = {
    home-manager.enable = true;
    yazi = {
      enable = true;
      shellWrapperName = "yy";
    };
    firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    };
    vscode = {
      enable = true;
      # package = pkgs.vscodium;
    };
    tealdeer.enable = true;
    pandoc.enable = true;
    # claude-code = {
    #   enable = true;
    #   package = pkgs.unstable.claude-code;
    # };
    distrobox.enable = true;
  };
}
