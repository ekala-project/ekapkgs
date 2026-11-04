{
  buildPerlPackage,
  fetchurl,
  FileSlurp,
}:
buildPerlPackage {
  pname = "Locale-PO";
  version = "0.27";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CO/COSIMO/Locale-PO-0.27.tar.gz";
    hash = "sha256-PJlKS2Pm5Og2xveak/UZIcq3fJDJdT/g+LVCkiDVFrk=";
  };
  propagatedBuildInputs = [ FileSlurp ];
  meta = {
    description = "Perl module for manipulating .po entries from GNU gettext";
  };
}
