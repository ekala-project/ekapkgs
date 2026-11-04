{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libosip2";
  version = "5.3.2";

  src = fetchurl {
    url = "mirror://gnu/osip/libosip2-${finalAttrs.version}.tar.gz";
    hash = "sha256-Fhhvb1VAk2tiw6rKboQJ4a8lzSKrw4grOTviFfSdOwA=";
  };

  meta = {
    homepage = "https://www.gnu.org/software/osip/";
    description = "GNU oSIP library, an implementation of the Session Initiation Protocol (SIP)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
})
