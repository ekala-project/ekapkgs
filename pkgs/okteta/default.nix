{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  qt6,
  shared-mime-info,
  xz,
  karchive,
  kcmutils,
  kconfig,
  kconfigwidgets,
  kcrash,
  knewstuff,
  kparts,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "okteta";
  version = "0.26.25-unstable-2026-04-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "utilities";
    repo = "okteta";
    rev = "9ab055f50e7569c9a0bc401be4b5686dc1e61dcc";
    hash = "sha256-1ih0kFS7opA5w1QyB7MQAOYFoSAUPKNM8fRi1G/mq2U=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    shared-mime-info
    xz
    karchive
    kcmutils
    kconfig
    kconfigwidgets
    kcrash
    knewstuff
    kparts
    kdePackages.qca
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Hex editor";
    homepage = "https://apps.kde.org/okteta/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
