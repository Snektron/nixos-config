{ lib, pkgs, config, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 8;
      efi.canTouchEfiVariables = true;
    };

    tmp.cleanOnBoot = true;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };
}
