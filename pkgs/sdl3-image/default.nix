{
  lib,
  sdl3,
  libavif ? null,
  libtiff,
  libwebp,
  stdenv,
  cmake,
  fetchFromGitHub,
  validatePkgConfig,
  libpng,
  libjpeg,
  # Boolean flags
  enableTests ? true,
  enableSTB ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl3-image";
  version = "3.4.6";

  outputs = [
    "lib"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_image";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-J2rg2DBcZt47lgivPhRJzeKgrYF6gOCZ0Ep2C9GndGg=";
  };

  strictDeps = true;
  doCheck = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    validatePkgConfig
  ];

  buildInputs = [
    sdl3
    libtiff
    libpng
    libwebp
  ]
  ++ lib.optional (libavif != null) libavif
  ++ lib.optional (!enableSTB) libjpeg;

  cmakeEntries = {
    SDLIMAGE_STRICT = false;
    SDLIMAGE_DEPS_SHARED = false;
    SDLIMAGE_BACKEND_STB = enableSTB;
    SDLIMAGE_BACKEND_IMAGEIO = false;
    SDLIMAGE_TESTS = enableTests;
  };

  cmakeFlags = [
    (lib.cmakeBool "SDLIMAGE_AVIF" (libavif != null))
  ];

  meta = {
    description = "SDL image library";
    homepage = "https://github.com/libsdl-org/SDL_image";
    license = lib.licenses.zlib;
    inherit (sdl3.meta) platforms;
  };
})
