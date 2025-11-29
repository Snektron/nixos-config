{ inputs, config, lib, pkgs, ...}: {
  imports = [
    ./graphical.nix
  ];

  home.packages = [
    pkgs.remmina
    pkgs.virt-manager
    pkgs.libreoffice
    pkgs.prismlauncher
    pkgs.freecad
    (pkgs.mattermost-desktop.overrideAttrs (old: {
      patches = (old.patches or []) ++ [ ../patches/0001-open-jitsi-urls-in-external-browser.patch ];
    }))
  ];

  accounts.email = {
    accounts.streamhpc = {
      address = "robin@streamhpc.com";
      realName = "Robin Voetter";
      smtp.tls.useStartTls = true;

      primary = true;
      flavor = "gmail.com";
    };
  };

  programs.swaybg.image = ../assets/backgrounds/oxybelis.jpg;

  programs.git.settings.user.email = "robin@streamhpc.com";

  programs.jujutsu.settings.user.email = "robin@streamhpc.com";

  programs.foot.settings.main.monitor-scale = "eDP-1:1, 27GL850:1.7, G2460:1.6, PL3494WQ:1.5";

  services.kanshi.settings = [
    {
      profile.name = "undocked";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          mode = "2560x1440@60Hz";
          position = "0,0";
        }
      ];
    }
    {
      profile.name = "amsterdamOffice";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          mode = "2560x1440@60Hz";
          position = "440,1440";
        }
        {
          criteria = "HDMI-A-1";
          status = "enable";
          mode = "3440x1440@60Hz";
          position = "0,0";
        }
      ];
    }
    {
      profile.name = "home";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          mode = "2560x1440@60Hz";
          position = "0,1440";
        }
        {
          criteria = "Goldstar Company Ltd 27GL850 011NTABE4544";
          status = "enable";
          mode = "2560x1440@60Hz";
          position = "0,0";
        }
      ];
    }
    {
      profile.name = "home2";
      profile.outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          mode = "2560x1440@60Hz";
          position = "0,1440";
        }
        {
          criteria = "Goldstar Company Ltd 27GL850 011NTABE4544";
          status = "enable";
          mode = "2560x1440@60Hz";
          position = "0,0";
        }
        {
          criteria = "AOC G2460 0x000002C3";
          status = "enable";
          mode = "1920x1080@60Hz";
          position = "2560,200";
        }
      ];
    }
  ];

  services.syncthing.enable = true;
}
