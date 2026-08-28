{
  lib,
  stdenv,
  fetchurl,
  libogg,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liboggz";
  version = "1.1.3";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/liboggz/liboggz-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-JGbQO2fvC8ug4Q+zUtGp/9n5aRFlerzjy7a6Qpxlbi8=";
  };

  propagatedBuildInputs = [ libogg ];

  nativeBuildInputs = [ pkg-config ];

  meta = {
    homepage = "https://xiph.org/oggz/";
    description = "C library and tools for manipulating with Ogg files and streams";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
  };
})
