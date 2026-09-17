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
  cargo,
  lcms2,
  libseccomp,
  rustc,
  rustPlatform,
  # TODO: libglycin - not available
  # TODO: libglycin-gtk4 - not available
  # TODO: glycin-loaders - not available
  # TODO: libcamera - not available
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snapshot";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/snapshot/${lib.versions.major finalAttrs.version}/snapshot-${finalAttrs.version}.tar.xz";
    hash = "sha256-7J2vmIPrkDMJEbtR5rae7YydvdVDjoZK3JDuVaX+nu0=";
  };

  cargoVendorDir = "vendor";

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    # TODO: libglycin - not available
    # TODO: libglycin.setupHook - not available
    # TODO: libglycin-gtk4 - not available
    # TODO: glycin-loaders - not available
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    # TODO: gst_all_1.gst-plugins-rs - not available
    gst_all_1.gstreamer
    gtk4
    lcms2
    libadwaita
    # TODO: libcamera - not available
    libseccomp
    pipewire # for device provider
  ];

  postPatch = ''
    substituteInPlace src/meson.build --replace-fail \
      "'cp', cargo_target / rust_target / meson.project_name()" \
      "'cp', cargo_target / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
    )
  '';

  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/snapshot";
    description = "Take pictures and videos on your computer, tablet, or phone";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "snapshot";
  };
})
