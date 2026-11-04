{
  buildPerlModule,
  fetchurl,
  lib,
  TestDeep,
  TestException,
}:
buildPerlModule {
  pname = "Apache-Session";
  version = "1.94";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHORNY/Apache-Session-1.94.tar.gz";
    hash = "sha256-/mm3aJmv6QuK5bgt4qqnV1rakIk39EhbgKrvMXVj6Z8=";
  };

  buildInputs = [
    TestDeep
    TestException
  ];

  meta = {
    description = "Persistence framework for session data";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
