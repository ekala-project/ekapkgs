{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  dbus,
  expat,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dbus-cplusplus";
  version = "0.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/dbus-cplusplus/dbus-c++/${finalAttrs.version}/libdbus-c++-${finalAttrs.version}.tar.gz";
    hash = "sha256-vBGsKXs8sBC+kExyeJaVVD7j/fPXXNyCJf03E4WvTmE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    dbus
    expat
    glib
  ];

  env.NIX_CFLAGS_COMPILE = "-fpermissive -include unistd.h";

  configureFlags = [
    "--disable-ecore"
    "--disable-examples"
    "--disable-tests"
  ];

  meta = {
    description = "C++ API for D-Bus";
    homepage = "https://sourceforge.net/projects/dbus-cplusplus/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
