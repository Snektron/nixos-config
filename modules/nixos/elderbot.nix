{ inputs, pkgs, config, lib, ... }:
let
  cfg = config.services.elderbot;
  elderbot = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.elderbot;
in with lib; {
  options.services.elderbot = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, start the ElderBot server.
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
    systemd.services.elderbot = {
      description = "ElderBot server service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        LoadCredentialEncrypted = [ "elderbot-tg-token:${cfg.tokenCred}" ];
        ExecStart = "${elderbot}/bin/elderbot $''{CREDENTIALS_DIRECTORY}/elderbot-tg-token";
        DynamicUser = true;
        CacheDirectory = "elderbot";
        WorkingDirectory = "%C/elderbot";
      };
    };
  };
}
