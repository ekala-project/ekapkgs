{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  exempi,
  libcdio,
  makeWrapper,
  taglib,
  extra-cmake-modules,
  kdoctools,
  qt6,
  karchive,
  kfilemetadata,
  kitemmodels,
  knewstuff,
  kxmlgui,
  libkcddb,
  libksane,
  poppler,
  solid,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tellico";
  version = "4.2.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = "tellico";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6V5eM6XU2P5GJRkW2oNtUcDZH+4Wlsz+bivrsqWOw4M=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    kdoctools
    makeWrapper
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    exempi
    karchive
    kfilemetadata
    kitemmodels
    knewstuff
    kxmlgui
    libcdio
    libkcddb
    libksane
    poppler
    qt6.qtcharts
    qt6.qtwebengine
    solid
    taglib
  ];

  meta = {
    description = "Collection management software, free and simple";
    mainProgram = "tellico";
    homepage = "https://tellico-project.org/";
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
      lgpl2Only
    ];
    platforms = lib.platforms.linux;
  };
})
