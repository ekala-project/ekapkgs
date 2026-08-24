{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoconf,
  automake,
  gettext,
  libiconv,
  libtool,
  libusb1,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmtp";
  version = "1.1.23";

  src = fetchFromGitHub {
    owner = "libmtp";
    repo = "libmtp";
    rev = "libmtp-${builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    sha256 = "sha256-FlPj9PEeOAWabU11dFTzDgY9TBbgmJclbeL0iULYw6A=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
    pkg-config
  ];

  buildInputs = [ libiconv ];

  propagatedBuildInputs = [ libusb1 ];

  preConfigure = ''
    autopoint -f
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [ "--with-udev=${placeholder "out"}/lib/udev" ];

  configurePlatforms = [
    "build"
    "host"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/libmtp/libmtp";
    description = "Implementation of Microsoft's Media Transfer Protocol";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21;
    maintainers = [ ];
  };
})
