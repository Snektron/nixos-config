{ pkgs, ... }: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    # Funny unstable mesa version, see overlays/default.nix
    package = pkgs.mesa_git.drivers;
    package32 = pkgs.pkgsi686Linux.mesa_git.drivers;
  };
}

