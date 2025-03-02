{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  gcc-unwrapped,
  rdma-core,
  addDriverRunpath,
  libxkbcommon,
  libX11,
  libxcb,
  libXfixes,
  libXrender,
  libXrandr,
  libXtst,
  libXcomposite,
  libXdamage,
  xorg,
  wayland,
  qt6Packages,
  libGL,
  fontconfig,
  nss,
  nspr,
  libdrm,
  dbus,
  libxkbfile,
  libxshmfence,
  glib,
  autoAddDriverRunpath
}: stdenv.mkDerivation rec {
  pname = "nsight-compute";
  version = "2025.1";

  src = fetchurl {
    url = "https://developer.nvidia.com/downloads/assets/tools/secure/nsight-compute/2025_1_0/nsight-compute-linux-2025.1.0.14-35237751.run";
    hash = "sha256-i/CfmgfMJWlLGUlyKoPkRySMu61Ak9OqVqprNRA0nrk=";
  };

  nativeBuildInputs = [ autoAddDriverRunpath autoPatchelfHook qt6Packages.wrapQtAppsHook ];

  # Seems that libtiff isn't actually required
  # This also fixes some missing cuda libs stuff
  autoPatchelfIgnoreMissingDeps = true;

  buildInputs = [
    gcc-unwrapped.lib
    rdma-core
    libxkbcommon
    libX11
    libxcb
    xorg.xcbutilimage
    xorg.xcbutilwm
    xorg.xcbutilrenderutil
    xorg.xcbutilcursor
    xorg.xcbutilkeysyms
    wayland
    qt6Packages.qtwayland
    libGL
    libXfixes
    libXrender
    libXrandr
    libXtst
    libXcomposite
    libXdamage
    fontconfig
    nss
    nspr
    libdrm
    dbus
    libxkbfile
    libxshmfence
    glib
  ];

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    sh $src --nox11 --noexec --keep
  '';

  installPhase = ''
    mkdir -p $out
    cp -a files/pkg/* $out
    mkdir -p $out/share/applications/
    cat <<EOF > $out/share/applications/NSight-Compute.desktop

    [Desktop Entry]
    Name=NSight Compute
    GenericName=Nvidia GPU Profiler
    Exec=$out/ncu-ui
    Terminal=false
    Type=Application
    EOF
  '';
}
