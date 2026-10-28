{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  rustPlatform,
  rustc,
  cargo,
  pkg-config,
  qt6,
  corrosion,
  hidapi,
  attica,
  kauth,
  kcmutils,
  kconfig,
  kcoreaddons,
  kglobalaccel,
  kguiaddons,
  kholidays,
  ki18n,
  kio,
  knewstuff,
  knotifications,
  kpackage,
  krunner ? null, # TODO: not yet in ekapkgs
  kservice,
  kunitconversion,
  kwidgetsaddons,
  kxmlgui,
  libplasma ? null, # TODO: not yet in ekapkgs
  solid,
  sonnet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdeplasma-addons";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/kdeplasma-addons-${finalAttrs.version}.tar.xz";
    hash = "sha256-G8HIYUh3M/SURpXVCcgfGbkKTYDFglzG32M7AxPj6Mw=";
  };

  cargoRoot = "kdeds/kameleon/qmk/kameleon-qmk-helper";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version;
    inherit (finalAttrs) cargoRoot;
    src = finalAttrs.src;
    hash = "sha256-HfHiue3hWZc243gYI9VfIi5c30itWhU22+ZEwoy8gPY=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    rustPlatform.cargoSetupHook
    rustc
    cargo
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwebengine
    corrosion
    hidapi
    attica
    kauth
    kcmutils
    kconfig
    kcoreaddons
    kglobalaccel
    kguiaddons
    kholidays
    ki18n
    kio
    knewstuff
    knotifications
    kpackage
    kservice
    kunitconversion
    kwidgetsaddons
    kxmlgui
    solid
    sonnet
  ]
  ++ lib.optional (krunner != null) krunner
  ++ lib.optional (libplasma != null) libplasma;

  meta = {
    description = "All kind of add-ons to improve your Plasma experience";
    homepage = "https://invent.kde.org/plasma/kdeplasma-addons";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
})
