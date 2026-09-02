{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-xfree86-type1";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-xfree86-type1-${finalAttrs.version}.tar.xz";
    hash = "sha256-qTwseIpeocACr3yGYs+dmCH7HfUbjSssXgAm39/qSDc=";
  };

  strictDeps = true;

  nativeBuildInputs = [ mkfontscale ];

  meta = {
    description = "XFree86 Cusrsor Postscript Type 1 Font";
    homepage = "https://gitlab.freedesktop.org/xorg/font/xfree86-type1";
    license = lib.licenses.x11;
    platforms = lib.platforms.unix;
  };
})
