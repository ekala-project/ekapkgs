{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fontconfig,
  meson,
  ninja,
  libxml2,
  freetype,
}:

stdenv.mkDerivation rec {
  pname = "libbluray";
  version = "1.4.1";

  src = fetchurl {
    url = "https://get.videolan.org/libbluray/${version}/libbluray-${version}.tar.xz";
    hash = "sha256-drXcQAl/KNyk67AJyY7VEyGyknRT91zHLPdKzQm59Ek=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    fontconfig
    libxml2
    freetype
  ];

  mesonFlags = [
    "-Dbdj_jar=disabled"
  ];

  meta = {
    homepage = "http://www.videolan.org/developers/libbluray.html";
    description = "Library to access Blu-Ray disks for video playback";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
  };
}
