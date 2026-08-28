{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nload";
  version = "0.7.4";

  src = fetchurl {
    url = "https://www.roland-riegel.de/nload/nload-${finalAttrs.version}.tar.gz";
    sha256 = "1rb9skch2kgqzigf19x8bzk211jdfjfdkrcvaqyj89jy2pkm3h61";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/rolandriegel/nload/commit/8a93886e0fb33a81b8fe32e88ee106a581fedd34.patch";
      name = "nload-0.7.4-Eliminate-flicker-on-some-terminals.patch";
      sha256 = "10yppy5l50wzpcvagsqkbyf1rcan6aj30am4rw8hmkgnbidf4zbq";
    })
  ];

  buildInputs = [ ncurses ];

  meta = {
    description = "Monitors network traffic and bandwidth usage with ncurses graphs";
    homepage = "https://www.roland-riegel.de/nload/index.html";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    mainProgram = "nload";
  };
})
