{ pkgs, lib, inputs, ... }: {
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
  # fix 'agent 13: pin prompt: pinentry: unexpected response: "S ERROR qt.isatty 83918950 "'
  systemd.user.services.yubikey-agent = {
    wantedBy = lib.mkForce [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };
  # gnupg pinentry is also used for yubikey-agent.
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gtk2;

  programs.adb.enable = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
}
