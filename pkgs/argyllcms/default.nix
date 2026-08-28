{
  stdenv,
  fetchzip,
  jam ? null,
  unzip,
  libx11,
  libxxf86vm,
  libxrandr,
  libxinerama,
  libxrender,
  libxext,
  libtiff,
  libjpeg,
  libpng,
  libxscrnsaver ? null,
  writeText,
  libxdmcp,
  libxau,
  lib,
  openssl,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "argyllcms";
  version = "3.4.1";

  src = fetchzip {
    url = "https://www.argyllcms.com/Argyll_V${version}_src.zip";
    hash = "sha256-QVugWtAk8xBn+/fRFqCoi072Q2q8OlB0LRhavrHC5MI=";
  };

  nativeBuildInputs = [
    jam
    unzip
  ];

  preConfigure =
    let
      jamTop = writeText "argyllcms_jamtop" ''
        DESTDIR = "/" ;
        REFSUBDIR = "share/argyllcms" ;

        ANCHORED_PATH_VARS = DESTDIR ;

        DEFINES += ARGYLLCMS ;

        USE_SERIAL = true ;
        USE_FAST_SERIAL = true ;
        USE_USB = true ;
        USE_DEMOINST = true ;
        USE_VTPGLUT = false ;
        USE_PRINTER = false ;
        USE_CMFM = false ;
        USE_LIBUSB = false ;
        USE_PLOT = true ;

        JPEGLIB = ;
        JPEGINC = ;
        HAVE_JPEG = true ;

        TIFFLIB = ;
        TIFFINC = ;
        HAVE_TIFF = true ;

        PNGLIB = ;
        PNGINC = ;
        HAVE_PNG = true ;

        ZLIB = ;
        ZINC = ;
        HAVE_Z = true ;

        SSLLIB = ;
        SSLINC = ;
        HAVE_SSL = true ;

        LINKFLAGS +=
          ${lib.concatStringsSep " " (map (x: "-L${x}/lib") buildInputs)}
          -lrt -lX11 -lXext -lXxf86vm -lXinerama -lXrandr -lXau -lXdmcp -lXss
          -ljpeg -ltiff -lpng -lssl ;
      '';
    in
    ''
      cp ${jamTop} Jamtop
      substituteInPlace Makefile --replace "-j 3" "-j $NIX_BUILD_CORES"
      rm -rf tiff jpg png

      export AR="$AR rusc"
    '';

  buildInputs = [
    libtiff
    libjpeg
    libpng
    libx11
    libxxf86vm
    libxrandr
    libxinerama
    libxext
    libxrender
    libxscrnsaver
    libxdmcp
    libxau
    openssl
  ];

  buildFlags = [ "all" ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    rm -v $out/bin/License.txt
    mkdir -p $out/etc/udev/rules.d
    sed -i '/udev-acl/d' usb/55-Argyll.rules
    cp -v usb/55-Argyll.rules $out/etc/udev/rules.d/

    sed -i -e 's/^CREATED .*/CREATED "'"$(date -d @$SOURCE_DATE_EPOCH)"'"/g' $out/share/argyllcms/RefMediumGamut.gam
  '';

  meta = {
    homepage = "https://www.argyllcms.com/";
    description = "Color management system (compatible with ICC)";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
