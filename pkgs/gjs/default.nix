{
  fetchurl,
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  gtk3,
  gobject-introspection,
  pango,
  cairo,
  glib,
  dbus,
  makeWrapper,
  # TODO: spidermonkey_140 (mozjs) is not yet available in ekapkgs
  spidermonkey_140 ? null,
  # TODO: readline is not yet available in ekapkgs
  readline ? null,
  # TODO: libsysprof-capture is not yet available in ekapkgs
  libsysprof-capture ? null,
  # TODO: libxml2 is not yet available in ekapkgs
  libxml2 ? null,
  # TODO: gdk-pixbuf is not yet available in ekapkgs
  gdk-pixbuf ? null,
  # TODO: harfbuzz is not yet available in ekapkgs
  harfbuzz ? null,
  # TODO: which is not yet available in ekapkgs
  which ? null,
  # TODO: xvfb-run is not yet available in ekapkgs
  xvfb-run ? null,
  atk,
  installTests ? true,
}:

let
  testDeps = [
    gtk3
    atk
    pango.out
    glib.out
  ]
  ++ lib.optional (gdk-pixbuf != null) gdk-pixbuf
  ++ lib.optional (harfbuzz != null) harfbuzz;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gjs";
  version = "1.88.1";

  outputs = [
    "out"
    "dev"
    "installedTests"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/${lib.versions.majorMinor finalAttrs.version}/gjs-${finalAttrs.version}.tar.xz";
    hash = "sha256-dnurgOZl1nLLAFY8JfCzkqnsjCmW7R1EVMaYtMLwo9k=";
  };

  patches = [
    # Hard-code various paths
    ./fix-paths.patch

    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch

    # Disable introspection test in installed tests
    ./disable-introspection-test.patch

    # Disable umlaut filename test (fails on ZFS)
    ./disable-umlaut-test.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    dbus # for dbus-run-session
    gobject-introspection
  ]
  ++ lib.optional (which != null) which # for locale detection
  ++ lib.optional (libxml2 != null) libxml2; # for xml-stripblanks

  buildInputs = [
    cairo
  ]
  ++ lib.optional (readline != null) readline
  ++ lib.optional (libsysprof-capture != null) libsysprof-capture
  ++ lib.optional (spidermonkey_140 != null) spidermonkey_140;

  nativeCheckInputs = lib.optional (xvfb-run != null) xvfb-run;

  checkInputs = testDeps;

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
    (lib.mesonBool "skip_gtk_tests" (!finalAttrs.finalPackage.doCheck))
  ] ++ lib.optionals (!stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isMusl) [
    "-Dprofiler=disabled"
  ];

  doCheck = false;

  strictDeps = true;

  postPatch = ''
    patchShebangs build/choose-tests-locale.sh
    substituteInPlace installed-tests/debugger-test.sh --subst-var-by gjsConsole $out/bin/gjs-console
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace installed-tests/js/meson.build \
      --replace "'Encoding'," "#'Encoding',"
  '';

  postInstall = ''
    # TODO: make the glib setup hook handle moving the schemas in other outputs.
    installedTestsSchemaDatadir="$installedTests/share/gsettings-schemas/gjs-${finalAttrs.version}"
    mkdir -p "$installedTestsSchemaDatadir"
    mv "$installedTests/share/glib-2.0" "$installedTestsSchemaDatadir"
  '';

  postFixup = lib.optionalString installTests ''
    wrapProgram "$installedTests/libexec/installed-tests/gjs/minijasmine" \
      --prefix XDG_DATA_DIRS : "$installedTestsSchemaDatadir" \
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" testDeps}"
  '';

  separateDebugInfo = stdenv.hostPlatform.isLinux;

  passthru = { };

  meta = {
    description = "JavaScript bindings for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/gjs/blob/master/doc/Home.md";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "gjs";
    maintainers = [ ];
    inherit (gobject-introspection.meta) platforms badPlatforms;
  };
})
