{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDeep,
  TestDifferences,
  TestLongString,
  TestWarn,
}:
buildPerlPackage {
  pname = "Sereal-Decoder";
  version = "5.006";
  src = fetchurl {
    url = "mirror://cpan/authors/id/Y/YV/YVES/Sereal-Decoder-5.006.tar.gz";
    hash = "sha256-eZGFXpGBo3nJsBIv6PwvaONEnJFhaow1eSbxFh9oR2g=";
  };
  buildInputs = [
    TestDeep
    TestDifferences
    TestLongString
    TestWarn
  ];
  preBuild = "ls";
  meta = {
    description = "Fast, compact, powerful binary deserialization";
    homepage = "https://github.com/Sereal/Sereal";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
