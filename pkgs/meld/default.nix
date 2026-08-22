{
  lib,
  fetchurl,
  gettext,
  itstool,
  python3,
  meson,
  ninja,
  wrapGAppsHook3,
  libxml2,
  pkg-config,
  desktop-file-utils,
  gobject-introspection,
  gtk3,
  gtksourceview4,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "meld";
  version = "3.23.1";

  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/meld/${lib.versions.majorMinor finalAttrs.version}/meld-${finalAttrs.version}.tar.xz";
    hash = "sha256-c/gnkkZjx8a0UadMg4UwTZn+qhPIH04KFx2ll8aENXQ=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    gettext
    itstool
    libxml2
    pkg-config
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook3
    gtk3 # for gtk-update-icon-cache
  ];

  buildInputs = [
    gtk3
    gtksourceview4
    gsettings-desktop-schemas
    adwaita-icon-theme
  ];

  pythonPath = with python3.pkgs; [
    pycairo
  ];

  postPatch = ''
    patchShebangs meson_shebang_normalisation.py
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Visual diff and merge tool";
    homepage = "https://meld.app/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "meld";
  };
})
