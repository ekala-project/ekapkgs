{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  intltool,
  pkg-config,
  libx11,
  gtk3,
  libxslt,
  docbook_xsl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxappearance";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxappearance";
    tag = finalAttrs.version;
    hash = "sha256-t5P3JYGZzhTaJ3s23r6yrAQoFcCV5uteHh67sWY1KrI=";
  };


  nativeBuildInputs = [
    pkg-config
    intltool
    gtk3.wrapGAppsHook
    autoreconfHook
    libxslt
    docbook_xsl
  ];

  buildInputs = [
    libx11
    gtk3
  ];

  patches = [
    ./lxappearance-0.6.3-xdg.system.data.dirs.patch
  ];

  env.XSLTPROC = lib.getExe' libxslt "xsltproc";

  configureFlags = [ "--enable-gtk3" ];

  meta = {
    description = "Lightweight program for configuring the theme and fonts of gtk applications";
    mainProgram = "lxappearance";
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
