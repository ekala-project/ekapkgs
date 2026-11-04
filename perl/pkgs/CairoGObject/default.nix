{
  buildPerlPackage,
  fetchurl,
  lib,
  Cairo,
  Glib,
  cairo,
  pkg-config,
  perl,
}:
buildPerlPackage {
  pname = "Cairo-GObject";
  version = "1.005";

  src = fetchurl {
    url = "mirror://cpan/authors/id/X/XA/XAOC/Cairo-GObject-1.005.tar.gz";
    hash = "sha256-jYlkRNceHQvKPSTjHl2CvQ2VQqrtkdH7fqs2e85nXFA=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ cairo ];

  propagatedBuildInputs = [
    Cairo
    Glib
  ];

  meta = {
    description = "Integrate Cairo into the Glib type system";
    homepage = "https://gtk2-perl.sourceforge.net";
    license = lib.licenses.lgpl21Only;
  };
}
