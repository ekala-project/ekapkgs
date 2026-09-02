{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  gobject-introspection,
  gtk3,
  icu,
  libhandy,
  libgedit-amtk,
  libgedit-gfls,
  libgedit-gtksourceview,
  pkg-config,
  gtk-doc,
  docbook-xsl-nons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgedit-tepl";
  version = "6.14.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "gedit";
    repo = "libgedit-tepl";
    tag = finalAttrs.version;
    hash = "sha256-KtmExJCEfa4c6alrtWOLNSKZUs65tZ7p9zcT9f8ZC+k=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    gobject-introspection
    pkg-config
    gtk-doc
    docbook-xsl-nons
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dgobject_introspection=false"
  ];

  buildInputs = [
    icu
    libhandy
  ];

  propagatedBuildInputs = [
    gtk3
    libgedit-amtk
    libgedit-gfls
    libgedit-gtksourceview
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/World/gedit/libgedit-tepl";
    description = "Text editor product line";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
