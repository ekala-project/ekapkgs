{
  buildPerlPackage,
  fetchurl,
  lib,
  HTMLParser,
  TestDifferences,
  TestMemoryCycle,
}:
buildPerlPackage {
  pname = "HTML-Scrubber";
  version = "0.19";

  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NI/NIGELM/HTML-Scrubber-0.19.tar.gz";
    hash = "sha256-rihVePhWX5FUxj5CNHBLV7aDX3ei+C/+ckiZ1FMmK7E=";
  };

  propagatedBuildInputs = [ HTMLParser ];

  buildInputs = [
    TestDifferences
    TestMemoryCycle
  ];

  meta = {
    description = "Perl extension for scrubbing/sanitizing HTML";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
