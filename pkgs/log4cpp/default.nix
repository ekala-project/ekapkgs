{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "log4cpp";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/log4cpp/log4cpp-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-oDa8a9YERHnmxFbeft0EKwYOpchD5HvrdfWbrqmyDjo=";
  };

  # Prevent autotools from trying to regenerate files due to timestamp skew
  postPatch = ''
    touch configure config.h.in include/config.h.in Makefile.in */Makefile.in
  '';

  meta = {
    homepage = "https://log4cpp.sourceforge.net/";
    description = "Logging framework for C++ patterned after Apache log4j";
    mainProgram = "log4cpp-config";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
