{
  lib,
  stdenv,
  fetchFromGitHub,
  vala,
  meson,
  ninja,
  pkg-config,
  gettext,
  gobject-introspection,
  glib,
  gdk-pixbuf,
  gtk4,
  glib-networking,
  libadwaita,
  libcanberra,
  libnotify,
  libsoup_3,
  libgee,
  libomemo-c,
  libgcrypt,
  sqlite,
  gpgme,
  qrencode,
  icu,
  srtp,
  libnice,
  gnutls,
  gstreamer,
  webrtc-audio-processing,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dino";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "dino";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TgXPJP+Xm8LrO2d8yMu6aCCypuBRKNtYuZAb0dYfhng=";
  };

  postPatch = ''
    echo ${finalAttrs.version} > VERSION
  '';

  nativeBuildInputs = [
    vala
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk4.wrapGAppsHook
    gettext
    gobject-introspection
  ];

  buildInputs = [
    qrencode
    glib
    glib-networking
    libadwaita
    libgee
    sqlite
    gdk-pixbuf
    gtk4
    libnotify
    gpgme
    libgcrypt
    libsoup_3
    icu
    libcanberra
    libomemo-c
    srtp
    libnice
    gnutls
    gstreamer
    gstreamer.plugins-base
    gstreamer.plugins-good
    webrtc-audio-processing
  ];

  doCheck = true;

  meta = {
    description = "Modern Jabber/XMPP Client using GTK/Vala";
    mainProgram = "dino";
    homepage = "https://github.com/dino/dino";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
