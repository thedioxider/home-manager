{
  lib,
  inputs,
  ...
}:
{
  sops =
    let
      secrets-store_path = "${inputs.secrets-dir}/sops/store.yaml";
    in
    {
      age.sshKeyPaths = [ "/home/dio/.ssh/id_ed25519" ];
    }
    // lib.optionalAttrs (builtins.pathExists secrets-store_path) {
      defaultSopsFile = secrets-store_path;

      secrets = { };
    };
}
