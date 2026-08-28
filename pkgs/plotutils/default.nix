{
  fetchurl,
  lib,
  stdenv,
  libpng,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "plotutils";
  version = "2.6";

  src = fetchurl {
    url = "mirror://gnu/plotutils/plotutils-${version}.tar.gz";
    sha256 = "1arkyizn5wbgvbh53aziv3s6lmd3wm9lqzkhxb3hijlp1y124hjg";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libpng ];
  patches = map fetchurl (import ./debian-patches.nix) ++ [ ./c++17-register-usage-fix.patch ];

  preBuild = ''
    # Fix parallel building.
    make -C libplot xmi.h
  '';

  configureFlags = [ "--enable-libplotter" ];

  hardeningDisable = [ "format" ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Powerful C/C++ library for exporting 2D vector graphics";
    homepage = "https://www.gnu.org/software/plotutils/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
