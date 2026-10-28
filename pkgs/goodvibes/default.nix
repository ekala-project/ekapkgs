{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
  glib-networking,
  gtk3,
  libsoup_3,
  keybinder3,
  gstreamer,
  appstream-glib,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goodvibes";
  version = "0.8.3";

  src = fetchFromGitLab {
    owner = "goodvibes";
    repo = "goodvibes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Lh4FPH0Bdxg2J4IxsZPs8Zjc7Tcobb4bTpvJzVNIy0Y=";
  };

  nativeBuildInputs = [
    meson

    meson.configurePhaseHook
    ninja
    pkg-config
    gtk3.wrapGAppsHook
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    # for libsoup TLS support
    glib-networking
    gtk3
    libsoup_3
    keybinder3
  ]
  ++ (with gstreamer; [
    gstreamer
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-bad
    gstreamer.plugins-ugly
  ]);

  postPatch = ''
    patchShebangs scripts
  '';

  meta = {
    description = "Lightweight internet radio player";
    homepage = "https://gitlab.com/goodvibes/goodvibes";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
