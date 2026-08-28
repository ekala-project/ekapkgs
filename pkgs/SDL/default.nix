{
  lib,
  SDL2,
  cmake,
  fetchFromGitHub,
  libGLU,
  libiconv,
  xorg,
  mesa,
  pkg-config,
  pkg-config-unwrapped,
  stdenv,
  libGLSupported ? lib.elem stdenv.hostPlatform.system mesa.meta.platforms,
  openglSupport ? libGLSupported,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL_compat";
  version = "1.2.68";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "sdl12-compat";
    rev = "release-" + finalAttrs.version;
    hash = "sha256-f2dl3L7/qoYNl4sjik1npcW/W09zsEumiV9jHuKnUmM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  # re-export PKG_CHECK_MODULES m4 macro used by sdl.m4
  propagatedNativeBuildInputs = [ pkg-config-unwrapped ];

  buildInputs = [
    xorg.libX11
    SDL2
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ]
  ++ lib.optionals openglSupport [ libGLU ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CMAKE_SKIP_RPATH TRUE)' 'set(CMAKE_SKIP_RPATH FALSE)'
  '';

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

  doCheck = !stdenv.hostPlatform.isDarwin;
  checkPhase = ''
    runHook preCheck
    ./testver
    runHook postCheck
  '';

  postInstall = ''
    # allow as a drop in replacement for SDL
    ln -s $out/lib/pkgconfig/sdl12_compat.pc $out/lib/pkgconfig/sdl.pc
  '';

  patches = [ ./find-headers.patch ];
  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://www.libsdl.org/";
    description = "Cross-platform multimedia library - build SDL 1.2 applications against 2.0";
    license = lib.licenses.zlib;
    mainProgram = "sdl-config";
    platforms = lib.platforms.all;
    pkgConfigModules = [
      "sdl"
      "sdl12_compat"
    ];
  };
})
