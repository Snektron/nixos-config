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
    version = "2022.07.04";
    src = super.fetchFromGitHub {
        owner = "mawww";
        repo = "kakoune";
        rev = "167929c15bb159a469220b9b120f70ebe4933cd5";
        sha256 = "sha256-2p829+biq5awDmkyIXF8/aPZvBVTpA/FhuN4o2zrQNk=";
    };
  });

  # Patch wlroots so that it doesnt need the khronos valiation layers
  wlroots = super.wlroots.overrideAttrs (old: rec {
    version = "0.16.0";
    src = self.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = version;
      sha256 = "sha256-MFR38UuB/wW7J9ODDUOfgTzKLse0SSMIRYTpEaEdRwM=";
    };
    patches = (old.patches or [ ]) ++ [
      ../patches/wlroots-validation-layers.patch
    ];
  });
}
