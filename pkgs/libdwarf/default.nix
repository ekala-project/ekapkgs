{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  zlib,
  zstd,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdwarf";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "davea42";
    repo = "libdwarf-code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-azVCzQt9oA40YACa9PkdNt0D8vWRNHXXGoSFOYNJxgA=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    zlib
    zstd
  ];

  outputs = [
    "bin"
    "lib"
    "dev"
    "out"
  ];

  meta = {
    description = "Library for reading DWARF2 and later DWARF";
    mainProgram = "dwarfdump";
    homepage = "https://github.com/davea42/libdwarf-code";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
  };
})
