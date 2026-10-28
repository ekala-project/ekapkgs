{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libGL,
  mesa,
  sdl2-compat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "projectm";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "projectm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KsIbg4O5irsQYzG13SdUakEjo13kPzN3n3vLe81yLjY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    sdl2-compat
    libGL
    mesa
  ];

  cmakeEntries = {
    ENABLE_PLAYLIST = true;
  };

  meta = {
    description = "Cross-platform music visualization library";
    homepage = "https://github.com/projectM-visualizer/projectm";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
