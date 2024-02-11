{ pkgs }: {
  breeze-obsidian-cursor-theme = pkgs.callPackage ./breeze-obsidian-cursor-theme.nix { };
  pinball = pkgs.callPackage ./pinball.nix { };

  inherit (pkgs) qemu;
}
