{ lib, stdenv, fetchzip }:
stdenv.mkDerivation {
  pname = "breeze-obsidian-cursor-theme";
  version = "1.0";

  src = fetchzip {
    url = "https://code.jpope.org/jpope/breeze_cursor_sources/raw/master/breeze-obsidian-cursor-theme.zip";
    sha256 = "sha256-Y75iDlmboHlLCDeNGt6rpYUjYhw8y6cdTpQhJfWu6oQ=";
  };

  installPhase = ''
    install -dm 755 $out/share/icons/Breeze_Obsidian
    cp -dr --no-preserve='ownership' cursors index.theme $out/share/icons/Breeze_Obsidian
  '';
}
