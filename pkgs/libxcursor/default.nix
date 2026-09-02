{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxfixes,
  libxrender,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxcursor";
  version = "1.2.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXcursor-${finalAttrs.version}.tar.xz";
    hash = "sha256-/elALdTP552nHi2Wu5gK/F5v9Pin10wVnhlmr7KywsA=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxfixes
    libxrender
  ];

  meta = {
    description = "X11 Cursor management library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcursor";
    license = lib.licenses.hpndSellVariant;
    platforms = lib.platforms.unix;
  };
})
