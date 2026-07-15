{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxfixes";
  version = "6.0.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXfixes-${finalAttrs.version}.tar.xz";
    hash = "sha256-OfEV1y2cX4ER5GhBZNPWjMH9Ifmyf/JAGwj938D0Cbo=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
  ];

  meta = {
    description = "Xlib-based library for the XFIXES Extension";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxfixes";
    license = with lib.licenses; [
      hpndSellVariant
      mit
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
