{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
  glib,
  gtk4,
  gtksourceview5,
  enchant,
  icu,
  libsysprof-capture ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspelling";
  version = "0.4.10";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libspelling/${lib.versions.majorMinor finalAttrs.version}/libspelling-${finalAttrs.version}.tar.xz";
    hash = "sha256-VuPwGjoYtXW+6kw0NJ+ZzaujFuH3wnGxIx97z12a9zs=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
  ];

  buildInputs = [
    enchant
    icu
  ]
  ++ lib.optionals (libsysprof-capture != null) [ libsysprof-capture ];

  propagatedBuildInputs = [
    glib
    gtk4
    gtksourceview5
  ];

  mesonFlags = lib.optionals (libsysprof-capture == null) [
    "-Dsysprof=false"
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    description = "Spellcheck library for GTK 4";
    homepage = "https://gitlab.gnome.org/GNOME/libspelling";
    license = lib.licenses.lgpl21Plus;
    changelog = "https://gitlab.gnome.org/GNOME/libspelling/-/raw/${finalAttrs.version}/NEWS";
    maintainers = [ ];
  };
})
