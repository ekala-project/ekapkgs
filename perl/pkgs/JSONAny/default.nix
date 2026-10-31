{
  buildPerlPackage,
  fetchurl,
  lib,
  TestFatal,
  TestNeeds,
  TestWarnings,
  TestWithoutModule,
}:
buildPerlPackage {
  pname = "JSON-Any";
  version = "1.40";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/JSON-Any-1.40.tar.gz";
    hash = "sha256-CDJWJVpICU/ZrBI54P6ooQojg6nNHvSxxyZO3htEAKs=";
  };
  buildInputs = [
    TestFatal
    TestNeeds
    TestWarnings
    TestWithoutModule
  ];
  meta = {
    description = "(DEPRECATED) Wrapper Class for the various JSON classes";
    homepage = "https://github.com/karenetheridge/JSON-Any";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
