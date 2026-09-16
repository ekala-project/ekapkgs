{
  buildPerlModule,
  fetchurl,
  lib,
  # buildInputs (available subset)
  TestDifferences,
  TestTrap,
  # propagatedBuildInputs
  EnvPath,
  FileWhich,
  GamesSolitaireVerify,
  InlineC,
  ListMoreUtils,
  MooX,
  StringShellQuote,
  TemplateToolkit,
  YAMLLibYAML,
}:
buildPerlModule {
  pname = "Task-FreecellSolver-Testing";
  version = "0.0.12";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Task-FreecellSolver-Testing-0.0.12.tar.gz";
    hash = "sha256-PRkQt64SVBfG4HeUeOtK8/yc+J4iGVhfiiBBFGP5k6c=";
  };
  buildInputs = [
    # CodeTidyAll  # missing: massive dep tree
    # TestDataSplit  # missing: needs IOAll, MooXlate
    TestDifferences
    # TestPerlTidy  # missing: needs PerlTidy, TestPerlCritic
    # TestRunPluginTrimDisplayedFilenames  # missing: needs Moose ecosystem
    # TestRunValgrind  # available but omitted for simplicity
    # TestTrailingSpace  # missing: needs FileFindObjectRule
    TestTrap
  ];
  propagatedBuildInputs = [
    EnvPath
    FileWhich
    GamesSolitaireVerify
    InlineC
    ListMoreUtils
    MooX
    StringShellQuote
    # TaskTestRunAllPlugins  # missing: needs entire Moose/TestRun ecosystem
    TemplateToolkit
    YAMLLibYAML
  ];
  doCheck = false;
  meta = {
    description = "Install the CPAN dependencies of the Freecell Solver test suite";
    license = with lib.licenses; [ mit ];
  };
}
