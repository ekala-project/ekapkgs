{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  glib,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "meanwhile";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/meanwhile/meanwhile-${finalAttrs.version}.tar.gz";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ glib ];

  meta = {
    description = "Library for the Lotus Sametime Community Client protocol";
    homepage = "https://sourceforge.net/projects/meanwhile/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
