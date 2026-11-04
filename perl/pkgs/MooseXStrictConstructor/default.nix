{
  buildPerlPackage,
  fetchurl,
  Moo,
  TestFatal,
  TestNeeds,
  Moose,
  namespaceautoclean,
}:
buildPerlPackage {
  pname = "MooseX-StrictConstructor";
  version = "0.21";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-StrictConstructor-0.21.tar.gz";
    hash = "sha256-xypa6Vg3Bszexx1AHcswVAE6dTa3UN8UNmE9hY6ikg0=";
  };
  buildInputs = [
    Moo
    TestFatal
    TestNeeds
  ];
  propagatedBuildInputs = [
    Moose
    namespaceautoclean
  ];
  meta = {
    description = "Make your object constructors blow up on unknown attributes";
  };
}
