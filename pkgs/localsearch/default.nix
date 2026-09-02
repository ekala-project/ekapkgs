{
  stdenv,
  lib,
  fetchurl,
  asciidoc,
  docbook-xsl-nons ? null,
  docbook_xml_dtd_45 ? null,
  gettext,
  itstool,
  libxslt,
  gexiv2_0_16 ? null,
  tinysparql,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsNoGuiHook ? null,
  bzip2,
  dbus,
  exempi,
  ffmpeg,
  giflib,
  glib,
  gobject-introspection,
  icu,
  json-glib,
  libcue ? null,
  libgsf ? null,
  libgxps ? null,
  libjpeg,
  libosinfo ? null,
  libpng,
  libseccomp ? null,
  libtiff,
  libuuid,
  libwebp ? null,
  libxml2,
  libzip ? null,
  poppler,
  systemd,
  taglib ? null,
  upower ? null,
  totem-pl-parser ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "localsearch";
  version = "3.11.1";

  src = fetchurl {
    url = "mirror://gnome/sources/localsearch/${lib.versions.majorMinor finalAttrs.version}/localsearch-${finalAttrs.version}.tar.xz";
    hash = "sha256-ezmmwoqKzysXLxWy+17nx6N2TER8L0oUyqI5t+vmGUI=";
  };

  patches = [
    ./tracker-landlock-nix-store-permission.patch
  ];

  nativeBuildInputs = [
    asciidoc
    docbook-xsl-nons
    docbook_xml_dtd_45
    gettext
    glib
    gobject-introspection
    itstool
    libxslt
    meson
    ninja
    pkg-config
    vala
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    bzip2
    dbus
    exempi
    ffmpeg
    giflib
    gexiv2_0_16
    totem-pl-parser
    tinysparql
    icu
    json-glib
    libcue
    libgsf
    libgxps
    libjpeg
    libosinfo
    libpng
    libtiff
    libuuid
    libwebp
    libxml2
    libzip
    poppler
    taglib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libseccomp
    systemd
    upower
  ];

  mesonFlags = [
    "-Dfunctional_tests=false"
  ];

  postInstall = ''
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/localsearch";
    description = "Desktop-neutral user information store, search tool and indexer";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "localsearch";
  };
})
