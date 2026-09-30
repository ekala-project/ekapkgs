{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  validatePkgConfig,
  expat,
  minizip,
  zlib,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freexl";
  version = "2.0.0";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/freexl-${finalAttrs.version}.tar.gz";
    hash = "sha256-F2cF8d5Yq3we679cbeRqt2/Ni4VlCNvSj1ZI98bhp/A=";
  };

  nativeBuildInputs = [ pkg-config validatePkgConfig ];

  buildInputs = [
    expat
    minizip
    zlib
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  # Create a shim for ints.h which minizip's ioapi.h references but
  # the ekapkgs minizip package doesn't install.
  preConfigure = ''
    mkdir -p $TMPDIR/minizip-ints-shim
    cat > $TMPDIR/minizip-ints-shim/ints.h << 'INTS_H'
    /* shim: redirect to standard integer types */
    #ifndef MINIZIP_INTS_H_SHIM
    #define MINIZIP_INTS_H_SHIM
    #include <stdint.h>
    typedef int8_t i8_t;
    typedef uint8_t ui8_t;
    typedef int16_t i16_t;
    typedef uint16_t ui16_t;
    typedef int32_t i32_t;
    typedef uint32_t ui32_t;
    typedef int64_t i64_t;
    typedef uint64_t ui64_t;
    #endif
    INTS_H
    export CPPFLAGS="-I${minizip}/include -I${zlib.dev}/include -I$TMPDIR/minizip-ints-shim"
    export LDFLAGS="-L${minizip}/lib"
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Library to extract valid data from within an Excel (.xls) spreadsheet";
    homepage = "https://www.gaia-gis.it/fossil/freexl";
    # They allow any of these
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      mpl11
    ];
    platforms = lib.platforms.unix;
  };
})
