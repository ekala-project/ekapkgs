{
  lib,
  stdenv,
  cmake,
  ninja,
  intltool,
  fetchurl,
  libxml2,
  webkitgtk_4_1,
  highlight,
  pkg-config,
  gtk3,
  glib,
  libnotify,
  libpst,
  gspell,
  evolution-data-server,
  libgweather,
  glib-networking,
  gsettings-desktop-schemas,
  itstool,
  shared-mime-info,
  libical,
  db,
  sqlite,
  adwaita-icon-theme,
  gnome-desktop,
  librsvg,
  gdk-pixbuf,
  libsecret,
  nss,
  nspr,
  icu,
  libcanberra-gtk3,
  geocode-glib_2,
  cmark,
  bogofilter,
  gstreamer,
  procps,
  p11-kit,
  openldap,
  spamassassin,
  tar,
  gzip,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "evolution";
  version = "3.60.2";

  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/evolution/${lib.versions.majorMinor finalAttrs.version}/evolution-${finalAttrs.version}.tar.xz";
    hash = "sha256-IYpJ+lBoFV29vTWjDRCi8jfHJGX7HQ4Kp4iJ8DnC7Y8=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    intltool
    itstool
    libxml2
    ninja
    pkg-config
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    adwaita-icon-theme
    bogofilter
    db
    evolution-data-server
    gdk-pixbuf
    glib
    glib-networking
    gnome-desktop
    gsettings-desktop-schemas
    gstreamer.plugins-base
    gstreamer
    gtk3
    gspell
    highlight
    icu
    libcanberra-gtk3
    geocode-glib_2
    cmark
    libgweather
    libical
    libnotify
    libpst
    librsvg
    libsecret
    nspr
    nss
    openldap
    p11-kit
    procps
    shared-mime-info
    sqlite
    webkitgtk_4_1
  ];

  propagatedUserEnvPkgs = [
    evolution-data-server
  ];

  cmakeEntries = {
    ENABLE_AUTOAR = false;
    ENABLE_YTNEF = false;
  };

  cmakeFlags = [
    (lib.cmakeFeature "WITH_SPAMASSASSIN" "${spamassassin}/bin/spamassassin")
    (lib.cmakeFeature "WITH_SA_LEARN" "${spamassassin}/bin/sa-learn")
    (lib.cmakeFeature "WITH_BOGOFILTER" "${bogofilter}/bin/bogofilter")
    (lib.cmakeFeature "WITH_OPENLDAP" "${openldap}")
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${
        lib.makeBinPath [
          tar
          gzip
          xz
        ]
      }"
    )
  '';

  requiredSystemFeatures = [
    "big-parallel"
  ];

  doCheck = true;

  env = {
    PKG_CONFIG_CAMEL_1_2_CAMEL_PROVIDERDIR = "$(out)/lib/evolution-data-server/camel-providers";
    PKG_CONFIG_LIBEDATASERVERUI_1_2_UIMODULEDIR = "$(out)/lib/evolution-data-server/ui-modules";
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/evolution";
    description = "Personal information management application that provides integrated mail, calendaring and address book functionality";
    mainProgram = "evolution";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
