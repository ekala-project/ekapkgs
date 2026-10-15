{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  ki18n,
  docbook-xml-dtd,
  docbook-xsl-nons,
  perl,
  perlPackages,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdoctools";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kdoctools-${finalAttrs.version}.tar.xz";
    hash = "sha256-uQtCqyIqMDRynlF9DAYlir9r3ChZHseK1W8krruq7ZQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    perl
    perlPackages.URI
    libxml2
  ];

  buildInputs = [
    qt6.qtbase
    karchive
    ki18n
    docbook-xml-dtd.v4_5
    docbook-xsl-nons
  ];

  propagatedBuildInputs = [
    perl
    perlPackages.URI
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Documentation generation from docbook";
    homepage = "https://invent.kde.org/frameworks/kdoctools";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
