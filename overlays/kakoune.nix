self: super: {
  # Override kakoune to a more recent version so that shift+space works
  kakoune-unwrapped = super.kakoune-unwrapped.overrideAttrs (old: {
    version = "2022.07.04";
    src = super.fetchFromGitHub {
        owner = "mawww";
        repo = "kakoune";
        rev = "167929c15bb159a469220b9b120f70ebe4933cd5";
        sha256 = "sha256-2p829+biq5awDmkyIXF8/aPZvBVTpA/FhuN4o2zrQNk=";
    };
  });
}

