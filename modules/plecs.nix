{ stdenv, fetchzip, makeWrapper, autoPatchelfHook, pkgs, lib }:

let
  pname = "plecs";
  version = "4.9.8";
  appname = "PLECS";
  meta = with lib; {
    description = "PLECS (Piecewise Linear Electrical Circuit Simulation) software";
    homepage = "https://www.plexim.com/plecs";
    mainProgram = "obsidian";
    license = licenses.unfree;
    platforms = platforms.linux;
  };

  desktopEntry = pkgs.makeDesktopItem {
    name = pname;
    desktopName = appname;
    comment = "PLECS (Piecewise Linear Electrical Circuit Simulation) software";
    icon = "plecs";   # TODO: find the logo somewhere
    exec = "plecs %f";
    categories = [ "Science" ];
    mimeTypes = [
      "x-scheme-handler/sgnl"
      "x-scheme-handler/signalcaptcha"
    ];
  };
in
stdenv.mkDerivation {
  pname = pname;
  version = version;
  meta = meta;

  src = fetchzip {
    url = "https://www.plexim.com/sites/default/files/packages/plecs-standalone-4-9-8_linux64.tar.gz";
    sha256 = "sha256-87Kdx49WLIiBFBoUXO+yMOwSFxD52nzWjKX09g6pTRU=";
  };

  dontBuild = true;

  dontWrapQtApps = true;

  nativeBuildInputs = [ makeWrapper autoPatchelfHook pkgs.kdePackages.wrapQtAppsHook ];
  
  buildInputs = with pkgs; [
    glibc
    libGL
    libGLU
    fontconfig
    freetype
    nspr
    nss
    qpdf
    zlib

    libdrm
    libxcb
    libxkbcommon
    xcb-util-cursor
    xorg.libxkbfile
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libSM
    xorg.libICE
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil

    qt6.qtbase    
    qt6.qtdeclarative
    qt6.qttools
    qt6.qtwebengine
];

  installPhase = ''
    mkdir -p $out/opt/plecs
    cp -r * $out/opt/plecs

    mkdir -p $out/bin
    makeWrapper $out/opt/plecs/PLECS $out/bin/plecs \
      --prefix LD_LIBRARY_PATH : "$out/opt/plecs/lib"

    # Install .desktop file
    mkdir -p $out/share/applications
    cp ${desktopEntry}/share/applications/plecs.desktop $out/share/applications/
  '';
}
