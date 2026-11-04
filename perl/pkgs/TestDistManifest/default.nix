{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  ModuleManifest,
}:
buildPerlModule {
  pname = "Test-DistManifest";
  version = "1.014";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Test-DistManifest-1.014.tar.gz";
    hash = "sha256-PSbCDfQmKJgcv8+lscoCjGzq2zRMHc+XolrWqItz18U=";
  };

  buildInputs = [ ModuleBuildTiny ];

  propagatedBuildInputs = [ ModuleManifest ];

  meta = {
    description = "Author test that validates a package MANIFEST";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
