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
    ../common/gpu.nix
    ../common/nix-config.nix
  ];

  home-manager.users.robin = import ../../user/lora.nix;

  networking.hostName = "lora";
  networking.networkmanager.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "riscv64-linux" ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  hardware.nvidia = {
    modesetting.enable = true;
    prime.sync.enable = true;
    prime.offload.enable = false;
    powerManagement.enable = true;
    nvidiaSettings = false;
    open = false;
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

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  system.stateVersion = "22.11";

  # system.nixos.tags = [ "proprietary" ];

  # system.nixos.tags = lib.mkForce [ "nouveau" ];
  # boot.kernelModules = [ "nouveau" ];
  # services.xserver.videoDrivers = lib.mkForce [ "amdgpu" "nouvaeu" ];
  # services.supergfxd.enable = false; # Enabled by asus-zephyrus-ga401 profile

  # hardware.opengl = {
  #   # Funny unstable mesa version, see overlays/default.nix
  #   package = pkgs.mesa_git.drivers;
  #   package32 = pkgs.pkgsi686Linux.mesa_git.drivers;
  # };

  # specialisation = {
  #   nouveau.configuration = {
  #     system.nixos.tags = lib.mkForce [ "" ];
  #     boot.kernelModules = [ "nouveau" ];
  #     services.xserver.videoDrivers = lib.mkForce [ "amdgpu" "nouvaeu" ];
  #     services.supergfxd.enable = false; # Enabled by asus-zephyrus-ga401 profile

  #     hardware.opengl = {
  #       # Funny unstable mesa version, see overlays/default.nix
  #       package = pkgs.mesa_git.drivers;
  #       package32 = pkgs.pkgsi686Linux.mesa_git.drivers;
  #     };
  #   };
  # };
}
