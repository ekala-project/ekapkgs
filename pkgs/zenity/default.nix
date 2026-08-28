{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  libxml2,
  gtk3,
  libx11,
  gettext,
  itstool,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zenity";
  version = "3.44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${lib.versions.majorMinor finalAttrs.version}/zenity-${finalAttrs.version}.tar.xz";
    sha256 = "wVWCMB7ZC51CzlIdvM+ZqYnyLxIEG91SecZjbamev2U=";
  };

  patches = [ ./fix-icon-install.patch ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    itstool
    libxml2
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libx11
  ];

  meta = {
    description = "Tool to display dialogs from the commandline and shell scripts";
    homepage = "https://gitlab.gnome.org/GNOME/zenity";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    mainProgram = "zenity";
  };
})
