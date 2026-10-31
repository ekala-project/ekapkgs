{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  ninja,
  pkg-config,
  gtk4,
  glib,
  ibus,
  libadwaita,
  libchewing,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ibus-chewing";
  version = "2.2.0";

  src = fetchFromCodeberg {
    owner = "chewing";
    repo = "ibus-chewing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0kXAvvbOsTUMmno6zzpRqpYb9xQlD4iwC1WNf5cMsSw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    gtk4
    ibus
    libadwaita
    libchewing
  ];

  enableParallelBuilding = true;

  meta = {
    broken = true; # build failure
    description = "Chewing engine for IBus";
    homepage = "https://codeberg.org/chewing/ibus-chewing";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
