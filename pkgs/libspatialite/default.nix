{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  validatePkgConfig,
  freexl,
  geos,
  librttopo,
  libxml2,
  minizip,
  proj,
  sqlite,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspatialite";
  version = "5.1.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-${finalAttrs.version}.tar.gz";
    hash = "sha256-Q74t00na/+AW3RQAxdEShYKMIv6jXKUQnyHz7VBgUIA=";
  };

  patches = [
    ./xmlNanoHTTPCleanup.patch
  ];

  postPatch = lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    substituteInPlace spatialite.pc.in \
      --replace-fail "@LIBS@ @LIBXML2_LIBS@ @SQLITE3_LIBS@ -lm" ""
  '';

  nativeBuildInputs = [
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    freexl
    geos
    librttopo
    libxml2
    minizip
    proj
    sqlite
    zlib
  ];

  configureFlags = [
    "--with-geosconfig=${lib.getExe' (lib.getDev geos) "geos-config"}"
  ];

  enableParallelBuilding = true;

  doCheck = false;

  preCheck = ''
    export LD_LIBRARY_PATH=$(pwd)/src/.libs
  '';

  meta = {
    description = "Extensible spatial index library in C++";
    homepage = "https://www.gaia-gis.it/fossil/libspatialite";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      mpl11
    ];
    platforms = lib.platforms.unix;
  };
})
