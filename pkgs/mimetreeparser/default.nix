{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcalendarcore,
  kio,
  kirigami,
  kmbox,
  kmime,
  kwidgetsaddons,
  libkleo,
  kirigami-addons,
  qgpgme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mimetreeparser";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/mimetreeparser-${finalAttrs.version}.tar.xz";
    hash = "sha256-grTjfLWbcmTvE7bowYvn1ZZm9Mv7UbWuDx16tuo1zQk=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    qt6.qtdeclarative
    kcalendarcore
    kio
    kmbox
    kmime
    kwidgetsaddons
    libkleo
    qgpgme
  ];

  propagatedBuildInputs = [
    kirigami
    kirigami-addons
    qt6.qtwebengine
  ];

  meta = {
    description = "Parser for MIME trees";
    homepage = "https://apps.kde.org/mimetreeparser/";
    license = with lib.licenses; [
      bsd2
      bsd3
      gpl2Only
      gpl2Plus
      gpl3Only
      lgpl2Only
      lgpl2Plus
      lgpl21Only
      lgpl21Plus
      lgpl3Only
      mit
    ];
    platforms = lib.platforms.linux;
  };
})
