{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  flex,
  bison,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bsd-games";
  version = "3.3";

  src = fetchurl {
    url = "mirror://sourceforge/bsd-games/bsd-games-${finalAttrs.version}.tar.gz";
    hash = "sha256-eL/ff04fYe1CrRIJ71JSC4mlg71RHpYGuBYvgTB4BI0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    flex
    bison
  ];

  buildInputs = [ ncurses ];

  makeFlags = [
    "prefix=$(out)"
  ];

  configureFlags = [
    "--prefix=$(out)"
    "--localstatedir=$(out)/var/lib"
  ];

  # The default INSTALL_SCORE uses "-g users" which fails in the sandbox
  postConfigure = ''
    sed -i 's/INSTALL_SCORE.*/INSTALL_SCORE := $(INSTALL) -m 664 \/dev\/null/' Config.mk
  '';

  meta = {
    description = "Classic BSD games collection";
    homepage = "https://sourceforge.net/projects/bsd-games/";
    license = lib.licenses.bsdOriginal;
    platforms = lib.platforms.linux;
  };
})
