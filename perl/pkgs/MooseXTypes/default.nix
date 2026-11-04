{
  buildPerlModule,
  fetchurl,
  lib,
  CarpClan,
  ModuleBuildTiny,
  Moose,
  SubExporterForMethods,
  TestFatal,
  TestRequires,
  namespaceautoclean,
}:
buildPerlModule {
  pname = "MooseX-Types";
  version = "0.50";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-0.50.tar.gz";
    hash = "sha256-nNh7NJLL8L6dLfkxeyrfn8MGY3cOaZBmVL6j9BsXywg=";
  };

  buildInputs = [
    ModuleBuildTiny
    TestFatal
    TestRequires
  ];

  propagatedBuildInputs = [
    CarpClan
    Moose
    SubExporterForMethods
    namespaceautoclean
  ];

  meta = {
    description = "Organise your Moose types in libraries";
    homepage = "https://github.com/moose/MooseX-Types";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
