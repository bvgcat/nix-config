{ stdenv, fetchzip, makeWrapper, autoPatchelfHook, pkgs, lib }:

stdenv.mkDerivation rec {
  pname = "plecs";
  version = "4.9.7";

  src = fetchzip {
    url = "https://www.plexim.com/sites/default/files/packages/plecs-standalone-4-9-7_linux64.tar.gz";
    sha256 = "sha256-w4FNJ/Btg2XAQQb91pndmPezygDl0To2+wChfgUbqOw=";
  };

  nativeBuildInputs = [ makeWrapper autoPatchelfHook pkgs.qt6.wrapQtAppsHook ];

  buildInputs = with pkgs;[
    glibc
    zlib
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libSM
    xorg.libICE
    libGL
    libGLU
    fontconfig
    freetype

    libxcb
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.libxkbfile
    xcb-util-cursor
    libxkbcommon
    libdrm
  
    qt6.qtbase
    qt6.qttools
    qt6.qtdeclarative
    qt6.qtwebengine

    qpdf
    nspr
    nss
  ];


  installPhase = ''
    mkdir -p $out/opt/plecs
    cp -r * $out/opt/plecs

    mkdir -p $out/bin
    makeWrapper $out/opt/plecs/PLECS $out/bin/plecs \
      --prefix LD_LIBRARY_PATH : "$out/opt/plecs/lib"
  '';
  
  meta = with lib; {
    description = "PLECS (Piecewise Linear Electrical Circuit Simulation) software";
    homepage = "https://www.plexim.com/plecs";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
