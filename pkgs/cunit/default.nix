{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  libtool,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "CUnit";
  version = "2.1-3";

  nativeBuildInputs = [
    autoreconfHook
    autoconf
    automake
  ];
  buildInputs = [ libtool ];

  src = fetchurl {
    url = "mirror://sourceforge/cunit/CUnit/${finalAttrs.version}/CUnit-${finalAttrs.version}.tar.bz2";
    sha256 = "057j82da9vv4li4z5ri3227ybd18nzyq81f6gsvhifs5z0vr3cpm";
  };

  meta = {
    description = "Unit Testing Framework for C";
    homepage = "https://cunit.sourceforge.net/";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
})
