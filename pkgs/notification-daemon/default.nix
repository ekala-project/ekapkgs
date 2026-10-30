{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  gtk3,
  libcanberra-gtk3,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notification-daemon";
  version = "3.20.0";

  src = fetchurl {
    url = "mirror://gnome/sources/notification-daemon/${lib.versions.majorMinor finalAttrs.version}/notification-daemon-${finalAttrs.version}.tar.xz";
    hash = "sha256-3RN2jzX9i7qcSSCw+CafOScOWjz+0aNMO5QKSSKG7OU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    glib
    gtk3
    libcanberra-gtk3
  ];

  meta = {
    description = "Notification daemon for the GNOME desktop";
    homepage = "https://gitlab.gnome.org/GNOME/notification-daemon";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "notification-daemon";
  };
})
