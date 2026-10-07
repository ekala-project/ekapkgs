{
  lib,
  stdenv,
  fetchgit,
  asciidoc,
  docbook-xml-dtd,
  docbook2x,
  libxml2,
  meson,
  ninja,
  pkg-config,
  curl,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "megatools";
  version = "1.11.5";

  src = fetchgit {
    url = "https://xff.cz/git/megatools";
    rev = finalAttrs.version;
    hash = "sha256-XOGjdvMw8wfhBwyOBnQqiiJeOGvYXKMYxiJ6BZeEwDQ=";
  };

  nativeBuildInputs = [
    asciidoc
    docbook-xml-dtd.v4_5
    docbook2x
    libxml2
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    glib
  ];

  strictDeps = true;

  meta = {
    description = "Command line client for Mega.co.nz";
    homepage = "https://xff.cz/megatools/";
    changelog = "https://xff.cz/megatools/builds/NEWS";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
