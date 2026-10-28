{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  replaceVars,
  gtk3,
  sassc,
  procps,
  xsettingsd,
  gsettings-desktop-schemas,
  kauth,
  kcodecs,
  kcolorscheme,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  kdecoration,
  kguiaddons,
  kwidgetsaddons,
  kwindowsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kde-gtk-config";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/kde-gtk-config-${finalAttrs.version}.tar.xz";
    hash = "sha256-ZZD++tKeN759Ue2J6duvZ4hK4KP+0U+NWKwTUsDAUD0=";
  };

  # The gtkconfig KDED module will crash the daemon if the GSettings schemas
  # aren't found.
  patches = [
    ./0001-gsettings-schemas-path.patch
    (replaceVars ./dependency-paths.patch {
      pgrep = lib.getExe' procps "pgrep";
      xsettingsd = lib.getExe xsettingsd;
    })
  ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DGSETTINGS_SCHEMAS_PATH=\"$GSETTINGS_SCHEMAS_PATH\""
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
    gtk3.wrapGAppsHook
    sassc
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    kauth
    kcodecs
    kcolorscheme
    kconfig
    kcoreaddons
    kdbusaddons
    kdecoration
    kguiaddons
    kwidgetsaddons
    kwindowsystem
  ];

  dontWrapGApps = true; # There is nothing to wrap

  cmakeEntries = {
    GLIB_SCHEMAS_DIR = "${gsettings-desktop-schemas.out}/";
  };

  # Hardcoded as QStrings, which are UTF-16 so Nix can't pick these up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${procps} ${xsettingsd}" > $out/nix-support/depends
  '';

  meta = {
    description = "GTK2 and GTK3 Configurator for KDE";
    homepage = "https://invent.kde.org/plasma/kde-gtk-config";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
