{
  buildPerlPackage,
  fetchurl,
  lib,
  ClassMethodModifiers,
  RoleHooks,
  RoleTiny,
  TypeTiny,
  TestFatal,
  TestRequires,
  TryTiny,
}:
buildPerlPackage {
  pname = "Sub-HandlesVia";
  version = "0.050002";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TOBYINK/Sub-HandlesVia-0.050002.tar.gz";
    hash = "sha256-PMWPrjBcCOEZziwz44SHBD5odSE4JkRBw1oxATTrUDg=";
  };
  propagatedBuildInputs = [
    ClassMethodModifiers
    RoleHooks
    RoleTiny
    TypeTiny
  ];
  buildInputs = [
    TestFatal
    TestRequires
    TryTiny
  ];
  meta = {
    description = "Alternative handles_via implementation";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
