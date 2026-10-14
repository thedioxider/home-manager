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
    opencode.enable = true;
    codex.enable = true;
    distrobox = {
      enable = true;
      # distrobox-enter drops host vars starting with `_`; valueless --env forwards the host value
      settings.container_manager_additional_flags = "--env=_JAVA_AWT_WM_NONREPARENTING";
    };
    discord.enable = true;
  };
}
