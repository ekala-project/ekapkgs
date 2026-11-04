{
  buildPerlModule,
  fetchurl,
  ModuleBuildTiny,
  TestFatal,
  DateTime,
  MooseXTypes,
}:
buildPerlModule {
  pname = "MooseX-Types-DateTime";
  version = "0.13";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-DateTime-0.13.tar.gz";
    hash = "sha256-uJ+iZjb2oX6qOGi0UUNARytou9whYaHXmiKhv1sdOcY=";
  };
  buildInputs = [
    ModuleBuildTiny
    TestFatal
  ];
  propagatedBuildInputs = [
    DateTime
    MooseXTypes
  ];
  meta = {
    description = "DateTime related constraints and coercions for Moose";
  };
}
