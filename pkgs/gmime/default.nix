{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  zlib,
  gpgme,
  libidn2,
  libunistring,
}:

stdenv.mkDerivation rec {
  version = "3.2.15";
  pname = "gmime";

  src = fetchurl {
    url = "https://github.com/jstedfast/gmime/releases/download/${version}/gmime-${version}.tar.xz";
    sha256 = "sha256-hM0qSBonlw7Dm1yV9y2wJnIpBKLM8/29V7KAzy0CtcQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    zlib
    gpgme
    libidn2
    libunistring
  ];

  propagatedBuildInputs = [ glib ];

  configureFlags = [
    "--enable-introspection=no"
    "--enable-vala=no"
  ];

  postPatch = ''
    substituteInPlace tests/testsuite.c \
      --replace /bin/rm rm
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/jstedfast/gmime/";
    description = "C/C++ library for creating, editing and parsing MIME messages and structures";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
