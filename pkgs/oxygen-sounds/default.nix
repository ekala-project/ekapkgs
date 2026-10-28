{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oxygen-sounds";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/oxygen-sounds-${finalAttrs.version}.tar.xz";
    hash = "sha256-DMW2AATY/rix3gMstdPAVsmPYqhxNYm5C0ceWUPjGtk=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  meta = {
    description = "The Oxygen Sound Theme";
    homepage = "https://invent.kde.org/plasma/oxygen-sounds";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
