{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "magic-enum";
  version = "0.9.8";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Neargye";
    repo = "magic_enum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P26B9vEdvqmy8RO22EGbpKbuQTgosLJbdCJ5efTYA4U=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    CMAKE_INSTALL_INCLUDEDIR = "include";
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  meta = {
    description = "Static reflection for enums (to string, from string, iteration) for modern C++";
    homepage = "https://github.com/Neargye/magic_enum";
    changelog = "https://github.com/Neargye/magic_enum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
  };
})
