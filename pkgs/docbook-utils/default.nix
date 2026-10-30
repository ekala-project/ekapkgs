{
  lib,
  stdenv,
  fetchurl,
  perl,
  opensp,
  openjade,
  docbook-dsssl,
  docbook-sgml-dtd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "docbook-utils";
  version = "0.6.14";

  src = fetchurl {
    url = "https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/docbook-utils-${finalAttrs.version}.tar.gz";
    hash = "sha256-SPqrjuinYFyTQvt7kG4IFePO6EpIkYKvOOj3wN8ukuk=";
  };

  nativeBuildInputs = [
    perl
  ];

  buildInputs = [
    opensp
    openjade
  ];

  # Prevent 'cd: /homeless-shelter' errors during config.status
  HOME = "/tmp";

  # docbook-utils expects 'jade' but openjade provides 'openjade'
  preConfigure = ''
    mkdir -p $TMPDIR/bin
    ln -s ${openjade}/bin/openjade $TMPDIR/bin/jade
    export PATH="$TMPDIR/bin:$PATH"
  '';

  configureFlags = [
    "--with-docbook-dsssl=${docbook-dsssl}/share/sgml/docbook/dsssl-stylesheets-${docbook-dsssl.version}"
  ];

  # Skip building the documentation (requires full SGML catalog setup)
  postConfigure = ''
    sed -i 's/SUBDIRS = backends bin doc frontends helpers/SUBDIRS = backends bin frontends helpers/' Makefile
  '';

  meta = {
    description = "Utilities for converting DocBook documents";
    homepage = "https://sourceware.org/docbook-tools/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
