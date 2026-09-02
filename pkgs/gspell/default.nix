{
  lib,
  stdenv,
  fetchurl,
  glib,
  meson,
  ninja,
  pkg-config,
  gtk3,
  icu,
  enchant,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gspell";
  version = "1.14.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gspell/${lib.versions.majorMinor finalAttrs.version}/gspell-${finalAttrs.version}.tar.xz";
    hash = "sha256-5zqJ1oxw+HSK77aw9c/f7D/xc89ESYN/1ssX0en89IY=";
  };

  nativeBuildInputs = [
    glib
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    gtk3
    icu
  ];

  propagatedBuildInputs = [
    enchant
  ];

  mesonFlags = [
    (lib.mesonBool "gobject_introspection" false)
    (lib.mesonBool "gtk_doc" false)
    (lib.mesonBool "vapi" false)
    (lib.mesonBool "tests" false)
    (lib.mesonBool "install_tests" false)
  ];

  meta = {
    description = "Spell-checking library for GTK applications";
    homepage = "https://gitlab.gnome.org/GNOME/gspell";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
