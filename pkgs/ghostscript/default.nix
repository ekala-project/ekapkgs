{
  config,
  stdenv,
  lib,
  fetchurl,
  fetchpatch2,
  pkg-config,
  zlib,
  expat,
  openssl,
  autoconf,
  libjpeg,
  libpng,
  libtiff,
  freetype,
  fontconfig,
  libpaper,
  jbig2dec,
  libiconv,
  lcms2,
  bash,
  buildPackages,
  openjpeg,
  cupsSupport ? config.ghostscript.cups or (!stdenv.hostPlatform.isDarwin),
  cups,
  x11Support ? cupsSupport,
  xorg,
  dynamicDrivers ? true,
}:

let
  fonts = stdenv.mkDerivation {
    name = "ghostscript-fonts";

    srcs = [
      (fetchurl {
        url = "mirror://sourceforge/gs-fonts/ghostscript-fonts-std-8.11.tar.gz";
        hash = "sha256-DrbzVhGfLkmyVjIQhS4X9X+dzFdV81Cmmkag1kGgxAE=";
      })
      (fetchurl {
        url = "mirror://gnu/ghostscript/gnu-gs-fonts-other-6.0.tar.gz";
        hash = "sha256-gUbMzEaZ/p2rhBRGvdFwOfR2nJA+zrVECRiLkgdUqrM=";
      })
    ];

    installPhase = ''
      mkdir "$out"
      mv -v * "$out/"
    '';
  };

in
stdenv.mkDerivation rec {
  pname = "ghostscript${lib.optionalString x11Support "-with-X"}";
  version = "10.05.1";

  src = fetchurl {
    url = "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${
      lib.replaceStrings [ "." ] [ "" ] version
    }/ghostscript-${version}.tar.xz";
    hash = "sha256-IvK9yhXCiDDJcVzdxcKW6maJi/2rC2BKTgvP6wOvbK0=";
  };

  patches = [
    ./urw-font-files.patch
    ./doc-no-ref.diff

    # Support SOURCE_DATE_EPOCH for reproducible builds
    (fetchpatch2 {
      url = "https://salsa.debian.org/debian/ghostscript/-/raw/01e895fea033cc35054d1b68010de9818fa4a8fc/debian/patches/2010_add_build_timestamp_setting.patch";
      hash = "sha256-XTKkFKzMR2QpcS1YqoxzJnyuGk/l/Y2jdevsmbMtCXA=";
    })
  ];

  outputs = [
    "out"
    "man"
    "doc"
    "fonts"
  ];

  enableParallelBuilding = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    pkg-config
    autoconf
    zlib
  ]
  ++ lib.optional cupsSupport cups;

  buildInputs = [
    zlib
    expat
    openssl
    libjpeg
    libpng
    libtiff
    freetype
    fontconfig
    libpaper
    jbig2dec
    libiconv
    lcms2
    bash
    openjpeg
  ]
  ++ lib.optionals x11Support [
    xorg.libICE
    xorg.libX11
    xorg.libXext
    xorg.libXt
  ]
  ++ lib.optional cupsSupport cups;

  preConfigure = ''
    # https://ghostscript.com/doc/current/Make.htm
    export CCAUX=$CC_FOR_BUILD
    ${lib.optionalString cupsSupport ''export CUPSCONFIG="${cups.dev}/bin/cups-config"''}

    rm -rf jpeg libpng zlib jasper expat tiff lcms2mt jbig2dec freetype cups/libs openjpeg

    sed "s@if ( test -f \$(INCLUDE)[^ ]* )@if ( true )@; s@INCLUDE=/usr/include@INCLUDE=/no-such-path@" -i base/unix-aux.mak
    sed "s@^ZLIBDIR=.*@ZLIBDIR=${zlib.dev}/include@" -i configure.ac

    # Sidestep a bug in autoconf-2.69 that sets the compiler for all checks to
    # $CXX after the part for the vendored copy of tesseract.
    substituteInPlace configure.ac \
      --replace-fail "--without-x" "--without-x --without-tesseract"

    autoconf
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DARWIN_LDFLAGS_SO_PREFIX=$out/lib/
  '';

  configureFlags = [
    "--with-system-libtiff"
    "--without-tesseract"
  ]
  ++ lib.optionals dynamicDrivers [
    "--enable-dynamic"
    "--disable-hidden-visibility"
  ]
  ++ lib.optionals x11Support [
    "--with-x"
  ]
  ++ lib.optionals cupsSupport [
    "--enable-cups"
  ];

  # make check does nothing useful
  doCheck = false;

  # don't build/install statically linked bin/gs
  buildFlags = [ "so" ];
  installTargets = [ "soinstall" ];

  postInstall = ''
    ln -s gsc "$out"/bin/gs

    cp -r Resource "$out/share/ghostscript/${version}"

    mkdir -p $fonts/share/fonts
    cp -rv ${fonts}/* "$fonts/share/fonts/"
    ln -s "$fonts/share/fonts" "$out/share/ghostscript/fonts"
  '';

  # validate dynamic linkage
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/gs --version
    $out/bin/gsx --version
    pushd examples
    for f in *.{ps,eps,pdf}; do
      echo "Rendering $f"
      $out/bin/gs \
        -dNOPAUSE \
        -dBATCH \
        -sDEVICE=bitcmyk \
        -sOutputFile=/dev/null \
        -r600 \
        -dBufferSpace=100000 \
        $f
    done
    popd # examples

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://www.ghostscript.com/";
    description = "PostScript interpreter (mainline version)";
    longDescription = ''
      Ghostscript is the name of a set of tools that provides (i) an
      interpreter for the PostScript language and the PDF file format,
      (ii) a set of C procedures (the Ghostscript library) that
      implement the graphics capabilities that appear as primitive
      operations in the PostScript language, and (iii) a wide variety
      of output drivers for various file formats and printers.
    '';
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "gs";
  };
}
