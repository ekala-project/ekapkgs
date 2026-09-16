{
  buildPerlPackage,
  fetchurl,
  lib,
  CPANMetaCheck,
  TestFatal,
  TestWarnings,
  TestWithoutModule,
  DateTimeLocale,
  DateTimeTimeZone,
}:
buildPerlPackage {
  pname = "DateTime";
  version = "1.59";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-1.59.tar.gz";
    hash = "sha256-3j6aY84VRwtNtK2tS6asjsKX2IwMbGs1SwgYg7CmdpU=";
  };
  buildInputs = [
    CPANMetaCheck
    TestFatal
    TestWarnings
    TestWithoutModule
  ];
  propagatedBuildInputs = [
    DateTimeLocale
    DateTimeTimeZone
  ];
  meta = {
    description = "A date and time object for Perl";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
