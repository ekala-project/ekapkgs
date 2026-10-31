{
  buildPerlModule,
  fetchurl,
  lib,
  Future,
  StructDumb,
  TestFatal,
  TestIdentity,
  TestRefcount,
}:
buildPerlModule {
  pname = "IO-Async";
  version = "0.802";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PEVANS/IO-Async-0.802.tar.gz";
    hash = "sha256-5YJzFXd2fEfqxDXvKQRmPUp1Cw5oAqSmGJo38Mswhzg";
  };
  preCheck = "rm t/50resolver.t";
  propagatedBuildInputs = [
    Future
    StructDumb
  ];
  buildInputs = [
    TestFatal
    TestIdentity
    TestRefcount
  ];
  meta = {
    description = "Asynchronous event-driven programming";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
