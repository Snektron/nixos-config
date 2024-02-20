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
    nvidiaPackages.stable = supernv.nvidiaPackages.stable.overrideAttrs (old: rec {
      version = "545.29.06";
      name = "nvidia-x11-${version}";
      src = self.fetchurl {
        url = "https://us.download.nvidia.com/XFree86/Linux-x86_64/550.40.07/NVIDIA-Linux-x86_64-550.40.07.run";
        hash = "sha256-KYk2xye37v7ZW7h+uNJM/u8fNf7KyGTZjiaU03dJpK0=";
      };
    });
    nvidia_x11 = selfnv.nvidiaPackages.stable;
  });

  meld = super.meld.overrideAttrs (old: {
    version = "git";
    src = self.fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "meld";
      rev = "2f7dbdedd2b022fce238ba25e182929e0a8cea1e";
      hash = "sha256-wbY/k3qs8EK96aRkaJpthjhjk7EKohE3HOJMex58v9A=";
    };
  });

  # Patch teamspeak postgresql plugin to use host instead of hostaddr, so that we can use
  # unix domain sockets with it.
  teamspeak_server = super.teamspeak_server.overrideAttrs (old: {
    postInstall = ''
      sed --in-place= 's/hostaddr=/    host=/' $out/lib/teamspeak/libts3db_postgresql.so
    '';
  });
}
