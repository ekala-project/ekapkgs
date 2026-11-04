{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-EOL";
  version = "2.02";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Test-EOL-2.02.tar.gz";
    hash = "sha256-KDGZ1/sngH/iImr3sSVxxtwlCNjlwP61BdCJ0xcgr8Q=";
  };
  meta = {
    description = "Check the correct line endings in your project";
    homepage = "https://github.com/karenetheridge/Test-EOL";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
