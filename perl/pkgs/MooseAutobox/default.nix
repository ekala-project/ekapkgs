{
  buildPerlModule,
  fetchurl,
  lib,
  ListMoreUtils,
  Moose,
  SyntaxKeywordJunction,
  autobox,
  namespaceautoclean,
  ModuleBuildTiny,
  TestException,
}:
buildPerlModule {
  pname = "Moose-Autobox";
  version = "0.16";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Moose-Autobox-0.16.tar.gz";
    hash = "sha256-kkAdpM9ITrcYjsGWtoGG76eCoQK0UeoVbNi4dy5ocFU=";
  };
  buildInputs = [
    ModuleBuildTiny
    TestException
  ];
  propagatedBuildInputs = [
    ListMoreUtils
    Moose
    SyntaxKeywordJunction
    autobox
    namespaceautoclean
  ];
  meta = {
    description = "Autoboxed wrappers for Native Perl datatypes";
    homepage = "https://github.com/moose/Moose-Autobox";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
