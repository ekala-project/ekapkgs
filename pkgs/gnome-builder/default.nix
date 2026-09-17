{
  stdenv,
  lib,
  fetchurl,
  ctags,
  desktop-file-utils,
  flatpak,
  gobject-introspection,
  gtk4,
  json-glib,
  jsonrpc-glib,
  libadwaita,
  libpeas2,
  libportal,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python3,
  template-glib,
  vala,
  wrapGAppsHook4,
  cmark,
  dbus,
  editorconfig-core-c,
  gi-docgen,
  gom,
  gtksourceview5,
  libdex,
  libpanel,
  libspelling,
  libsysprof-capture,
  libyaml,
  ostree,
  pcre2,
  sysprof,
  libgit2-glib,
  # TODO: vte-gtk4 - not available
  # TODO: webkitgtk - not wired up
  # TODO: xvfb-run - not available
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-builder";
  version = "50.0";

  outputs = [
    "out"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-builder/${lib.versions.major finalAttrs.version}/gnome-builder-${finalAttrs.version}.tar.xz";
    hash = "sha256-RtVP0T9PS9tu7X0AS0mdC22adqb6/GitFsOJlT/ZL0Y=";
  };

  patches = [
    # Fix finding typelibs in test environment on Nix.
    ./fix-finding-test-typelibs.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gi-docgen
    gobject-introspection
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    cmark
    ctags
    editorconfig-core-c
    flatpak
    gom
    gtk4
    gtksourceview5
    json-glib
    jsonrpc-glib
    libadwaita
    libdex
    libgit2-glib
    libpanel
    libpeas2
    libportal.gtk4
    libspelling
    libsysprof-capture
    libxml2
    libyaml
    ostree
    pcre2
    python3
    template-glib
    vala
    # TODO: vte-gtk4 - not available
    # TODO: webkitgtk - not wired up
  ];

  # TODO: nativeCheckInputs = [ dbus xvfb-run ]; # xvfb-run not available

  mesonFlags = [
    "-Ddocs=true"

    # Making the build system correctly detect clang header and library paths
    # is difficult. Somebody should look into fixing this.
    "-Dplugin_clang=false"

    # Do not try to check if appstream images exist
    "-Dnetwork_tests=false"
  ];

  doCheck = false; # TODO: enable when xvfb-run is available for tests

  postPatch = ''
    patchShebangs build-aux/meson/post_install.py
    substituteInPlace build-aux/meson/post_install.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${sysprof}/bin"
      --prefix XDG_DATA_DIRS : "${libpanel}/share"
    )

    # Ensure that all plugins get their interpreter paths fixed up.
    find $out/lib -name \*.py -type f -print0 | while read -d "" f; do
      chmod a+x "$f"
    done
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput share/doc/libide "$devdoc"
  '';

  meta = {
    description = "IDE for writing GNOME-based software";
    longDescription = ''
      Global search, auto-completion, source code map, documentation
      reference, and other features expected in an IDE, but with a focus
      on streamlining GNOME-based development projects.

      This package does not pull in the dependencies needed for every
      plugin. If you find that a plugin you wish to use doesn't work, we
      currently recommend running gnome-builder inside a nix-shell with
      appropriate dependencies loaded.
    '';
    homepage = "https://apps.gnome.org/Builder/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gnome-builder";
  };
})
