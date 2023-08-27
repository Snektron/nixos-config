{ config, lib, pkgs, ...}: {
  imports = [
    ./graphical.nix
  ];

  home.packages = with pkgs; [
    teamspeak_client
    ghidra
    rpcs3
    prismlauncher
  ];

  programs.foot.settings.main.monitor-scale = "27GL850:1.5, G2460:1.6";

  programs.swaybg.image = ../assets/backgrounds/mountains.jpg;

  services.kanshi.profiles.home = {
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

  services.syncthing.enable = true;
}
