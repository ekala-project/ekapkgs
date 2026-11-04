{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  TestSharedFork,
  TestTCP,
  PerlIOviaTimeout,
}:
buildPerlModule {
  pname = "IO-Socket-Timeout";
  version = "0.32";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAMS/IO-Socket-Timeout-0.32.tar.gz";
    hash = "sha256-7fkV1sxmvuQ1A6ptwrNzNm846v9wFYIYPa0Qy4rfKXI=";
  };

  buildInputs = [
    ModuleBuildTiny
    TestSharedFork
    TestTCP
  ];

  propagatedBuildInputs = [ PerlIOviaTimeout ];

  meta = {
    description = "IO::Socket with read/write timeout";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
