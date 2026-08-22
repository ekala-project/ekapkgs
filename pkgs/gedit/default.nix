{
  stdenv,
  lib,
  meson,
  fetchFromGitLab,
  pkg-config,
  gtk3,
  glib,
  libgedit-amtk ? null,
  libgedit-gtksourceview ? null,
  libgedit-tepl ? null,
  libpeas,
  libxml2,
  gsettings-desktop-schemas ? null,
  wrapGAppsHook3,
  gtk-doc,
  gobject-introspection,
  docbook-xsl-nons,
  ninja,
  gspell,
  itstool,
  desktop-file-utils,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gedit";
  version = "50.0";

  outputs = [
    "out"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "gedit";
    repo = "gedit";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-UkKd1H7twf9r9Jf5Cx6br/8lVT2F2O9U5jR2Ihom0ZA=";
  };

  patches = [
    ./correct-gir-lib-path.patch
  ];

  postPatch = ''
    # Disable GObject Introspection since Gtk-3.0.gir is not available
    sed -i '/gnome.generate_gir/,/^)/d' gedit/meson.build
  '';

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    libxml2
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    gtk-doc
    gobject-introspection
    docbook-xsl-nons
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gspell
    gtk3
    libgedit-amtk
    libgedit-gtksourceview
    libgedit-tepl
    libpeas
  ];

  # Reliably fails to generate gedit-file-browser-enum-types.h in time
  enableParallelBuilding = false;

  meta = {
    homepage = "https://gitlab.gnome.org/World/gedit/gedit";
    description = "Former GNOME text editor";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "gedit";
  };
})
