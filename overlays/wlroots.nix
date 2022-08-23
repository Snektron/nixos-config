self: super: {
  # Patch wlroots so that it doesnt need the khronos valiation layers
  wlroots = super.wlroots.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ../patches/wlroots-validation-layers.patch
    ];
  });
}
