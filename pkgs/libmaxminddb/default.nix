{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmaxminddb";
  version = "1.14.1";

  src = fetchurl {
    url = "https://github.com/maxmind/libmaxminddb/releases/download/${finalAttrs.version}/libmaxminddb-${finalAttrs.version}.tar.gz";
    hash = "sha256-ylyH1BM5+LxNqrtT6Kk1azyZXy0kGbhde/+COy7MJS0=";
  };

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = "https://github.com/maxmind/libmaxminddb";
    license = lib.licenses.asl20;
    mainProgram = "mmdblookup";
    platforms = lib.platforms.all;
  };
})
