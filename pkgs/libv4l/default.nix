{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  perl,
  libjpeg,
  udev,
}:

stdenv.mkDerivation rec {
  pname = "libv4l";
  version = "1.24.1";

  src = fetchurl {
    url = "https://linuxtv.org/downloads/v4l-utils/v4l-utils-${version}.tar.bz2";
    hash = "sha256-y7f+imMH9c5TOgXN7XC7k8O6BjlaubbQB+tTt12AX1s=";
  };

  outputs = [
    "out"
    "dev"
  ];

  configureFlags = [
    "--disable-v4l-utils"
  ];

  postFixup = ''
    ln -s "$dev/include/libv4l1-videodev.h" "$dev/include/videodev.h"
  '';

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    udev
  ];

  propagatedBuildInputs = [ libjpeg ];

  postPatch = ''
    patchShebangs utils/
  '';

  enableParallelBuilding = true;

  meta = {
    description = "V4L utils and libv4l, provide common image formats regardless of the v4l device";
    homepage = "https://linuxtv.org/projects.php";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
}
