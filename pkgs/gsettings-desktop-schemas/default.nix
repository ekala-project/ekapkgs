{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "gsettings-desktop-schemas";
  version = "48.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-5o8VWBO/GPhlqLLI6dRzWItsytyvu2Zqt4iFfGwtG9M=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    glib
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  mesonFlags = [
    "-Dintrospection=false"
  ];

  preInstall = ''
    mkdir -p $out/share/glib-2.0/schemas
    cat - > $out/share/glib-2.0/schemas/remove-backgrounds.gschema.override <<- EOF
      [org.gnome.desktop.background]
      picture-uri='''
      picture-uri-dark='''

      [org.gnome.desktop.screensaver]
      picture-uri='''
    EOF
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gsettings-desktop-schemas";
    description = "Collection of GSettings schemas for settings shared by various components of a desktop";
    license = lib.licenses.lgpl21Plus;
  };
}
