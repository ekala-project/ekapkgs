{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "threadweaver";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/threadweaver-6.30.0.tar.xz";
    hash = "sha256-5UAJaKQYIDk+dhkKtduydsCVEyY9GxhdZLQPgtzZtFc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [ qt6.qtbase ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE high-level multithreading framework";
    homepage = "https://invent.kde.org/frameworks/threadweaver";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
