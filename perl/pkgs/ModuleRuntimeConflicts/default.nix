{
  buildPerlPackage,
  fetchurl,
  lib,
  DistCheckConflicts,
}:
buildPerlPackage {
  pname = "Module-Runtime-Conflicts";
  version = "0.003";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Module-Runtime-Conflicts-0.003.tar.gz";
    hash = "sha256-cHzcdQOMcP6Rd5uIisBQ8ShWXTlnupZoDhscfMlzOHU=";
  };

  propagatedBuildInputs = [ DistCheckConflicts ];

  meta = {
    description = "Provide information on conflicts for Module::Runtime";
    homepage = "https://github.com/karenetheridge/Module-Runtime-Conflicts";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
