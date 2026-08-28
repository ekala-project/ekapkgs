{
  stdenv,
  lib,
  fetchFromGitHub,
  replaceVars,
  cmake,
  pkg-config,
  glib,
  gtk3,
  gsettings-desktop-schemas,

  # TODO: not yet available in ekapkgs
  # adwaita-qt,
  # adwaita-qt6,
  # qtbase,
  # qtwayland,
}:

stdenv.mkDerivation rec {
  pname = "qgnomeplatform";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "QGnomePlatform";
    rev = version;
    sha256 = "sha256-DaIBtWmce+58OOhqFG5802c3EprBAtDXhjiSPIImoOM=";
  };

  patches = [
    # Hardcode GSettings schema path to avoid crashes from missing schemas
    (replaceVars ./hardcode-gsettings.patch {
      gds_gsettings_path = glib.getSchemaPath gsettings-desktop-schemas;
    })

    # Backport cursor fix for Qt6 apps
    # Adjusted from https://github.com/FedoraQt/QGnomePlatform/pull/138
    ./qt6-cursor-fix.patch

    # fixing build with Qt>=6.10
    ./qt6_10.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    # TODO: Qt deps not yet available in ekapkgs
    # qtbase
    # qtwayland
    # adwaita-qt or adwaita-qt6 depending on useQt6
  ];

  # Qt setup hook complains about missing `wrapQtAppsHook` otherwise.
  dontWrapQtApps = true;

  cmakeFlags = [
    "-DGLIB_SCHEMAS_DIR=${glib.getSchemaPath gsettings-desktop-schemas}"
    # TODO: uncomment once qtbase available
    # "-DQT_PLUGINS_DIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"

    # Workaround CMake 4 compat
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.31")
  ];

  meta = {
    description = "QPlatformTheme for a better Qt application inclusion in GNOME";
    homepage = "https://github.com/FedoraQt/QGnomePlatform";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
