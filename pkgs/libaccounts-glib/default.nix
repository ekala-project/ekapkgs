{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  glib,
  check,
  python3,
  vala,
  gtk-doc,
  glibcLocales,
  libxml2,
  libxslt,
  pkg-config,
  sqlite,
  docbook_xsl,
  docbook_xml_dtd_43,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libaccounts-glib";
  version = "1.27";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "libaccounts-glib";
    rev = "VERSION_${finalAttrs.version}";
    hash = "sha256-mLhcwp8rhCGSB1K6rTWT0tuiINzgwULwXINfCbgPKEg=";
  };

  nativeBuildInputs = [
    check
    docbook_xml_dtd_43
    docbook_xsl
    glibcLocales
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    libxml2
    libxslt
    sqlite
  ];

  env.LC_ALL = "en_US.UTF-8";

  mesonFlags = [
    "-Dinstall-py-overrides=false"
  ];

  meta = {
    description = "Library for managing accounts which can be used from GLib applications";
    homepage = "https://gitlab.com/accounts-sso/libaccounts-glib";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21;
  };
})
