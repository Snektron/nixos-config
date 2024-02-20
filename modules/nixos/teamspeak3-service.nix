{ config, lib, pkgs, ... }:

with lib;

let
  ts3 = pkgs.teamspeak_server;
  cfg = config.services.teamspeak3;
  user = "teamspeak";
  group = "teamspeak";
in {
  # This module overrides the standard nixos teamspeak 3 module.
  disabledModules = [
    "services/networking/teamspeak3.nix"
  ];

  options = {
    services.teamspeak3 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run the Teamspeak3 voice communication server daemon.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/teamspeak3-server";
        description = ''
          Directory to store TS3 database and other state/data files.
        '';
      };

      logPath = mkOption {
        type = types.path;
        default = "/var/log/teamspeak3-server/";
        description = ''
          Directory to store log files in.
        '';
      };

      voiceIP = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "0.0.0.0";
        description = ''
          IP on which the server instance will listen for incoming voice connections. Defaults to any IP.
        '';
      };

      defaultVoicePort = mkOption {
        type = types.int;
        default = 9987;
        description = ''
          Default UDP port for clients to connect to virtual servers - used for first virtual server, subsequent ones will open on incrementing port numbers by default.
        '';
      };

      fileTransferIP = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "0.0.0.0";
        description = ''
          IP on which the server instance will listen for incoming file transfer connections. Defaults to any IP.
        '';
      };

      fileTransferPort = mkOption {
        type = types.int;
        default = 30033;
        description = ''
          TCP port opened for file transfers.
        '';
      };

      queryIP = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "0.0.0.0";
        description = ''
          IP on which the server instance will listen for incoming ServerQuery connections. Defaults to any IP.
        '';
      };

      queryPort = mkOption {
        type = types.int;
        default = 10011;
        description = ''
          TCP port opened for ServerQuery connections.
        '';
      };

      dbHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = ''
          The hostname or IP address of your PostgreSQL server
        '';
      };

      dbPort = mkOption {
        type = types.int;
        default = 5432;
        description = ''
          The TCP port of your PostgreSQL server
        '';
      };

      dbUsername = mkOption {
        type = types.str;
        default = user;
        description = ''
          The username used to authenticate with your PostgreSQL server
        '';
      };

      dbPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The password used to authenticate with your PostgreSQL server
        '';
      };

      database = mkOption {
        type = types.str;
        default = "teamspeak";
        description = ''
          The name of a database on your PostgreSQL server. Note that this database must be created
          before the TeamSpeak Server is started.
        '';
      };

      dbTimeout = mkOption {
        type = types.int;
        default = 10;
        description = ''
          The maximum connection timeout in seconds. The minimum setting allowed is 2.
        '';
      };
    };

  };

  config = mkIf cfg.enable {
    users.users.${user} = {
      description = "Teamspeak3 voice communication server daemon";
      group = group;
      uid = config.ids.uids.teamspeak;
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.${group} = {
      gid = config.ids.gids.teamspeak;
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.logPath}' - ${user} ${group} - -"
    ];

    systemd.services.teamspeak3-server = {
      description = "Teamspeak3 voice communication server daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = let
        dbpluginparameter = pkgs.writeText "ts3db_postgresql.ini" ''
          [config]
          host=${cfg.dbHost}
          port=${toString cfg.dbPort}
          username=${cfg.dbUsername}
          password=${optionalString (cfg.dbPassword != null) (toString cfg.dbPassword)}
          database=${cfg.database}
          timeout=${toString cfg.dbTimeout}
        '';
      in {
        ExecStart = ''
          ${ts3}/bin/ts3server \
            dbsqlpath=${ts3}/lib/teamspeak/sql/ logpath=${cfg.logPath} \
            ${optionalString (cfg.voiceIP != null) "voice_ip=${cfg.voiceIP}"} \
            default_voice_port=${toString cfg.defaultVoicePort} \
            ${optionalString (cfg.fileTransferIP != null) "filetransfer_ip=${cfg.fileTransferIP}"} \
            filetransfer_port=${toString cfg.fileTransferPort} \
            ${optionalString (cfg.queryIP != null) "query_ip=${cfg.queryIP}"} \
            query_port=${toString cfg.queryPort} license_accepted=1 \
            dbplugin=ts3db_postgresql dbpluginparameter=${dbpluginparameter} \
            dbsqlcreatepath=create_postgresql
        '';
        WorkingDirectory = cfg.dataDir;
        User = user;
        Group = group;
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ arobyn ];
}
