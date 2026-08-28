{
  lib,
  SDL2,
  cmake,
  fetchFromGitHub,
  libGLU,
  libx11,
  mesa,
  pkg-config,
  pkg-config-unwrapped,
  stdenv,
  # Boolean flags
  libGLSupported ? lib.elem stdenv.hostPlatform.system mesa.meta.platforms,
  openglSupport ? libGLSupported,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdl12-compat";
  version = "1.2.76";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "sdl12-compat";
    rev = "release-" + finalAttrs.version;
    hash = "sha256-hSHtYFn4gr8Y9cNyLBT6frDgidNCRENPtTrtGfgH3po=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  # re-export PKG_CHECK_MODULES m4 macro used by sdl.m4
  propagatedNativeBuildInputs = [ pkg-config-unwrapped ];

  buildInputs = [
    libx11
    SDL2
  ]
  ++ lib.optionals openglSupport [ libGLU ];

  dontPatchELF = true; # don't strip rpath

  cmakeFlags =
    let
      rpath = lib.makeLibraryPath [ SDL2 ];
    in
    [
      (lib.cmakeFeature "CMAKE_INSTALL_RPATH" rpath)
      (lib.cmakeFeature "CMAKE_BUILD_RPATH" rpath)
      (lib.cmakeBool "SDL12TESTS" finalAttrs.finalPackage.doCheck)
    ];

  enableParallelBuilding = true;

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./test/testver
    runHook postCheck
  '';

  postInstall = ''
    # allow as a drop in replacement for SDL
    # Can be removed after treewide switch from pkg-config to pkgconf
    ln -s $out/lib/pkgconfig/sdl12_compat.pc $out/lib/pkgconfig/sdl.pc
  '';

  patches = [
    ./find-headers.patch
  ];
  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://www.libsdl.org/";
    description = "Cross-platform multimedia library - build SDL 1.2 applications against 2.0";
    license = lib.licenses.zlib;
    mainProgram = "sdl-config";
    platforms = lib.platforms.all;
  };
})
