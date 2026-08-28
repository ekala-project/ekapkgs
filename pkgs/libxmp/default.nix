{
  lib,
  stdenv,
  docutils,
  fetchFromGitHub,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxmp";
  version = "4.7.2";

  src = fetchFromGitHub {
    owner = "libxmp";
    repo = "libxmp";
    tag = "libxmp-${finalAttrs.version}";
    hash = "sha256-0no+WT5cLDDtoRO5GKlsx9BLrv4n2JvDr9Dky0yNOsk=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    docutils
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED" true)
    (lib.cmakeBool "BUILD_STATIC" false)
  ];

  meta = {
    description = "Extended module player library";
    homepage = "https://xmp.sourceforge.net/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
