{
  buildPerlPackage,
  fetchurl,
  DataOptList,
  ImportInto,
  Moo,
}:
buildPerlPackage {
  pname = "MooX";
  version = "0.101";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GE/GETTY/MooX-0.101.tar.gz";
    hash = "sha256-L/kaZW54quCspCKTgp16flrLm/IrBAFjWyq2yHDeMtU=";
  };
  propagatedBuildInputs = [
    DataOptList
    ImportInto
    Moo
  ];
  meta = {
    description = "Using Moo and MooX:: packages the most lazy way";
  };
}
