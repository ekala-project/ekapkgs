{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wayland,
  libepoxy,
  glib,
  libwpe,
  libxkbcommon,
  libGL,
  libX11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wpebackend-fdo";
  version = "1.16.0";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/wpebackend-fdo-${finalAttrs.version}.tar.xz";
    hash = "sha256-vt3zISMtW9CBBsF528YA+M6I6zYgtKWaYykGO3j2RjU=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libepoxy
    glib
    libwpe
    libxkbcommon
    libGL
    libX11
  ];

  meta = {
    description = "Freedesktop.org backend for WPE WebKit";
    homepage = "https://wpewebkit.org";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
  };
})
