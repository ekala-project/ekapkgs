{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook3,
  bash-completion,
  blueprint-compiler,
  dbus,
  dbus-glib,
  fish,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  granite7,
  gtk4-layer-shell,
  gtk4,
  gvfs,
  json-glib,
  libadwaita,
  libgee,
  libnotify,
  libpulseaudio,
  librsvg,
  meson,
  ninja,
  pkg-config,
  python3,
  scdoc,
  vala,
  wayland-scanner,
  sassc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SwayNotificationCenter";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayNotificationCenter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U5jsH2hSMTNMCtmo+lIXunam4M+B3xxMQU1SM3ZK5X0=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    bash-completion
    blueprint-compiler
    fish
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    sassc
    scdoc
    vala
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    dbus-glib
    gdk-pixbuf
    glib
    gtk4-layer-shell
    gtk4
    gvfs
    json-glib
    libadwaita
    libgee
    libnotify
    libpulseaudio
    librsvg
    granite7
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
    substituteInPlace src/functions.vala --replace "/usr/local/etc/xdg/swaync" "$out/etc/xdg/swaync"
  '';

  strictDeps = true;

  meta = {
    description = "Simple notification daemon with a GUI built for Sway";
    homepage = "https://github.com/ErikReider/SwayNotificationCenter";
    changelog = "https://github.com/ErikReider/SwayNotificationCenter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "swaync";
  };
})
