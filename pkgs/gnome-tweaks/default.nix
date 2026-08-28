{
  lib,
  meson,
  ninja,
  fetchurl,
  desktop-file-utils,
  gdk-pixbuf,
  gettext,
  glib,
  gnome-desktop,
  # TODO: gnome-settings-daemon not yet ported to ekapkgs
  gnome-settings-daemon,
  # TODO: gnome-shell not yet ported to ekapkgs
  gnome-shell,
  gnome-shell-extensions,
  gobject-introspection,
  gsettings-desktop-schemas,
  gtk4,
  itstool,
  libadwaita,
  libgudev,
  libnotify,
  libxml2,
  # TODO: mutter not yet ported to ekapkgs
  mutter,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gnome-tweaks";
  version = "49.0";
  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-tweaks/${lib.versions.major finalAttrs.version}/gnome-tweaks-${finalAttrs.version}.tar.xz";
    hash = "sha256-s5Cb3LSQW2hCfWq1geAfQ23/jlwKOJseCxRQDxiAbrs=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    itstool
    libxml2
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gnome-desktop
    gnome-settings-daemon
    gnome-shell
    # Makes it possible to select user themes through the `user-theme` extension
    gnome-shell-extensions
    mutter
    gsettings-desktop-schemas
    gtk4
    libadwaita
    libgudev
    libnotify
  ];

  pythonPath = lib.optional (python3Packages ? pygobject3) python3Packages.pygobject3;

  postPatch = ''
    patchShebangs meson-postinstall.py
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/libexec" "$out ''${pythonPath[*]}"
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-tweaks";
    description = "Tool to customize advanced GNOME 3 options";
    mainProgram = "gnome-tweaks";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
