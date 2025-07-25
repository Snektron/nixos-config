nixpkgs: self: super: {
  # Patch foot with an option that allows per-monitor scaling, so that
  # DPI and stuff isn't so horrible.
  foot = super.foot.overrideAttrs (old: rec {
    # Also use an older version so that we don't need to
    # update the patches every time
    version = "1.16.2";
    src = self.fetchFromGitea {
      domain = "codeberg.org";
      owner = "dnkl";
      repo = "foot";
      rev = version;
      hash = "sha256-hT+btlfqfwGBDWTssYl8KN6SbR9/Y2ors4ipECliigM=";
    };
    patches = (old.patches or [ ]) ++ [
      ../patches/foot-per-monitor-scale.patch
    ];
  });

  # Note: We could also just set hardware.nvidia.package, but it seems that some derivations
  # use pkgs.nvidia_x11 directly rather than this option. This makes sure that we catch
  # everything.
  linuxPackages_latest = super.linuxPackages_latest.extend (selfnv: supernv: {
    nvidiaPackages.mkDriver = supernv.nvidiaPackages.mkDriver;
    nvidiaPackages.stable = selfnv.nvidiaPackages.mkDriver {
      version = "575.64";
      sha256_64bit = "sha256-6wG8/nOwbH0ktgg8J+ZBT2l5VC8G5lYBQhtkzMCtaLE=";
      openSha256 = "";
      useSettings = false;
      usePersistenced = false;
    };
    nvidiaPackages.production = selfnv.nvidiaPackages.stable;
    nvidiaPackages.beta = selfnv.nvidiaPackages.stable;
    nvidia_x11 = selfnv.nvidiaPackages.stable;
  });

  # Patch teamspeak postgresql plugin to use host instead of hostaddr, so that we can use
  # unix domain sockets with it.
  teamspeak_server = super.teamspeak_server.overrideAttrs (old: {
    postInstall = ''
      sed --in-place= 's/hostaddr=/    host=/' $out/lib/teamspeak/libts3db_postgresql.so
    '';
  });

  river = (super.river.override {
    wlroots_0_18 = self.wlroots_0_19;
  }).overrideAttrs (old: {
    version = "3.11-git";

    src = self.fetchFromGitea {
      domain = "codeberg.org";
      owner = "river";
      repo = "river";
      rev = "fcf8b1e44293875627e1b3b3223809ed01ebfcab";
      hash = "sha256-SyV9FvAcQysLvBJllSUfgDo8dxeV0x3HHedQl1Ysyao=";
    };

    deps = self.callPackage ./river.zig.zon.nix {
      zig = self.zig_0_14;
    };
  });

  mesa_git = (super.mesa.override {
    # nouveau-experimental was renamed to nouveau, so we have to manually override it.
    vulkanDrivers = [ "amd" "nouveau" "swrast" ];
    galliumDrivers = [ "nouveau" "radeonsi" "swrast" "zink" ];
    enableOpenCL = self.stdenv.isx86_64;
  }).overrideAttrs (old: let
    rustDeps = [
      {
        pname = "paste";
        version = "1.0.14";
        hash = "sha256-+J1h7New5MEclUBvwDQtTYJCHKKqAEOeQkuKy+g0vEc=";
      }
    ];

    copyRustDep = dep: ''
      cp -R --no-preserve=mode,ownership ${self.fetchCrate dep} subprojects/${dep.pname}-${dep.version}
      cp -R subprojects/packagefiles/${dep.pname}/* subprojects/${dep.pname}-${dep.version}/
    '';

    copyRustDeps = self.lib.concatStringsSep "\n" (builtins.map copyRustDep rustDeps);
  in {
    version = "24.04.29-git";
    src = self.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "mesa";
      repo = "mesa";
      rev = "450c9460c641807a66ce1017c0c8a1aec94c243d";
      hash = "sha256-BPd7dl2ASw8IWMD1Z1rGFzihJ+uL9gZeUQ7ykrFB/Qc=";
    };
    postPatch = old.postPatch + ''
      ${copyRustDeps}
    '';
    nativeBuildInputs = old.nativeBuildInputs ++ [ self.rust-cbindgen ];
    mesonFlags = old.mesonFlags ++ [ "-Dintel-rt=disabled" "-Dintel-clc=system" ];
  });
}
