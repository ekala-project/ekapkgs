{
  stdenv,
  lib,
  fetchFromGitLab,
  glib,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  gspell,
  gtk3,
  gtksourceview4,
  libxfce4ui,
  xfconf,
  enablePolkit ? true,
  polkit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mousepad";
  version = "0.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "mousepad";
    tag = "mousepad-${finalAttrs.version}";
    hash = "sha256-zoPzMqXfY3ir8MOYXTr+ZNmxISdMgKQEWwIgsVD9oMw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    glib
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gspell
    gtk3
    gtksourceview4
    libxfce4ui
    xfconf
  ]
  ++ lib.optionals enablePolkit [
    polkit
  ];

  mesonFlags = [ "-Dkeyfile-settings=true" ];

  meta = {
    description = "Simple text editor for Xfce";
    homepage = "https://gitlab.xfce.org/apps/mousepad";
    license = lib.licenses.gpl2Plus;
    mainProgram = "mousepad";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
