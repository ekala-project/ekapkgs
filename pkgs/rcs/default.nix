{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  diffutils,
  ed,
  lzip,
}:

stdenv.mkDerivation rec {
  pname = "rcs";
  version = "5.10.1";

  src = fetchurl {
    url = "mirror://gnu/rcs/${pname}-${version}.tar.lz";
    sha256 = "sha256-Q93+EHJKi4XiRo9kA7YABzcYbwHmDgvWL95p2EIjTMU=";
  };

  ac_cv_path_ED = "${ed}/bin/ed";
  DIFF = "${diffutils}/bin/diff";
  DIFF3 = "${diffutils}/bin/diff3";

  disallowedReferences = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    buildPackages.diffutils
    buildPackages.ed
  ];

  env.NIX_CFLAGS_COMPILE = "-std=c99";

  hardeningDisable = lib.optional stdenv.cc.isClang "format";

  nativeBuildInputs = [ lzip ];

  meta = {
    homepage = "https://www.gnu.org/software/rcs/";
    description = "Revision control system";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
