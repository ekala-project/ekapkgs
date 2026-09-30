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
  glib,
  gtk4,
  gstreamer,
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
    meson.configurePhaseHook
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    gtk4.wrapGAppsHook
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
  ++ (with gstreamer; [
    gstreamer
    plugins-base
    plugins-good
    plugins-bad
    plugins-ugly
  ]);

  meta = {
    homepage = "https://gitlab.gnome.org/World/amberol";
    description = "Small and simple sound and music player";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "amberol";
  };
})
