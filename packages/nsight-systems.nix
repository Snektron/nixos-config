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
  autoAddDriverRunpath,
  dpkg
}: stdenv.mkDerivation rec {
  pname = "nsight-systems";
  version = "2025.3.1";

  src = fetchurl {
    url = "https://developer.nvidia.com/downloads/assets/tools/secure/nsight-systems/2025_3/nsight-systems-2025.3.1_2025.3.1.90-1_amd64.deb";
    hash = "sha256-Q7m5egUKxs+9LccN9g6raAnVBVsiKXFjilVcnZ2oock=";
  };

  nativeBuildInputs = [ autoAddDriverRunpath autoPatchelfHook qt6Packages.wrapQtAppsHook dpkg ];

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

  dontConfigure = true;

  installPhase = ''
    mkdir -p $out
    cp -a opt/nvidia/nsight-systems/*/* $out
    rm $out/EULA.txt
    mkdir -p $out/share/applications/
    cat <<EOF > $out/share/applications/NSight-Systems.desktop

    [Desktop Entry]
    Name=NSight Systems
    GenericName=Nvidia Systems Profiler
    Exec=$out/bin/nsys-ui
    Terminal=false
    Type=Application
    EOF
  '';
}

