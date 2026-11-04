{
  buildPerlPackage,
  fetchurl,
  lib,
  libxml_perl,
}:
buildPerlPackage {
  pname = "XML-Handler-YAWriter";
  version = "0.23";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KR/KRAEHE/XML-Handler-YAWriter-0.23.tar.gz";
    hash = "sha256-50y7vl41wapyYZC/re8cePN7ThV3+JyT2sKgr4MqpIU=";
  };

  propagatedBuildInputs = [ libxml_perl ];

  meta = {
    description = "Yet another Perl SAX XML Writer";
    license = lib.licenses.gpl1Only;
  };
}
