{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxfixes,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxcomposite";
  version = "0.4.7";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXcomposite-${finalAttrs.version}.tar.xz";
    hash = "sha256-i98xCWf0hFA/pRcUz5e/8HI9m2c+Duy/krP5fAYMjMs=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxfixes
  ];

  propagatedBuildInputs = [
    xorgproto
    libxfixes
  ];

  meta = {
    description = "Client library for the Composite extension to the X11 protocol";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcomposite";
    license = with lib.licenses; [
      hpndSellVariant
      mit
    ];
    platforms = lib.platforms.unix;
  };
})
