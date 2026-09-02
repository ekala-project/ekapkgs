{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  duktape,
  glib,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libproxy";
  version = "0.5.12";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "libproxy";
    repo = "libproxy";
    rev = finalAttrs.version;
    hash = "sha256-pkvmeD7O2EUDzw59/e7YcgiHDf2vvIXmd11axGSwCEs=";
  };

  postPatch = ''
    chmod +x data/install-git-hook.sh
    patchShebangs data/install-git-hook.sh

    substituteInPlace src/libproxy/meson.build \
      --replace-fail "requires_private: 'gobject-2.0'" "requires: 'gobject-2.0'"
  '';

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    duktape
    glib
  ];

  mesonFlags = [
    "-Drelease=true"
    "-Ddocs=false"
    "-Dintrospection=false"
    "-Dconfig-gnome=false"
  ];

  meta = {
    description = "Library that provides automatic proxy configuration management";
    homepage = "https://libproxy.github.io/libproxy/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "proxy";
  };
})
