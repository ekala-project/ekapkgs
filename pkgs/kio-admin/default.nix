{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kio,
  polkit-qt-1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kio-admin";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kio-admin-${finalAttrs.version}.tar.xz";
    hash = "sha256-8Sr/mJE8kebragnK/e2+o+4uQ6bVWejsmNC3K1TMMuo=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    kio
    polkit-qt-1
  ];

  meta = {
    description = "Manage files as administrator using the admin:// KIO protocol";
    homepage = "https://apps.kde.org/kio-admin/";
    license = with lib.licenses; [
      bsd3
      gpl2Only
      gpl3Only
    ];
    platforms = lib.platforms.linux;
  };
})
