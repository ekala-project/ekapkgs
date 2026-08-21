{
  stdenv,
  lib,
  glib,
  autoreconfHook,
  pkg-config,
  systemd,
  fetchFromGitLab,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-desktop-testing";
  version = "2021.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-desktop-testing";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-PWn4eEZskY0YgMpf6O2dgXNSu8b8T311vFHREv2HE/Q=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    systemd
  ];

  enableParallelBuilding = true;
  meta = {
    description = "GNOME test runner for installed tests";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-desktop-testing";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
