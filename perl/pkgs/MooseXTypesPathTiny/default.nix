{
  buildPerlModule,
  fetchurl,
  lib,
  Filepushd,
  ModuleBuildTiny,
  TestFatal,
  MooseXGetopt,
  MooseXTypesStringlike,
  PathTiny,
}:
buildPerlModule {
  pname = "MooseX-Types-Path-Tiny";
  version = "0.012";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Path-Tiny-0.012.tar.gz";
    hash = "sha256-Ge7eAt1lTnD3PjTNevAGN2UXO8rv7v8b2+ITGOz9kVg=";
  };
  buildInputs = [
    Filepushd
    ModuleBuildTiny
    TestFatal
  ];
  propagatedBuildInputs = [
    MooseXGetopt
    MooseXTypesStringlike
    PathTiny
  ];
  meta = {
    description = "Path::Tiny types and coercions for Moose";
    license = lib.licenses.asl20;
  };
}
