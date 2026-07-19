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
  version = "1.1.22";

  src = fetchFromGitHub {
    owner = "libmtp";
    repo = "libmtp";
    rev = "libmtp-${builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    sha256 = "sha256-hIH6W8qQ6DB4ST7SlFz6CCnLsEGOWgmUb9HoHMNA3wY=";
  };

  patches = [
    (fetchpatch {
      name = "gettext-0.25.patch";
      url = "https://github.com/libmtp/libmtp/commit/5e53ee68e61cc6547476b942b6aa9776da5d4eda.patch";
      hash = "sha256-eXDNDHg8K+ZiO9n4RqQPJrh4V9GNiK/ZxZOA/oIX83M=";
    })
    (fetchpatch {
      name = "gettext-0.25-p2.patch";
      url = "https://github.com/libmtp/libmtp/commit/122eb9d78b370955b9c4d7618b12a2429f01b81a.patch";
      hash = "sha256-Skqr6REBl/Egf9tS5q8k5qmEhFY+rG2fymbiu9e4Mho=";
    })
  ];

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
