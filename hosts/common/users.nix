{ pkgs, ... }: {
  users.users = {
    robin = {
      isNormalUser = true;
      description = "Robin Voetter";
      shell = pkgs.fish;
      extraGroups = [ "wheel" "networkmanager" "video" "render" "docker" "dialout" ];
      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLaACuxmwEyBP1KX5FfGBcdIvGwrqW1LuRSHOp+pm9lOyUl2lsC81P9COnPgYzCS8xpcuqWsoHMAByoXR1J6LNw= YubiKey #23825474 PIV Slot 9a"
      ];
    };
  };
}
