{
  stdenv,
  lib,
  fetchurl,
  cmake,
}:

let
  isCross = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  isStatic = stdenv.hostPlatform.isStatic;
  isMusl = stdenv.hostPlatform.isMusl;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "libptytty";
  version = "2.0";

  src = fetchurl {
    url = "https://dist.schmorp.de/libptytty/libptytty-${finalAttrs.version}.tar.gz";
    sha256 = "1xrikmrsdkxhdy9ggc0ci6kg5b1hn3bz44ag1mk5k1zjmlxfscw0";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags =
    lib.optional isStatic "-DBUILD_SHARED_LIBS=OFF"
    ++ lib.optional (isCross || isStatic) "-DTTY_GID_SUPPORT=OFF"
    ++ lib.optionals isMusl [
      "-DUTMP_SUPPORT=OFF"
      "-DWTMP_SUPPORT=OFF"
      "-DLASTLOG_SUPPORT=OFF"
    ];

  meta = {
    description = "OS independent and secure pty/tty and utmp/wtmp/lastlog";
    homepage = "http://dist.schmorp.de/libptytty";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    broken = isStatic && isMusl;
  };
})
