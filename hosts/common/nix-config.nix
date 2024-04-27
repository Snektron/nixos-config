{ inputs, lib, config, pkgs, ... }:
let
  # Filter out the `self` flake.
  # TODO: Maybe its useful to let this stay here? Or rename it to something else...
  # TODO: Why does kirb do `value ? outputs`?
  flakes = lib.filterAttrs (name: value: name != "self") inputs;
in {
 # Ensure that you can use flake inputs throughout the system. Because this system is
 # flake-based and does not use channels, we cannot otherwise use `import <nixpkgs>`.
 # These inputs are based on the symlinks in /etc/nix/inputs, so to get the above
 # effect, we map the system inputs to that directory.
 # https://git.chir.rs/darkkirb/nixos-config/src/branch/main/utils/link-input.nix
  nix.nixPath = [ "/etc/nix/inputs" ];
  environment.etc = lib.mapAttrs' (name: value: {
    name = "nix/inputs/${name}";
    value.source = value.outPath;
  }) flakes;

  # By registering the system flakes in nix.registry, we can write flakes
  # using `outputs = { self, nixpkgs }` without using inputs! Then these
  # inputs are taken from here.
  # Note that because we registery `self` as input here, it cannot be used
  # therefore we should rename `self` to something else.
  nix.registry = builtins.mapAttrs (name: value: {
    flake = value;
  }) flakes;

  nix = {
    # Use hardlinks instead of softlinks
    settings.auto-optimise-store = true;

    settings.trusted-users = [ "robin" ];

    # Enable flakes and `nix <command>` system-wide.
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Print a summary of changes when switching to a new system.
  system.activationScripts.diff = {
    # Run this script also when running --dry-activate
    supportsDryActivation = true;
    text = ''
      if [[ -e /run/current-system ]]; then
        echo "--- Summary of changes"
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
      fi
    '';
  };
}
