{ pkgs }: {
  breeze-obsidian-cursor-theme = pkgs.callPackage ./breeze-obsidian-cursor-theme.nix { };
  pinball = pkgs.callPackage ./pinball.nix { };
  pythobot = pkgs.callPackage ./pythobot { };
  elderbot = pkgs.callPackage ./elderbot { };
  sneksbot = pkgs.callPackage ./sneksbot { };
}
