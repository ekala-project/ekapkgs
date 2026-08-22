{
  stdenv,
  lib,
  fetchFromGitLab,
  glib,
  gtk3,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  gtk-doc,
  docbook-xsl-nons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgedit-amtk";
  version = "5.10.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "gedit";
    repo = "libgedit-amtk";
    tag = finalAttrs.version;
    forceFetchGit = true;
    hash = "sha256-wA5KRA1qWJzw5JRXQL/kP2BgCQiNhf6aIe6RppBEH90=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dgobject_introspection=false"
  ];

  propagatedBuildInputs = [
    glib
    gtk3
  ];

  doCheck = false;

  meta = {
    homepage = "https://gitlab.gnome.org/World/gedit/libgedit-amtk";
    description = "Actions, Menus and Toolbars Kit for GTK applications";
    maintainers = [ ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
