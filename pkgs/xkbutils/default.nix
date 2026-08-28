{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxaw,
  libxt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xkbutils";
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xkbutils-${finalAttrs.version}.tar.xz";
    hash = "sha256-MaK77h4JzLoB3pKJe49UC1Rd6BLzGNMd4HvTpade4l4=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxaw
    libxt
  ];

  meta = {
    description = "Collection of small XKB utilities";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xkbutils";
    license = with lib.licenses; [
      hpnd
      hpndDec
      mit
    ];
    platforms = lib.platforms.unix;
  };
})
