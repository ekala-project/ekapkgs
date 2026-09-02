{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yyjson";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "ibireme";
    repo = "yyjson";
    tag = finalAttrs.version;
    hash = "sha256-1CYnEgUMUc7eqdkv6M/KyL/MdVQBMov9HgLCycF6++w=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Fastest JSON library in C";
    homepage = "https://github.com/ibireme/yyjson";
    changelog = "https://github.com/ibireme/yyjson/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
