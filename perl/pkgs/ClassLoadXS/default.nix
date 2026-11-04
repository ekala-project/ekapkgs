{
  buildPerlPackage,
  fetchurl,
  lib,
  ClassLoad,
  TestFatal,
  TestNeeds,
}:
buildPerlPackage {

  pname = "Class-Load-XS";
  version = "0.10";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Class-Load-XS-0.10.tar.gz";
    hash = "sha256-W8Is9Tbr/SVkxb2vQvDYpM7j0ZMPyLRLfUpCA4YirdE=";
  };
  buildInputs = [
    TestFatal
    TestNeeds
  ];
  propagatedBuildInputs = [ ClassLoad ];
  meta = {
    description = "XS implementation of parts of Class::Load";
    homepage = "https://github.com/moose/Class-Load-XS";
    license = lib.licenses.artistic2;
  };

}
