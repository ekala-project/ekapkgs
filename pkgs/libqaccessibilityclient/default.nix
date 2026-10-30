{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qtbase,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqaccessibilityclient";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://kde/stable/libqaccessibilityclient/libqaccessibilityclient-${finalAttrs.version}.tar.xz";
    hash = "sha256-TFDESGItycUEHtENp9h7Pk5xzLSdSDGoSSEdQjxfXTM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    extra-cmake-modules
    qtbase
  ];

  cmakeEntries = {
    QT_MAJOR_VERSION = "6";
  };

  outputs = [
    "out"
    "dev"
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Accessibility tools helper library, used e.g. by screen readers";
    homepage = "https://github.com/KDE/libqaccessibilityclient";
    license = with lib.licenses; [
      lgpl3Only
      lgpl21Only
    ];
    platforms = lib.platforms.linux;
  };
})
