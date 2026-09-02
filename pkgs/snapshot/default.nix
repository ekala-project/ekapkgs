{
  stdenv,
  lib,
  fetchurl,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gst_all_1,
  gtk4,
  libadwaita,
  pipewire,
  # TODO: libglycin - not available
  # TODO: libglycin-gtk4 - not available
  # TODO: glycin-loaders - not available
  # TODO: cargo - not available (rustPlatform)
  # TODO: rustc - not available (rustPlatform)
  # TODO: rustPlatform.cargoSetupHook - not available
  # TODO: libcamera - not available
  # TODO: lcms2 - not available
  # TODO: libseccomp - not available
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snapshot";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/snapshot/${lib.versions.major finalAttrs.version}/snapshot-${finalAttrs.version}.tar.xz";
    hash = "sha256-7J2vmIPrkDMJEbtR5rae7YydvdVDjoZK3JDuVaX+nu0=";
  };

  # TODO: cargoVendorDir = "vendor";

  nativeBuildInputs = [
    # TODO: cargo
    desktop-file-utils
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    # TODO: rustc
    # TODO: rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    # TODO: libglycin
    # TODO: libglycin.setupHook
    # TODO: libglycin-gtk4
    # TODO: glycin-loaders
    # TODO: gst_all_1.gst-plugins-bad - not available
    gst_all_1.gst-plugins-base
    # TODO: gst_all_1.gst-plugins-good - not available
    # TODO: gst_all_1.gst-plugins-rs - not available
    gst_all_1.gstreamer
    gtk4
    libadwaita
    # TODO: libcamera
    # TODO: lcms2
    # TODO: libseccomp
    pipewire # for device provider
  ];

  # TODO: requires Rust build support
  # postPatch = ''
  #   substituteInPlace src/meson.build --replace-fail \
  #     "'cp', cargo_target / rust_target / meson.project_name()" \
  #     "'cp', cargo_target / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
  # '';

  # TODO: requires gst-plugins-good
  # preFixup = ''
  #   gappsWrapperArgs+=(
  #     --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
  #   )
  # '';

  # TODO: requires Rust build support
  # env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/snapshot";
    description = "Take pictures and videos on your computer, tablet, or phone";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "snapshot";
  };
})
