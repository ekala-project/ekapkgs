{
  buildPerlModule,
  fetchurl,
  lib,
  BKeywords,
  ConfigTiny,
  ExceptionClass,
  FileWhich,
  ListSomeUtils,
  ModulePluggable,
  PPI,
  PPIxQuoteLike,
  PPIxRegexp,
  PPIxUtilities,
  PPIxUtils,
  PerlTidy,
  PodSpell,
  Readonly,
  StringFormat,
  TestDeep,
}:
buildPerlModule {

  pname = "Perl-Critic";
  version = "1.150";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PETDANCE/Perl-Critic-1.150.tar.gz";
    hash = "sha256-5c2V3j5DvOcHdRdidLqkBfMm/IdA3wBUu4FpdcyNNJs=";
  };
  buildInputs = [ TestDeep ];
  propagatedBuildInputs = [
    BKeywords
    ConfigTiny
    ExceptionClass
    FileWhich
    ListSomeUtils
    ModulePluggable
    PPI
    PPIxQuoteLike
    PPIxRegexp
    PPIxUtilities
    PPIxUtils
    PerlTidy
    PodSpell
    Readonly
    StringFormat
  ];
  preCheck = ''
    # Remove tests with hardcoded line numbers.
    rm t/20_policy_require_tidy_code.t
    rm t/03_pragmas.t
  '';
  meta = {
    description = "Critique Perl source code for best-practices";
    homepage = "https://metacpan.org/pod/perlcritic";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "perlcritic";
  };
}
