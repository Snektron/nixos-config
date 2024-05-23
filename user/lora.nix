{ inputs, config, lib, pkgs, ...}: {
  imports = [
    ./graphical.nix
  ];

  home.packages = [
    pkgs.remmina
    pkgs.virt-manager
    pkgs.libreoffice
    pkgs.prismlauncher
  ];

  accounts.email = {
    accounts.streamhpc = {
      address = "robin@streamhpc.com";
      smtp.tls.useStartTls = true;

      primary = true;
      flavor = "gmail.com";
    };
  };

  programs.swaybg.image = ../assets/backgrounds/oxybelis.jpg;

  programs.git.userEmail = "robin@streamhpc.com";

  programs.foot.settings.main.monitor-scale = "eDP-1:1, 27GL850:1.7, G2460:1.6, QROM8HA000914:1.5";

  services.kanshi.settings = {
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
          criteria = "Unknown U34P2G1 QROM8HA000914";
          status = "enable";
          mode = "3440x1440@60Hz";
          position = "0,0";
        }
      ];
    };
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
    };
  };

  services.syncthing.enable = true;
}
