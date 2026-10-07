{
  lib,
  stdenv,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "extra-cmake-modules";
  version = "6.27.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.27/extra-cmake-modules-${version}.tar.xz";
    hash = "sha256-87WvV4AXpqDxJ/scMWCdsuTwFumbkA1aEfb/tsVQBqM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  # ECM is a pure CMake module package, no actual compilation
  cmakeEntries = {
    BUILD_TESTING = false;
    BUILD_HTML_DOCS = false;
    BUILD_MAN_DOCS = false;
    BUILD_QTHELP_DOCS = false;
  };

  meta = {
    homepage = "https://invent.kde.org/frameworks/extra-cmake-modules";
    description = "Extra CMake modules for KDE frameworks";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
  };
}
