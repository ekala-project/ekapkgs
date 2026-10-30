{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  dbus-glib,
  glib,
  ORBit2 ? throw "ORBit2 is not yet available in ekapkgs", # TODO: port ORBit2
  libxml2,
  polkit,
  python312,
  intltool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gconf";
  version = "3.2.6";

  src = fetchurl {
    url = "mirror://gnome/sources/GConf/${lib.versions.majorMinor finalAttrs.version}/GConf-${finalAttrs.version}.tar.xz";
    hash = "sha256-GRK5GAOrCaXu0002S/Cf46KpyWdR/eA6Tgz6UaBNeEw=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  strictDeps = true;

  buildInputs = [
    ORBit2
    libxml2
  ]
  # polkit requires pam, which requires shadow.h, which is not available on
  # darwin
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) polkit;

  propagatedBuildInputs = [
    glib
    dbus-glib
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    python312
    glib
  ];

  configureFlags =
    # fixes the "libgconfbackend-oldxml.so is not portable" error on darwin
    lib.optionals stdenv.hostPlatform.isDarwin [ "--enable-static" ];

  postPatch = ''
    2to3 --write --nobackup gsettings/gsettings-schema-convert
  '';

  meta = {
    homepage = "https://projects.gnome.org/gconf/";
    description = "Deprecated system for storing application preferences";
    # ORBit2 is not available in ekapkgs
    broken = true;
    platforms = lib.platforms.unix;
  };
})
