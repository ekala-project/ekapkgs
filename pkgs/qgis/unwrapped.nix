{
  lib,
  stdenv,

  fetchFromGitHub,
  makeWrapper,
  gtk3,
  wrapQtAppsHook ? null,

  withGrass ? false,
  withServer ? false,

  bison,
  cmake,
  draco,
  exiv2,
  fcgi,
  flex,
  geos,
  grass ? null,
  gsl,
  hdf5,
  libspatialindex,
  libspatialite,
  libzip,
  netcdf,
  ninja,
  openssl,
  pdal ? null,
  libpq,
  proj,
  protobuf,
  python3,
  qca,
  qscintilla ? null,
  qt3d ? null,
  qt5compat,
  qtbase,
  qtdeclarative,
  qtkeychain,
  qtlocation,
  qtmultimedia,
  qtsensors ? null,
  qtserialport ? null,
  qtsvg,
  qttools,
  qtwebengine,
  qwt,
  sqlite,
  txt2tags,
  zstd,
}:

let
  py = python3;

  pythonBuildInputs =
    let
      p = py.pkgs;
    in
    lib.filter (x: x != null) [
      (p.chardet or null)
      (p.gdal or null)
      (p.jinja2 or null)
      (p.numpy or null)
      (p.owslib or null)
      (p.psycopg2 or null)
      (p.pygments or null)
      (p.pyqt6 or null)
      (p.pyqt-builder or null)
      (p.python-dateutil or null)
      (p.pytz or null)
      (p.pyyaml or null)
      (p.requests or null)
      (p.setuptools or null)
      (p.sip or null)
      (p.six or null)
      (p.urllib3 or null)
    ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "qgis-unwrapped";
  version = "4.2.2";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-gEUShI09n7fpLcfKaNmiatB8pco0yJ227Ge7pPnMxCY=";
  };

  postPatch = ''
    substituteInPlace python/utils.py \
      --replace-fail '("mod_spatialite", "sqlite3_modspatialite_init")' \
        '("${libspatialite}/lib/mod_spatialite.so", "sqlite3_modspatialite_init")'
  '';

  passthru = {
    inherit pythonBuildInputs;
    inherit py;
  };

  nativeBuildInputs = [
    makeWrapper
    gtk3.wrapGAppsHook
    wrapQtAppsHook

    bison
    cmake
    cmake.configurePhaseHook
    flex
    ninja
  ];

  buildInputs = [
    draco
    exiv2
    fcgi
    geos
    gsl
    hdf5
    libpq
    libspatialindex
    libspatialite
    libzip
    netcdf
    openssl
    proj
    protobuf
    qca
    qt5compat
    qtbase
    qtdeclarative
    qtkeychain
    qtlocation
    qtmultimedia
    qttools
    qtwebengine
    qwt
    sqlite
    txt2tags
    zstd
  ]
  ++ lib.optional (qscintilla != null) qscintilla
  ++ lib.optional (qt3d != null) qt3d
  ++ lib.optional (qtsensors != null) qtsensors
  ++ lib.optional (qtserialport != null) qtserialport
  ++ lib.optional (pdal != null) pdal
  ++ lib.optional withGrass grass
  ++ pythonBuildInputs;

  # Add path to Qt platform plugins
  # (offscreen is needed by "${APIS_SRC_DIR}/generate_console_pap.py")
  env.QT_QPA_PLATFORM_PLUGIN_PATH = "${qtbase}/${qtbase.qtPluginPrefix}/platforms";

  cmakeEntries = {
    WITH_QTWEBENGINE = true;
    WITH_3D = true;
    WITH_PDAL = pdal != null;
    ENABLE_TESTS = false;
    QT_PLUGINS_DIR = "${qtbase}/${qtbase.qtPluginPrefix}";
    # See https://github.com/libspatialindex/libspatialindex/issues/276
    WITH_INTERNAL_SPATIALINDEX = true;
  }
  // lib.optionalAttrs withServer {
    WITH_SERVER = true;
    QGIS_CGIBIN_SUBDIR = "$(out)/lib/cgi-bin";
  }
  // lib.optionalAttrs withGrass (
    let
      gmajor = lib.versions.major grass.version;
      gminor = lib.versions.minor grass.version;
    in
    {
      "GRASS_PREFIX${gmajor}" = "${grass}/grass${gmajor}${gminor}";
    }
  );

  qtWrapperArgs = [
    "--set QT_QPA_PLATFORM_PLUGIN_PATH ${qtbase}/${qtbase.qtPluginPrefix}/platforms"
  ];

  dontWrapGApps = true; # wrapper params passed below

  # GRASS has to be available on the command line even though we baked in the
  # path at build time using GRASS_PREFIX. Using wrapGAppsHook also prevents
  # file dialogs from crashing the program on non-NixOS.
  postFixup = lib.optionalString withGrass ''
    for program in $out/bin/*; do
      wrapProgram $program \
        "''${gappsWrapperArgs[@]}" \
        --prefix PATH : ${lib.makeBinPath [ grass ]}
    done
  '';

  # >9k objects, >3h build time on a normal build slot
  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Free and Open Source Geographic Information System";
    homepage = "https://www.qgis.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
