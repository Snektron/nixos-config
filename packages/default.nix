{ inputs, system, nixpkgs-config }:
let
  pkgs = import inputs.nixpkgs ({ inherit system; } // nixpkgs-config );
in {
  breeze-obsidian-cursor-theme = pkgs.callPackage ../packages/breeze-obsidian-cursor-theme.nix { };
}
