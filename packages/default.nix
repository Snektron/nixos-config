{ pkgs }: {
  breeze-obsidian-cursor-theme = pkgs.callPackage ../packages/breeze-obsidian-cursor-theme.nix { };

  inherit (pkgs) qemu;
}
