{
  buildPerlPackage,
  fetchurl,
  Test2Suite,
  TestUseAllModules,
}:
buildPerlPackage {
  pname = "Net-Netmask";
  version = "2.0002";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JM/JMASLAK/Net-Netmask-2.0002.tar.gz";
    hash = "sha256-JKmy58a8wTAteXROukwCG/PeR/FJqvrM2U+bBC/dv5Q=";
  };
  buildInputs = [
    Test2Suite
    TestUseAllModules
  ];
  meta = {
    description = "Understand and manipulate IP netmasks";
  };
}
