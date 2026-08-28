{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  speexdsp,
}:

stdenv.mkDerivation rec {
  pname = "speex";
  version = "1.2.1";

  src = fetchurl {
    url = "https://downloads.us.xiph.org/releases/speex/speex-${version}.tar.gz";
    sha256 = "sha256-S0TU8rOKNwotmKeDKf78VqDPk9HBvnACkhe6rmYo/uo=";
  };

  postPatch = ''
    sed -i '/AC_CONFIG_MACRO_DIR/i PKG_PROG_PKG_CONFIG' configure.ac
  '';

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    speexdsp
  ];

  propagatedBuildInputs = [ speexdsp ];

  meta = {
    homepage = "https://www.speex.org/";
    description = "Open Source/Free Software patent-free audio compression format designed for speech";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
