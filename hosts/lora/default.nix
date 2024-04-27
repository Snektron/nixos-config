{ lib, inputs, config, pkgs, ... }: {
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga401
    ./hardware-configuration.nix
    ../common/boot.nix
    ../common/network.nix
    ../common/desktop.nix
    ../common/v4l2.nix
    ../common/printing.nix
    ../common/stdenv.nix
    ../common/users.nix
    ../common/system.nix
    ../common/nix-config.nix
  ];

  home-manager.users.robin = import ../../user/lora.nix;

  networking.hostName = "lora";
  # networking.networkmanager.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "riscv64-linux" ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.kernelModules = [ "nouveau" ];

  hardware.nvidia = {
    modesetting.enable = true;
    prime.sync.enable = true;
    prime.offload.enable = false;
    powerManagement.enable = true;
    nvidiaSettings = false;
  };
  services.xserver.videoDrivers = lib.mkForce [ "amdgpu" "nouvaeu" ];
  services.supergfxd.enable = false; # Enabled by asus-zephyrus-ga401 profile

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  environment.systemPackages = [ pkgs.virtiofsd ];

  system.stateVersion = "22.11";
}
