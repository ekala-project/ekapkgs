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
  docbook_xml_dtd_42,
  libxml2,
  gst_all_1,
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
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
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
    docbook_xml_dtd_42
    libxml2
    ninja
  ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "systemd" enableSystemd)
    "-Ddbus_sys=${placeholder "out"}/share/dbus-1/system.d"
    "-Ddbus_services=${placeholder "out"}/share/dbus-1/system-services"
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dcron=false"
    "-Dgtk_doc=true"
    "-Dbash_completion=false"
    "-Dbash_command_not_found=false"
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
