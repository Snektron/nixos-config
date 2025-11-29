{ inputs, pkgs, config, lib, ... }:
let
  pythobot = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.pythobot;
  cfg = config.services.pythobot;
in with lib; {
  options.services.pythobot = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, start the PythoBot server.
      '';
    };

    tokenCred = mkOption {
      type = types.path;
      description = ''
        Path to a systemd-creds encrypted telegram bot API token.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.pythobot = {
      description = "PythoBot server service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        LoadCredentialEncrypted = [ "pythobot-tg-token:${cfg.tokenCred}" ];
        ExecStart = "${pythobot}/bin/pytho $''{CREDENTIALS_DIRECTORY}/pythobot-tg-token";
        DynamicUser = true;
      };
    };
  };
}
