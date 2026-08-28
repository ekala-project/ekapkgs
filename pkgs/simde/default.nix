{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simde";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "simd-everywhere";
    repo = "simde";
    rev = "v${finalAttrs.version}";
    hash = "sha256-igjDHCpKXy6EbA9Mf6peL4OTVRPYTV0Y2jbgYQuWMT4=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
  ];

  meta = {
    homepage = "https://simd-everywhere.github.io";
    description = "Implementations of SIMD instruction sets for systems which don't natively support them";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
