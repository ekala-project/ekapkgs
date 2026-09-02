{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  gtk-doc,
  xkeyboard-config,
  libxml2,
  xorg,
  docbook_xsl,
  glib,
  isocodes,
  libxkbfile,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "libxklavier";
  version = "5.4";

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/archived-projects/libxklavier.git";
    rev = "${pname}-${version}";
    sha256 = "1w1x5mrgly2ldiw3q2r6y620zgd89gk7n90ja46775lhaswxzv7a";
  };

  patches = [
    ./honor-XKB_CONFIG_ROOT.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  propagatedBuildInputs = [
    xorg.libX11
    xorg.libXi
    xkeyboard-config
    libxml2
    xorg.libICE
    glib
    libxkbfile
    isocodes
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gtk-doc
    docbook_xsl
    gobject-introspection
  ];

  preAutoreconf = ''
    export NOCONFIGURE=1
    gtkdocize
  '';

  configureFlags = [
    "--with-xkb-base=${xkeyboard-config}/etc/X11/xkb"
    "--with-xkb-bin-base=${xorg.xkbcomp}/bin"
    "--disable-xmodmap-support"
    "--disable-gtk-doc"
  ];

  meta = {
    description = "Library providing high-level API for X Keyboard Extension known as XKB";
    homepage = "http://freedesktop.org/wiki/Software/LibXklavier";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
}
