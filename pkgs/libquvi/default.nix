{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  curl,
  lua,
  libquvi-scripts,
  libproxy,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libquvi";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "nickhutchinson";
    repo = "libquvi";
    tag = "${finalAttrs.version}";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    lua.v5_1
    libquvi-scripts
    libproxy
    glib
  ];

  meta = {
    description = "Library for parsing video download links";
    homepage = "https://github.com/nickhutchinson/libquvi";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
