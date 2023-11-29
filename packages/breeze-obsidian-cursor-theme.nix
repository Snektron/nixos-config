{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "breeze-obsidian-cursor-theme";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "Snektron";
    repo = "breeze-obsidian-cursor-theme";
    rev = "d1d78d161a734915eadddce28018199e9c58dc0f";
    hash = "sha256-MBcxB6/UZGYlnIMNUEnFjoHvsq25/w90aLrGBAc2z1M=";
  };

  sourceRoot = "${src.name}/Breeze_Obsidian";

  installPhase = ''
    install -dm 755 $out/share/icons/Breeze_Obsidian
    cp -dr --no-preserve='ownership' cursors index.theme $out/share/icons/Breeze_Obsidian
  '';
}
