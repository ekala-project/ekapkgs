{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtraceevent";
  version = "1.9.0";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git";
    tag = "libtraceevent-${finalAttrs.version}";
    hash = "sha256-4KuF+UNMWxfxXYVlS0cBY5/p242UQ/NoRRVK+wmn04E=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  mesonFlags = [
    "-Ddoc=false"
  ];

  meta = {
    description = "Linux kernel trace event library";
    homepage = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
  };
})
