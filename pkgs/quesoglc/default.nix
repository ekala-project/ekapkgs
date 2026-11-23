{
  lib,
  stdenv,
  fetchurl,
  libGLU,
  libGL,
  glew,
  freetype,
  fontconfig,
  fribidi,
  libx11,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "quesoglc";
  version = "0.7.2-free";

  src = fetchurl {
    url = "mirror://sourceforge/quesoglc/quesoglc-${finalAttrs.version}.tar.bz2";
    hash = "sha256-et6YcO8alvOSOI+jl6NJMIYLsh/PilTqCQ8L37iHrSE=";
  };

  buildInputs = [
    libGLU
    libGL
    glew
    freetype
    fontconfig
    fribidi
    libx11
  ];

  # required for cross builds
  configureFlags = [
    # system glew is not compatible with chromium-bsu API assumption
    "--without-glew"

    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
    "ac_cv_func_memcmp_working=yes"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  # FIXME: Configure fails to use system glew.
  meta = {
    description = "Free implementation of the OpenGL Character Renderer";
    longDescription = ''
      QuesoGLC is a free (as in free speech) implementation of the OpenGL
      Character Renderer (GLC). QuesoGLC is based on the FreeType library,
      provides Unicode support and is designed to be easily ported to any
      platform that supports both FreeType and the OpenGL API.
    '';
    homepage = "https://quesoglc.sourceforge.net/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
