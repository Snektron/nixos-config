self: super: {
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
      ../patches/wlroots-extra-debug.patch
    ];
  });
}
