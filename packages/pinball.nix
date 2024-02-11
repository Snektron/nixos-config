{ lib, stdenv, fetchFromGitHub, fetchzip, cmake, ninja, SDL2, SDL2_mixer }:
stdenv.mkDerivation rec {
  pname = "pinball";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "k4zmu2a";
    repo = "SpaceCadetPinball";
    rev = "6a30ccbef12c7b7781ccf89788d77461fa20a90a";
    hash = "sha256-W2P7Txv3RtmKhQ5c0+b4ghf+OMsN+ydUZt+6tB+LClM=";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ SDL2 SDL2.dev SDL2_mixer SDL2_mixer.dev ];

  postInstall = let
    gamedata = fetchzip {
      url = "https://ia801904.us.archive.org/26/items/pinball_202007/Pinball.zip";
      hash = "sha256-YUw6fPZ6oIrLYfYaO06qrUla/mH6VIBqzuw6OkZ12/I=";
    };
  in ''
    cp -R ${gamedata}/* $out/bin/
  '';
}

