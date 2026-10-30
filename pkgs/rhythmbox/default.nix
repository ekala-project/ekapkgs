{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  python3,
  vala,
  glib,
  gtk3,
  libpeas,
  libsoup_3,
  libxml2,
  libsecret,
  libnotify,
  libdmapsharing,
  gobject-introspection,
  totem-pl-parser,
  libgudev,
  libgpod,
  libmtp,
  lirc,
  brasero-unwrapped,
  grilo,
  tdb,
  json-glib,
  itstool,
  desktop-file-utils,
  gstreamer,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rhythmbox";
  version = "3.4.9";

  src = fetchurl {
    url = "mirror://gnome/sources/rhythmbox/${lib.versions.majorMinor finalAttrs.version}/rhythmbox-${finalAttrs.version}.tar.xz";
    sha256 = "5CKRoY33oh/+azUr9z8F1+KYu04FvOWWf5jujO5ECPE=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    vala
    glib
    itstool
    gtk3.wrapGAppsHook
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    python3
    libsoup_3
    libxml2
    tdb
    json-glib

    glib
    gtk3
    libpeas
    totem-pl-parser
    libgudev
    libgpod
    libmtp
    lirc
    brasero-unwrapped
    grilo

    python3.pkgs.pygobject3

    gstreamer
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-bad
    gstreamer.plugins-ugly
    gstreamer.libav

    libdmapsharing
    libsecret
    libnotify
  ];

  mesonFeatures = {
    daap = true;
    tests = false;
  };

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/lib/rhythmbox/plugins/"
    )
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/rhythmbox";
    description = "Music playing application for GNOME";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
