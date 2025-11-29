{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6Packages
}: stdenv.mkDerivation rec {
  pname = "rocprof-compute-viewer";
  version = "7.2.0-pre";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocprof-compute-viewer";
    rev = "156405add1b003d53b30a3843cf4a62fcf1aa68e";
    hash = "";
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
