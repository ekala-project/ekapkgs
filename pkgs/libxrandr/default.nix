{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  libxrender,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxrandr";
  version = "1.5.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXrandr-${finalAttrs.version}.tar.xz";
    hash = "sha256-crkiwudlQ06enwlgFIBwvUUEsogmPihopMzOG3zydno=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
    libxrender
  ];

  propagatedBuildInputs = [ libxrender ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  meta = {
    description = "Xlib Resize, Rotate and Reflection (RandR) extension library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxrandr";
    license = lib.licenses.hpndSellVariant;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
