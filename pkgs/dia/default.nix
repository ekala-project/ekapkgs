{
  lib,
  stdenv,
  appstream,
  dblatex ? null,
  desktop-file-utils,
  docbook-xsl-nons,
  docbook_xml_dtd_45,
  fetchFromGitLab,
  gdk-pixbuf,
  graphene,
  gtk3,
  libxml2,
  libxslt,
  meson,
  ninja,
  pkg-config,
  poppler,
  python3,
  wrapGAppsHook3,
}:

let
  xpm-pixbuf = stdenv.mkDerivation {
    pname = "xpm-pixbuf";
    version = "0-unstable-2024-05-24";

    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "ZanderBrown";
      repo = "xpm-pixbuf";
      rev = "d290a0c846687b22d2a8c5aaec83a6689f30e1c3";
      hash = "sha256-LU6nKe7IIecF/3wwhlwR1hyABBvfwvujVW5zJJSzkqo=";
    };

    nativeBuildInputs = [
      meson
      meson.configurePhaseHook
      ninja
      pkg-config
    ];

    buildInputs = [ gdk-pixbuf ];

    meta = {
      license = lib.licenses.lgpl21;
      homepage = "https://gitlab.gnome.org/ZanderBrown/xpm-pixbuf";
    };
  };
in
stdenv.mkDerivation {
  pname = "dia";
  version = "0.97.2-unstable-2026-07-24";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "dia";
    rev = "ad68cc378b7a187706bc2648c48b44d16fb80819";
    hash = "sha256-ejjSc9GGXD5GsbeRps1T20xifJuzWA1yq/G7jk797Cw=";
  };

  patches = [
    ./fix-build-with-poppler-26-06.patch
  ];

  postPatch = ''
    # Fix build with poppler 25.10.0
    substituteInPlace plug-ins/pdf/pdf-import.cpp \
      --replace-fail 's->getLength();' 's->size();'
  '';

  strictDeps = true;

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    docbook-xsl-nons
    docbook_xml_dtd_45
    libxml2
    libxslt
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    graphene
    gtk3
    libxml2
    libxslt
    python3
    poppler
    xpm-pixbuf
  ];

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/org.gnome.Dia.thumbnailer \
      --replace-fail "TryExec=dia" "TryExec=$out/bin/dia" \
      --replace-fail "Exec=dia" "Exec=$out/bin/dia"
  '';

  meta = {
    description = "Gnome Diagram drawing software";
    mainProgram = "dia";
    homepage = "https://wiki.gnome.org/Apps/Dia";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
