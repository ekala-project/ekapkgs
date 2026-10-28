{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  doxygen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdsoap-ws-discovery-client";
  version = "0.4.0";

  src = fetchurl {
    url = "mirror://kde/stable/kdsoap-ws-discovery-client/kdsoap-ws-discovery-client-${finalAttrs.version}.tar.xz";
    hash = "sha256-LNJHwBPnX0EGWbrDcq/5PSLXHFpUwFnhN7lESvizQno=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    doxygen
  ];

  buildInputs = [
    qt6.qtbase
    # kdsoap # TODO: kdsoap not yet ported
  ];

  meta = {
    description = "Library for finding WS-Discovery devices in the network using Qt and KDSoap";
    homepage = "https://invent.kde.org/libraries/kdsoap-ws-discovery-client";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
