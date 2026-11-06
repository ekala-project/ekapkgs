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
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "lgse";
    repo = "strata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mWFYDKlVR6/LytRBGmgZlWX70N+Qlt3Ev5W5TmJ8UdE=";
  };

  cargoHash = "sha256-+8Ztfdf/523VTH4nozy9b5Fde+GTk0xWRMbBUBA5rKs=";

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
