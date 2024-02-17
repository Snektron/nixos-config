{ pkgs, inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
  ];

  environment.systemPackages = [
    pkgs.home-manager
  ];

  programs.dconf.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  virtualisation.docker.enable = true;

  services.yubikey-agent.enable = true;
  programs.gnupg.agent.pinentryFlavor = "gtk2";

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
}
