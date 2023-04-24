self: super: {
  mesa = super.mesa_23;

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
}
