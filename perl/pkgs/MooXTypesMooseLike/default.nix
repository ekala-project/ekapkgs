{
  buildPerlPackage,
  fetchurl,
  lib,
  ModuleRuntime,
  Moo,
  TestFatal,
}:
buildPerlPackage {
  pname = "MooX-Types-MooseLike";
  version = "0.29";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MATEU/MooX-Types-MooseLike-0.29.tar.gz";
    hash = "sha256-HTeAqpvqQwr75lqox25xjxBFzniKrdpBFvWdO3p60rQ=";
  };

  propagatedBuildInputs = [ ModuleRuntime ];

  buildInputs = [
    Moo
    TestFatal
  ];

  meta = {
    description = "Some Moosish types and a type builder";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
