{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "ragel";
  version = "6.10";

  src = fetchurl {
    url = "https://www.colm.net/files/ragel/${pname}-${version}.tar.gz";
    sha256 = "0gvcsl62gh6sg73nwaxav4a5ja23zcnyxncdcdnqa2yjcpdnw5az";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=gnu++98";

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "State machine compiler";
    homepage = "https://www.colm.net/open-source/ragel/";
    license = lib.licenses.gpl2;
    mainProgram = "ragel";
    platforms = lib.platforms.unix;
  };
}
