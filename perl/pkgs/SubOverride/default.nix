{
  buildPerlPackage,
  fetchurl,
  TestFatal,
}:
buildPerlPackage {
  pname = "Sub-Override";
  version = "0.09";
  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OV/OVID/Sub-Override-0.09.tar.gz";
    hash = "sha256-k5pnwfcplo4MyBt0lY23UOG9t8AgvuGiYzMvQiwuJbU=";
  };
  buildInputs = [ TestFatal ];
  meta = {
    description = "Perl extension for easily overriding subroutines";
  };
}
