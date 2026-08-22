{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  appstream-glib,
  meson,
  ninja,
  pkg-config,
  reuse ? null,
  m4,
  wrapGAppsHook4,
  glib,
  gtk4,
  gst_all_1,
  libadwaita,
  dbus,
  rustc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amberol";
  version = "2026.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "amberol";
    tag = finalAttrs.version;
    hash = "sha256-d4lhfWqg6EZeXGL1kHGS7oWrqI3c9bpDCKUdGp31OpI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "amberol-${finalAttrs.version}";
    hash = "sha256-OFZd9nKRqXJMHSIIP8tlSNtFAQzk/f/6SBeEvbdPVK0=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    cargo
    desktop-file-utils
    m4
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ]
  ++ lib.optionals (reuse != null) [
    reuse
  ];

  buildInputs = [
    dbus
    glib
    gtk4
    libadwaita
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  meta = {
    homepage = "https://gitlab.gnome.org/World/amberol";
    description = "Small and simple sound and music player";
    maintainers = [ ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "amberol";
  };
})
