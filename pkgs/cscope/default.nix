{
  fetchurl,
  lib,
  stdenv,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cscope";
  version = "15.9";

  src = fetchurl {
    url = "mirror://sourceforge/cscope/cscope-${finalAttrs.version}.tar.gz";
    sha256 = "0ngiv4aj3rr35k3q3wjx0y19gh7i1ydqa0cqip6sjwd8fph5ll65";
  };

  configureFlags = [ "--with-ncurses=${ncurses.dev}" ];

  buildInputs = [ ncurses ];

  meta = {
    description = "Developer's tool for browsing source code";
    homepage = "https://cscope.sourceforge.net/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
