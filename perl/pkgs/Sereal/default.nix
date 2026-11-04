{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDeep,
  TestLongString,
  TestWarn,
  SerealDecoder,
  SerealEncoder,
}:
buildPerlPackage {
  pname = "Sereal";
  version = "5.006";

  src = fetchurl {
    url = "mirror://cpan/authors/id/Y/YV/YVES/Sereal-5.006.tar.gz";
    hash = "sha256-uwXnY+1ry+pEx5IX/vCy05GKwVRxlHIwOMbER+5vWd4=";
  };

  buildInputs = [
    TestDeep
    TestLongString
    TestWarn
  ];

  propagatedBuildInputs = [
    SerealDecoder
    SerealEncoder
  ];

  meta = {
    description = "Fast, compact, powerful binary (de-)serialization";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
