{
  lib,
  stdenv,
  gettext,
  fetchurl,
  blueprint-compiler,
  evolution-data-server-gtk4, # TODO: not in ekapkgs (gtk4 variant of evolution-data-server)
  pkg-config,
  libxslt, # TODO: not in ekapkgs, needs porting or corepkgs
  docbook-xsl-nons, # TODO: not in ekapkgs, needs porting or corepkgs
  docbook_xml_dtd_42, # TODO: not in ekapkgs, needs porting or corepkgs
  desktop-file-utils,
  gtk4,
  glib,
  libportal-gtk4 ? null, # TODO: not in ekapkgs, needs porting
  gnome-online-accounts, # TODO: being ported to ekapkgs
  qrencode,
  wrapGAppsHook4,
  folks, # TODO: being ported to ekapkgs
  libxml2,
  vala,
  meson,
  ninja,
  libadwaita,
  libglycin ? null, # TODO: not in ekapkgs, needs porting
  libglycin-gtk4 ? null, # TODO: not in ekapkgs, needs porting
  glycin-loaders ? null, # TODO: not in ekapkgs, needs porting
  gsettings-desktop-schemas,
  gst_all_1,
  pipewire,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-contacts";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${lib.versions.major finalAttrs.version}/gnome-contacts-${finalAttrs.version}.tar.xz";
    hash = "sha256-KjvqNDFxviRPErfCGkDKOOmpLeqYkDk69eisE5vA2rM=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    meson
    ninja
    pkg-config
    vala
    gettext
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    # TODO: gst_all_1.gst-plugins-rs not in ekapkgs (GTK4 sink & paintable)
    pipewire # pipewiresrc
    gtk4
    glib
  ]
  ++ lib.optional (libportal-gtk4 != null) libportal-gtk4
  ++ [
    evolution-data-server-gtk4
    gsettings-desktop-schemas
    folks
    libadwaita
  ]
  ++ lib.optional (libglycin != null) libglycin
  ++ lib.optional (libglycin-gtk4 != null) libglycin-gtk4
  ++ [
    libxml2
    gnome-online-accounts
    qrencode
  ]
  ++ lib.optional (glycin-loaders != null) glycin-loaders;

  doCheck = true;

  meta = {
    homepage = "https://apps.gnome.org/Contacts/";
    description = "GNOME's integrated address book";
    mainProgram = "gnome-contacts";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
