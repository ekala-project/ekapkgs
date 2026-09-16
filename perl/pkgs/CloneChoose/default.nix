{
  buildPerlPackage,
  fetchurl,
  Clone,
  ClonePP,
  TestWithoutModule,
}:
buildPerlPackage {
  pname = "Clone-Choose";
  version = "0.010";
  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HE/HERMES/Clone-Choose-0.010.tar.gz";
    hash = "sha256-ViNIH1jO6O25bNICqtDfViLUJ+X3SLJThR39YuUSNjI=";
  };
  buildInputs = [
    Clone
    ClonePP
    TestWithoutModule
  ];
  meta = {
    description = "Choose appropriate clone utility";
  };
}
