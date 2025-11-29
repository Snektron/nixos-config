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
          ${pkgs.river-classic}/bin/river
        '';
      in
      {
        command = "${run}";
        user = "robin";
      };
      default_session = initial_session;
    };
  };

  security.pam.services.swaylock = {};

  services.dbus.enable = true;

  environment.systemPackages = [
    pkgs.xdg-utils
  ];

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
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # Stop applications from switching to headset mode by just disabling it all together
    # https://wiki.archlinux.org/title/Bluetooth_headset#Disable_PipeWire_HSP/HFP_profile
    wireplumber.extraConfig.bluetoothEnhancements = {
      "wireplumber.settings" = {
        "bluetooth.autoswitch-to-headset-profile" = false;
      };

      "monitor.bluez.properties" = {
        "bluez.enable-sbc-xq" = false;
        "bluez.enable-msbc" = false;
        "bluez.roles" = [ "a2dp_sink" ]; # Only enable a2dp
      };

      "wh-1000xm3-ldac-hq" = {
        "monitor.bluez.rules" = [
          {
            matches = [
              {
                # Match any bluetooth device with ids equal to that of a WH-1000XM3
                "device.name" = "~bluez_card.*";
                "device.product.id" = "0x0cd3";
                "device.vendor.id" = "usb:054c";
              }
            ];
            actions = {
              update-props = {
                # Set quality to high quality instead of the default of auto
                "bluez5.a2dp.ldac.quality" = "hq";
              };
            };
          }
        ];
      };
    };
  };

  hardware.bluetooth = {
    enable = true;
    settings.General.Disable = "Handsfree"; # Fix shitty audio quality, but disables mic
  };
}
