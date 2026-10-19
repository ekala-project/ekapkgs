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

  nativeBuildInputs = [
    pkg-config
    validatePkgConfig
  ];

  # TODO: configure can't find minizip headers despite correct CPPFLAGS

  buildInputs = [
    expat
    minizip
    zlib
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

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
    # Configure can't find minizip headers
    broken = true;
  };
})
