{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  libxext,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxxf86vm";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXxf86vm-${finalAttrs.version}.tar.xz";
    sha256 = "1qryzfzf3qr2xx1sipdn8kw310zs4ygpzgh4mm4m87fffd643bwn";
  };

  hardeningDisable = [
    "bindnow"
    "relro"
  ];

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxext
    xorgproto
  ];

  meta = {
    description = "X11 XFree86 video mode extension library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxxf86vm";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
