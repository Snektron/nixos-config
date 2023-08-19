{ inputs, system }: {
  # Enable flakes system-wide
  extraOptions = ''
    experimental-features = nix-command flakes
  '';

  settings = {
    auto-optimise-store = true;
    trusted-users = [ "robin" ];
  };
}
