{
  buildPerlModule,
  fetchurl,
  lib,
  stdenv,
  DirManifest,
  TestDifferences,
  ClassXSAccessor,
  ExceptionClass,
  PathTiny,
}:
buildPerlModule {
  pname = "Games-Solitaire-Verify";
  version = "0.2403";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Games-Solitaire-Verify-0.2403.tar.gz";
    hash = "sha256-5atHXIK6HLCIrSj0I8pRTUaUTWrjw+tV6WNunn8dyJM=";
  };
  buildInputs = [
    DirManifest
    TestDifferences
  ];
  propagatedBuildInputs = [
    ClassXSAccessor
    ExceptionClass
    PathTiny
  ];
  meta = {
    description = "Verify solutions for solitaire games";
    license = with lib.licenses; [ mit ];
    # Unsuccessful stat on filename containing newline at lib/perl5/5.40.0/File/Path.pm line 361.
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
}
