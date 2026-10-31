{
  buildPerlPackage,
  fetchurl,
  lib,
  SerealDecoder,
  TestDeep,
  TestDifferences,
  TestLongString,
  TestWarn,
}:
buildPerlPackage {
  pname = "Sereal-Encoder";
  version = "5.006";
  src = fetchurl {
    url = "mirror://cpan/authors/id/Y/YV/YVES/Sereal-Encoder-5.006.tar.gz";
    hash = "sha256-kLQsyHdZgq4MdJno9ZLOeu+ug0M1g+EKWtVxKBHRcK0=";
  };
  buildInputs = [
    SerealDecoder
    TestDeep
    TestDifferences
    TestLongString
    TestWarn
  ];
  meta = {
    description = "Fast, compact, powerful binary serialization";
    homepage = "https://github.com/Sereal/Sereal";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
