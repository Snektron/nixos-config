{ config, lib, pkgs, ...}: {
  imports = [
    ./graphical.nix
  ];

  home.packages = with pkgs; [
    teamspeak3
    ghidra
    rpcs3
    prismlauncher
    kicad-unstable # kicad is broken
    freecad
    nvtopPackages.amd
  ];

  programs.foot.settings.main.monitor-scale = "27GL850:1.5, G2460:1.6";

  programs.swaybg.image = ../assets/backgrounds/mountains.jpg;

  services.kanshi.settings = [
    {
      profile.name = "home";
      profile.outputs = [
        {
          criteria = "LG Electronics 27GL850 011NTABE4544";
          status = "enable";
          mode = "2560x1440@144Hz";
          position = "0,0";
        }
        {
          criteria = "AOC G2460 0x000002C3";
          status = "enable";
          mode = "1920x1080@144Hz";
          position = "2560,200";
        }
      ];
    }
  ];

  services.syncthing.enable = true;
}
