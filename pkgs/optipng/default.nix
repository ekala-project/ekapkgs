{
  lib,
  stdenv,
  fetchurl,
  libpng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "optipng";
  version = "7.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/optipng/optipng-${finalAttrs.version}.tar.gz";
    hash = "sha256-wleb5YwsZtrp1jFU7cs9Qn/vZMsA7Ar/B5ydFW7Ebyk=";
  };

  buildInputs = [ libpng ];

  # Workaround for crash in cexcept.h
  preConfigure = ''
    export LD=$CC
  '';

  # OptiPNG does not like --static, --build or --host
  dontDisableStatic = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];

  configureFlags = [
    "--with-system-zlib"
    "--with-system-libpng"
  ];

  meta = {
    homepage = "https://optipng.sourceforge.net/";
    description = "PNG optimizer";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    mainProgram = "optipng";
  };
})
