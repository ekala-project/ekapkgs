{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kauth,
  kcmutils,
  kconfig,
  kcoreaddons,
  ki18n,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-firewall";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/plasma-firewall-${finalAttrs.version}.tar.xz";
    hash = "sha256-rbxqYtJyo4ZkYSdLt43kng+DyZcSJfYZrbMEI5m+aZc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kauth
    kcmutils
    kconfig
    kcoreaddons
    ki18n
  ];

  meta = {
    description = "Control Panel for your system firewall";
    homepage = "https://invent.kde.org/plasma/plasma-firewall";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
