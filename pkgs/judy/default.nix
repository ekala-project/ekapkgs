{
  lib,
  stdenv,
  fetchurl,
  pkgsBuildBuild,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "judy";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/judy/Judy-${version}.tar.gz";
    sha256 = "1sv3990vsx8hrza1mvq3bhvv9m6ff08y4yz7swn6znszz24l0w6j";
  };

  nativeBuildInputs = [ autoreconfHook ];
  depsBuildBuild = [ pkgsBuildBuild.stdenv.cc ];
  patches = [
    ./cross.patch
    ./fix-source-date.patch
  ];

  enableParallelBuilding = false;

  meta = {
    homepage = "https://judy.sourceforge.net/";
    license = lib.licenses.lgpl21Plus;
    description = "State-of-the-art C library that implements a sparse dynamic array";
    platforms = lib.platforms.unix;
  };
}
