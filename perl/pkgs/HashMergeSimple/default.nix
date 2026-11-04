{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDeep,
  TestDifferences,
  TestException,
  TestMost,
  TestWarn,
  Clone,
}:
buildPerlPackage {
  pname = "Hash-Merge-Simple";
  version = "0.051";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RO/ROKR/Hash-Merge-Simple-0.051.tar.gz";
    hash = "sha256-HFYyeHPS8E1XInd/BEhj2WiRBGaZd0DVWnVAccYoe3M=";
  };

  buildInputs = [
    TestDeep
    TestDifferences
    TestException
    TestMost
    TestWarn
  ];

  propagatedBuildInputs = [ Clone ];

  meta = {
    description = "Recursively merge two or more hashes, simply";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
