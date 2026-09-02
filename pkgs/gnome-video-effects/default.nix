{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "gnome-video-effects";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "166utGs/WoMvsuDZC0K/jGFgICylKsmt0Xr84ZLjyKg=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
  ];

  meta = with lib; {
    description = "Collection of GStreamer effects to be used in different GNOME Modules";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-video-effects";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
