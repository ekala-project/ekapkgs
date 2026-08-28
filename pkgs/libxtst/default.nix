{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  libxi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxtst";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXtst-${finalAttrs.version}.tar.xz";
    hash = "sha256-tQ1MJblwCadEcGwQOcWY9NjmSRDJ/eOBmU4criNdkkI=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
    libxi
  ];

  meta = {
    description = "Library for the XTEST and RECORD X11 extensions";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxtst";
    license = with lib.licenses; [
      mitOpenGroup
      hpndSellVariant
      hpndDoc
      x11
      hpndDocSell
    ];
    platforms = lib.platforms.unix;
  };
})
