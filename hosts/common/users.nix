{ pkgs, lib, ... }: {
  programs.fish.enable = true;

  users.users = {
    robin = {
      isNormalUser = true;
      description = "Robin Voetter";
      shell = pkgs.fish;
      extraGroups = [ "wheel" "networkmanager" "video" "render" "docker" "dialout" ];
      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDmDV1ugpdlBWD43un00Si/+XyPYyceM8/D8on4s4JlBDTirbwPZ4+3u25iI/mIKrU1FDADSv3XlEfXQ6APihk0="
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAm2kKSQx0i3eYn9S5Wl1rEmO8Yd5JpTAwAdczfa/sCO7bWcSiyFhwiPSGn4gSbXd5QxE0TzxYV1no6oHUGyswU="
      ];
    };
  };
}
