{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  sdl2-compat,
  SDL2_mixer,
  simpleini,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "li-ri";
  version = "3.1.6";

  src = fetchFromGitHub {
    owner = "petitlapin";
    repo = "Li-Ri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dw4r0tRUBNQfJzKZI9R51ansRyg9rztBOXjcvjSgJic=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
  ];
  buildInputs = [
    sdl2-compat
    SDL2_mixer
    simpleini
  ];

  cmakeEntries = {
    USE_SYSTEM_SIMPLEINI = true;
    LIRI_DATA_DIR = "${placeholder ";
  };

  meta = {
    homepage = "https://github.com/petitlapin/Li-Ri";
    description = "Drive a toy wood engine and collect all the coaches to win";
    platforms = with lib.platforms; linux;
    license = with lib.licenses; [
      # Code
      gpl2Only
      # or
      gpl3Only

      # Metadata
      cc0
    ];
    mainProgram = "Li-ri";
  };
})
