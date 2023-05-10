self: super: {
  # Patch foot with an option that allows per-monitor scaling, so that
  # DPI and stuff isn't so horrible.
  foot = super.foot.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ../patches/foot-per-monitor-scale.patch
    ];
  });

  # Override kakoune to a more recent version so that shift+space works
  kakoune-unwrapped = super.kakoune-unwrapped.overrideAttrs (old: {
    version = "2023.02.12";
    src = super.fetchFromGitHub {
        owner = "mawww";
        repo = "kakoune";
        rev = "3150e9b3cd8e61d9bc68245d67822614d4376cf4";
        sha256 = "sha256-YuoSUk2vjw/waGNRbSdqrCMBiUJWDMCa3iBsFjZCXtM=";
    };
  });

  # Note: We could also just set hardware.nvidia.package, but it seems that some derivations
  # use pkgs.nvidia_x11 directly rather than this option. This makes sure that we catch
  # everything.
  linuxPackages_latest = super.linuxPackages_latest.extend (selfnv: supernv: {
    nvidiaPackages.stable = supernv.nvidiaPackages.latest;
    nvidia_x11 = selfnv.nvidiaPackages.stable;
  });

  qemu = super.qemu.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ../patches/pcie-atomic-completion.patch ];
  });
}
