{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  pkg-config,
  wayland-scanner,
  xfce4-dev-tools,
  wrapGAppsHook3,
  gtk3,
  libnotify,
  libxfce4ui,
  libxfce4util,
  polkit,
  upower,
  wayland-protocols,
  wlr-protocols,
  xfconf,
  xfce4-panel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-power-manager";
  version = "4.20.1";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfce4-power-manager";
    tag = "xfce4-power-manager-${finalAttrs.version}";
    hash = "sha256-0Pgk5N+Cr75RwOp2dbYB8OOEzmXDVUHzoqFbaUF/Z0k=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    wayland-scanner
    xfce4-dev-tools
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libnotify
    libxfce4ui
    libxfce4util
    polkit
    upower
    wayland-protocols
    wlr-protocols
    xfconf
    xfce4-panel
  ];

  postPatch = ''
    substituteInPlace common/xfpm-brightness-polkit.c --replace-fail "SBINDIR" "\"/run/current-system/sw/bin\""
    substituteInPlace src/xfpm-suspend.c --replace-fail "SBINDIR" "\"/run/current-system/sw/bin\""
  '';

  configureFlags = [
    "--enable-maintainer-mode"
    "--sbindir=\${out}/bin"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Power manager for the Xfce Desktop Environment";
    homepage = "https://gitlab.xfce.org/xfce/xfce4-power-manager";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-power-manager";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
