{
  buildPerlPackage,
  fetchurl,
  lib,
  TestScript,
  FileFindRulePerl,
  PerlCritic,
}:
buildPerlPackage {
  pname = "Perl-MinimumVersion";
  version = "1.40";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DB/DBOOK/Perl-MinimumVersion-1.40.tar.gz";
    hash = "sha256-dYmleMtg1wykdVw5WzWStECgzWobB05OzqyTsDGhvpA=";
  };

  buildInputs = [ TestScript ];

  propagatedBuildInputs = [
    FileFindRulePerl
    PerlCritic
  ];

  meta = {
    description = "Find a minimum required version of perl for Perl code";
    homepage = "https://github.com/neilbowers/Perl-MinimumVersion";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "perlver";
  };
}
