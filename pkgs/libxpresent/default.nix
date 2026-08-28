{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  libxfixes,
  libxrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxpresent";
  version = "1.0.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXpresent-${finalAttrs.version}.tar.xz";
    hash = "sha256-TlshtIEiBqSyIwE2Bq4xFwUCwQQwOHd6Hvj3DAnTdgI=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
    libxfixes
    libxrandr
  ];

  propagatedBuildInputs = [
    xorgproto
    libxfixes
  ];

  meta = {
    description = "Library for the X Present Extension";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxpresent";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
