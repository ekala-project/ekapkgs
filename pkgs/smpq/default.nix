{
  lib,
  cmake,
  fetchurl,
  stdenv,
  stormlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smpq";
  version = "1.6";

  src = fetchurl {
    url = "https://launchpad.net/smpq/trunk/${finalAttrs.version}/+download/smpq_${finalAttrs.version}.orig.tar.gz";
    hash = "sha256-tdLcil3oYptx7l02ErboTYhBi4bFzTm6MV6esEYvGMs=";
  };

  cmakeEntries = {
    WITH_KDE = false;
    CMAKE_POLICY_VERSION_MINIMUM = "3.5";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ stormlib ];

  strictDeps = true;

  meta = {
    homepage = "https://launchpad.net/smpq";
    description = "StormLib MPQ archiving utility";
    license = lib.licenses.gpl3Only;
    mainProgram = "smpq";
    platforms = lib.platforms.all;
  };
})
