{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  libdvdread,
  libxml2,
  freetype,
  fribidi,
  libpng,
  zlib,
  pkg-config,
  flex,
  bison,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "dvdauthor";
  version = "0.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/dvdauthor/dvdauthor-${version}.tar.gz";
    hash = "sha256-MCCpLen3jrNvSLbyLVoAHEcQeCZjSnhaYt/NCA9hLrc=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    libxml2
  ];

  buildInputs = [
    libpng
    freetype
    libdvdread
    libxml2
    zlib
    fribidi
    flex
    bison
  ];

  # The libxml.m4 macro (AM_PATH_XML2) is missing from ekapkgs' libxml2.
  # Provide a minimal version that delegates to pkg-config.
  postPatch = ''
    mkdir -p m4
    cat > m4/libxml.m4 << 'M4EOF'
    AC_DEFUN([AM_PATH_XML2],[
      AC_REQUIRE([PKG_PROG_PKG_CONFIG])
      verdep=ifelse([$1], [], [], [">= $1"])
      PKG_CHECK_MODULES(XML, [libxml-2.0 $verdep], [$2], [$3])
      XML_CPPFLAGS=$XML_CFLAGS
      AC_SUBST(XML_CPPFLAGS)
      AC_SUBST(XML_LIBS)
    ])
    M4EOF
    cp ${gettext}/share/gettext/m4/*.m4 m4/
    export ACLOCAL_PATH="$PWD/m4:$ACLOCAL_PATH"
  '';

  configureFlags = [
    "FREETYPECONFIG=${lib.getExe' (lib.getDev freetype) "freetype-config"}"
    "XML2_CONFIG=${lib.getExe' (lib.getDev libxml2) "xml2-config"}"
  ];

  meta = {
    description = "Tools for generating DVD files to be played on standalone DVD players";
    homepage = "https://dvdauthor.sourceforge.net/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
