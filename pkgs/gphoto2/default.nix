{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  libexif,
  libgphoto2,
  libjpeg,
  libtool,
  popt,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "gphoto2";
  version = "2.5.32";

  src = fetchFromGitHub {
    owner = "gphoto";
    repo = "gphoto2";
    rev = "v${version}";
    sha256 = "sha256-9Tn6CBxZpzPnlyiBYdpQGViT3NEcup6AXT7Z0DqI/vA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
    libtool
  ];

  buildInputs = [
    libexif
    libgphoto2
    libjpeg
    popt
    readline
  ];

  meta = {
    description = "Ready to use set of digital camera software applications";
    homepage = "http://www.gphoto.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "gphoto2";
  };
}
