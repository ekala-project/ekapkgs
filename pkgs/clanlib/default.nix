{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libGL,
  libpng,
  pkg-config,
  xorgproto,
  freetype,
  fontconfig,
  alsa-lib,
  libxrender,
  libxinerama,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clanlib";
  version = "4.2.0";

  src = fetchFromGitHub {
    repo = "ClanLib";
    owner = "sphair";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sRHRkT8NiKVfa9YgP6DYV9WzCZoH7f0phHpoYMnCk98=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libGL
    libpng
    xorgproto
    freetype
    fontconfig
    alsa-lib
    libxrender
    libxinerama
  ];

  meta = {
    homepage = "https://github.com/sphair/ClanLib";
    description = "Cross platform toolkit library with a primary focus on game creation";
    license = lib.licenses.mit;
    platforms = with lib.platforms; lib.intersectLists linux (x86 ++ arm ++ aarch64 ++ riscv);
  };
})
