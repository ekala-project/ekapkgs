{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gsound ? null,
  gtk4,
  wrapGAppsHook4,
  librsvg,
  gettext,
  itstool,
  vala,
  libxml2,
  libadwaita,
  libgee,
  meson,
  ninja,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-nibbles";
  version = "4.5.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nibbles/${lib.versions.majorMinor finalAttrs.version}/gnome-nibbles-${finalAttrs.version}.tar.xz";
    hash = "sha256-dnKdO1Ys14Yq0wWQw71A/SUfnUu1xTuqhBUBl/Ixpfo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    gettext
    itstool
    libxml2
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    librsvg
    libadwaita
    libgee
  ]
  ++ lib.optional (gsound != null) gsound;

  meta = {
    description = "Guide a worm around a maze";
    mainProgram = "gnome-nibbles";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-nibbles";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-nibbles/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
