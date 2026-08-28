{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-sun-misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-sun-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-3YTdEW2Sev+k+g+ilyez7PwPBkI4gXwKHlUqCsOE258=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "Open Look Glyph and Cursor pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/sun-misc/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
