{ inputs, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  ## Boot
  boot.loader = {
    grub = {
      enable = true;
      version = 2;
      device = "nodev";
      efiSupport = true;
    };
    efi.canTouchEfiVariables = true;
  };

  boot = {
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback.out ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    '';
  };

  ## Filesystem configuration
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  ## Networking
  networking.hostName = "python";
  networking.networkmanager.enable = true;

  ## Input
  services.xserver.xkbOptions = "caps:hyper,compose:rctrl";
  console.useXkbConfig = true;

  ## Video
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  programs.xwayland.enable = true;

  services.greetd = {
    enable = true;
    restart = false;
    settings = rec {
      initial_session =
      let
        run = pkgs.writeShellScript "start-river" ''
          # Seems to be needed to get river to properly start
          sleep 1
          # Set the proper XDG desktop so that xdg-desktop-portal works
          # This needs to be done before river is started
          export XDG_CURRENT_DESKTOP=river
          ${pkgs.river}/bin/river
        '';
      in
      {
        command = "${run}";
        user = "robin";
      };
      default_session = initial_session;
    };
  };

  services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  ## Audio
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = false;
    media-session.enable = true;
  };

  hardware.bluetooth.enable = true;

  ## Standard environment
  environment.systemPackages = [
    pkgs.home-manager
  ];

  programs.fish.enable = true;
  programs.dconf.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  ## Misc
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  services.journald.extraConfig = ''
    SystemMaxUse=100M
  '';

  ## Users
  users.users.robin = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "video" "render" "docker" ];
  };

  ## System
  system.stateVersion = "22.11";
}
