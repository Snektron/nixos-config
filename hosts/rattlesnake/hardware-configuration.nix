{ config, lib, pkgs, modulesPath, ... }:  {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  hardware.deviceTree.name = "starfive/jh7110-starfive-visionfive-2-v1.2a.dtb";

  boot.initrd.availableKernelModules = [ "xhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f35a30f3-e4c5-4e3e-ab26-5f20292380e4";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4EA4-0FAE";
    fsType = "vfat";
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "riscv64-linux";
}
