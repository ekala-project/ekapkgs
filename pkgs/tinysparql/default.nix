{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  gettext,
  meson,
  ninja,
  pkg-config,
  asciidoc,
  gobject-introspection,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  vala,
  python3,
  libxml2,
  glib,
  wrapGAppsNoGuiHook ? null,
  sqlite,
  libstemmer ? null,
  icu,
  libuuid,
  libsoup_3,
  json-glib,
  avahi ? null,
  dbus,
  man-db ? null,
  writeText,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinysparql";
  version = "3.11.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url =
      with finalAttrs;
      "mirror://gnome/sources/tinysparql/${lib.versions.majorMinor version}/tinysparql-${version}.tar.xz";
    hash = "sha256-z9RgIe4VFK1DXnFPeqHsenh8f1FqlPTHQ4iX7j1uyh4=";
  };

  patches = [
    (fetchpatch {
      name = "tinysparql-sqlite-double-value-precision.patch";
      url = "https://gitlab.gnome.org/GNOME/tinysparql/-/commit/47d5bf9313d0ccb1feb7169eed9047d0e1597a39.patch";
      hash = "sha256-k6eELZCEEtD8s7GiMckjTlf6QcAiUNY1Mraw7GROsm4=";
    })
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    asciidoc
    gettext
    glib
    wrapGAppsNoGuiHook
    (python3.pythonOnBuildForHost.withPackages (p: [ p.pygobject3 ]))
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala
  ];

  buildInputs = [
    glib
    libxml2
    sqlite
    icu
    libsoup_3
    libuuid
    json-glib
    avahi
    libstemmer
  ];

  nativeCheckInputs = [
    dbus
    man-db
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dsystemd_user_services_dir=${placeholder "out"}/lib/systemd/user"
    (lib.mesonEnable "introspection" withIntrospection)
    (lib.mesonEnable "vapi" withIntrospection)
  ]
  ++ (
    let
      crossFile = writeText "cross-file.conf" ''
        [properties]
        sqlite3_has_fts5 = '${lib.boolToString (lib.hasInfix "-DSQLITE_ENABLE_FTS3" sqlite.NIX_CFLAGS_COMPILE)}'
      '';
    in
    [
      "--cross-file=${crossFile}"
    ]
  );

  doCheck = true;

  postPatch = ''
    patchShebangs \
      utils/data-generators/cc/generate

    substituteInPlace tests/functional-tests/test_cli.py --replace-fail "TINYSPARQL-IMPORT(1)" "TINYSPARQL-IMPORT"
  '';

  preCheck =
    let
      linuxDot0 = lib.optionalString stdenv.hostPlatform.isLinux ".0";
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      export HOME=$(mktemp -d)

      mkdir -p $out/lib
      ln -s $PWD/src/libtinysparql/libtinysparql-3.0${extension} $out/lib/libtinysparql-3.0${extension}${linuxDot0}
    '';

  checkPhase = ''
    runHook preCheck

    dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test \
        --timeout-multiplier 0 \
        --print-errorlogs

    runHook postCheck
  '';

  postCheck = ''
    rm -r $out/lib
  '';

  postFixup = ''
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    homepage = "https://tracker.gnome.org/";
    description = "Desktop-neutral user information store, search tool and indexer";
    mainProgram = "tinysparql";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "tracker-sparql-3.0"
      "tinysparql-3.0"
    ];
  };
})
