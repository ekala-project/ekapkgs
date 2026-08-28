{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  pkg-config,
  xfce4-dev-tools,
  wayland-scanner,
  wrapGAppsHook3,
  xfce4-exo,
  garcon,
  gtk3,
  gtk-layer-shell,
  glib,
  libnotify,
  libx11,
  libxext,
  libxfce4ui,
  libxfce4util,
  libxklavier,
  libxml2,
  bashNonInteractive ? null,
  withXrandr ? true,
  upower,
  withUpower ? false,
  wlr-protocols ? null,
  xapp ? null,
  xfconf,
  xf86-input-libinput ? null,
  colord,
  withColord ? true,
}:

let
  garconNoGir = garcon.override { withIntrospection = false; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-settings";
  version = "4.20.5";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfce4-settings";
    tag = "xfce4-settings-${finalAttrs.version}";
    hash = "sha256-96XlFRFyHb/FrhGEzxjprdPOO43vjo7ErnZFfbbuWdI=";
    fetchSubmodules = true;
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gettext
    pkg-config
    xfce4-dev-tools
    wayland-scanner
    wrapGAppsHook3
    libxml2
  ];

  buildInputs = [
    xfce4-exo
    garconNoGir
    glib
    gtk3
    gtk-layer-shell
    libnotify
    libx11
    libxext
    libxfce4ui
    libxfce4util
    libxklavier
    xfconf
  ]
  ++ lib.optionals (bashNonInteractive != null) [ bashNonInteractive ]
  ++ lib.optionals (wlr-protocols != null) [ wlr-protocols ]
  ++ lib.optionals (xapp != null) [ xapp ]
  ++ lib.optionals (xf86-input-libinput != null) [ xf86-input-libinput ]
  ++ lib.optionals withUpower [ upower ]
  ++ lib.optionals withColord [ colord ];

  strictDeps = true;

  configureFlags = [
    "--enable-sound-settings"
    (lib.enableFeature withXrandr "xrandr")
  ]
  ++ lib.optionals withUpower [ "--enable-upower-glib" ]
  ++ lib.optionals withColord [ "--enable-colord" ];

  enableParallelBuilding = true;

  meta = {
    description = "Settings manager for Xfce";
    homepage = "https://gitlab.xfce.org/xfce/xfce4-settings";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-settings-manager";
    platforms = lib.platforms.linux;
  };
})
