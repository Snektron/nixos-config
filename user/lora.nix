{ config, lib, pkgs, ...}: {
  imports = [
    ./home.nix
  ];

  programs.swaybg.image = ../assets/backgrounds/oxybelis.jpg;

  programs.git.userEmail = "robin@streamhpc.com";

  services.gpg-agent.sshKeys = [ "20084BBCAE601968F2A7C4B52350830A48C015BD" ];

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
