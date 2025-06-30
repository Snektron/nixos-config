{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6Packages
}: stdenv.mkDerivation rec {
  pname = "rocprof-compute-viewer";
  version = "7.0.0-pre";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocprof-compute-viewer";
    rev = "3557f09eb3de1439956136229dce74b3af8f8e68";
    hash = "sha256-Y4u2J988KcFjexNtnmG54PmfrO2+FJ2/QpmVvFBIqlw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.qtbase
  ];

  postInstall = ''
    mkdir -p $out/share/applications/
    cat <<EOF > $out/share/applications/ROCprof-Compute-Viewer.desktop

    [Desktop Entry]
    Name=ROCprof Compute Viewer
    GenericName=ROCm GPU Profiler
    Exec=$out/bin/rocprof-compute-viewer
    Terminal=false
    Type=Application
    EOF
  '';
}
