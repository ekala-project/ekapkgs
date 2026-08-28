{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unifdef";
  version = "2.12";

  src = fetchurl {
    url = "https://dotat.at/prog/unifdef/unifdef-${finalAttrs.version}.tar.xz";
    hash = "sha256-Q84PAuzc3HI7JHVXVWPdsZLpiMiG02gmC8CmOu46xAA=";
  };

  patches = [
    ./unifdef-fix-build-with-gcc15.patch
  ];

  makeFlags = [
    "prefix=$(out)"
    "DESTDIR="
  ];

  meta = {
    homepage = "https://dotat.at/prog/unifdef/";
    description = "Selectively remove C preprocessor conditionals";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
  };
})
