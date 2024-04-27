{ pkgs, ... }: {
  ## Desktop Environment
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

    config.common.default = "*";
  };

  programs.xwayland.enable = true;

  services.xserver.xkb.options = "caps:hyper,compose:rctrl";
  console.useXkbConfig = true;

  ## Audio
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    settings.General.Disable = "Handsfree"; # Fix shitty audio quality, but disables mic
  };
}
