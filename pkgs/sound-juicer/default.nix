{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk3,
  itstool,
  libxml2,
  brasero,
  libcanberra-gtk3,
  adwaita-icon-theme,
  gstreamer,
  libmusicbrainz,
  libdiscid,
  isocodes,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sound-juicer";
  version = "3.40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/sound-juicer/${lib.versions.majorMinor finalAttrs.version}/sound-juicer-${finalAttrs.version}.tar.xz";
    sha256 = "LuiCdEORvrTG1koPaCX7dlUQtwbsK3BL+0LkKvquHeY=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    itstool
    libxml2
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    brasero
    libcanberra-gtk3
    adwaita-icon-theme
    gsettings-desktop-schemas
    libmusicbrainz
    libdiscid
    isocodes
    gstreamer
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-bad
    gstreamer.pkgs.gst-libav
  ];

  meta = {
    description = "Gnome CD Ripper";
    mainProgram = "sound-juicer";
    homepage = "https://gitlab.gnome.org/GNOME/sound-juicer";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
