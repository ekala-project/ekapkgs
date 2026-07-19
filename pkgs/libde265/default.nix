{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.1.1";
  pname = "libde265";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libde265";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZHfPC86oylqt2bwWMJRWVjdMEEmX6UOKR7XkR0HPyok=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/strukturag/libde265";
    description = "Open h.265 video codec implementation";
    mainProgram = "dec265";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
