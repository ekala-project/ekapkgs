{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsigc++";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "libsigcplusplus";
    repo = "libsigcplusplus";
    tag = finalAttrs.version;
    hash = "sha256-ZV1gcq/efFaf4MkkDZP9Z1isNqwnvUWWouVwtTnpyhc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
  ];

  doCheck = true;

  meta = {
    homepage = "https://libsigcplusplus.github.io/libsigcplusplus/";
    changelog = "https://github.com/libsigcplusplus/libsigcplusplus/blob/${finalAttrs.src.tag}/NEWS";
    description = "Typesafe callback system for standard C++";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
})
