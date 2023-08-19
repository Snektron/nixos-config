{ inputs, config, lib, pkgs, ...}: {
  imports = [
    ./graphical.nix
  ];

  home.packages = let
    pkgs_2205 = inputs.nixpkgs_2205.outputs.legacyPackages.x86_64-linux;
  in [
    pkgs_2205.remmina
    pkgs.virt-manager
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

  services.kanshi.profiles = {
    undocked = {
      outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          mode = "2560x1440@60Hz";
          position = "0,0";
        }
      ];
    };
    amsterdamOffice = {
      outputs = [
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
    homeLora = {
      outputs = [
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
    homePython = {
      outputs = [
        {
          criteria = "DP-1";
          status = "enable";
          mode = "2560x1440@144Hz";
          position = "0,0";
        }
        {
          criteria = "DP-2";
          status = "enable";
          mode = "1920x1080@144Hz";
          position = "2560,200";
        }
      ];
    };
  };
}
