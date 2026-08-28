{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "gnome-backgrounds";
  version = "48.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${lib.versions.major version}/gnome-backgrounds-${version}.tar.xz";
    hash = "sha256-LWuqAR7peATHVh9+HL2NR2PjC1W4gY3aePn3WvuNjQU=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
  ];

  meta = {
    description = "Default wallpaper set for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-backgrounds";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-backgrounds/-/blob/${version}/NEWS?ref_type=tags";
    license = lib.licenses.cc-by-sa-30;
    platforms = lib.platforms.unix;
  };
}
