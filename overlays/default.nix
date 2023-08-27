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
    nvidiaPackages.stable = supernv.nvidiaPackages.production.overrideAttrs (old: rec {
      version = "535.104.05";
      name = "nvidia-x11-${version}";
      src = self.fetchurl {
        url = "https://us.download.nvidia.com/XFree86/Linux-x86_64/535.104.05/NVIDIA-Linux-x86_64-535.104.05.run";
        hash = "sha256-L51gnR2ncL7udXY2Y1xG5+2CU63oh7h8elSC4z/L7ck=";
      };
    });
    nvidia_x11 = selfnv.nvidiaPackages.stable;
  });

  qemu = super.qemu.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ../patches/pcie-atomic-completion.patch ];
  });
}
