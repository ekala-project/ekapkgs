{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xwud";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xwud-${finalAttrs.version}.tar.xz";
    hash = "sha256-5Vy+2rNtel9nGr+OWUiIr8SMqhFtUdQp6lPqMX7Axh4=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    xorgproto
  ];

  meta = {
    description = "Utility to display an image in XWD (X Window Dump) format";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xwud";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xwud";
    platforms = lib.platforms.unix;
  };
})
