{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  glib,
  linux-pam,
  popt,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libuser";
  version = "0.64";

  src = fetchgit {
    url = "https://pagure.io/libuser.git";
    rev = "libuser-${finalAttrs.version}";
    hash = "sha256-5jIjX2aU5ReiPiHsuqVGvUY8A22PkvzuegT0V/xrft0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    glib
    linux-pam
    popt
  ];

  meta = {
    description = "Library for user and group account administration";
    homepage = "https://pagure.io/libuser";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
