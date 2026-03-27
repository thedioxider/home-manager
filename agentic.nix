{
  lib,
  inputs,
  ...
}:
let
  openclaw-secrets_path = "${inputs.secrets-dir}/openclaw.json";
  secrets = builtins.fromJSON (builtins.readFile openclaw-secrets_path);
in
lib.optionalAttrs (builtins.pathExists openclaw-secrets_path) {
  programs.openclaw = {
    enable = true;
    config = {
      gateway = {
        mode = "local";
        auth.token = secrets.gatewayToken;
      };
      channels.telegram = {
        botToken = secrets.telegramToken;
        allowFrom = secrets.telegramAllowFrom;
      };
    };
  };
}
