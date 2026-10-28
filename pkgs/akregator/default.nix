{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcodecs,
  kstatusnotifieritem,
  kuserfeedback,
  plasma-activities,
  grantleetheme,
  kontactinterface,
  ktextaddons,
  libkdepim,
  pimcommon,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "akregator";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/akregator-${finalAttrs.version}.tar.xz";
    hash = "sha256-2BnfjkU+RRZ+2Qw7+ZBzAX8yX3koMrl86d9URfhE3u0=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwebengine
    kcodecs
    kstatusnotifieritem
    kuserfeedback
    plasma-activities
    grantleetheme
    kontactinterface
    ktextaddons
    libkdepim
    pimcommon
    kdePackages.messagelib
  ];

  meta = {
    description = "RSS Feed Reader";
    homepage = "https://apps.kde.org/akregator/";
    license = with lib.licenses; [
      bsd2
      bsd3
      cc0
      gpl2Plus
      lgpl2Plus
      mit
    ];
    platforms = lib.platforms.linux;
    mainProgram = "akregator";
  };
})
