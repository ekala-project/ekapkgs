{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  gtk3,
  libgee,
  gettext,
  vala,
  libintl,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgnome-games-support";
  version = "1.8.2";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome-games-support/${lib.versions.majorMinor finalAttrs.version}/libgnome-games-support-${finalAttrs.version}.tar.xz";
    sha256 = "KENGBKewOHMawCMXMTiP8QT1ZbsjMMwk54zaBM/T730=";
  };

  nativeBuildInputs = [
    gettext
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    libintl
  ];

  propagatedBuildInputs = [
    # Required by libgnome-games-support-1.pc
    glib
    gtk3
    libgee
  ];

  meta = {
    description = "Small library intended for internal use by GNOME Games, but it may be used by others";
    homepage = "https://gitlab.gnome.org/GNOME/libgnome-games-support";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
  };
})
