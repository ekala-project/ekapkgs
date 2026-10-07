{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  mate-common,
  pkg-config,
  gettext,
  itstool,
  libxml2,
  libcanberra-gtk3 ? null,
  libgtop,
  libxdamage,
  libxpresent,
  libxres,
  libstartup_notification,
  zenity,
  glib,
  gtk3,
  mate-desktop,
  mate-settings-daemon ? null,
  yelp-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "marco";
  version = "1.29.1";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "marco";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3ylRNRI5iD+S8ClascPs4U0NRlU++47MmqmdkFN56Lk=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    gettext
    itstool
    libxml2
    mate-common
    gtk3.wrapGAppsHook
    yelp-tools
  ];

  buildInputs = [
    libgtop
    libxdamage
    libxpresent
    libxres
    libstartup_notification
    gtk3
    zenity
    mate-desktop
  ]
  ++ lib.optional (libcanberra-gtk3 != null) libcanberra-gtk3
  ++ lib.optional (mate-settings-daemon != null) mate-settings-daemon;

  postPatch = ''
    substituteInPlace src/core/util.c \
      --replace-fail 'argvl[i++] = "zenity"' 'argvl[i++] = "${lib.getExe zenity}"'
  '';

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";
  env.ZENITY = lib.getExe zenity;

  meta = {
    description = "MATE default window manager";
    homepage = "https://github.com/mate-desktop/marco";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
