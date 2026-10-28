{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  kwallet,
  pam,
  libgcrypt,
  socat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwallet-pam";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/kwallet-pam-${finalAttrs.version}.tar.xz";
    hash = "sha256-1x9ZRe8whvVvUvUxUIwqs2MHj7vVrkCEvTZHBJ5u6U8=";
  };

  postPatch = ''
    sed -i pam_kwallet_init -e "s|socat|${lib.getBin socat}/bin/socat|"
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    kwallet
    pam
    libgcrypt
    socat
  ];

  dontWrapQtApps = true;

  meta = {
    description = "PAM Integration with KWallet - Unlock KWallet when you login";
    homepage = "https://invent.kde.org/plasma/kwallet-pam";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
