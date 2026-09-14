{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  curl,
  icu,
  libzim,
  pugixml,
  zlib,
  libmicrohttpd,
  mustache-hpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkiwix";
  version = "14.2.1";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "libkiwix";
    rev = finalAttrs.version;
    hash = "sha256-wkUcQSBXrKw4Jx/ij12Nj45Jem6i7kun/gu1pJDOQeA=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    icu
    zlib
    mustache-hpp
  ];

  propagatedBuildInputs = [
    curl
    libmicrohttpd
    libzim
    pugixml
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  meta = {
    description = "Common code base for all Kiwix ports";
    homepage = "https://kiwix.org";
    changelog = "https://github.com/kiwix/libkiwix/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
