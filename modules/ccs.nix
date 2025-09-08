{ stdenv, fetchzip, unzip, makeWrapper, autoPatchelfHook, pkgs, lib }:

stdenv.mkDerivation rec {
  pname = "ccstudio";
  version = "20.2.0.00012";

  src = fetchzip {
    url = "https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-J1VdearkvK/20.2.0/CCS_20.2.0.00012_linux.zip";
    sha256 = "sha256-oKjyTJP5ZiXwap//ayEz1hrWneHUD9Uk4yMgUEc3W/Q=";
  };

  nativeBuildInputs = [ unzip makeWrapper autoPatchelfHook ];

  buildInputs = with pkgs; [
    zlib
    ncurses5
    libusb1
    glib
    gtk2
    libX11
    libXext
    libXrender
    libXtst
    libXi
    freetype
    fontconfig
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXfixes
    alsa-lib
  ];

  unpackPhase = ''
    runHook preUnpack
    
    # Extract the main zip
    unzip $src -d ccstudio-source
    
    # Find and extract the .run file (which is often a self-extracting archive)
    RUN_FILE=$(find ccstudio-source -name "*.run" | head -1)
    
    if [ -z "$RUN_FILE" ]; then
      echo "Error: No .run file found in the archive"
      find ccstudio-source -type f
      exit 1
    fi
    
    echo "Found installer: $RUN_FILE"
    chmod +x "$RUN_FILE"
    
    # Try to extract the .run file (many .run files are actually shell scripts that extract archives)
    mkdir extracted-installer
    cd extracted-installer
    
    # Try different extraction methods
    if "$RUN_FILE" --help 2>&1 | grep -q "extract"; then
      "$RUN_FILE" --extract ./ || true
    else
      # Try to run with --help or similar to see available options
      echo "Trying to extract using different methods..."
      "$RUN_FILE" --target ./ || \
      "$RUN_FILE" --extract-only || \
      "$RUN_FILE" --noexec --target ./ || \
      { echo "Could not extract installer"; exit 1; }
    fi
    
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    
    # Look for the actual application files in the extracted contents
    if [ -d "ccs" ]; then
      echo "Found extracted CCS directory"
      mkdir -p $out/opt/ccstudio
      cp -r ccs/* $out/opt/ccstudio/
      
      # Find the main executable
      CCS_BIN=$(find $out/opt/ccstudio -name "ccs" -type f -executable | head -1)
      
      if [ -n "$CCS_BIN" ]; then
        mkdir -p $out/bin
        makeWrapper $CCS_BIN $out/bin/ccs \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}:$out/opt/ccstudio" \
          --set CCSTUDIO_HOME $out/opt/ccstudio
      else
        echo "Warning: Could not find main executable in extracted files"
      fi
    else
      echo "Could not find extracted application files. Directory contents:"
      ls -la
      exit 1
    fi
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Code Composer Studio™ integrated development environment (IDE)";
    homepage = "https://www.ti.com/tool/CCSTUDIO";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}