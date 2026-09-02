{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-dec-misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-dec-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-gtloIB2P+L7A5R3M14G7TU6/F+EQBJRCeb3AIB4WGvc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "DEC cursors in pcf font format";
    homepage = "https://gitlab.freedesktop.org/xorg/font/dec-misc";
    license = lib.licenses.hpnd;
    platforms = lib.platforms.unix;
  };
})
