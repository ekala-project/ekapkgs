{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  TestSharedFork,
  TestTCP,
}:
buildPerlModule {
  pname = "PerlIO-via-Timeout";
  version = "0.32";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAMS/PerlIO-via-Timeout-0.32.tar.gz";
    hash = "sha256-knj572aIUNkT2Y+kwNfn1mfP81AzkfSk6uc6JG8ueRY=";
  };

  buildInputs = [
    ModuleBuildTiny
    TestSharedFork
    TestTCP
  ];

  meta = {
    description = "PerlIO layer that adds read & write timeout to a handle";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
