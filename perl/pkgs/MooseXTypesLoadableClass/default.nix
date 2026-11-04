{
  buildPerlModule,
  fetchurl,
  lib,
  MooseXTypes,
  ModuleBuildTiny,
  TestFatal,
}:
buildPerlModule {
  pname = "MooseX-Types-LoadableClass";
  version = "0.015";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-LoadableClass-0.015.tar.gz";
    hash = "sha256-4DfTd4JT3PkpRkNXFbraDmRJwKKAj6P/MqllBk1aO/Q=";
  };
  buildInputs = [
    ModuleBuildTiny
    TestFatal
  ];
  propagatedBuildInputs = [ MooseXTypes ];
  meta = {
    description = "ClassName type constraint with coercion to load the class";
    homepage = "https://github.com/moose/MooseX-Types-LoadableClass";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
