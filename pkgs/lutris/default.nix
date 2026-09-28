{
  python3Packages,
  lib,
  fetchFromGitHub,

  # build inputs
  at-spi2-core,
  file,
  glib,
  gdk-pixbuf,
  glib-networking,
  gnome-desktop,
  gobject-introspection,
  gstreamer,
  gtk3,
  libnotify,
  pango,
  wrapGAppsHook3,
  meson,
  ninja,

  # commands that lutris needs
  xrandr,
  pciutils,
  psmisc,
  mesa-demos,
  vulkan-tools,
  pulseaudio,
  p7zip,
  xgamma,
  fluidsynth,
  xorg-server,
  xkbcomp,
  setxkbmap,
  util-linux,
  pkg-config,
  desktop-file-utils,
  appstream-glib,
  gettext,
}:

let
  # See lutris/util/linux.py
  requiredTools = [
    xrandr
    pciutils
    psmisc
    mesa-demos
    vulkan-tools
    pulseaudio
    p7zip
    xgamma
    fluidsynth
    xorg-server
    setxkbmap
    xkbcomp
    util-linux
  ];
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lutris";
  version = "0.5.22";

  src = fetchFromGitHub {
    owner = "lutris";
    repo = "lutris";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4mNknvfJQJEPZjQoNdKLQcW4CI93D6BUDPj8LtD940A=";
  };

  format = "other";

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gobject-introspection
    meson
    meson.configurePhaseHook
    ninja
    wrapGAppsHook3
    pkg-config
  ];

  buildInputs = [
    at-spi2-core
    gdk-pixbuf
    glib-networking
    gnome-desktop
    gtk3
    libnotify
    pango
  ]
  ++ (with gstreamer; [
    libav
    plugins-bad
    plugins-base
    plugins-good
    plugins-ugly
    gstreamer
  ]);

  # See `install_requires` in https://github.com/lutris/lutris/blob/master/setup.py
  dependencies = with python3Packages; [
    certifi
    dbus-python
    distro
    evdev
    lxml
    pillow
    pygobject3
    pypresence
    pyyaml
    requests
    protobuf
    moddb
  ];

  postPatch = ''
    substituteInPlace lutris/util/magic.py \
      --replace-fail '"libmagic.so.1"' "'${lib.getLib file}/lib/libmagic.so.1'"
  '';

  # avoid double wrapping
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath requiredTools}"
      --set APPIMAGE_EXTRACT_AND_RUN 1
      "''${gappsWrapperArgs[@]}"
    )
  '';

  meta = {
    homepage = "https://lutris.net";
    description = "Open Source gaming platform for GNU/Linux";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "lutris";
  };
})
