{
  buildPerlModule,
  fetchurl,
  DynaLoaderFunctions,
}:
buildPerlModule {
  pname = "Devel-CallChecker";
  version = "0.010";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHINGO/Devel-CallChecker-0.010.tar.gz";
    hash = "sha256-Zt5Vepeohgn4KgqtmtNZfR0zM7aOcyyRAIOeBpFNy+Q=";
  };

  propagatedBuildInputs = [ DynaLoaderFunctions ];

  meta = {
    description = "Custom op checking attached to subroutines";
  };
}
