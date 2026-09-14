{
  lib,
  stdenv,
  fetchurl,
  cairo,
  meson,
  ninja,
  pkg-config,
  gstreamer,
  gst-plugins-base,
  gst-plugins-bad,
  gst-rtsp-server,
  python3,
  gobject-introspection,
  rustPlatform,
  rustc,
  cargo,
  json-glib,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-devtools";
  version = "1.28.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-${finalAttrs.version}.tar.xz";
    hash = "sha256-dFkEXbMdbkRgC8vgEdySV1AmiHDnuQ9+ego69KIcCeU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      src
      cargoRoot
      ;
    name = "gst-devtools-${finalAttrs.version}";
    hash = "sha256-5VYzDwAMyVN2HR/sS8rCwTR7UW/tt60AS7wZMjx+w74=";
  };

  separateDebugInfo = true;

  __structuredAttrs = true;
  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    cairo
    python3
    json-glib
  ];

  propagatedBuildInputs = [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gst-rtsp-server
  ];

  mesonFlags = [
    "-Ddoc=disabled"
    (lib.mesonEnable "introspection" withIntrospection)
  ];

  cargoRoot = "dots-viewer";

  preFixup = ''
    moveToOutput "lib/gstreamer-1.0/pkgconfig" "$dev"
  '';

  meta = {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = "https://gstreamer.freedesktop.org";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
