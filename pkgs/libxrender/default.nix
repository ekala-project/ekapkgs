{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxrender";
  version = "0.9.12";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXrender-${finalAttrs.version}.tar.xz";
    hash = "sha256-uDISjaSLOcjWCCJEgXQ0A60Wkb9OVU5L6cF03xcdG5c=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
  ];

  propagatedBuildInputs = [
    xorgproto
    libx11
  ];

  configureFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  meta = {
    description = "Xlib library for the Render Extension to the X11 protocol";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxrender";
    license = lib.licenses.hpndSellVariant;
    maintainers = [ ];
    pkgConfigModules = [ "xrender" ];
    platforms = lib.platforms.unix;
  };
})
