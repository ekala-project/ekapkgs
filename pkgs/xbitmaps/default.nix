{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xbitmaps";
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://xorg/individual/data/xbitmaps-${finalAttrs.version}.tar.xz";
    hash = "sha256-rWytVIh4MqF9hsLM/F5Sod+rCQ+DB7FSx4sOFSnND3o=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "X BitMap (XBM) format bitmaps commonly used in X.Org applications";
    homepage = "https://gitlab.freedesktop.org/xorg/data/bitmaps";
    license = with lib.licenses; [
      icu
      smlnj
    ];
    platforms = lib.platforms.unix;
  };
})
