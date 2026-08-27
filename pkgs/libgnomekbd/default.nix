{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  glib,
  gtk3,
  libxklavier,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "libgnomekbd";
  version = "3.28.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libgnomekbd/${lib.versions.majorMinor version}/libgnomekbd-${version}.tar.xz";
    sha256 = "ItxZVm1zwAZTUPWpc0DmLsx7CMTfGRg4BLuL4kyP6HA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    glib
    gobject-introspection
  ];

  # Requires in libgnomekbd.pc
  propagatedBuildInputs = [
    gtk3
    libxklavier
    glib
  ];

  postInstall = ''
    # Missing post-install script.
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  meta = {
    description = "Keyboard management library";
    mainProgram = "gkbd-keyboard-display";
    maintainers = [ ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
