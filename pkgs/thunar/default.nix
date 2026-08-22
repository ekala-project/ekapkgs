{
  stdenv,
  lib,
  fetchFromGitLab,
  docbook_xsl,
  gettext,
  xfce4-exo,
  gdk-pixbuf,
  gtk3,
  libexif,
  libgudev,
  libnotify,
  libx11,
  libxfce4ui,
  libxfce4util,
  libxslt,
  pcre2,
  pkg-config,
  xfce4-dev-tools,
  xfce4-panel,
  xfconf,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thunar";
  version = "4.20.9";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "thunar";
    tag = "thunar-${finalAttrs.version}";
    hash = "sha256-rKKxCl7hoIcEDcKVaaRJfU+hyDHE/vpL0gxXExX6NeI=";
  };

  nativeBuildInputs = [
    docbook_xsl
    gettext
    libxslt
    pkg-config
    xfce4-dev-tools
    wrapGAppsHook3
  ];

  buildInputs = [
    xfce4-exo
    gdk-pixbuf
    gtk3
    libx11
    libexif
    libgudev
    libnotify
    libxfce4ui
    libxfce4util
    pcre2
    xfce4-panel
    xfconf
  ];

  configureFlags = [
    "--enable-maintainer-mode"
    "--with-custom-thunarx-dirs-enabled"
  ];

  enableParallelBuilding = true;

  postPatch = ''
    sed -i -e 's|thunar_dialogs_show_insecure_program (parent, _(".*"), file, exec)|1|' thunar/thunar-file.c
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ xfce4-exo ]}
    )
  '';

  meta = {
    description = "Xfce file manager";
    homepage = "https://gitlab.xfce.org/xfce/thunar";
    license = lib.licenses.gpl2Plus;
    mainProgram = "thunar";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
