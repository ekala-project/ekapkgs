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
  wrapGAppsHook4,
  python3,
  # Not native
  gst_all_1,
  gsettings-desktop-schemas,
  gtk4,
  # TODO: avahi not yet available in ekapkgs
  avahi,
  glib,
  # TODO: networkmanager not yet available in ekapkgs
  networkmanager,
  json-glib,
  glib-networking,
  libadwaita,
  # TODO: libportal-gtk4 not yet available in ekapkgs
  libportal-gtk4 ? null,
  # TODO: libpulseaudio not yet ported to ekapkgs
  libpulseaudio,
  libsoup_3,
  pipewire,
  # TODO: protobufc not yet available in ekapkgs
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
    ninja
    pkg-config
    gettext
    desktop-file-utils
    appstream-glib
    wrapGAppsHook4
    python3
  ];

  buildInputs = [
    avahi
    gtk4
    glib
    gsettings-desktop-schemas
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ]
  ++ lib.optional (gst_all_1 ? gst-rtsp-server) gst_all_1.gst-rtsp-server
  ++ [
    pipewire
    networkmanager
    json-glib
    # Not strictly required according to configure phase log, but putting it
    # here adds gio modules to the GIO_EXTRA_MODULES environment variables - as
    # required for TLS. See https://github.com/NixOS/nixpkgs/issues/502092
    glib-networking
    libadwaita
  ]
  ++ lib.optional (libportal-gtk4 != null) libportal-gtk4
  ++ [
    libpulseaudio
    libsoup_3
    protobufc
  ];

  env.CFLAGS = "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0";

  preConfigure = ''
    patchShebangs ./build-aux/meson/postinstall.py
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-network-displays";
    description = "Miracast implementation for GNOME";
    maintainers = [ ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gnome-network-displays";
  };
})
