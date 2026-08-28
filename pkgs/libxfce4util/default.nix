{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  xfce4-dev-tools,
  wrapGAppsHook3,
  hicolor-icon-theme,
  python3,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "libxfce4util";
  version = "4.20.1";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "xfce";
    repo = "libxfce4util";
    rev = "libxfce4util-${version}";
    sha256 = "sha256-QlT5ev4NhjR/apbgYQsjrweJ2IqLySozLYLzCAnmkfM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    xfce4-dev-tools
    wrapGAppsHook3
    python3
  ];

  buildInputs = [
    hicolor-icon-theme
  ];

  propagatedBuildInputs = [
    glib
  ];

  configureFlags = [ "--enable-maintainer-mode" ];

  postPatch = ''
    patchShebangs xdt-gen-visibility
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Extension library for Xfce";
    homepage = "https://gitlab.xfce.org/xfce/libxfce4util";
    mainProgram = "xfce4-kiosk-query";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
}
