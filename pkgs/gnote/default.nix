{
  lib,
  stdenv,
  fetchurl,
  desktop-file-utils,
  gettext,
  gtkmm4,
  itstool,
  libadwaita,
  libsecret ? null,
  libuuid,
  libxml2,
  libxslt,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "gnote";
  version = "49.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnote/${lib.versions.major version}/gnote-${version}.tar.xz";
    hash = "sha256-lC8CsXIFff4HbdBNDwNlLqafNjg3Lsbrn8p3CBYEp7U=";
  };

  buildInputs = [
    gtkmm4
    libadwaita
    libuuid
    libxml2
    libxslt
  ]
  ++ lib.optional (libsecret != null) libsecret;

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnote";
    description = "Note taking application";
    mainProgram = "gnote";
    maintainers = [ ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
