{
  stdenv,
  fetchFromGitHub,
  lib,
  gettext,
  glib,
  pkg-config,
  polkit,
  python3,
  sqlite,
  gobject-introspection,
  vala,
  jansson,
  docbook_xsl_ns ? docbook-xsl-ns,
  docbook-xsl-ns ? null,
  gtk-doc,
  boost,
  meson,
  ninja,
  libxslt,
  docbook-xsl-nons,
  docbook-xml-dtd,
  libxml2,
  gstreamer,
  gtk3,
  enableSystemd ? true,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "packagekit";
  version = "1.3.5";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitHub {
    owner = "PackageKit";
    repo = "PackageKit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aKucwqwNyZWyHfNu9ntzSwD+eQy8KjCt6RVMjjjZmZg=";
  };

  buildInputs = [
    glib
    polkit
    python3
    gstreamer
    gstreamer.plugins-base
    gtk3
    jansson
    sqlite
    boost
  ]
  ++ lib.optional enableSystemd systemd;

  nativeBuildInputs = [
    gobject-introspection
    glib
    vala
    gettext
    pkg-config
    gtk-doc
    meson
    meson.configurePhaseHook
    libxslt
    docbook-xsl-nons
    docbook-xml-dtd.v4_2
    libxml2
    ninja
  ];

  strictDeps = true;

  mesonEntries = {
    systemd = enableSystemd;
    dbus_sys = "${placeholder ";
    dbus_services = "${placeholder ";
    systemdsystemunitdir = "${placeholder ";
    cron = false;
    gtk_doc = true;
    bash_completion = false;
    bash_command_not_found = false;
  };

  mesonFlags = [
    out"}/share/dbus-1/system.d"
    out"}/share/dbus-1/system-services"
    out"}/lib/systemd/system"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  postPatch = ''
    substituteInPlace etc/meson.build \
      --replace-fail "install_dir: join_paths(get_option('sysconfdir'), 'PackageKit')" "install_dir: join_paths('$out', 'etc', 'PackageKit')"
    substituteInPlace data/meson.build \
      --replace-fail "install_dir: join_paths(get_option('localstatedir'), 'lib', 'PackageKit')," "install_dir: join_paths('$out', 'var', 'lib', 'PackageKit'),"
  ''
  + lib.optionalString (docbook_xsl_ns != null) ''
    substituteInPlace client/meson.build \
      --replace-fail http://docbook.sourceforge.net/release/xsl-ns/current ${docbook_xsl_ns}/share/xml/docbook-xsl-ns
  '';

  meta = {
    description = "System to facilitate installing and updating packages";
    homepage = "https://github.com/PackageKit/PackageKit";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
