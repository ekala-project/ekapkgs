{
  buildPerlModule,
  fetchurl,
  lib,
  Test2Suite,
  ListUtilsBy,
  ModulePluggable,
}:
buildPerlModule {
  pname = "Convert-Color";
  version = "0.17";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PEVANS/Convert-Color-0.17.tar.gz";
    hash = "sha256-5/jDN8VSXqoDd3xXaD6hGvm5j/HQURojSvH4CkMiTsc=";
  };
  buildInputs = [ Test2Suite ];
  propagatedBuildInputs = [
    ListUtilsBy
    ModulePluggable
  ];
  meta = {
    description = "Color space conversions and named lookups";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
