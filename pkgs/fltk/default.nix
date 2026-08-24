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

  cmakeFlags = [
    (lib.cmakeBool "OPTION_BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "OPTION_USE_SYSTEM_ZLIB" true)
    (lib.cmakeBool "OPTION_USE_SYSTEM_LIBJPEG" true)
    (lib.cmakeBool "OPTION_USE_SYSTEM_LIBPNG" true)

    (lib.cmakeBool "OPTION_USE_XINERAMA" true)
    (lib.cmakeBool "OPTION_USE_XFIXES" true)
    (lib.cmakeBool "OPTION_USE_XCURSOR" true)
    (lib.cmakeBool "OPTION_USE_XFT" true)
    (lib.cmakeBool "OPTION_USE_XRENDER" true)
    (lib.cmakeBool "OPTION_USE_XDBE" true)

    (lib.cmakeBool "OPTION_USE_GL" true)
    "-DOpenGL_GL_PREFERENCE=GLVND"

    (lib.cmakeBool "OPTION_CAIRO" true)
    (lib.cmakeBool "OPTION_CAIROEXT" true)

    (lib.cmakeBool "FLTK_BUILD_EXAMPLES" true)
    (lib.cmakeBool "FLTK_BUILD_TEST" true)

    (lib.cmakeBool "OPTION_BUILD_HTML_DOCUMENTATION" false)
    (lib.cmakeBool "OPTION_INSTALL_HTML_DOCUMENTATION" false)
    (lib.cmakeBool "OPTION_INCLUDE_DRIVER_DOCUMENTATION" false)
    (lib.cmakeBool "OPTION_BUILD_PDF_DOCUMENTATION" false)
    (lib.cmakeBool "OPTION_INSTALL_PDF_DOCUMENTATION" false)

    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
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
    maintainers = [ ];
  };
})
