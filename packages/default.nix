{ inputs, system, nixpkgsConfig }:
let
  pkgs = import inputs.nixpkgs ({ inherit system; } // nixpkgsConfig );
in {
  breeze-obsidian-cursor-theme = pkgs.callPackage ../packages/breeze-obsidian-cursor-theme.nix { };

  inherit (pkgs) qemu;
}
