{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  xfce4-dev-tools,
  wrapGAppsHook3,
  hicolor-icon-theme,
  perl,
  libxfce4util,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "xfconf";
  version = "4.20.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "xfconf";
    rev = "xfconf-${version}";
    sha256 = "sha256-U+Sk7ubBr1ZD1GLQXlxrx0NQdhV/WpVBbnLcc94Tjcw=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    xfce4-dev-tools
    wrapGAppsHook3
    perl
  ];

  buildInputs = [
    hicolor-icon-theme
    libxfce4util
  ];

  propagatedBuildInputs = [ glib ];

  configureFlags = [ "--enable-maintainer-mode" ];

  enableParallelBuilding = true;

  meta = {
    description = "Simple client-server configuration storage and query system for Xfce";
    homepage = "https://gitlab.xfce.org/xfce/xfconf";
    mainProgram = "xfconf-query";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
