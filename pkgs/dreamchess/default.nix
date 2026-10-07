{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  flex,
  gettext,
  makeWrapper,
  sdl2-compat,
  SDL2_image,
  SDL2_mixer,
  expat,
  glew,
  freetype,
  libsm,
  libxext,
  libGL,
  libGLU,
  libx11,
  libxcb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dreamchess";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "dreamchess";
    repo = "dreamchess";
    rev = "${finalAttrs.version}";
    hash = "sha256-qus/RjwdAl9SuDXfLVKTPImqrvPF3xSDVlbXYLM3JNE=";
  };

  patches = [
    ### Fix cmake minimum version
    ./0000-fix-cmake-min.patch
  ];

  buildInputs = [
    sdl2-compat
    SDL2_image
    SDL2_mixer
    expat
    glew
    freetype
    libsm
    libxext
    libGL
    libGLU
    libxcb
    libx11
  ];
  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    bison
    flex
    gettext
    makeWrapper
  ];
  cmakeEntries = {
    CMAKE_VERBOSE_MAKEFILE = true;
    OpenGL_GL_PREFERENCE = "GLVND";
    CMAKE_INSTALL_DATAROOTDIR = "${placeholder ";
  };

  # This makes sure the default engine (dreamer) will be called from
  # the /nix/store/ as well when starting a new game
  postFixup = ''
    wrapProgram $out/bin/dreamchess \
      --prefix PATH : $out/bin
  '';

  postInstallCheck = ''
    stat "''${!outputBin}/bin/${finalAttrs.meta.mainProgram}"
    stat "''${!outputBin}/bin/dreamer"
  '';

  meta = {
    homepage = "https://github.com/dreamchess/dreamchess";
    description = "OpenGL Chess Game";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "dreamchess";
  };
})
