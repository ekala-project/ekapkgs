{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-cursor-misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-cursor-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-JdnJWVATy4yghCBQmZOmQ0yRflPKH+w/Y6zUWhnU+YI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "X Cursor as a pcf font";
    homepage = "https://gitlab.freedesktop.org/xorg/font/cursor-misc";
    # "These ""glyphs"" are unencumbered"
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
  };
})
