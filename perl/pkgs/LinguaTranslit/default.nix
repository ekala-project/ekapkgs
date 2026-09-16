{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Lingua-Translit";
  version = "0.29";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AL/ALINKE/Lingua-Translit-0.29.tar.gz";
    hash = "sha256-GtL6vAB52tcIt9nVVDfJ67GS5hC/lgryWUWFi5JZd1I=";
  };
  doCheck = false;
}
