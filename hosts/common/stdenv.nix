{ pkgs, inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs; };
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
  # gnupg pinentry is also used for yubikey-agent.
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gtk2;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
}
