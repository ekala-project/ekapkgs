{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  sqlcipher,
}:

let
  qt' = libsForQt5; # upstream has adopted qt6, but no released version supports it
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sqlitebrowser";
  version = "3.13.1";

  src = fetchFromGitHub {
    owner = "sqlitebrowser";
    repo = "sqlitebrowser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bpZnO8i8MDgOm0f93pBmpy1sZLJQ9R4o4ZLnGfT0JRg=";
  };

  patches = lib.optional stdenv.hostPlatform.isDarwin ./macos.patch;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '"Unknown"' '"${finalAttrs.src.rev}"'

    substituteInPlace src/app.plist \
      --replace-fail '@ICON@' 'icon.icns'
  ''
  # Fix build with CMake 4
  # Will be part of the Qt6 port
  # Note: The vendored version of qhexedit is incompatible with our qhexedit2: https://github.com/sqlitebrowser/sqlitebrowser/issues/1808
  + ''
    substituteInPlace libs/qhexedit/CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 2.8.12.2)' 'cmake_minimum_required(VERSION 3.16)'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    qt'.qttools
    qt'.wrapQtAppsHook
  ];

  buildInputs = [
    qt'.qtbase
    sqlcipher
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin qt'.qtmacextras;

  cmakeEntries = {
    sqlcipher = true;
    ENABLE_TESTING = finalAttrs.finalPackage.doCheck or false;
    FORCE_INTERNAL_QSCINTILLA = true;
    FORCE_INTERNAL_QCUSTOMPLOT = true;
    FORCE_INTERNAL_QHEXEDIT = true;
  };

  cmakeFlags = [
    "-Wno-dev"
  ];

  env.LANG = "C.UTF-8";

  doCheck = true;

  meta = {
    description = "DB Browser for SQLite";
    mainProgram = "sqlitebrowser";
    homepage = "https://sqlitebrowser.org/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
})
