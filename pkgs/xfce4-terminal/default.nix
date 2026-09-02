{
  stdenv,
  lib,
  fetchFromGitLab,
  docbook_xml_dtd_45,
  docbook_xsl,
  glib,
  libxslt,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  gtk-layer-shell,
  libutempter,
  libx11,
  libxfce4ui,
  pcre2,
  vte,
  xfconf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-terminal";
  version = "1.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfce4-terminal";
    tag = "xfce4-terminal-${finalAttrs.version}";
    hash = "sha256-2zlx9pt9srMT6iKy89oKKdvh7YALOkyQTy7hRH60AOw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
    glib
    libxslt
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    gtk-layer-shell
    libutempter
    libx11
    libxfce4ui
    pcre2
    vte
    xfconf
  ];

  meta = {
    description = "Modern terminal emulator";
    homepage = "https://gitlab.xfce.org/apps/xfce4-terminal";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-terminal";
    platforms = lib.platforms.linux;
  };
})
