# Main configuration for the VisionFive 2
{ inputs, lib, config, pkgs, modulesPath, ... }: let
  system = pkgs.system;
  kernel = inputs.nixos-vf2.packages.${system}.kernel;
in {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    ./hardware-configuration.nix
    ../common/users.nix
    ../common/system.nix
    ../common/nix-config.nix
    inputs.nixos-vf2.nixosModules.systemd-boot
  ];

  networking.hostName = "rattlesnake";

  nixpkgs = {
    overlays = [
      # Contains fixes etc for packages on RISC-V.
      inputs.nixos-vf2.overlays.default
    ];
    hostPlatform = "riscv64-linux";
  };

  boot = {
    supportedFilesystems = lib.mkForce [ "vfat" "ext4" ];
    kernelPackages = pkgs.linuxPackagesFor kernel;
    kernelParams = [
      "console=tty0"
      "console=ttyS0,115200"
      "earlycon=sbi"
      "boot.shell_on_fail"
      "clk_ignore_unused" # Causes a hang on some kernels
    ];
    consoleLogLevel = 7;
    initrd.availableKernelModules = [
      "dw_mmc-starfive"
      "motorcomm"
      "dwmac-starfive"
      "cdns3-starfive"
      "jh7110-trng"
      "phy-jh7110-usb"
      "clk-starfive-jh7110-aon"
      "clk-starfive-jh7110-stg"
      "clk-starfive-jh7110-vout"
      "clk-starfive-jh7110-isp"
      "clk-starfive-jh7100-audio"
      "phy-jh7110-pcie"
      "pcie-starfive"
      "nvme"
    ];
    blacklistedKernelModules = [
      "jh7110-crypto" # Crashes
    ];

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 8;
      efi.canTouchEfiVariables = true;
    };
  };

  systemd.services."serial-getty@hvc0".enable = false;

  # If getty is not explicitly enabled, it will not start automatically.
  # https://github.com/NixOS/nixpkgs/issues/84105
  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };

  services.openssh = {
    enable = true;
    allowSFTP = false;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  environment.systemPackages = with pkgs; [
    neofetch
    lshw
    pciutils
    parted
    git
    lm_sensors
  ];

  programs.fish.enable = true;

  system.stateVersion = "23.11";
}
