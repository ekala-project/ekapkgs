{
  buildPerlModule,
  fetchurl,
  lib,
  Moo,
  TypeTiny,
  TestNoWarnings,
}:
buildPerlModule {
  pname = "Array-Compare";
  version = "3.0.8";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAVECROSS/Array-Compare-v3.0.8.tar.gz";
    hash = "sha256-MEc7XpEBU4QNJDHqlGO55W5SPN56PFBhadaaK5dC2DQ=";
  };
  buildInputs = [ TestNoWarnings ];
  propagatedBuildInputs = [
    Moo
    TypeTiny
  ];
  meta = {
    description = "Perl extension for comparing arrays";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
