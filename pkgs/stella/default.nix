{
  lib,
  sdl2-compat,
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
    sdl2-compat
    pkg-config
  ];

  buildInputs = [
    sdl2-compat
    sqlite
  ];

  strictDeps = true;

  meta = {
    homepage = "https://stella-emu.github.io/";
    description = "Open-source Atari 2600 VCS emulator";
    changelog = "https://github.com/stella-emu/stella/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "stella";
    platforms = lib.platforms.unix;
  };
})
