{
  buildPerlModule,
  fetchurl,
  ListMoreUtils,
}:
buildPerlModule {
  pname = "Statistics-Descriptive";
  version = "3.0801";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Statistics-Descriptive-3.0801.tar.gz";
    hash = "sha256-BHtwpj/cqpFhaOD/LVjhVeDrvGjtTMvXOnIT3KMCj2U=";
  };

  propagatedBuildInputs = [ ListMoreUtils ];

  meta = {
    description = "Module of basic descriptive statistical functions";
  };
}
