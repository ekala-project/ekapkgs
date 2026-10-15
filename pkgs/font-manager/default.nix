{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  gettext,
  python3,
  pkg-config,
  libxml2,
  json-glib,
  sqlite,
  itstool,
  yelp-tools,
  vala,
  gsettings-desktop-schemas,
  gtk4,
  adwaita-icon-theme,
  libarchive,
  desktop-file-utils,
  wrapGAppsHook4,
  gobject-introspection,
  withWebkit ? true,
  glib-networking,
  libsoup_3,
  webkitgtk_6_0,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-manager";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "FontManager";
    repo = "font-manager";
    tag = finalAttrs.version;
    hash = "sha256-hggRvwMy/D2jc98CQPc7GChTV9+zYbYHPMENf/8Uq9s=";
  };

  patches = [
    (fetchpatch {
      name = "fix-reproducible-build-issue.patch";
      url = "https://github.com/FontManager/font-manager/commit/cc0c148d90741e39615e3380d283f684a052dd94.patch";
      hash = "sha256-bRn+jVjBu6ZqmQCErgcqxv6OyFa4hkPYB5bvK7rEibA=";
    })
    ./fix-compilation-error-with-newer-vala-versions.patch
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    python3
    itstool
    desktop-file-utils
    vala
    yelp-tools
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    libxml2
    json-glib
    sqlite
    gsettings-desktop-schemas
    gtk4
    adwaita-icon-theme
    libarchive
  ]
  ++ lib.optionals withWebkit [
    glib-networking
    libsoup_3
    webkitgtk_6_0
  ];

  mesonFlags = [
    "-Dreproducible=true"
    (lib.mesonBool "webkit" withWebkit)
  ];

  meta = {
    homepage = "https://fontmanager.github.io/";
    description = "Simple font management for GTK desktop environments";
    mainProgram = "font-manager";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
