{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxv";
  version = "1.0.13";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXv-${finalAttrs.version}.tar.xz";
    hash = "sha256-fTSRCVjhwfjRk9go/qG32hkilygKNUN68GkvADugN1U=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
  ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  meta = {
    description = "Xlib-based library for the X Video (Xv) extension to the X Window System";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxv";
    license = with lib.licenses; [
      hpnd
      hpndSellVariant
    ];
    platforms = lib.platforms.unix;
  };
})
