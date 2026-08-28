{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "span-lite";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "martinmoene";
    repo = "span-lite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BYRSdGzIvrOjPXxeabMj4tPFmQ0wfq7y+zJf6BD/bTw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "C++20-like span for C++98, C++11 and later in a single-file header-only library";
    homepage = "https://github.com/martinmoene/span-lite";
    license = lib.licenses.bsd1;
    platforms = lib.platforms.all;
  };
})
