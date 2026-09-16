{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Text-Roman";
  version = "3.5";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SY/SYP/Text-Roman-3.5.tar.gz";
    hash = "sha256-y0oIo7FRgC/7L84yWKQWVCq4HbD3Oe5HSpWD/7c+BGo=";
  };
}
