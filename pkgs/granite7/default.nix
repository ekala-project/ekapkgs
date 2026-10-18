{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  sassc,
  vala,
  pkg-config,
  libgee,
  libshumate,
  gtk4,
  glib,
  gettext,
  gsettings-desktop-schemas,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "granite7";
  version = "7.8.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "granite";
    tag = finalAttrs.version;
    hash = "sha256-Hk5EiTMsSOg2eQQCbILDoibcmfS+4N//4go6rc06Qwc=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    sassc
    vala
    gtk4.wrapGAppsHook
  ];

  buildInputs = [
    libshumate
  ];

  propagatedBuildInputs = [
    glib
    gsettings-desktop-schemas
    gtk4
    libgee
  ];

  meta = {
    description = "Extension to GTK used by elementary OS";
    homepage = "https://github.com/elementary/granite";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "granite-7-demo";
  };
})
