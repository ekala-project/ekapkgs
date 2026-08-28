{
  stdenv,
  lib,
  fetchFromGitLab,
  appstream-glib,
  desktop-file-utils,
  # TODO: fwupd not yet available in ekapkgs
  fwupd,
  gettext,
  glib,
  gtk4,
  libadwaita,
  libxmlb,
  meson,
  ninja,
  pkg-config,
  # TODO: systemd not yet ported to ekapkgs
  # systemd,
  help2man,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-firmware";
  version = "49.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "gnome-firmware";
    rev = finalAttrs.version;
    sha256 = "sha256-3uU0N40O1eoK5JHWMwacSrBzOTq/c+qYwoH9kBOsqrM=";
  };

  nativeBuildInputs = [
    appstream-glib # for ITS rules
    desktop-file-utils
    gettext
    help2man
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    fwupd
    glib
    gtk4
    libadwaita
    libxmlb
    # TODO: systemd not yet ported to ekapkgs
    # systemd
  ];

  mesonFlags = [
    "-Dconsolekit=false"
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/World/gnome-firmware";
    description = "Tool for installing firmware on devices";
    mainProgram = "gnome-firmware";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
