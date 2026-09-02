{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  python3,
  glib,
  gdk-pixbuf,
  pango,
  freetype,
  cairo,
  libxml2,
  bzip2,
  rustPlatform,
  rustc,
  cargo-c,
  cargo-auditable-cargo-wrapper,
  docutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librsvg";
  version = "2.61.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/librsvg/${lib.versions.majorMinor finalAttrs.version}/librsvg-${finalAttrs.version}.tar.xz";
    hash = "sha256-vBu81BkSCwmNsovqVTNdneJHDU5qn27pcge0EPwVhn0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "librsvg-deps-${finalAttrs.version}";
    hash = "sha256-3DAFyY7uNB5cP8ry28v12QsFdxHtpr1nyLtzhojBq7c=";
    dontConfigure = true;
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    rustc
    cargo-c
    cargo-auditable-cargo-wrapper
    docutils
    python3
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libxml2
    bzip2
    pango
    freetype
  ];

  propagatedBuildInputs = [
    glib
    gdk-pixbuf
    cairo
  ];

  mesonAutoFeatures = "disabled";

  mesonFlags = [
    "-Dtriplet=${stdenv.hostPlatform.rust.rustcTarget}"
    (lib.mesonEnable "pixbuf" true)
    (lib.mesonEnable "introspection" false)
    (lib.mesonEnable "pixbuf-loader" false)
    (lib.mesonEnable "vala" false)
    (lib.mesonEnable "docs" false)
    (lib.mesonEnable "avif" false)
    (lib.mesonBool "tests" false)
  ];

  postPatch = ''
    patchShebangs \
      meson/cargo_wrapper.py \
      meson/makedef.py \
      meson/query-rustc.py
  '';

  meta = {
    description = "Small library to render SVG images to Cairo surfaces";
    homepage = "https://gitlab.gnome.org/GNOME/librsvg";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
