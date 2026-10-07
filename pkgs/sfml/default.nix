{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  flac,
  freetype,
  glew,
  libjpeg,
  libvorbis,
  miniaudio,
  udev,
  libxi,
  libx11,
  libxcursor,
  libxrandr,
  libxrender,
  libxcb-image,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfml";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "SFML";
    tag = finalAttrs.version;
    hash = "sha256-YqlrY0iIsxcjlLb+buMU0zpXo7/eKSKxOsITWf7BX6s=";
  };

  patches = [
    ./unvendor-miniaudio.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    flac
    freetype
    glew
    libjpeg
    libvorbis
    miniaudio
    udev
    libx11
    libxi
    libxcursor
    libxrandr
    libxrender
    libxcb-image
  ];

  cmakeEntries = {
    SFML_INSTALL_PKGCONFIG_FILES = true;
    SFML_MISC_INSTALL_PREFIX = "share/SFML";
    SFML_BUILD_FRAMEWORKS = false;
    SFML_USE_SYSTEM_DEPS = true;
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    description = "Simple and fast multimedia library";
    homepage = "https://www.sfml-dev.org/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
  };
})
