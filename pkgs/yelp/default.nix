{
  stdenv,
  lib,
  fetchurl,
  desktop-file-utils,
  gettext,
  itstool,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  bzip2,
  glib,
  gtk4,
  libadwaita,
  libxml2,
  libxslt,
  sqlite,
  webkitgtk_6_0 ? null, # TODO: webkitgtk_6_0 is likely missing from ekapkgs; needs porting
  xz,
  yelp-xsl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yelp";
  version = "49.1";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp/${lib.versions.major finalAttrs.version}/yelp-${finalAttrs.version}.tar.xz";
    hash = "sha256-Pj6U7y0slIfMUQYuOvv6FXjOvSnYDIQ1e21+5tz9inQ=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    bzip2
    glib
    gtk4
    libadwaita
    libxml2
    libxslt
    sqlite
    xz
    yelp-xsl
  ]
  # TODO: webkitgtk_6_0 needs to be ported to ekapkgs for full functionality
  ++ lib.optional (webkitgtk_6_0 != null) webkitgtk_6_0;

  postPatch = ''
    chmod +x src/link-gnome-help.sh data/domains/gen_yelp_xml.sh
    patchShebangs src/link-gnome-help.sh
    patchShebangs data/domains/gen_yelp_xml.sh
  '';

  meta = {
    homepage = "https://apps.gnome.org/Yelp/";
    description = "Help viewer for GNOME";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
