{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  TestDeep,
  TestWarnings,
  MooseXTypes,
}:
buildPerlModule {
  pname = "MooseX-Types-Common";
  version = "0.001014";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Common-0.001014.tar.gz";
    hash = "sha256-75Nxi20vJA1QtcOssadLTCoZGGllFHAAGoK+HzXQ7w8=";
  };

  buildInputs = [
    ModuleBuildTiny
    TestDeep
    TestWarnings
  ];

  propagatedBuildInputs = [ MooseXTypes ];

  meta = {
    description = "Library of commonly used type constraints";
    homepage = "https://github.com/moose/MooseX-Types-Common";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
