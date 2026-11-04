{
  buildPerlPackage,
  fetchurl,
  lib,
  pkg-config,
  cairo,
  ExtUtilsDepends,
  ExtUtilsPkgConfig,
}:
buildPerlPackage {

  pname = "Cairo";
  version = "1.109";
  src = fetchurl {
    url = "mirror://cpan/authors/id/X/XA/XAOC/Cairo-1.109.tar.gz";
    hash = "sha256-ghlzbkAcIxHaX1FXdd5D/YfmOEtQTaNqGS8rIXZDB38=";
  };
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ cairo ];
  propagatedBuildInputs = [
    ExtUtilsDepends
    ExtUtilsPkgConfig
  ];
  meta = {
    description = "Perl interface to the cairo 2d vector graphics library";
    homepage = "https://gtk2-perl.sourceforge.net";
    license = lib.licenses.lgpl21Only;
  };

}
