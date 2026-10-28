{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  karchive,
  kcmutils,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kdbusaddons,
  kdnssd,
  kdoctools,
  kguiaddons,
  ki18n,
  kio,
  plasma-activities,
  plasma-activities-stats,
  qcoro,
  solid,
  syntax-highlighting,
  samba,
  libssh,
  libmtp,
  libimobiledevice,
  gperf,
  libtirpc,
  openexr,
  taglib,
  shared-mime-info,
  libappimage,
  libxcursor,
  kdsoap-ws-discovery-client,
  libkexiv2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kio-extras";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kio-extras-${finalAttrs.version}.tar.xz";
    hash = "sha256-tfyYVS7qH5J5+x8Dx+P/s2pG/93Qvwu6mGgzHYxGHm4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
    gperf
    shared-mime-info
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    qt6.qtsvg
    karchive
    kcmutils
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    kdnssd
    kguiaddons
    ki18n
    kio
    plasma-activities
    plasma-activities-stats
    qcoro
    solid
    syntax-highlighting
    samba
    libssh
    libmtp
    libimobiledevice
    gperf
    libtirpc
    openexr
    taglib
    libappimage
    libxcursor
    # kdsoap # TODO: kdsoap not yet ported
    kdsoap-ws-discovery-client
    libkexiv2
  ];

  postInstall = ''
    substituteInPlace $out/share/dbus-1/services/org.kde.kmtpd5.service \
      --replace-fail Exec=$out/libexec/kf6/kiod6 Exec=${kio}/libexec/kf6/kiod6
  '';

  meta = {
    description = "Additional components to increase the functionality of KIO";
    homepage = "https://apps.kde.org/kio-extras/";
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
