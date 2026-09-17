{
  stdenv,
  lib,
  cmark,
  editorconfig-core-c,
  fetchurl,
  flatpak,
  gi-docgen,
  glib,
  gobject-introspection,
  gom,
  gtk4,
  gtksourceview5,
  json-glib,
  libadwaita,
  libdex,
  libgit2,
  libpanel,
  libpeas2,
  libsecret,
  libsoup_3,
  libspelling,
  libssh2,
  libsysprof-capture,
  libxml2,
  libyaml,
  meson,
  ninja,
  pkg-config,
  readline,
  template-glib,
  vte-gtk4,
  webkitgtk_6_0,
  wrapGAppsNoGuiHook,
  withGtk ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfoundry${lib.optionalString withGtk "-gtk"}";
  version = "1.1.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/foundry/${lib.versions.majorMinor finalAttrs.version}/foundry-${finalAttrs.version}.tar.xz";
    hash = "sha256-RtsNZENsMTYRyv37TKDVzsK5e+fXpfG+fujQFQ1PJcg=";
  };

  patches = [
    ./host_sdk_filename_nixos.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    gi-docgen
    gobject-introspection
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    editorconfig-core-c
    flatpak
    gom
    libadwaita
    libgit2
    libpanel
    libsecret
    libsoup_3
    libssh2
    libsysprof-capture
    libxml2
    libyaml
    readline
    template-glib
  ]
  ++ lib.optionals withGtk [
    cmark
    gtk4
    gtksourceview5
    libspelling
    vte-gtk4
    webkitgtk_6_0
  ];

  propagatedBuildInputs = [
    glib
    json-glib
    libdex
    libpeas2
  ];

  mesonFlags = [
    (lib.mesonBool "docs" true)
    (lib.mesonBool "gtk" withGtk)
  ];

  postFixup = ''
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    description = "Command line tool and library that can be used to build developer tools";
    mainProgram = "foundry";
    homepage = "https://gitlab.gnome.org/GNOME/foundry";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
