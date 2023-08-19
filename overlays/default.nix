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
    version = "2023.08.08";
    src = super.fetchFromGitHub {
        owner = "mawww";
        repo = "kakoune";
        rev = "e605ad8582d8e015806ed9b4d7aba8ca1ea13d57";
        sha256 = "sha256-RR3kw39vEjsg+6cIY6cK2i3ecGHlr1yzuBKaDtGlOGo=";
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
