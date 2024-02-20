{ inputs, pkgs, lib, config, ... }: {
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ../common/users.nix
    ../common/network.nix
    ../common/system.nix
    ../common/nix-config.nix
    ../../modules/nixos/pythobot.nix
    ../../modules/nixos/elderbot.nix
    ../../modules/nixos/sneksbot.nix
    ../../modules/nixos/teamspeak3-service.nix
  ];

  boot.tmp.cleanOnBoot = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "taipan";
    domain = "taipan.pythons.space";

    firewall = {
      allowPing = true;
      allowedTCPPorts = [
        80    # HTTP
        443   # HTTPS
        config.services.syncthing.relay.port
        config.services.teamspeak.fileTransferPort
      ];
      allowedUDPPorts = [
        config.services.teamspeak3.defaultVoicePort
      ];
    };
  };

  networking.useDHCP = false;
  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "ens6";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = false;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  services.openssh = {
    enable = true;
    allowSFTP = false;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # nginx complains that this is required.
    commonHttpConfig = "server_names_hash_bucket_size 64;";
  };

  services.syncthing.relay = {
    enable = true;
    port = 22067;
    pools = []; # Don't join any pools
    providedBy = "pythons";
  };

  services.pythobot = {
    enable = true;
    tokenCred = ../../secrets/pythobot-tg-token.cred;
  };

  services.elderbot = {
    enable = true;
    tokenCred = ../../secrets/elderbot-tg-token.cred;
  };

  services.sneksbot = {
    enable = true;
    tokenCred = ../../secrets/sneksbot-tg-token.cred;
  };

  services.teamspeak3 = {
    enable = true;
    dbHost = ""; # Connect via unix socket to the below database.
    database = config.users.users.teamspeak.name;
  };

  services.postgresql = {
    enable = true;
    port = 5432;

    # Only allow unix socket authentication
    authentication = "local sameuser all peer map=superuser_map";

    identMap = ''
      superuser_map root     postgres
      superuser_map postgres postgres
      superuser_map  /^(.*)$ \1
    '';

    ensureDatabases = [
      config.users.users.teamspeak.name
    ];

    ensureUsers = [
      {
        inherit (config.users.users.teamspeak) name;
        ensureDBOwnership = true;
      }
    ];
  };

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.gc = {
    automatic = true;
    dates = "06:00";
  };

  system.stateVersion = "23.11";
}
