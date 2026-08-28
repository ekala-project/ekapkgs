{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-cronyx-cyrillic";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-cronyx-cyrillic-${finalAttrs.version}.tar.xz";
    hash = "sha256-3AeBzg3L/9v2quGgAXOhNAP5Kw3pJbylqeEX5OLWt4k=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "Cronyx pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/cronyx-cyrillic";
    license = lib.licenses.cronyx;
    platforms = lib.platforms.unix;
  };
})
