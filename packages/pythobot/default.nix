{ buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "pythobot";
  version = "1.0.0";
  rev = "51762d0b512a7d430a2fd7a2c2a361821bcc5a78";

  goPackagePath = "github.com/Snektron/pytho";

  src = fetchFromGitHub {
    inherit rev;
    owner = "Snektron";
    repo = "pytho";
    sha256 = "183alkhdk4a155591igddqhrwmmrg4cs94hw09xdxc9d1ril578v";
  };

  goDeps = ./pytho-deps.nix;
}
