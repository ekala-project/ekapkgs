{
  stdenv,
  lib,
  qt6,
  fetchFromGitHub,
  cmake,
  doxygen,
  msgpack-c,
  neovim,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neovim-qt-unwrapped";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "equalsraf";
    repo = "neovim-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r77tg3xVemHW/zDNA6dYerFjFaYDDeHsD68WhMfI70Q=";
  };

  cmakeFlags = [
    "-DUSE_SYSTEM_MSGPACK=1"
    "-DENABLE_TESTS=0"
    "-DWITH_QT=Qt6"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    doxygen
    qt6.wrapQtAppsHook
    (python3.withPackages (ps: [
      ps.jinja2
      ps.msgpack
    ]))
  ];

  buildInputs = [
    neovim.unwrapped
    qt6.qtbase
    qt6.qtsvg
    msgpack-c
  ];

  meta = {
    description = "Neovim client library and GUI, in Qt";
    homepage = "https://github.com/equalsraf/neovim-qt";
    license = lib.licenses.isc;
    mainProgram = "nvim-qt";
    inherit (neovim.meta) platforms;
  };
})
