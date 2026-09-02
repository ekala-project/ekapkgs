{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  libusb1,
  libtool,
  libexif,
  libjpeg,
  curl,
  libxml2,
  gd,
}:

stdenv.mkDerivation rec {
  pname = "libgphoto2";
  version = "2.5.34";

  src = fetchFromGitHub {
    owner = "gphoto";
    repo = "libgphoto2";
    rev = "libgphoto2-${builtins.replaceStrings [ "." ] [ "_" ] version}-release";
    sha256 = "sha256-+yPpoIgyXL/Qp2C4ykSlUg2BheWjzTEi6wID6yCsP/s=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    autoreconfHook
    gettext
    libtool
    pkg-config
  ];

  buildInputs = [
    libjpeg
    libtool
    libusb1
    curl
    libxml2
    gd
  ];

  propagatedBuildInputs = [ libexif ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  hardeningDisable = [ "format" ];

  postInstall = ''
    mkdir -p $out/lib/udev/{rules.d,hwdb.d}
    $out/lib/libgphoto2/print-camera-list \
        udev-rules version 201 group camera \
        >$out/lib/udev/rules.d/40-libgphoto2.rules
    $out/lib/libgphoto2/print-camera-list \
        hwdb version 201 group camera \
        >$out/lib/udev/hwdb.d/20-gphoto.hwdb
  '';

  meta = {
    homepage = "http://www.gphoto.org/proj/libgphoto2/";
    description = "Library for accessing digital cameras";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
