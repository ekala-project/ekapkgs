{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  akonadi,
  akonadi-search,
  kcolorscheme,
  kiconthemes,
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
  pname = "kaddressbook";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kaddressbook-${finalAttrs.version}.tar.xz";
    hash = "sha256-jVk600RHHMmnsNPvnXpX1SmXRcWt7dBna53HDT5DI3Y=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    akonadi
    akonadi-search
    kcolorscheme
    kiconthemes
    kuserfeedback
    plasma-activities
    grantleetheme
    kontactinterface
    ktextaddons
    libkdepim
    pimcommon
    kdePackages.akonadi-contacts
  ];

  meta = {
    description = "Address book application to manage your contacts";
    homepage = "https://apps.kde.org/kaddressbook/";
    license = with lib.licenses; [
      bsd3
      gpl2Only
      gpl2Plus
      lgpl2Plus
      mit
    ];
    platforms = lib.platforms.linux;
    mainProgram = "kaddressbook";
  };
})
