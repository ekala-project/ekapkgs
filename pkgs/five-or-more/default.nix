{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gtk3,
  wrapGAppsHook3,
  librsvg,
  libgnome-games-support,
  gettext,
  itstool,
  libxml2,
  python3,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "five-or-more";
  version = "48.1";

  src = fetchurl {
    url = "mirror://gnome/sources/five-or-more/${lib.versions.major finalAttrs.version}/five-or-more-${finalAttrs.version}.tar.xz";
    hash = "sha256-2UHOLjfqZsDYDx6BeX+8u+To72WnkLPMXla58QtepaM=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    itstool
    libxml2
    python3
    wrapGAppsHook3
    vala
  ];

  buildInputs = [
    gtk3
    librsvg
    libgnome-games-support
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/five-or-more";
    description = "Remove colored balls from the board by forming lines";
    mainProgram = "five-or-more";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
})
