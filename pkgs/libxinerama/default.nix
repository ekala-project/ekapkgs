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
  pname = "libxinerama";
  version = "1.1.6";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXinerama-${finalAttrs.version}.tar.xz";
    hash = "sha256-0A/BWZwwPcXLwSK4BovcdAXW/LGQYPRZf8Ub06i+Udc=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
  ];

  propagatedBuildInputs = [ xorgproto ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  meta = {
    description = "Library for Xinerama extension to X11 Protocol";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxinerama";
    license = with lib.licenses; [
      mit
      mitOpenGroup
    ];
    platforms = lib.platforms.unix;
  };
})
