{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "time";
  version = "1.10";

  src = fetchurl {
    url = "mirror://gnu/time/time-${finalAttrs.version}.tar.xz";
    hash = "sha256-cGv3uERMqeuQN+ntoY4dDrfCMnrn2MLOOkgjxfgMexE=";
  };

  meta = {
    description = "Tool that runs programs and summarizes the system resources they use";
    license = lib.licenses.gpl3Plus;
    homepage = "https://www.gnu.org/software/time/";
    mainProgram = "time";
    platforms = lib.platforms.unix;
  };
})
