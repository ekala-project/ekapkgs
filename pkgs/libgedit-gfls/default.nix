{
  stdenv,
  lib,
  fetchFromGitLab,
  docbook-xsl-nons,
  gobject-introspection,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  gtk3,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgedit-gfls";
  version = "0.4.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "gedit";
    repo = "libgedit-gfls";
    tag = finalAttrs.version;
    forceFetchGit = true;
    hash = "sha256-8nr8rBvSBLadhxHipZiWOJj663R9jP6kFurSKp3n0U0=";
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    gobject-introspection
    gtk-doc
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dgobject_introspection=false"
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    glib
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/World/gedit/libgedit-gfls";
    description = "Module dedicated to file loading and saving";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
