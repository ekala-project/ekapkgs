{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  autoreconfHook,
  gettext,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gts";
  version = "0.7.6";

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  src = fetchurl {
    url = "mirror://sourceforge/gts/gts-${finalAttrs.version}.tar.gz";
    sha256 = "07mqx09jxh8cv9753y2d2jsv7wp8vjmrd7zcfpbrddz3wc9kx705";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    glib
  ];

  buildInputs = [ gettext ];
  propagatedBuildInputs = [ glib ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  meta = {
    homepage = "https://gts.sourceforge.net/";
    license = lib.licenses.lgpl2Plus;
    description = "GNU Triangulated Surface Library";
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
