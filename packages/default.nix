{ pkgs }: {
  breeze-obsidian-cursor-theme = pkgs.callPackage ./breeze-obsidian-cursor-theme.nix { };
  pinball = pkgs.callPackage ./pinball.nix { };
  pythobot = pkgs.callPackage ./pythobot { };
  elderbot = pkgs.callPackage ./elderbot { };
  sneksbot = pkgs.callPackage ./sneksbot { };
  nsight-compute = pkgs.callPackage ./nsight-compute.nix { };
  nsight-systems = pkgs.callPackage ./nsight-systems.nix { };
  rocprof-compute-viewer = pkgs.callPackage ./rcv.nix { };

  # Re-export mesa overlay so that we can build it ahead of time
  mesa = pkgs.mesa;
}
