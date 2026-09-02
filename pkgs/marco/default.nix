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
  wrapGAppsHook3,
  yelp-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "marco";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "marco";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k45k49mPxy4vmDtCFHaqk0kwZ5wXVAaTj3kanK79n7I=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    gettext
    itstool
    libxml2
    mate-common
    wrapGAppsHook3
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

  enableParallelBuilding = true;

  meta = {
    description = "MATE default window manager";
    homepage = "https://github.com/mate-desktop/marco";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
