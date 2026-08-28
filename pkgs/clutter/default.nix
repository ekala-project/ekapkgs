{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libGLU,
  libGL,
  libxcb,
  xorg,
  cogl,
  pango,
  atk,
  json-glib,
  gtk3,
  libinput,
  libgudev,
  libxkbcommon,
}:

stdenv.mkDerivation rec {
  pname = "clutter";
  version = "1.26.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1rn4cd1an6a9dfda884aqpcwcgq8dgydpqvb19nmagw4b70zlj4b";
  };

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [ gtk3 ];
  nativeBuildInputs = [
    pkg-config
  ];
  propagatedBuildInputs = [
    cogl
    pango
    atk
    json-glib
    xorg.libX11
    libGL
    libGLU
    xorg.libXext
    xorg.libXfixes
    xorg.libXdamage
    xorg.libXcomposite
    xorg.libXi
    libxcb
    libinput
    libgudev
    libxkbcommon
  ];

  configureFlags = [
    "--disable-introspection"
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  meta = {
    description = "Library for creating fast, dynamic graphical user interfaces";
    license = lib.licenses.lgpl2Plus;
    homepage = "http://www.clutter-project.org/";
    platforms = lib.platforms.linux;
  };
}
