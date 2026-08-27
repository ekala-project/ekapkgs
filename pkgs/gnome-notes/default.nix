{
  stdenv,
  lib,
  meson,
  ninja,
  gettext,
  fetchurl,
  pkg-config,
  wrapGAppsHook3,
  itstool,
  desktop-file-utils,
  python3,
  glib,
  gtk3,
  evolution-data-server, # TODO: being ported to ekapkgs
  gnome-online-accounts, # TODO: being ported to ekapkgs
  json-glib,
  libuuid, # TODO: not in ekapkgs, needs porting or corepkgs
  curl, # TODO: not in ekapkgs, needs porting or corepkgs
  libhandy,
  webkitgtk_4_1 ? null, # TODO: not in ekapkgs, needs porting
  libxml2,
  gsettings-desktop-schemas,
  tinysparql, # TODO: being ported to ekapkgs
  adwaita-icon-theme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-notes";
  version = "40.2";

  src = fetchurl {
    url = "mirror://gnome/sources/bijiben/${lib.versions.major finalAttrs.version}/bijiben-${finalAttrs.version}.tar.xz";
    hash = "sha256-siERvAaVa+81mqzx1u3h5So1sADIgROTZjL4rGztzmc=";
  };

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    libxml2
    desktop-file-utils
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    json-glib
    libuuid
    curl
    libhandy
  ]
  ++ lib.optional (webkitgtk_4_1 != null) webkitgtk_4_1
  ++ [
    tinysparql
    gnome-online-accounts
    gsettings-desktop-schemas
    evolution-data-server
    adwaita-icon-theme
  ];

  mesonFlags = [ "-Dupdate_mimedb=false" ];

  meta = {
    description = "Note editor designed to remain simple to use";
    mainProgram = "bijiben";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-notes";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
