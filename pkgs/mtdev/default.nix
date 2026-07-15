{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtdev";
  version = "1.1.7";

  src = fetchurl {
    url = "https://bitmath.org/code/mtdev/mtdev-${finalAttrs.version}.tar.bz2";
    hash = "sha256-oQetrSEB/srFSsf58OCg3RVdlUGT2lXCNAyX8v8dgU4=";
  };

  meta = {
    homepage = "https://bitmath.org/code/mtdev/";
    description = "Multitouch Protocol Translation Library";
    mainProgram = "mtdev-test";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = with lib.platforms; freebsd ++ linux;
  };
})
