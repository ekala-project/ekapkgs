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
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "lgse";
    repo = "strata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RSTEgtfDYYGxXef1J22NMGpmgjObg3T6APZqfSyfNPY=";
  };

  cargoHash = "sha256-0nMfswOfyXiwIWF0Xne61jGwPdU/gMo6Wt6JGZEfrJw=";

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

  doCheck = false;

  meta = {
    description = "A fast, keyboard-first file manager for Linux";
    homepage = "https://github.com/lgse/strata";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "strata";
  };
})
