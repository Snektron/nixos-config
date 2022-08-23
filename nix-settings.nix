{ inputs, system }: {
  # Enable flakes system-wide
  extraOptions = ''
    experimental-features = nix-command flakes
  '';

  autoOptimiseStore = true;
}
