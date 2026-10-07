{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zlib,
  libjpeg,
  libpng,
  fontconfig,
  freetype,
  libx11,
  libxext,
  libxinerama,
  libxfixes,
  libxcursor,
  libxft,
  libxrender,
  libGL,
  libGLU,
  glew,
  cairo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fltk";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "fltk";
    repo = "fltk";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-8Go/UNuZ1LEn8BniAyBbAPk7jdvSs5QvXxin9LAFvhU=";
  };

  outputs = [
    "out"
    "bin"
  ];

  outputBin = "out";

  postPatch = ''
    patchShebangs documentation/make_*
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    libGL
    libGLU
    glew
    fontconfig
  ];

  propagatedBuildInputs = [
    zlib
    libjpeg
    libpng
    freetype
    libx11
    libxext
    libxinerama
    libxfixes
    libxcursor
    libxft
    libxrender
    cairo
  ];

  cmakeEntries = {
    OPTION_USE_SYSTEM_ZLIB = true;
    OPTION_USE_SYSTEM_LIBJPEG = true;
    OPTION_USE_SYSTEM_LIBPNG = true;
    OPTION_USE_XINERAMA = true;
    OPTION_USE_XFIXES = true;
    OPTION_USE_XCURSOR = true;
    OPTION_USE_XFT = true;
    OPTION_USE_XRENDER = true;
    OPTION_USE_XDBE = true;
    OPTION_USE_GL = true;
    OpenGL_GL_PREFERENCE = "GLVND";
    OPTION_CAIRO = true;
    OPTION_CAIROEXT = true;
    FLTK_BUILD_EXAMPLES = true;
    FLTK_BUILD_TEST = true;
    OPTION_BUILD_HTML_DOCUMENTATION = false;
    OPTION_INSTALL_HTML_DOCUMENTATION = false;
    OPTION_INCLUDE_DRIVER_DOCUMENTATION = false;
    OPTION_BUILD_PDF_DOCUMENTATION = false;
    OPTION_INSTALL_PDF_DOCUMENTATION = false;
    CMAKE_SKIP_BUILD_RPATH = true;
  };

  cmakeFlags = [
    (lib.cmakeBool "OPTION_BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  postInstall = ''
    mkdir -p $bin/bin
    mv bin/{test,examples}/* $bin/bin/
  '';

  postFixup = ''
    substituteInPlace $out/bin/fltk-config \
      --replace-fail "/$out/" "/"
  '';

  meta = {
    description = "C++ cross-platform lightweight GUI library";
    homepage = "https://www.fltk.org";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl2Only;
  };
})
