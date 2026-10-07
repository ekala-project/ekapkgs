{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  protobuf,
  glib,
  gobject-introspection,
  gstreamer,
  gtk4,
  gtk4-layer-shell,
  gdk-pixbuf,
  graphene,
  cairo,
  pango,
  poppler,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "walker";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "walker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gxHJsrJZo2qbKK47Kf/9ho3i/HhRwkL8XvPnczGPd9E=";
  };

  cargoHash = "sha256-TkBdBgUa0fMN/Eddi0qycNjNgYaVECRFbrXixOEpQnc=";

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    protobuf
    gtk4.wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk4
    gtk4-layer-shell
    gdk-pixbuf
    graphene
    cairo
    pango
    poppler
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.libav
  ];

  meta = {
    description = "Wayland-native application runner";
    homepage = "https://github.com/abenz1267/walker";
    changelog = "https://github.com/abenz1267/walker/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "walker";
  };
})
