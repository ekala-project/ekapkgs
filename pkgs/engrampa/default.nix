{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  gettext,
  itstool,
  libxml2,
  caja ? null,
  gtk3,
  hicolor-icon-theme,
  json-glib,
  mate-common,
  mate-desktop,
  wrapGAppsHook3,
  yelp-tools,
  withMagic ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  file,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "engrampa";
  version = "1.28.3";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "engrampa";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-bmqCsbGz49wda1sMiAvG3XTGpFEwMvDx8ojuzxZ9MAI=";
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
    gtk3
    hicolor-icon-theme
    json-glib
    mate-desktop
  ]
  ++ lib.optional (caja != null) caja
  ++ lib.optionals withMagic [
    file
  ];

  configureFlags =
    lib.optionals (caja != null) [
      "--with-cajadir=$$out/lib/caja/extensions-2.0"
    ]
    ++ lib.optionals withMagic [
      "--enable-magic"
    ];

  enableParallelBuilding = true;

  meta = {
    description = "Archive Manager for MATE";
    mainProgram = "engrampa";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
      fdl11Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
