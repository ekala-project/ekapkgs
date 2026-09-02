{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  gtk-doc,
  pkg-config,
  intltool,
  gettext,
  glib,
  libxml2,
  zlib,
  bzip2,
  perl,
  gdk-pixbuf,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "libgsf";
  version = "1.14.53";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgsf";
    rev = "LIBGSF_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-vC/6QEoV6FvFxQ0YlMkBbTmAtqbkvgZf+9BU8epi8yo=";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace "AC_PATH_PROG(PKG_CONFIG, pkg-config, no)" \
                "PKG_PROG_PKG_CONFIG"
  '';

  nativeBuildInputs = [
    autoreconfHook
    gtk-doc
    pkg-config
    intltool
  ];

  buildInputs = [
    gettext
    bzip2
    zlib
  ];

  nativeCheckInputs = [
    perl
  ];

  propagatedBuildInputs = [
    libxml2
    glib
    gdk-pixbuf
    libiconv
  ];

  doCheck = false;

  preConfigure = ''
    export PKG_CONFIG="$(command -v "$PKG_CONFIG")"
  '';

  meta = {
    description = "GNOME's Structured File Library";
    homepage = "https://www.gnome.org/projects/libgsf";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.unix;
  };
}
