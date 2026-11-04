{
  buildPerlModule,
  fetchurl,
  lib,
  MCE,
  PerlCritic,
}:
buildPerlModule {
  pname = "Test-Perl-Critic";
  version = "1.04";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PETDANCE/Test-Perl-Critic-1.04.tar.gz";
    hash = "sha256-KPgGtUEseQi1bPFnMIS4tEzhy1TJQX14TZFCjhoECW4=";
  };

  propagatedBuildInputs = [
    MCE
    PerlCritic
  ];

  meta = {
    description = "Use Perl::Critic in test programs";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
