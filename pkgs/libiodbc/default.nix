{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libiodbc";
  version = "3.52.16";

  src = fetchurl {
    url = "mirror://sourceforge/iodbc/libiodbc-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-OJizLQeWE2D28s822zYDa3GaIw5HZGklioDzIkPoRfo=";
  };

  configureFlags = [ "--disable-libodbc" ];

  nativeBuildInputs = [ pkg-config ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  preBuild = ''
    export NIX_LDFLAGS_BEFORE="-rpath $out/lib"
  '';

  meta = {
    description = "iODBC driver manager";
    homepage = "https://www.iodbc.org";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
  };
})
