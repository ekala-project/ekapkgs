{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  docbook_xsl,
  libxslt,
  meson,
  pkg-config,
  wrapGAppsHook3,
  python3,
  autoconf,
  automake,
  glib,
  gtk-doc,
  libtool,
  intltool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-dev-tools";
  version = "4.20.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfce4-dev-tools";
    rev = "xfce4-dev-tools-${finalAttrs.version}";
    hash = "sha256-eUfNa/9ksLCKtVwBRtHaVl7Yl95tukUaDdoLNfeR+Ew=";
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook_xsl
    libxslt
    meson
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    python3
  ];

  propagatedBuildInputs = [
    autoconf
    automake
    glib
    gtk-doc
    intltool
    libtool
  ];

  dontUseMesonConfigure = true;
  configureFlags = [ "--enable-maintainer-mode" ];

  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://gitlab.xfce.org/xfce/xfce4-dev-tools";
    description = "Autoconf macros and scripts to augment app build systems";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
