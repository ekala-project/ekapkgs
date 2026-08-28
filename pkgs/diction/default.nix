{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "diction";
  version = "1.14";

  src = fetchurl {
    url = "https://www.moria.de/~michael/comp/diction/diction-${finalAttrs.version}.tar.gz";
    hash = "sha256-2gEvs6XLplZtI4zahpsM7NvvBFJ4DE02gQCoQEcv1/w=";
  };

  meta = {
    description = "GNU style and diction utilities";
    homepage = "https://www.moria.de/~michael/comp/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
