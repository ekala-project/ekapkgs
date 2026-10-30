{
  autoconf,
  automake,
  cunit,
  docbook5,
  fetchFromGitHub,
  gdal,
  geos,
  json_c,
  lib,
  libiconv,
  libtool,
  libxml2,
  libxslt,
  pcre2,
  perl,
  pkg-config,
  postgresql,
  postgresqlBuildExtension,
  proj,
  protobufc,
  stdenv,
  which,

  withSfcgal ? false,
  sfcgal,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "postgis";
  version = "3.6.4";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "postgis";
    repo = "postgis";
    tag = finalAttrs.version;
    hash = "sha256-ZRBrZ23s0w3noFU6L3Ke9G/Z8d7xGGg3qo/2GPDpbK4=";
  };

  buildInputs = [
    geos
    proj
    gdal
    json_c
    protobufc
    pcre2.dev
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin libiconv
  ++ lib.optional withSfcgal sfcgal;

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    libxml2
    perl
    pkg-config
    protobufc
    which
  ];

  dontDisableStatic = true;

  checkInputs = [
    cunit
  ];

  nativeCheckInputs = [
    postgresql
    libxslt
  ];

  # postgis config directory assumes /include /lib from the same root for json-c library
  env.NIX_LDFLAGS = "-L${lib.getLib json_c}/lib";

  setOutputFlags = false;
  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags =
    let
      isCross = stdenv.hostPlatform.config != stdenv.buildPlatform.config;
    in
    [
      (lib.withFeatureAs true "pgconfig" "${postgresql.pg_config}/bin/pg_config")
      (lib.withFeatureAs true "gdalconfig" "${gdal}/bin/gdal-config")
      (lib.withFeatureAs true "jsondir" (lib.getDev json_c))
      (lib.withFeatureAs true "xml2config" (lib.getExe' (lib.getDev libxml2) "xml2-config"))
      (lib.withFeatureAs withSfcgal "sfcgal" "${sfcgal}/bin/sfcgal-config")
      (lib.withFeature (!isCross) "json") # configure: error: cannot check for file existence when cross compiling
    ];

  makeFlags = [
    "PERL=${perl}/bin/perl"
  ];

  doCheck = stdenv.hostPlatform.isLinux;

  preCheck = ''
    substituteInPlace doc/postgis-out.xml --replace-fail "http://docbook.org/xml/5.0/dtd/docbook.dtd" "${docbook5}/xml/dtd/docbook/docbookx.dtd"
    # The test suite hardcodes it to use /tmp.
    export PGIS_REG_TMPDIR="$TMPDIR/pgis_reg"
  '';

  # create aliases for all commands adding version information
  postInstall = ''
    for prog in $out/bin/*; do # */
      ln -s $prog $prog-${finalAttrs.version}
    done

    mkdir -p $doc/share/doc/postgis
    mv doc/* $doc/share/doc/postgis/
  '';

  meta = {
    description = "Geographic Objects for PostgreSQL";
    homepage = "https://postgis.net/";
    changelog = "https://git.osgeo.org/postgis/postgis/raw/tag/${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl2Plus;
    inherit (postgresql.meta) platforms;
    # gdal -> libspatialite -> freexl is broken (minizip ints.h not installed)
    broken = true;
  };
})
