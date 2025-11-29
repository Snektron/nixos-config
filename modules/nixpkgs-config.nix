{ inputs, ... }: {
  nixpkgs = {
    overlays = [ inputs.self.overlays.default ];
    config = {
      allowUnfree = true;
      # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1119760100
      allowUnfreePredicate = (pkg: true);

      # Not entirely sure why this is needed
      permittedInsecurePackages = [
        "qtwebengine-5.15.19"
      ];
    };
  };
}
