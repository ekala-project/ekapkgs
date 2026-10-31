{
  stdenv,
  lib,
  fetchurl,
  docbook-xsl-nons,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  libxml2,
  libxslt,
  gobject-introspection,
  wrapGAppsHook4,
  wrapGAppsNoGuiHook,
  python3,
  gdk-pixbuf,
  glib,
  gssdp_1_6,
  gupnp_1_6,
  gupnp-av,
  gupnp-dlna,
  gstreamer,
  gst-editing-services,
  gst-plugins-base,
  gst-plugins-good,
  gst-plugins-bad,
  gst-plugins-ugly,
  libgee,
  libsoup_3,
  libx11,
  withGtk ? true,
  gtk4,
  libmediaart,
  pipewire,
  sqlite,
  systemd,
  tinysparql,
  shared-mime-info,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rygel";
  version = "45.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/rygel/${lib.versions.major finalAttrs.version}/rygel-${finalAttrs.version}.tar.xz";
    hash = "sha256-IOV7cLFahl133Dj594arxSxksRH+X5OKYsKNcS3xMx0=";
  };

  patches = [
    ./add-option-for-installation-sysconfdir.patch
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    meson
    ninja
    pkg-config
    vala
    gettext
    libxml2
    libxslt
    gobject-introspection
    (if withGtk then wrapGAppsHook4 else wrapGAppsNoGuiHook)
    python3
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gssdp_1_6
    gupnp_1_6
    gupnp-av
    gupnp-dlna
    libgee
    libsoup_3
    libmediaart
    pipewire
    libx11
    sqlite
    systemd
    tinysparql
    shared-mime-info
  ]
  ++ lib.optionals withGtk [ gtk4 ]
  ++ [
    gstreamer
    gst-editing-services
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ];

  mesonFlags = [
    "-Dsystemd-user-units-dir=${placeholder "out"}/lib/systemd/user"
    "-Dapi-docs=false"
    "--sysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
    (lib.mesonEnable "gtk" withGtk)
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs data/xml/process-xml.py
  '';

  meta = {
    description = "Home media solution (UPnP AV MediaServer) that allows you to easily share audio, video and pictures to other devices";
    homepage = "https://gitlab.gnome.org/GNOME/rygel";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
