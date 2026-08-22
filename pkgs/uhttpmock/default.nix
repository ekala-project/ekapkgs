{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gobject-introspection ? null,
  vala ? null,
  gtk-doc ? null,
  docbook-xsl-nons ? null,
  glib,
  libsoup_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uhttpmock";
  version = "0.11.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pwithnall";
    repo = "uhttpmock";
    rev = finalAttrs.version;
    hash = "sha256-itJhiPpAF5dwLrVF2vuNznABqTwEjVj6W8mbv1aEmE4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gobject-introspection
    vala
    gtk-doc
    docbook-xsl-nons
  ];

  buildInputs = [
    glib
    libsoup_3
  ];

  propagatedBuildInputs = [
    glib
    libsoup_3
  ];

  mesonFlags = [
    "-Dintrospection=false"
    "-Dvapi=disabled"
  ];

  meta = {
    description = "Project for mocking web service APIs which use HTTP or HTTPS";
    homepage = "https://gitlab.freedesktop.org/pwithnall/uhttpmock/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
