{
  lib,
  stdenv,
  fetchurl,
  libGLU,
  libGL,
  libx11,
  xorgproto,
  tcl,
  libglut,
  freetype,
  sfml_2 ? null,
  libxi,
  libxmu,
  libxext,
  libxt,
  libsm,
  libice,
  libpng,
  pkg-config,
  gettext,
  intltool,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.8.4";
  pname = "extremetuxracer";

  src = fetchurl {
    url = "mirror://sourceforge/extremetuxracer/etr-${finalAttrs.version}.tar.xz";
    hash = "sha256-+jKFzAx1Wlr/Up8/LOo1FkgRFMa0uOHsB2n+7/BHc+U=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    libGLU
    libGL
    libx11
    xorgproto
    tcl
    libglut
    freetype
    libxi
    libxmu
    libxext
    libxt
    libsm
    libice
    libpng
    gettext
  ]
  ++ lib.optional (sfml_2 != null) sfml_2;

  configureFlags = [ "--with-tcl=${tcl}/lib" ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE"
  '';

  meta = {
    description = "High speed arctic racing game based on Tux Racer";
    license = lib.licenses.gpl2Plus;
    homepage = "https://sourceforge.net/projects/extremetuxracer/";
    mainProgram = "etr";
    platforms = lib.platforms.linux;
  };
})
