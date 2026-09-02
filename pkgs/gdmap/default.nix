{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  cairo,
  gtk3,
  pkg-config,
  libxml2,
  gettext,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "gdmap";
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "sjohannes";
    repo = "gdmap";
    tag = "v1.4.0";
    sha256 = "sha256-yqrlxmMxtcJqUe9xgs01d1AAc2gkPBPsQbzQfffZET0=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    gtk3
    cairo
    libxml2
    gettext
  ];

  meta = {
    homepage = "https://gitlab.com/sjohannes/gdmap";
    description = "Tool to visualize disk space (GTK 3 port)";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "gdmap";
  };
}
