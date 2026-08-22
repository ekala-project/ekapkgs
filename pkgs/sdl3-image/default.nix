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
  version = "3.2.6";

  outputs = [
    "lib"
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL_image";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-CnUCqFq9ZaM/WQcmaCpQdjtjR9l5ymzgeqEJx7ZW/s4=";
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

  cmakeFlags = [
    (lib.cmakeBool "SDLIMAGE_STRICT" false)
    (lib.cmakeBool "SDLIMAGE_DEPS_SHARED" false)
    (lib.cmakeBool "SDLIMAGE_BACKEND_STB" enableSTB)
    (lib.cmakeBool "SDLIMAGE_BACKEND_IMAGEIO" false)
    (lib.cmakeBool "SDLIMAGE_TESTS" enableTests)
    (lib.cmakeBool "SDLIMAGE_AVIF" (libavif != null))
  ];

  meta = {
    description = "SDL image library";
    homepage = "https://github.com/libsdl-org/SDL_image";
    license = lib.licenses.zlib;
    maintainers = [ ];
    inherit (sdl3.meta) platforms;
  };
})
