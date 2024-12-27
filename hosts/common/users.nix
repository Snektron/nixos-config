{ pkgs, lib, config, inputs, ... }: {
  programs.fish.enable = true;

  imports = [
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
  ];

  users.users = {
    robin = {
      isNormalUser = true;
      description = "Robin Voetter";
      shell = pkgs.fish;

      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "render"
        "docker"
        "dialout"
        "kvm"
      ]
      ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
      ++ lib.optionals config.programs.wireshark.enable [ "wireshark " ];

      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDmDV1ugpdlBWD43un00Si/+XyPYyceM8/D8on4s4JlBDTirbwPZ4+3u25iI/mIKrU1FDADSv3XlEfXQ6APihk0="
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAm2kKSQx0i3eYn9S5Wl1rEmO8Yd5JpTAwAdczfa/sCO7bWcSiyFhwiPSGn4gSbXd5QxE0TzxYV1no6oHUGyswU="
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBA0Dp3PJvNa3Kdx4YQrPLqr9je0ctgYKsP+G91g5iIserEoL51IXzP4dQ7JEkRXWLoiLHrYTtTwij/dCb5iBU8A="
      ];
    };
  };
}
