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
  libgedit-amtk,
  libgedit-gfls,
  libxml2,
  glib,
  gtk3,
  shared-mime-info,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgedit-gtksourceview";
  version = "299.7.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "gedit";
    repo = "libgedit-gtksourceview";
    tag = finalAttrs.version;
    forceFetchGit = true;
    hash = "sha256-i+6Rfqm/KPJrLSvhvTVY53Q6O+LJEU9WjLJ/L3hMSUA=";
  };

  patches = [
    ./nix-share-path.patch
  ];

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
    libgedit-amtk
    libgedit-gfls
    libxml2
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    shared-mime-info
  ];

  meta = {
    description = "Source code editing widget for GTK";
    homepage = "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
