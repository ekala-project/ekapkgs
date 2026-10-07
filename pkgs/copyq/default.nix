{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6,
  libx11,
  libxfixes,
  libxtst,
  wayland,
  miniaudio,
  pkg-config,
  extra-cmake-modules,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "CopyQ";
  version = "17.0.0";

  src = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z9M36tXqkTUsxr6Ej9PZs9l+njGpEUS9iq+JZ3i7AB8=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    qt6.qtdeclarative
    qt6.qtwayland
    libx11
    libxfixes
    libxtst
    wayland
    miniaudio
  ];

  cmakeEntries = {
    WITH_QT6 = true;
    WITH_QCA_ENCRYPTION = false;
    WITH_KEYCHAIN = false;
    WITH_NATIVE_NOTIFICATIONS = false;
    MINIAUDIO_INCLUDE_DIR = "${lib.getInclude miniaudio}/include/miniaudio";
    ECM_DIR = "${extra-cmake-modules}/share/ECM/cmake";
  };

  meta = {
    homepage = "https://hluk.github.io/CopyQ";
    description = "Clipboard Manager with Advanced Features";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "copyq";
  };
})
