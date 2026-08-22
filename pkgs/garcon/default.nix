{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  pkg-config,
  xfce4-dev-tools,
  gtk3,
  libxfce4ui,
  libxfce4util,
  withIntrospection ? false,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "garcon";
  version = "4.20.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "garcon";
    tag = "garcon-${finalAttrs.version}";
    hash = "sha256-MeZkDb2QgGMaloO6Nwlj9JmZByepd6ERqpAWqrVv1xw=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    xfce4-dev-tools
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libxfce4ui
    libxfce4util
  ];

  configureFlags = [ "--enable-maintainer-mode" ];
  enableParallelBuilding = true;

  meta = {
    description = "Xfce menu support library";
    homepage = "https://gitlab.xfce.org/xfce/garcon";
    license = with lib.licenses; [
      lgpl2Only
      fdl11Only
    ];
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
