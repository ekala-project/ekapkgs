{
  lib,
  stdenv,
  fetchurl,
  # native
  meson,
  ninja,
  pkg-config,
  gettext,
  desktop-file-utils,
  appstream-glib,
  python3,
  # Not native
  gstreamer,
  gsettings-desktop-schemas,
  gtk4,
  avahi,
  glib,
  networkmanager,
  json-glib,
  glib-networking,
  libadwaita,
  libportal,
  libpulseaudio,
  libsoup_3,
  pipewire,
  protobufc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-network-displays";
  version = "0.99.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-network-displays/${lib.versions.majorMinor finalAttrs.version}/gnome-network-displays-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-Hs5KG8gix+v3JeiEe4zomYtH0ewXFaS03bnd1xaR7YU=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    desktop-file-utils
    appstream-glib
    gtk4.wrapGAppsHook
    python3
  ];

  buildInputs = [
    avahi
    gtk4
    glib
    gsettings-desktop-schemas
    gstreamer
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-bad
    gstreamer.plugins-ugly
  ]
  ++ lib.optional (gstreamer ? rtsp-server) gstreamer.rtsp-server
  ++ [
    pipewire
    networkmanager
    json-glib
    # Not strictly required according to configure phase log, but putting it
    # here adds gio modules to the GIO_EXTRA_MODULES environment variables - as
    # required for TLS. See https://github.com/NixOS/nixpkgs/issues/502092
    glib-networking
    libadwaita
    libportal.gtk4
    libpulseaudio
    libsoup_3
    protobufc
  ];

  env.CFLAGS = "-I${gstreamer.plugins-base.dev}/include/gstreamer-1.0";

  preConfigure = ''
    patchShebangs ./build-aux/meson/postinstall.py
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-network-displays";
    description = "Miracast implementation for GNOME";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gnome-network-displays";
  };
})
