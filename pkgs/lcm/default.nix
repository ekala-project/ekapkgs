{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lcm";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "lcm-proj";
    repo = "lcm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2IWIVq2o6R4pU48VXbizYpmZXsq1r5siATDE4j6WiZU=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    glib
  ];

  # Move cmake config files to dev output to avoid a reference cycle
  # between out (cmake files referencing dev/include) and dev (referencing out/lib)
  postInstall = ''
    moveToOutput lib/lcm $dev
  '';

  meta = {
    description = "Lightweight Communications and Marshalling (LCM)";
    homepage = "https://github.com/lcm-proj/lcm";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
  };
})
