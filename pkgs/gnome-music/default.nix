{
  lib,
  meson,
  ninja,
  gettext,
  fetchurl,
  gdk-pixbuf,
  tinysparql, # TODO: being ported to ekapkgs
  libxml2,
  python3,
  libnotify,
  wrapGAppsHook4,
  libmediaart,
  gobject-introspection,
  gnome-online-accounts, # TODO: being ported to ekapkgs
  grilo,
  grilo-plugins, # TODO: not in ekapkgs, needs porting
  pkg-config,
  gtk4,
  pango,
  glib,
  desktop-file-utils,
  appstream-glib,
  itstool,
  gst_all_1,
  libsoup_3,
  libadwaita,
  gsettings-desktop-schemas,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gnome-music";
  version = "50.0";

  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-music/${lib.versions.major finalAttrs.version}/gnome-music-${finalAttrs.version}.tar.xz";
    hash = "sha256-xyiQyn5YCc7+uHawEZn4sZcUa1wl6dV0UwGihMDzzao=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    itstool
    pkg-config
    libxml2
    wrapGAppsHook4
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    pango
    glib
    libmediaart
    gnome-online-accounts
    gdk-pixbuf
    python3
    grilo
    grilo-plugins
    libnotify
    libsoup_3
    libadwaita
    gsettings-desktop-schemas
    tinysparql
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    # TODO: gst-plugins-good, gst-plugins-bad, gst-plugins-ugly, gst-libav not in ekapkgs
  ]);

  pythonPath = with python3.pkgs; [
    pycairo
    dbus-python
  ] ++ lib.optional (python3.pkgs ? pygobject3) python3.pkgs.pygobject3;

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  doCheck = false;

  # handle setup hooks better
  strictDeps = false;

  meta = {
    homepage = "https://apps.gnome.org/Music/";
    description = "Music player and management application for the GNOME desktop environment";
    mainProgram = "gnome-music";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
