{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  name = "pythobot";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Snektron";
    repo = "pytho";
    sha256 = "sha256-Vvm9BZjNyswmauWPat61Nx3tDkb7L35rMXZepGfleOg=";
    rev = "00b702c3af3e8417ba54cce0e867204975bf42c8";
  };

  vendorHash = "sha256-QoVryPstnfdvc390pgAeLF04AXNzR2BEXLXY2isTK+s=";
}
