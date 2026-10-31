{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
}:

stdenv.mkDerivation {
  pname = "libsbsms";
  version = "2.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/sbsms/libsbsms-2.0.2.tar.gz";
    sha256 = "sha256-zqs9lwZkszcFe0a89VKD1Q0ynaY2v4PQ7nw24iNBru4=";
  };

  patches = [
    (replaceVars ./configure.patch {
      msse = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse";
    })
  ];

  doCheck = true;

  meta = {
    homepage = "https://sourceforge.net/projects/sbsms/files/sbsms";
    description = "Subband sinusoidal modeling library for time stretching and pitch scaling audio";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
}
