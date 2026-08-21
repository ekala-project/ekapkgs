{
  stdenv,
  lib,
  gettext,
  libxml2,
  libhandy,
  fetchurl,
  fetchpatch,
  pkg-config,
  libcanberra-gtk3 ? null,
  gtk3,
  glib,
  meson,
  ninja,
  python3,
  wrapGAppsHook3,
  appstream-glib,
  desktop-file-utils,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-screenshot";
  version = "41.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-screenshot/${lib.versions.major finalAttrs.version}/gnome-screenshot-${finalAttrs.version}.tar.xz";
    hash = "sha256-Stt97JJkKPdCY9V5ZnPPFC5HILbnaPVGio0JM/mMlZc=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-screenshot/-/commit/b60dad3c2536c17bd201f74ad8e40eb74385ed9f.patch";
      hash = "sha256-Js83h/3xxcw2hsgjzGa5lAYFXVrt6MPhXOTh5dZTx/w=";
    })
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    appstream-glib
    libxml2
    desktop-file-utils
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
    libhandy
    adwaita-icon-theme
    gsettings-desktop-schemas
  ]
  ++ lib.optional (libcanberra-gtk3 != null) libcanberra-gtk3;

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/postinstall.py
    patchShebangs build-aux/postinstall.py
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-screenshot";
    description = "Utility used in the GNOME desktop environment for taking screenshots";
    mainProgram = "gnome-screenshot";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
