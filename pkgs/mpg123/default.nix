{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmpg123";
  version = "1.33.4";

  src = fetchurl {
    url = "mirror://sourceforge/mpg123/mpg123-${finalAttrs.version}.tar.bz2";
    hash = "sha256-OujJ/4Cpe/wOIuifvNdGh+yk/B2zFbEmB/J/ActaR9k=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  configureFlags = [
    "--with-audio=${
      lib.concatStringsSep "," (lib.optional stdenv.hostPlatform.isLinux "alsa" ++ [ "dummy" ])
    }"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Fast console MPEG Audio Player and decoder library";
    homepage = "https://mpg123.org";
    license = lib.licenses.lgpl21Only;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
