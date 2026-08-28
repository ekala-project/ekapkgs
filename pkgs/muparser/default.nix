{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "muparser";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "beltoforion";
    repo = "muparser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CE3xgJr2RNsNMrj8Cf6xd/pD9M1OlHEclTW6xZV5X30=";
  };

  postPatch = ''
    substituteInPlace muparser.pc.in \
      --replace "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@" \
      --replace "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "@CMAKE_INSTALL_FULL_INCLUDEDIR@"
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Extensible high performance math expression parser library written in C++";
    homepage = "https://beltoforion.de/en/muparser/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
