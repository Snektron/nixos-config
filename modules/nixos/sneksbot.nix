{ inputs, pkgs, config, lib, ... }:
let
  cfg = config.services.sneksbot;
  sneksbot = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.sneksbot;
in with lib; {
  options.services.sneksbot = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, start the SneksBot server.
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
    systemd.services.sneksbot = {
      description = "ElderBot server service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        LoadCredentialEncrypted = [ "sneksbot-tg-token:${cfg.tokenCred}" ];
        ExecStart = "${sneksbot}/bin/sneksbot $''{CREDENTIALS_DIRECTORY}/sneksbot-tg-token";
        DynamicUser = true;
      };
    };
  };
}
