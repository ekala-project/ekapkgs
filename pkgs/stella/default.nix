{
  lib,
  SDL2,
  fetchFromGitHub,
  sqlite,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stella";
  version = "7.0c";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = finalAttrs.version;
    hash = "sha256-I2R+nILzHDupL0QU76PxqXuD1D6TXXVUvMDzEjWVi00=";
  };

  nativeBuildInputs = [
    SDL2
    pkg-config
  ];

  buildInputs = [
    SDL2
    sqlite
  ];

  strictDeps = true;

  meta = {
    homepage = "https://stella-emu.github.io/";
    description = "Open-source Atari 2600 VCS emulator";
    changelog = "https://github.com/stella-emu/stella/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "stella";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
