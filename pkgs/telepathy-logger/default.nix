{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  dbus-glib,
  telepathy-glib,
  libxml2,
  sqlite,
  gobject-introspection,
  intltool,
  python3,
  libxslt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "telepathy-logger";
  version = "0.8.2";

  src = fetchurl {
    url = "https://telepathy.freedesktop.org/releases/telepathy-logger/telepathy-logger-${finalAttrs.version}.tar.bz2";
    hash = "sha256-j8rVNNZTsbNlEyxbFYra6UeBD/uumEP3LdF5eWZBXa4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gobject-introspection
    intltool
    libxslt
    pkg-config
    python3
  ];

  buildInputs = [
    dbus-glib
    glib
    libxml2
    sqlite
    telepathy-glib
  ];

  configureFlags = [
    "--enable-introspection"
  ];

  postPatch = ''
    # Fix Python 2 syntax (xrange) for Python 3
    find . -name '*.py' -exec sed -i 's/\bxrange\b/range/g' {} +
  '';

  meta = {
    description = "Logger service for the Telepathy framework";
    homepage = "https://telepathy.freedesktop.org/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
