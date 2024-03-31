{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common/boot.nix
    ../common/network.nix
    ../common/desktop.nix
    ../common/printing.nix
    ../common/v4l2.nix
    ../common/stdenv.nix
    ../common/users.nix
    ../common/system.nix
    ../common/nix-config.nix
  ];

  networking.hostName = "python";
  networking.networkmanager.enable = true;

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" "riscv64-linux" ];
    # Something is adding amdgpu here, and by default its listed before vfio. This causes
    # vfio to fail to bind to the GPU: using mkBefore makes sure that it is loaded before the
    # amdgpu driver.
    initrd.kernelModules = lib.mkBefore [ "vfio" "vfio_pci" "vfio_iommu_type1" ];
  };

  ## Filesystem configuration
  fileSystems = {
    "/".options = [ "noatime" "nodiratime" "discard" ];
    # This stupid SSD never works properly
    # "/media/windows" = {
    #   device = "/dev/disk/by-partuuid/02894a88-8159-496a-a7c0-1de93ea44237";
    #   fsType = "ntfs";
    # };
    "/media/windows-extra" = {
      device = "/dev/disk/by-partuuid/c5a88c6c-a473-4b5e-a64d-fd603d1c1ee4";
      fsType = "ntfs";
    };
  };

  ## Video
  services.udev.extraRules = ''
    SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
  '';

  security.pam.loginLimits = [
    { domain = "*"; item = "memlock"; type = "soft"; value = "unlimited"; }
    { domain = "*"; item = "memlock"; type = "hard"; value = "unlimited"; }
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  services.openssh = {
    enable = true;
    allowSFTP = false;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  ## System
  system.stateVersion = "22.11";
}
