{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  libxau,
  libxext,
  libxmu,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xauth";
  version = "1.1.5";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xauth-${finalAttrs.version}.tar.xz";
    hash = "sha256-pAAOL0QfrOv1aQJr7ezCO6JizGknvlIHCr4AAmJc++A=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxau
    libxext
    libxmu
    xorgproto
  ];

  meta = {
    description = "X authority file utility";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xauth";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xauth";
    platforms = lib.platforms.unix;
  };
})
