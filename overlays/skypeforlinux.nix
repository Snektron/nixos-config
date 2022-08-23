self: super: {
  # Override skype with the version that (theoretically) supports screen sharing under wayland
  # Doesn't actually seem to work properly though...
  skypeforlinux = super.skypeforlinux.overrideAttrs (old: {
    src = builtins.fetchurl {
      url = "https://repo.skype.com/latest/skypeforlinux-64-insider.deb";
      sha256 = "1k33w4557ixx0xh717bj8yypga1faq5874ybn9rnbjyw6l1vxbik";
    };

    postFixup = let
      rpath = self.lib.makeLibraryPath [ self.libglvnd ];
    in old.postFixup + ''
      # Make skype use wayland
      # The chromium version is not new enough to do this automatically
      substituteInPlace $out/share/applications/skypeforlinux.desktop \
        --replace '%U' '--enable-features=UseOzonePlatform --ozone-platform=wayland %U'

      # Add GlESv2.so to the library search path, seems to be required to make
      # skype responsive on secondary monitors.
      for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* -or -name \*.node\* \) ); do
        patchelf --add-rpath ${rpath} $file || true
      done
    '';
  });
}
