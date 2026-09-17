{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  gettext,
  glib,
  sqlite,
  libsoup_3,
  libxml2,
  json-glib,
  grilo,
  libmediaart,
  totem-pl-parser,
  itstool,
  gperf,
  localsearch,
  rest,
  gnome-online-accounts,
  tinysparql,
  gjs,
  lua5_4,
  liboauth,
  libarchive,
  libdmapsharing,
  gmime,
  gom,
  avahi,
  dleyna,
  gst_all_1,
}:

stdenv.mkDerivation rec {
  pname = "grilo-plugins";
  version = "0.3.18";

  src = fetchurl {
    url = "mirror://gnome/sources/grilo-plugins/${lib.versions.majorMinor version}/grilo-plugins-${version}.tar.xz";
    sha256 = "jjznTucXw8Mi0MsPjfJrsJFAKKXQFuKAVf+0nMmkbF4=";
  };

  patches = [
    (replaceVars ./chromaprint-gst-plugins.patch {
      load_plugins =
        lib.concatMapStrings
          (plugin: ''gst_registry_scan_path(gst_registry_get(), "${lib.getLib plugin}/lib/gstreamer-1.0");'')
          (
            with gst_all_1;
            [
              gstreamer
              gst-plugins-base
              gst-plugins-bad
            ]
          );
    })
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    gperf # for lua-factory
    glib # glib-compile-resources
    localsearch
  ];

  buildInputs = [
    grilo
    libxml2
    sqlite
    totem-pl-parser
    libsoup_3
    json-glib
    libmediaart
    lua5_4
    liboauth
    gnome-online-accounts
    rest
    tinysparql
    libarchive
    libdmapsharing
    gmime
    gom
    avahi
    dleyna
    gst_all_1.gstreamer
  ];

  mesonFlags = [
  ];

  meta = {
    description = "Collection of plugins for the Grilo framework";
    homepage = "https://gitlab.gnome.org/GNOME/grilo-plugins";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
