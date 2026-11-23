{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  asciidoc,
  zlib,
  jansson,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jose";
  version = "15";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "jose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zfwo4axQuCKHtP7W3qacZqoo+Dkp5q4RKW34HeBxgOQ=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    pkg-config
    ninja
    asciidoc
  ];

  buildInputs = [
    zlib
    jansson
    openssl
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  meta = {
    description = "C-language implementation of Javascript Object Signing and Encryption";
    mainProgram = "jose";
    homepage = "https://github.com/latchset/jose";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
