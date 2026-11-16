{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
  gtk4,
  gdk-pixbuf,
  gtksourceview5,
  gstreamer,
  cairo,
  pango,
  poppler,
  fontconfig,
  libseccomp,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "strata";
  version = "1.2.2-nightly.20261116";

  src = fetchFromGitHub {
    owner = "lgse";
    repo = "strata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d6avzOhMLpUdMnq2jYwzRj0uhtf62VAOCzMwUWovgFM=";
  };

  cargoHash = "sha256-Lj5iWNPiYX9/8V01a8grbo/MZBEgtHYg2ct5S8ETDdI=";

  nativeBuildInputs = [
    pkg-config
    glib.dev
    gtk4.wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk4
    gdk-pixbuf
    gtksourceview5
    cairo
    pango
    poppler
    fontconfig
    libseccomp
    gstreamer.plugins-base
    gstreamer.plugins-good
  ];

  meta = {
    description = "A fast, keyboard-first file manager for Linux";
    homepage = "https://github.com/lgse/strata";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "strata";
  };
})
