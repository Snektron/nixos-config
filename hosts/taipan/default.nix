{ inputs, pkgs, lib, ... }: {
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    ../common/users.nix
    ../common/network.nix
    ../common/system.nix
    ../common/nix-config.nix
    ../../modules/nixos/pythobot.nix
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
        22067 # Syncthing relay
      ];
      allowedUDPPorts = [ ];
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

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.gc = {
    automatic = true;
    dates = "06:00";
  };

  system.stateVersion = "23.11";
}
