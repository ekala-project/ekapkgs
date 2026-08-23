{
  lib,
  stdenv,
  gettext,
  fetchurl,
  wrapGAppsHook3,
  gnome-video-effects ? null,
  libcanberra-gtk3 ? null,
  pkg-config,
  gtk3,
  glib,
  clutter-gtk ? null,
  clutter-gst ? null,
  gst_all_1,
  itstool,
  vala,
  docbook_xml_dtd_43 ? null,
  docbook-xsl-nons ? null,
  appstream-glib ? null,
  libxslt,
  gtk-doc ? null,
  adwaita-icon-theme ? null,
  librsvg,
  totem ? null,
  gdk-pixbuf,
  gnome-desktop,
  libxml2,
  meson,
  ninja,
  dbus,
  pipewire ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cheese";
  version = "44.1";

  outputs = [
    "out"
    "man"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/cheese/${lib.versions.major finalAttrs.version}/cheese-${finalAttrs.version}.tar.xz";
    hash = "sha256-XyGFxMmeVN3yuLr2DIKBmVDlSVLhMuhjmHXz7cv49o4=";
  };

  nativeBuildInputs = [
    appstream-glib
    docbook_xml_dtd_43
    docbook-xsl-nons
    gettext
    gtk-doc
    itstool
    libxml2
    libxslt
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    glib
  ];

  buildInputs = [
    adwaita-icon-theme
    clutter-gst
    dbus
    gnome-desktop
    gnome-video-effects
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtk3
    libcanberra-gtk3
    librsvg
    pipewire
  ];

  propagatedBuildInputs = [
    clutter-gtk
    gdk-pixbuf
    glib
    gst_all_1.gstreamer
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome-video-effects}/share"
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${totem}/share"
    )
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/cheese";
    changelog = "https://gitlab.gnome.org/GNOME/cheese/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Take photos and videos with your webcam, with fun graphical effects";
    mainProgram = "cheese";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
