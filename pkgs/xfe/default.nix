{
  lib,
  stdenv,
  fetchurl,
  fox_1_6,
  fontconfig,
  freetype,
  pkg-config,
  gettext,
  libxcb-util,
  gcc,
  intltool,
  file,
  libpng,
  libxft,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfe";
  version = "2.1.11";

  src = fetchurl {
    url = "mirror://sourceforge/xfe/xfe-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-6ooSp7A7wOCHZZZ/n9jipr0MXrkAkvfwIMf5x2RWqO0=";
  };

  nativeBuildInputs = [
    fox_1_6
    pkg-config
    intltool
  ];

  buildInputs = [
    fox_1_6
    gettext
    libxcb-util
    gcc
    file
    libpng
    fontconfig
    freetype
    libx11
    libxft
  ];

  preConfigure = ''
    sed -i s,/usr/share/xfe,$out/share/xfe, src/xfedefs.h
  '';

  meta = {
    description = "MS-Explorer like file manager for X";
    homepage = "https://sourceforge.net/projects/xfe/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
