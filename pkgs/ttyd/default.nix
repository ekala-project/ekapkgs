{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  xxd,
  openssl,
  libwebsockets,
  json_c,
  libuv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ttyd";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "tsl0922";
    repo = "ttyd";
    tag = finalAttrs.version;
    sha256 = "sha256-7e08oBKU7BMZ8328qCfNynCSe7LVZ88+iQZRRKl2YkY=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    openssl
    libwebsockets
    json_c
    libuv
    zlib
  ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Share your terminal over the web";
    homepage = "https://github.com/tsl0922/ttyd";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "ttyd";
  };
})
