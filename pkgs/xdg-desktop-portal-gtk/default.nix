{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  xdg-desktop-portal,
  gtk3,
  gnome-settings-daemon ? null,
  gnome-desktop,
  glib,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-gtk";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal-gtk";
    rev = finalAttrs.version;
    sha256 = "sha256-aeSm6Wd0EMaZb7tYpnKT/QBt9l/fVyQLgvn5aBqQOAc=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    xdg-desktop-portal
    gsettings-desktop-schemas
    gnome-desktop
  ]
  ++ lib.optionals (gnome-settings-daemon != null) [
    (runCommand "gnome-settings-daemon-${gnome-settings-daemon.version}-gsettings-schemas" { } ''
      mkdir -p $out/share
      cp -r ${gnome-settings-daemon}/share/gsettings-schemas/ $out/share/
    '')
  ];

  meta = {
    description = "Desktop integration portals for sandboxed apps";
    homepage = "https://github.com/flatpak/xdg-desktop-portal-gtk";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21Plus;
  };
})
