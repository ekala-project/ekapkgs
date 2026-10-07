{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk3,
  vala,
  enchant,
  meson,
  ninja,
  desktop-file-utils,
  gnome-online-accounts,
  gsettings-desktop-schemas,
  adwaita-icon-theme,
  libpeas,
  libsecret,
  gmime,
  isocodes,
  icu,
  libxml2,
  gettext,
  sqlite,
  gcr,
  json-glib,
  itstool,
  libgee,
  webkitgtk,
  python3,
  glib-networking,
  gobject-introspection,
  gspell,
  libstemmer,
  libytnef,
  libhandy,
  gsound,
  libunwind,
  folks,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geary";
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/geary/${lib.versions.major finalAttrs.version}/geary-${finalAttrs.version}.tar.xz";
    hash = "sha256-r60VEwKBfd8Ji15BbnrH8tXupWejuAu5C9PGKv0TuaE=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    itstool
    libxml2 # for xmllint for xml-stripblanks preprocessing
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    vala
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    adwaita-icon-theme
    enchant
    folks
    gcr
    glib-networking
    gmime
    gnome-online-accounts
    gsettings-desktop-schemas
    gsound
    gspell
    gtk3
    isocodes
    icu
    json-glib
    libgee
    libhandy
    libpeas
    libsecret
    libunwind
    libstemmer
    libxml2
    libytnef
    sqlite
    webkitgtk.gtk3
  ];

  mesonEntries = {
    profile = "release";
  };

  mesonFeatures = {
    contractor = true;
  };

  strictDeps = true;

  postPatch = ''
    chmod +x build-aux/git_version.py

    patchShebangs build-aux/git_version.py

    # Only used for generating .pot file
    # https://gitlab.gnome.org/GNOME/geary/-/merge_requests/856
    substituteInPlace meson.build \
      --replace-fail "appstream_glib = dependency('appstream-glib', version: '>=0.7.10')" ""

    chmod +x desktop/geary-attach
  '';

  doCheck = false;

  preFixup = ''
    # Add geary to path for geary-attach
    gappsWrapperArgs+=(--prefix PATH : "$out/bin")
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/geary";
    changelog = "https://gitlab.gnome.org/GNOME/geary/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Mail client for GNOME 3";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
