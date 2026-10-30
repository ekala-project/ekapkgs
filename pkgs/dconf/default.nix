{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  python3,
  vala,
  libxslt,
  pkg-config,
  glib,
  bash-completion,
  dbus,
  gtk-doc,
  docbook-xsl-nons,
  docbook-xml-dtd,
  buildPackages,
  gobject-introspection,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  withDocs ? withIntrospection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dconf";
  version = "0.49.0";

  strictDeps = true;

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ]
  ++ lib.optional withDocs "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf/${lib.versions.majorMinor finalAttrs.version}/dconf-${finalAttrs.version}.tar.xz";
    sha256 = "FqR+SaWBVtu5ZXjhcIMlKZ5MGe6pvhKNW9Ev0JY9bDY=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    libxslt
    glib
    docbook-xsl-nons
    docbook-xml-dtd.v4_2
    gtk-doc
  ];

  buildInputs = [
    glib
    bash-completion
    dbus
  ]
  ++ lib.optionals withIntrospection [
    vala
  ];

  mesonEntries = {
    sysconfdir = "/etc";
    gtk_doc = withDocs;
    vapi = withIntrospection;
  };

  nativeCheckInputs = [
    dbus # for dbus-daemon
  ];

  mesonCheckFlags = [
    "--no-suite"
    "dconf:dconf-doc-check"
  ];

  postPatch = ''
    chmod +x tests/test-dconf.py tests/shellcheck.sh
    patchShebangs tests/test-dconf.py tests/shellcheck.sh
  '';

  passthru = {
    # TODO(ekaos): replace with integrationTests
    # tests = { inherit (nixosTests) dconf; };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/dconf";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    badPlatforms = [
      # Mandatory libdconfsettings shared library.
      lib.systems.inspect.platformPatterns.isStatic
    ];
    mainProgram = "dconf";
  };
})
