{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kirigami,
  kirigami-addons,
  qcoro,
  futuresql,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kontrast";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kontrast-${finalAttrs.version}.tar.xz";
    hash = "sha256-nLc5Y39KpXrFCsD3/TcZNf4KfqHTJLnntY/7rCBErUg=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    kcoreaddons
    kcrash
    ki18n
    kirigami
    kirigami-addons
    qcoro
    futuresql
  ];

  meta = {
    description = "Tool to check contrast for colors that allows verifying that your colors are correctly accessible";
    homepage = "https://apps.kde.org/kontrast/";
    license = with lib.licenses; [
      bsd2
      bsd3
      gpl3Plus
    ];
    platforms = lib.platforms.linux;
    mainProgram = "kontrast";
  };
})
